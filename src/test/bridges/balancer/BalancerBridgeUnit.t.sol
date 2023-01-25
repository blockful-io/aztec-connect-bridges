// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";

// balancer-specific imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization} from "../../../interfaces/balancer/IVault.sol";
import {IRollupProcessor} from "rollup-encoder/interfaces/IRollupProcessor.sol";
import {BalancerBridge} from "../../../bridges/balancer/BalancerBridge.sol";
import {ErrorLib} from "../../../bridges/base/ErrorLib.sol";

import "forge-std/Test.sol";

// @notice The purpose of this test is to directly test convert functionality of the bridge.
contract BalancerBridgeUnitTest is BridgeTestBase {
    address private constant BENEFICIARY = address(11);
    address private constant vaultAddr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address private constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant BstETHSTABLE = 0x32296969Ef14EB0c6d29669C550D4a0449130230;

    address private rollupProcessor;
    // The reference to the balancer bridge
    BalancerBridge private bridge;

    // @dev This method exists on RollupProcessor.sol. It's defined here in order to be able to receive ETH like a real
    //      rollup processor would.
    function receiveEthFromBridge(uint256 _interactionNonce) external payable {}

    function setUp() public {
        // In unit tests we set address of rollupProcessor to the address of this test contract
        rollupProcessor = address(this);

        // Deploy a new balancer bridge and pass the pool address of bb-a-usd
        bridge = new BalancerBridge(rollupProcessor);
        
        // Set ETH balance of bridge and BENEFICIARY to 0 for clarity (somebody sent ETH to that address on mainnet)
        vm.deal(address(bridge), 0);
        vm.deal(BENEFICIARY, 0);

        // Use the label cheatcode to mark the address with "balancer Bridge" in the traces
        vm.label(address(bridge), "Balancer Bridge");
        vm.label(address(vaultAddr), "Balancer Vault");
        vm.label(address(BAL), "BAL");
        vm.label(address(DAI), "DAI");
        vm.label(address(wstETH), "Wrapped liquid staked Ether 2.0");
        vm.label(address(WETH), "WETH");
        vm.label(address(BstETHSTABLE), "Balancer stETH Stable Pool");

        bridge.registerSubsidyCriteria(wstETH, WETH, BstETHSTABLE);
        SUBSIDY.subsidize{value: 1e17}(
            address(bridge), bridge._computeCriteria(wstETH, WETH, BstETHSTABLE), uint32(100)
        );
        SUBSIDY.registerBeneficiary(BENEFICIARY);
    }

    // function testInvalidCaller(address _callerAddress) public {
    //     vm.assume(_callerAddress != rollupProcessor);
    //     // Use HEVM cheatcode to call from a different address than is address(this)
    //     vm.prank(_callerAddress);
    //     vm.expectRevert(ErrorLib.InvalidCaller.selector);
    //     bridge.convert(emptyAsset, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    // }

    // function testInvalidInputAssetType() public {
    //     vm.expectRevert(ErrorLib.InvalidInputA.selector);
    //     bridge.convert(emptyAsset, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    // }

    // function testInvalidOutputAssetType() public {
    //     AztecTypes.AztecAsset memory inputAssetA =
    //         AztecTypes.AztecAsset({id: 1, erc20Address: DAI, assetType: AztecTypes.AztecAssetType.ERC20});
    //     vm.expectRevert(ErrorLib.InvalidOutputA.selector);
    //     bridge.convert(inputAssetA, emptyAsset, emptyAsset, emptyAsset, 0, 0, 0, address(0));
    // }

    // function testBalancerBridgeUnitTestFixed() public {
    //     testBalancerBridgeUnitTest(10 ether);
    // }

    function avoidDeepStack() public returns (uint64 auxData) {
        // Pre-approve tokens
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = wstETH;
        tokensIn[1] = WETH;

        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BstETHSTABLE;

        bridge.preApproveTokens(tokensIn, tokensOut);

        // Prepare IAsset
        IERC20 token0 = IERC20(wstETH);
        IERC20 token1 = IERC20(WETH);
        IERC20[] memory tokens = new IERC20[](2);
        tokens[0] = token0;
        tokens[1] = token1;
        IAsset[] memory assets = bridge.asIAsset(tokens);

        // Prepare maxAmountsIn
        uint256[] memory amountsIn = new uint256[](2);
        amountsIn[0] = 10e18;
        amountsIn[1] = 10e18;

        uint256 joinKind = 1;
        uint256[] memory initBalances = new uint256[](2);
        initBalances[0] = 1e18;
        initBalances[1] = 1e18;
        bytes memory userDataEncoded = abi.encode(joinKind, initBalances);

        // Get poolId
        bytes32 poolId = IVault(BstETHSTABLE).getPoolId();
        // Build request
        // @dev An equivalent for max uint256 can be the built-in (2**256 - 1)

        IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({ 
            assets: assets,
            maxAmountsIn: amountsIn,
            userData: userDataEncoded,
            // userData: abi.encode([1e18,1e18],[0,0]),
            fromInternalBalance: false
        });
        IVault.JoinPool memory joinPool = IVault.JoinPool({
            poolId: poolId,
            sender: address(bridge),
            recipient: address(bridge),
            request: request
        });

        auxData = bridge.commitJoin(joinPool);
    }

    // @notice The purpose of this test is to directly test convert functionality of the bridge.
    // @dev In order to avoid overflows we set _depositAmount to be uint96 instead of uint256.
    function testBalancerBridgeUnitTest() public {
        // Define input and output assets
        AztecTypes.AztecAsset memory inputAssetA =
            AztecTypes.AztecAsset({id: 1, erc20Address: wstETH, assetType: AztecTypes.AztecAssetType.ERC20});
        AztecTypes.AztecAsset memory inputAssetB =
            AztecTypes.AztecAsset({id: 0, erc20Address: address(0), assetType: AztecTypes.AztecAssetType.ETH});
        AztecTypes.AztecAsset memory outputAssetA =
            AztecTypes.AztecAsset({id: 2, erc20Address: BstETHSTABLE, assetType: AztecTypes.AztecAssetType.ERC20});
                
        // Rollup processor transfers ERC20 tokens to the bridge before calling convert. Since we are calling
        // bridge.convert(...) function directly we have to transfer the funds in the test on our own. In this case
        // we'll solve it by directly minting the _depositAmount of Dai to the bridge.
        deal(wstETH, address(bridge), 1e18);
        deal(WETH, address(bridge), 1e18);

        // Store weth balance before interaction to be able to verify the balance after interaction is correct
        uint256 bstEthStableBalanceBefore = IERC20(BstETHSTABLE).balanceOf(address(bridge));
        assertEq(bstEthStableBalanceBefore, 0);

        // Prepare auxData separetly tro avoid deep stack
        uint64 auxData = avoidDeepStack();
        assertGt(auxData, 0);

        // Call the bridge contract
        (uint256 outputValueA, uint256 outputValueB, bool isAsync) = bridge.convert(
            inputAssetA, // _inputAssetA - definition of an input asset
            inputAssetB, // _inputAssetB - not used so can be left empty
            outputAssetA, // _outputAssetA - in this balancer equal to input asset
            emptyAsset, // _outputAssetB - not used so can be left empty
            0, // _totalInputValue - an amount of input asset A sent to the bridge
            0, // _interactionNonce
            auxData, // _auxData - auxiliary data for the bridge
            BENEFICIARY // _rollupBeneficiary - address, the subsidy will be sent to
        );

        uint256 bstEthStableBalanceAfter = IERC20(BstETHSTABLE).balanceOf(address(bridge));
        assertEq(bstEthStableBalanceAfter - bstEthStableBalanceBefore, outputValueA, "Balances must match");

        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(outputAssetA.erc20Address).transferFrom(address(bridge), rollupProcessor, outputValueA);

    }
}
