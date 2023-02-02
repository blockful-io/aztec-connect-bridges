// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization, JoinKind, ExitKind} from "../../interfaces/balancer/IVault.sol";
import {ISubsidy} from "../../aztec/interfaces/ISubsidy.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";
import {ErrorLib} from "../base/ErrorLib.sol";
import {BridgeBase} from "../base/BridgeBase.sol";

import "forge-std/Test.sol";
/**
 * @title Balancer Bridge Contract.
 * @author Aztec Team
 * @dev This bridge demonstrates the flow of assets in the convert function. This bridge simply returns what has been
 *      sent to it.
 */
contract BalancerBridge is BridgeBase {
    address public constant vaultAddr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    IVault public constant VAULT = IVault(vaultAddr);

    mapping(uint64=>IVault.Join) private commitsJoin;
    mapping(uint64=>IVault.Exit) private commitsExit;
    mapping(uint64=>IVault.ActionKind) private actions;

    /**
     * @notice Set address of rollup processor
     * @param _rollupProcessor Address of rollup processor
     */
    constructor(
        address _rollupProcessor
    ) BridgeBase(_rollupProcessor) {
    }

    /**
     * @notice Sets all the important approvals.
     * @param _tokensIn - An array of address of input tokens (tokens to later swap in the convert(...) function)
     * @param _tokensOut - An array of address of output tokens (tokens to later return to rollup processor)
     * @dev SwapBridge never holds any ERC20 tokens after or before an invocation of any of its functions. For this
     * reason the following is not a security risk and makes convert(...) function more gas efficient.
     */
    function preApproveTokens(address[] calldata _tokensIn, address[] calldata _tokensOut) external {
        for (uint256 i = 0; i < _tokensIn.length;) {
            if(address(0) == _tokensIn[i]) {
                unchecked {
                    ++i;
                }
                continue;
            }
            address tokenIn = _tokensIn[i];
            IERC20(tokenIn).approve(vaultAddr, 0);
            IERC20(tokenIn).approve(vaultAddr, type(uint256).max);
            unchecked {
                ++i;
            }
        }
        for (uint256 i = 0; i < _tokensOut.length;) {
            if(address(0) == _tokensOut[i]) {
                unchecked {
                    ++i;
                }
                continue;
            }
            address tokenOut = _tokensOut[i];
            IERC20(tokenOut).approve(address(ROLLUP_PROCESSOR), 0);
            IERC20(tokenOut).approve(address(ROLLUP_PROCESSOR), type(uint256).max);
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice A function which will build the parameters for the vault action
     * @param _joinPool - The struct containing the parameters for the vault action
     * @return auxData - The hash in uint64
     */
    function commitJoin(
        IVault.Join memory _joinPool
    ) public returns (uint64 auxData) { 
        auxData = uint64(uint256(keccak256(abi.encode(_joinPool))));
        commitsJoin[auxData] = _joinPool;
        actions[auxData] = IVault.ActionKind.JOIN;
    }

    /**
     * @notice A function which will build the parameters for the vault action
     * @param _exitPool - The struct containing the parameters for the vault action
     * @return auxData - The hash in uint64
     */
    function commitExit(
        IVault.Exit memory _exitPool
    ) public returns (uint64 auxData) { 
        auxData = uint64(uint256(keccak256(abi.encode(_exitPool))));
        commitsExit[auxData] = _exitPool;
        actions[auxData] = IVault.ActionKind.EXIT;
    }

    function joinPool(
        IVault.Join memory _joinPool,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        ( outputValueA, outputValueB, async ) = 
        convert(
            _convert.inputAssetA,
            _convert.inputAssetB,
            _convert.outputAssetA,
            _convert.outputAssetB,
            _convert.totalInputValue,
            _convert.interactionNonce,
            commitJoin(_joinPool),
            _convert.rollupBeneficiary
        );
    }

    function exitPool(
        IVault.Exit memory _exitPool,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        ( outputValueA, outputValueB, async ) = 
        convert(
            _convert.inputAssetA,
            _convert.inputAssetB,
            _convert.outputAssetA,
            _convert.outputAssetB,
            _convert.totalInputValue,
            _convert.interactionNonce,
            commitExit(_exitPool),
            _convert.rollupBeneficiary
        );
    }

    function paySubsidyJoinOrExit(
        bytes32 poolId, 
        IVault.ActionKind kind,
        address _rollupBeneficiary 
    ) public {
        // Load the tokens from the pool given its poolID
        (IERC20[] memory tokens, , ) = VAULT.getPoolTokens(poolId);

        // Create an array of addresses of the tokens in the pool
        address[] memory poolTokens = new address[](tokens.length);

        // Change from IERC20 to address and add to the array
        for(uint256 i = 0; i < tokens.length; i++) {
            poolTokens[i] = address(tokens[i]);
        }

        // The pool issue an ERC20 which is the output of 
        // a join and also the input of an exit
        address[] memory contractToken = new address[](1);
        ( contractToken[0], ) = VAULT.getPool(poolId);

        // Reverts the result based on Join or Exit
        if(kind == IVault. ActionKind.JOIN) {
            // In the Join action, the contract token is the output
            SUBSIDY.claimSubsidy(
                _computeCriteria(poolTokens, contractToken),
                _rollupBeneficiary
            );
        } else {
            // In the Exit action, the contract token is the input
            SUBSIDY.claimSubsidy(
                _computeCriteria(contractToken, poolTokens),
                _rollupBeneficiary
            );    
        }
    }

    /**
     * @notice A function which returns an _totalInputValue amount of _inputAssetA
     * @param _inputAssetA - Arbitrary ERC20 token
     * @param _outputAssetA - Equal to _inputAssetA
     * @param _rollupBeneficiary - Address of the contract which receives subsidy in case subsidy was set for a given
     *                             criteria
     * @return outputValueA - the amount of output asset to return
     * @dev In this case _outputAssetA equals _inputAssetA
     */
    function convert(
        AztecTypes.AztecAsset calldata _inputAssetA,
        AztecTypes.AztecAsset calldata _inputAssetB,
        AztecTypes.AztecAsset calldata _outputAssetA,
        AztecTypes.AztecAsset calldata _outputAssetB,
        uint256 _totalInputValue,
        uint256,
        uint64 _auxData,
        address _rollupBeneficiary
    ) public payable override (BridgeBase) onlyRollup returns (uint256 outputValueA, uint256 outputValueB, bool) {                
        // Load the inputs for the vault action
        if(actions[_auxData] == IVault.ActionKind.JOIN) {
            IVault.Join memory inputs = commitsJoin[_auxData];
            paySubsidyJoinOrExit(inputs.poolId, IVault.ActionKind.JOIN, _rollupBeneficiary);

            outputValueA = 
            joinPool(
                inputs.poolId,
                inputs.sender,
                inputs.recipient,
                inputs.request
            );
        } else if(actions[_auxData] == IVault.ActionKind.EXIT) {
            IVault.Exit memory inputs = commitsExit[_auxData];
            paySubsidyJoinOrExit(inputs.poolId, IVault.ActionKind.EXIT, _rollupBeneficiary);            
            
            uint256[] memory outputValue = 
            exitPool(
                inputs.poolId,
                inputs.sender,
                inputs.recipient,
                inputs.request
            );
            outputValueA = outputValue[0];
            outputValueB = outputValue[1];
        } else {
            revert ErrorLib.InvalidAuxData();
        }

        // bool inputIsEth = _inputAssetA.assetType == AztecTypes.AztecAssetType.ETH;
        // bool outputIsEth = _outputAssetA.assetType == AztecTypes.AztecAssetType.ETH;
        // inputIsEth == true ? true :  _inputAssetB.assetType == AztecTypes.AztecAssetType.ETH;

        // if (_inputAssetA.assetType != AztecTypes.AztecAssetType.ERC20 && !inputIsEth) revert ErrorLib.InvalidInputA();
        // if (_outputAssetA.assetType != AztecTypes.AztecAssetType.ERC20 && !outputIsEth) revert ErrorLib.InvalidOutputA();t

    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _poolId - The poolId of the pool to join
     * @param _sender - The address which will send the tokens to the pool
     * @param _recipient - The address which will receive the pool tokens
     * @param _request - The struct containing the parameters for the vault action
     * @return outputValue - the amount of output asset to return
     */
    function joinPool(
        bytes32 _poolId,
        address _sender,
        address _recipient,
        IVault.JoinPoolRequest memory _request
    ) internal returns (uint256 outputValue) {
        // Get the address of the pool
        (address poolAddr, ) = VAULT.getPool(_poolId);
        
        // then the balance, before and after the vault action,
        outputValue = IERC20(poolAddr).balanceOf(_recipient) - outputValue;

        // check if the input is ETH
        bool isEth = false;
        for(uint256 i = 0; i < _request.assets.length; i++) {
            if(_request.assets[i] == IAsset(address(0))) {
                isEth = true;
            }
        }

        VAULT.joinPool{value: isEth ? msg.value : 0}(
          _poolId,
          _sender,
          _recipient,
          _request
        );

        // to calculate the output value
        outputValue = IERC20(poolAddr).balanceOf(_recipient) - outputValue;
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _poolId - The poolId of the pool to join
     * @param _sender - The address which will send the tokens to the pool
     * @param _recipient - The address which will receive the pool tokens
     * @param _request - The struct containing the parameters for the vault action
     * @return outputValue - the amount of output asset to return
     */
    function exitPool(
        bytes32 _poolId,
        address _sender,
        address _recipient,
        IVault.ExitPoolRequest memory _request
    ) internal returns (uint256[] memory outputValue) {
        // Load the tokens from the pool given its poolID
        (IERC20[] memory tokens, , ) = VAULT.getPoolTokens(_poolId);

        outputValue = new uint256[](tokens.length);
        for(uint256 i = 0; i < tokens.length; i++) {
            // then the balance, before and after the vault action,
            outputValue[i] = tokens[i].balanceOf(_recipient);
        }

        VAULT.exitPool(
            _poolId,
            _sender,
            payable(_recipient),
            _request
        );

        for(uint256 i = 0; i < tokens.length; i++) {
            outputValue[i] = tokens[i].balanceOf(_recipient) - outputValue[i];
        }
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _inputAssetA - The token IN
     * @param _outputAssetA - The token OUT
     * @param _totalInputValue - The amount of _inputAssetA to swap
     * @return outputValueA - the amount of output assets returned
     */
    function swapGiveInAndOut(
        IVault.SwapKind _kind,
        bytes32 _poolId, 
        address _inputAssetA, 
        address _outputAssetA, 
        uint256 _totalInputValue
    ) internal returns (uint256 outputValueA) {
        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            poolId: _poolId,
            kind: _kind,
            assetIn: IAsset(_inputAssetA),
            assetOut: IAsset(_outputAssetA),
            amount: _totalInputValue,
            userData: "0x00"
        });

        IVault.FundManagement memory fundManagement = IVault.FundManagement({
            sender: address(this), // the bridge has already received the tokens from the rollup so it owns totalInputValue of inputAssetA
            fromInternalBalance: false,
            recipient: payable(address(this)), // we want the output tokens transferred back to us
            toInternalBalance: false
        });

        // Swap
        outputValueA = VAULT.swap(
          singleSwap,
          fundManagement,
          0, // limit
          block.timestamp
        );
    }

    /**
     * @notice Registers subsidy criteria for a given token pair.
     * @param _criteria - The criteria to register calculated with _computeCriteria
     */
    function registerSubsidyCriteria(uint256 _criteria) external {
        SUBSIDY.setGasUsageAndMinGasPerMinute({
            _criteria: _criteria,
            _gasUsage: uint32(300000), // 300k gas (Note: this is a gas usage when only 1 split path is used)
            _minGasPerMinute: uint32(100) // 1 fully subsidized call per 2 days (300k / (24 * 60) / 2)
        });
    }

    /**
     * @notice Computes the criteria that is passed when claiming subsidy.
     * @param _inputTokens The input assetA
     * @param _outputTokens The output asset
     * @return The criteria
     */
    function _computeCriteria(
        address[] memory _inputTokens, 
        address[] memory _outputTokens
    ) public pure returns (uint256) {
        bytes memory encoded;

        for(uint256 i = 0; i < _inputTokens.length; i++) {
            encoded = abi.encodePacked(encoded, _inputTokens[i]);
        }

        for(uint256 i = 0; i < _outputTokens.length; i++) {
            encoded = abi.encodePacked(encoded, _outputTokens[i]);
        }

        return uint256(keccak256(encoded));
    }

    /**
     * @notice Cast a low-level call conversion
     * @param tokens - an array of IERC20 tokens
     * @return assets - an array of IAssets
     */
    function _asIAsset(IERC20[] memory tokens) public pure returns (IAsset[] memory assets) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            assets := tokens
        }
    }

    /**
     * @notice Cast a low-level call conversion
     * @param assets - an array of IAssets
     * @return tokens - an array of IERC20 tokens
     */
    function _asIERC20(IAsset[] memory assets) public pure returns (IERC20[] memory tokens) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            tokens := assets
        }
    }
}
