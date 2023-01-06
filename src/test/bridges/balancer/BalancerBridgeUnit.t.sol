// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";

// balancer-specific imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BalancerBridge} from "../../../bridges/balancer/BalancerBridge.sol";
import {ErrorLib} from "../../../bridges/base/ErrorLib.sol";

import "forge-std/Test.sol";

// @notice The purpose of this test is to directly test convert functionality of the bridge.
contract BalancerBridgeUnitTest is BridgeTestBase {
    address private constant balancer = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address private constant BBAUSD = 0xA13a9247ea42D743238089903570127DdA72fE44;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant BENEFICIARY = address(11);

    address private rollupProcessor;
    // The reference to the balancer bridge
    BalancerBridge private bridge;

    // @dev This method exists on RollupProcessor.sol. It's defined here in order to be able to receive ETH like a real
    //      rollup processor would.
    function receiveEthFromBridge(uint256 _interactionNonce) external payable {}

    function setUp() public {
        // In unit tests we set address of rollupProcessor to the address of this test contract
        rollupProcessor = address(this);

        // Deploy a new balancer bridge
        bridge = new BalancerBridge(rollupProcessor, BBAUSD);

        // Set ETH balance of bridge and BENEFICIARY to 0 for clarity (somebody sent ETH to that address on mainnet)
        vm.deal(address(bridge), 0);
        vm.deal(BENEFICIARY, 0);

        // Use the label cheatcode to mark the address with "balancer Bridge" in the traces
        vm.label(address(bridge), "Balancer Bridge");
        vm.label(address(balancer), "Balancer Vault");

        // Subsidize the bridge when used with Dai and register a beneficiary
        AztecTypes.AztecAsset memory daiAsset = ROLLUP_ENCODER.getRealAztecAsset(DAI);
        AztecTypes.AztecAsset memory bbausdAsset =
            AztecTypes.AztecAsset({id: 1, erc20Address: BBAUSD, assetType: AztecTypes.AztecAssetType.ERC20});
        
        bridge.registerSubsidyCriteria(daiAsset.erc20Address, bbausdAsset.erc20Address);
        SUBSIDY.subsidize{value: 1e17}(
            address(bridge), bridge.computeCriteria(daiAsset, emptyAsset, bbausdAsset, emptyAsset, 0), 500
        );
        SUBSIDY.registerBeneficiary(BENEFICIARY);
    }

    function testInvalidCaller(address _callerAddress) public {
        vm.assume(_callerAddress != rollupProcessor);
        // Use HEVM cheatcode to call from a different address than is address(this)
        vm.prank(_callerAddress);
        vm.expectRevert(ErrorLib.InvalidCaller.selector);
        bridge.convert(emptyAsset, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    }

    function testInvalidInputAssetType() public {
        vm.expectRevert(ErrorLib.InvalidInputA.selector);
        bridge.convert(emptyAsset, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    }

    function testInvalidOutputAssetType() public {
        AztecTypes.AztecAsset memory inputAssetA =
            AztecTypes.AztecAsset({id: 1, erc20Address: DAI, assetType: AztecTypes.AztecAssetType.ERC20});
        vm.expectRevert(ErrorLib.InvalidOutputA.selector);
        bridge.convert(inputAssetA, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    }

    function testBalancerBridgeUnitTestFixed() public {
        testBalancerBridgeUnitTest(10 ether);
    }

    // @notice The purpose of this test is to directly test convert functionality of the bridge.
    // @dev In order to avoid overflows we set _depositAmount to be uint96 instead of uint256.
    function testBalancerBridgeUnitTest(uint96 _depositAmount) public {
        vm.warp(block.timestamp + 1 days);

        // Define input and output assets
        AztecTypes.AztecAsset memory inputAssetA =
            AztecTypes.AztecAsset({id: 0, erc20Address: address(0), assetType: AztecTypes.AztecAssetType.ETH});

        AztecTypes.AztecAsset memory outputAssetA =
            AztecTypes.AztecAsset({id: 1, erc20Address: BBAUSD, assetType: AztecTypes.AztecAssetType.ERC20});

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert. Since we are calling
        // bridge.convert(...) function directly we have to transfer the funds in the test on our own. In this case
        // we'll solve it by directly minting the _depositAmount of Dai to the bridge.
        deal(DAI, address(bridge), _depositAmount);

        // Store dai balance before interaction to be able to verify the balance after interaction is correct
        uint256 daiBalanceBefore = IERC20(DAI).balanceOf(rollupProcessor);

        // Pre-approve tokens
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = DAI;

        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BBAUSD;

        bridge.preApproveTokens(tokensIn, tokensOut);



        // Call the bridge contract
        (uint256 outputValueA, uint256 outputValueB, bool isAsync) = bridge.convert(
            inputAssetA, // _inputAssetA - definition of an input asset
            emptyAsset, // _inputAssetB - not used so can be left empty
            outputAssetA, // _outputAssetA - in this balancer equal to input asset
            emptyAsset, // _outputAssetB - not used so can be left empty
            _depositAmount, // _totalInputValue - an amount of input asset A sent to the bridge
            0, // _interactionNonce
            0, // _auxData - not used in the balancer bridge
            BENEFICIARY // _rollupBeneficiary - address, the subsidy will be sent to
        );

        // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(outputAssetA.erc20Address).transferFrom(address(bridge), rollupProcessor, outputValueA);

        // assertEq(outputValueB, 0, "Output value B must be 0");
        // assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // uint256 daiBalanceAfter = IERC20(DAI).balanceOf(rollupProcessor);
        // assertEq(daiBalanceAfter - daiBalanceBefore, _depositAmount, "Balances must match");

        // SUBSIDY.withdraw(BENEFICIARY);
        // assertGt(BENEFICIARY.balance, 0, "Subsidy was not claimed");
    }
}
