// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization} from "../../interfaces/balancer/IVault.sol";
import {ISubsidy} from "../../aztec/interfaces/ISubsidy.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";
import {ErrorLib} from "../base/ErrorLib.sol";
import {BridgeBase} from "../base/BridgeBase.sol";

import "forge-std/Test.sol";
/**
 * @title An example bridge contract.
 * @author Aztec Team
 * @notice You can use this contract to immediately get back what you've deposited.
 * @dev This bridge demonstrates the flow of assets in the convert function. This bridge simply returns what has been
 *      sent to it.
 */
contract BalancerBridge is BridgeBase {

    // Main addresses
    address public constant vaultAddr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    IVault public constant VAULT = IVault(vaultAddr);

    mapping(uint64=>IVault.JoinPool) private joinPoolStructs;

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
        uint256 tokensLength = _tokensIn.length;
        for (uint256 i; i < tokensLength;) {
            address tokenIn = _tokensIn[i];
            IERC20(tokenIn).approve(vaultAddr, 0);
            IERC20(tokenIn).approve(vaultAddr, type(uint256).max);
            unchecked {
                ++i;
            }
        }
        tokensLength = _tokensOut.length;
        for (uint256 i; i < tokensLength;) {
            address tokenOut = _tokensOut[i];
            IERC20(tokenOut).approve(address(ROLLUP_PROCESSOR), 0);
            IERC20(tokenOut).approve(address(ROLLUP_PROCESSOR), type(uint256).max);
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice A function which will build the parameters for the vault action criteria
     * @param _joinPool - The struct containing the parameters for the vault action
     * @return auxData - The hash in uint64
     */
    function commitJoin(
        IVault.JoinPool memory _joinPool
    ) public returns (uint64 auxData) { 
        auxData = uint64(uint256(keccak256(abi.encode(_joinPool))));
        joinPoolStructs[auxData] = _joinPool;
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
    ) external payable override (BridgeBase) onlyRollup returns (uint256 outputValueA, uint256, bool) {                
        // Pay out subsidy to the rollupBeneficiary
        SUBSIDY.claimSubsidy(
            _computeCriteria(_inputAssetA.erc20Address, _inputAssetB.erc20Address, _outputAssetA.erc20Address), _rollupBeneficiary
        );
        
        // Check if the input asset is ETH
        bool inputIsEth = _inputAssetA.assetType == AztecTypes.AztecAssetType.ETH;
        inputIsEth == true ? true :  _inputAssetB.assetType == AztecTypes.AztecAssetType.ETH;
        bool outputIsEth = _outputAssetA.assetType == AztecTypes.AztecAssetType.ETH;

        // Check if the input asset is ETH
        if (_inputAssetA.assetType != AztecTypes.AztecAssetType.ERC20 && !inputIsEth) revert ErrorLib.InvalidInputA();
        if (_outputAssetA.assetType != AztecTypes.AztecAssetType.ERC20 && !outputIsEth) revert ErrorLib.InvalidOutputA();

        // Load the inputs for the vault action
        IVault.JoinPool memory inputs = joinPoolStructs[_auxData];

        // call joinPool and retrieves the output amount
        outputValueA = 
        joinPool(
            inputs.poolId,
            inputs.sender,
            inputs.recipient,
            inputs.request
        );

        // Delete the struct from the mapping
        delete(joinPoolStructs[_auxData]);

        // Approve rollup processor to take input value of input asset
        IERC20(_outputAssetA.erc20Address).approve(ROLLUP_PROCESSOR, outputValueA);
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _poolId - The poolId of the pool to join
     * @param _sender - The address which will send the tokens to the pool
     * @param _recipient - The address which will receive the pool tokens
     * @param request - The struct containing the parameters for the vault action
     * @return outputValue - the amount of output asset to return
     */
    function joinPool(
        bytes32 _poolId,
        address _sender,
        address _recipient,
        IVault.JoinPoolRequest memory request
    ) internal returns (uint256 outputValue) {
        // Get the address of the pool
        (address poolAddr, ) = VAULT.getPool(_poolId);
        outputValue = IERC20(poolAddr).balanceOf(_recipient);

        // before and after the vault action,
        VAULT.joinPool(
          _poolId,
          _sender,
          _recipient,
          request
        );

        // to calculate the output value
        outputValue = IERC20(poolAddr).balanceOf(_recipient) - outputValue;
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _inputAssetA - The token IN
     * @param _outputAssetA - The token OUT
     * @param _totalInputValue - The amount of _inputAssetA to swap
     * @return outputValueA - the amount of output assets returned
     */
    function swapGiveInAndOut(IVault.SwapKind kind,bytes32 poolId, address _inputAssetA, address _outputAssetA, uint256 _totalInputValue) internal returns (uint256 outputValueA) {
        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            poolId: poolId,
            kind: kind,
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
     * @param _inputTokenA The input assetA
     * @param _inputTokenB The input assetB
     * @param _outputToken The output asset
     */
    function registerSubsidyCriteria(address _inputTokenA, address _inputTokenB, address _outputToken) external {
        SUBSIDY.setGasUsageAndMinGasPerMinute({
            _criteria: _computeCriteria(_inputTokenA, _inputTokenB, _outputToken),
            _gasUsage: uint32(300000), // 300k gas (Note: this is a gas usage when only 1 split path is used)
            _minGasPerMinute: uint32(100) // 1 fully subsidized call per 2 days (300k / (24 * 60) / 2)
        });
    }

    /**
     * @notice Computes the criteria that is passed when claiming subsidy.
     * @param _inputTokenA The input assetA
     * @param _inputTokenB The input assetB
     * @param _outputToken The output asset
     * @return The criteria
     */
    function _computeCriteria(address _inputTokenA, address _inputTokenB, address _outputToken) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_inputTokenA, _inputTokenB, _outputToken)));
    }

    /**
     * @notice Cast a low-level call conversion
     * @param tokens - an array of IERC20 tokens
     * @return assets - an array of IAssets
     */
    function asIAsset(IERC20[] memory tokens) public pure returns (IAsset[] memory assets) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            assets := tokens
        }
    }
}
