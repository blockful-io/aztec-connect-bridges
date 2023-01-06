// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization} from "../../interfaces/balancer/IVault.sol";
import {IPool} from "../../interfaces/balancer/IPool.sol";
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

    error INVALID_POOL();

    // Main addresses
    address public immutable poolAddr;
    address public constant vaultAddr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    IVault public constant VAULT = IVault(vaultAddr);

    /**
     * @notice Set address of rollup processor
     * @param _rollupProcessor Address of rollup processor
     */
    constructor(
        address _rollupProcessor,
        address _poolAddress
    ) BridgeBase(_rollupProcessor) {
        poolAddr = _poolAddress;
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
            _computeCriteria(_inputAssetA.erc20Address, _outputAssetA.erc20Address), _rollupBeneficiary
        );
        
        // Check if the input asset is ERC20
        if (_inputAssetA.assetType != AztecTypes.AztecAssetType.ERC20) revert ErrorLib.InvalidInputA();
        if (_outputAssetA.assetType != AztecTypes.AztecAssetType.ERC20) revert ErrorLib.InvalidOutputA();

        // Fetch poolId from bb-a-USD pool address
        bytes32 poolId = IPool(poolAddr).getPoolId();

        // Calls the joinPool tryna fetch the output value in bpts
        (outputValueA, ) = joinPool(poolId,_inputAssetA.erc20Address, _outputAssetA.erc20Address, _totalInputValue);
        
        // Approve rollup processor to take input value of input asset
        IERC20(_outputAssetA.erc20Address).approve(ROLLUP_PROCESSOR, outputValueA);
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     */
    function joinPool(bytes32 poolId, address _inputAssetA, address _outputAssetA, uint256 _totalInputValue) internal returns (uint256, uint256[] memory) {
        // (
        //     IERC20[] memory tokens, 
        //     uint256[] memory balances,
        // ) = VAULT.getPoolTokens(poolId);

        // VAULT.joinPool({
        //     poolAddress: pool,
        //     poolId: poolId,
        //     recipient: address(this),
        //     currentBalances: balances,
        //     tokens: allTokens,
        //     lastChangeBlock: params.lastChangeBlock ?? 0,
        //     protocolFeePercentage: params.protocolFeePercentage ?? 0,
        //     data: params.data ?? '0x',
        //     from: params.from,
        // });
    }

    /**
     * @notice A function which returns an amount of _outputAssetA
     * @param _inputAssetA - The token IN
     * @param _outputAssetA - The token OUT
     * @param _totalInputValue - The amount of _inputAssetA to swap
     * @return outputValueA - the amount of output assets returned
     */
    function swapGiveIn(bytes32 poolId, address _inputAssetA, address _outputAssetA, uint256 _totalInputValue) internal returns (uint256 outputValueA) {
        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            poolId: poolId,
            kind: IVault.SwapKind.GIVEN_IN,
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
     * @param _tokenIn - Input token to swap
     * @param _tokenOut - Output token to swap
     */
    function registerSubsidyCriteria(address _tokenIn, address _tokenOut) external {
        SUBSIDY.setGasUsageAndMinGasPerMinute({
            _criteria: _computeCriteria(_tokenIn, _tokenOut),
            _gasUsage: uint32(300000), // 300k gas (Note: this is a gas usage when only 1 split path is used)
            _minGasPerMinute: uint32(100) // 1 fully subsidized call per 2 days (300k / (24 * 60) / 2)
        });
    }

    /**
     * @notice Computes the criteria that is passed when claiming subsidy.
     * @param _inputToken The input asset
     * @param _outputToken The output asset
     * @return The criteria
     */
    function _computeCriteria(address _inputToken, address _outputToken) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_inputToken, _outputToken)));
    }

    /**
     * @notice Computes the criteria that is passed when claiming subsidy.
     * @param _inputAssetA The input asset
     * @param _outputAssetA The output asset
     * @return The criteria
     */
    function computeCriteria(
        AztecTypes.AztecAsset calldata _inputAssetA,
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata _outputAssetA,
        AztecTypes.AztecAsset calldata,
        uint64
    ) public view override (BridgeBase) returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_inputAssetA.erc20Address, _outputAssetA.erc20Address)));
    }
}
