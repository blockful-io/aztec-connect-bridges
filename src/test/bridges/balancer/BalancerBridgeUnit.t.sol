// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";

// balancer-specific imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization, JoinKind, ExitKind} from "../../../interfaces/balancer/IVault.sol";
import {IRollupProcessor} from "rollup-encoder/interfaces/IRollupProcessor.sol";
import {BalancerBridge} from "../../../bridges/balancer/BalancerBridge.sol";
import {ErrorLib} from "../../../bridges/base/ErrorLib.sol";

import "forge-std/Test.sol";

// @notice The purpose of this test is to directly test convert functionality of the bridge.
contract BalancerBridgeUnitTest is BridgeTestBase {
    // Bridge and Rollup
    address private constant BENEFICIARY = address(11);
    address private rollupProcessor;
    BalancerBridge private bridge;
    // Balancer Vault and Commons
    address private constant VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // Balancer 80 BAL 20 WETH
    address private constant B80BAL20WETH = 0x5c6Ee304399DBdB9C8Ef030aB642B10820DB8F56;
    address private constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;
    // Balancer Aave Boosted StablePool
    address private constant BBAUSD = 0xA13a9247ea42D743238089903570127DdA72fE44;
    address private constant BBADAI = 0xae37D54Ae477268B9997d4161B96b8200755935c;
    address private constant BBAUSDT = 0x2F4eb100552ef93840d5aDC30560E5513DFfFACb;
    address private constant BBAUSDC = 0x82698aeCc9E28e9Bb27608Bd52cF57f704BD1B83;
    // Balancer stETH Stable Pool
    address private constant BSTETHSTABLE = 0x32296969Ef14EB0c6d29669C550D4a0449130230;
    address private constant WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    // Balancer rETH Stable Pool
    address private constant BRETHSTABLE = 0x1E19CF2D73a72Ef1332C882F20534B6519Be0276;
    address private constant RETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;
    // Balancer 50wstETH-50bb-a-USD
    address private constant WSTETH50BBAUSD50 = 0x25Accb7943Fd73Dda5E23bA6329085a3C24bfb6a;
    // Balancer 50STG-50bb-a-USD
    address private constant STG50BBAUSD50 = 0x4ce0BD7deBf13434d3ae127430e9BD4291bfB61f;
    address private constant STG = 0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6;

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
        vm.label(address(VAULT), "Balancer Vault");
        vm.label(address(WETH), "WETH");
        vm.label(address(DAI), "DAI");
        vm.label(address(B80BAL20WETH), "Balancer 80 BAL 20 WETH");
        vm.label(address(BAL), "BAL");
        
        vm.label(address(BBAUSD), "Balancer Aave Boosted StablePool");
        vm.label(address(BBADAI), "BBADAI");
        vm.label(address(BBAUSDT), "BBAUSDT");
        vm.label(address(BBAUSDC), "BBAUSDC");

        vm.label(address(BSTETHSTABLE), "Balancer stETH Stable Pool");
        vm.label(address(WSTETH), "Wrapped liquid staked Ether 2.0");

        vm.label(address(WSTETH50BBAUSD50), "Balancer 50wstETH-50bb-a-USD");

        vm.label(address(BRETHSTABLE), "Wrapped liquid staked Ether 2.0");
        vm.label(address(RETH), "Rocket Pool ETH");

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

    function asIERC20(address[] memory inputTokens) internal pure returns (IERC20[] memory tokens) {
        tokens = new IERC20[](inputTokens.length);
        for (uint256 i = 0; i < inputTokens.length; i++) {
            tokens[i] = IERC20(inputTokens[i]);
        }        
    }

    function encodeData(
        IVault.ActionKind actionType, 
        JoinKind poolKind, 
        address[] memory inputTokens, 
        uint256[] memory amountsIn, 
        address[] memory outputTokens
    ) public view returns (
        IVault.Join memory joinPool,
        IVault.Exit memory exitPool,
        IVault.Convert memory convert
    ) {
        // Convert IERC20 to IAsset
        IERC20[] memory tokens = asIERC20(actionType == IVault.ActionKind.JOIN ? inputTokens : outputTokens);
        IAsset[] memory assets = bridge._asIAsset(tokens);

        // @dev JoinKind is a enum in the IVault interface
        //     Using maxAmountsIn as a higher value than the amountsIn
        uint256[] memory maxAmountsIn = new uint256[](amountsIn.length);
        for(uint256 i = 0; i < amountsIn.length; i++) {
            maxAmountsIn[i] = 2**256 - 1;
        }
        
        // @dev We encode both joinKind and amountsIn
        bytes memory userDataEncoded = abi.encode(poolKind, amountsIn);

        // Get poolId
        // @dev There will always be only 1 issued token per single pool.
        //      Which means we can asume the index 0 of the array is the correct pool to use.
        //      Also assuming we are only handling joins and exits
        bytes32 poolId = IVault(actionType == IVault.ActionKind.JOIN ? outputTokens[0] : inputTokens[0] ).getPoolId();
        
        convert = IVault.Convert({
            inputAssetA: emptyAsset,
            inputAssetB: emptyAsset,
            outputAssetA: emptyAsset,
            outputAssetB: emptyAsset,
            totalInputValue: 0,
            interactionNonce: 0,
            rollupBeneficiary: BENEFICIARY
        });

        // Build request
        if(actionType == IVault.ActionKind.JOIN) {
            IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({ 
                assets: assets,
                maxAmountsIn: maxAmountsIn,
                userData: userDataEncoded,
                fromInternalBalance: false
            });
            joinPool = IVault.Join({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });
        } else {
            IVault.ExitPoolRequest memory request = IVault.ExitPoolRequest({ 
                assets: assets,
                minAmountsOut: amountsIn,
                userData: userDataEncoded,
                toInternalBalance: false
            });
            exitPool = IVault.Exit({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });
        }
        
        return (joinPool, exitPool, convert);
    }

    /* @notice Same as testJoinPool80BAL20WETH, but using ETH instead of WETH
     * @dev In order to avoid overflows we set _depositAmount to be uint96 instead of uint256.
     */ 
    function testJoinPool80BAL20WETHUsingETH() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = BAL;
        tokensIn[1] = address(0);
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = B80BAL20WETH;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert. Since we are calling
        // bridge.convert(...) function directly we have to transfer the funds in the test on our own. In this case
        // we'll solve it by directly minting the _depositAmount of Dai to the bridge.
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Store the input balances before the trade to compare later
        uint256[] memory inputBalancesBefore = new uint256[](tokensIn.length);
        for(uint256 i = 0; i < tokensIn.length; i++) {
            if(tokensIn[i] == address(0)){
                inputBalancesBefore[i] = address(bridge).balance;
            } else {
                inputBalancesBefore[i] = IERC20(tokensIn[i]).balanceOf(address(bridge));
            }
        }

        uint256 outputBalanceBefore = IERC20(tokensOut[0]).balanceOf(rollupProcessor);
        assertEq(outputBalanceBefore, 0, "Initial output balance must be 0");

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.JOIN, 
            JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.joinPool{ value: 1e18 }(joinPool, convert);

        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");
        
        // Matches all input balances after the transaction
        uint256[] memory inputBalancesAfter = new uint256[](tokensIn.length);
        for(uint256 i = 0; i < tokensIn.length; i++) {
            if(tokensIn[i] == address(0)){
                inputBalancesBefore[i] = address(bridge).balance;
            } else {
                inputBalancesAfter[i] = IERC20(tokensIn[i]).balanceOf(address(bridge));
            }
        }

        // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        
        // Verify the rollup processor received the correct amount of tokens
        uint256 outputBalanceAfter = IERC20(tokensOut[0]).balanceOf(rollupProcessor);
        assertEq(outputBalanceAfter, outputValueA, "Rollup processor have not received any tokens yet");

    }

    /* @notice The purpose of this test is to directly test convert functionality of the bridge
     *         when joining Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     * @dev In order to avoid overflows we set _depositAmount to be uint96 instead of uint256.
     */ 
    function testJoinPool80BAL20WETH() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = BAL;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = B80BAL20WETH;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert. Since we are calling
        // bridge.convert(...) function directly we have to transfer the funds in the test on our own. In this case
        // we'll solve it by directly minting the _depositAmount of Dai to the bridge.
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Store the input balances before the trade to compare later
        uint256[] memory inputBalancesBefore = new uint256[](tokensIn.length);
        for(uint256 i = 0; i < tokensIn.length; i++) {
            inputBalancesBefore[i] = IERC20(tokensIn[i]).balanceOf(address(bridge));
        }

        uint256 outputBalanceBefore = IERC20(tokensOut[0]).balanceOf(rollupProcessor);
        assertEq(outputBalanceBefore, 0, "Initial output balance must be 0");

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.JOIN, 
            JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.joinPool(joinPool, convert);

        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");
        
        // Matches all input balances after the transaction
        uint256[] memory inputBalancesAfter = new uint256[](tokensIn.length);
        for(uint256 i = 0; i < tokensIn.length; i++) {
            inputBalancesAfter[i] = IERC20(tokensIn[i]).balanceOf(address(bridge));
        }

        // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        
        // Verify the rollup processor received the correct amount of tokens
        uint256 outputBalanceAfter = IERC20(tokensOut[0]).balanceOf(rollupProcessor);
        assertEq(outputBalanceAfter, outputValueA, "Rollup processor have not received any tokens yet");

    }

    /**
     * @dev Deal multiple assets based on input token array
     * @param _inputTokens - The array of input tokens
     * @param _target - The receiver of such tokens
     * @param _amount - The array with the amount of tokens
     */
    function dealMultiple(
        address[] memory _inputTokens, 
        address _target, 
        uint256[] memory _amount
    ) public {
        for(uint256 i = 0; i < _inputTokens.length; i++){
            if(_inputTokens[i] == address(0)) {
                vm.deal(address(bridge), _amount[i]);
            } else {
                deal(_inputTokens[i], _target, _amount[i]);
            }
        }
    }

}
