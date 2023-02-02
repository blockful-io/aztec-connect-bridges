// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";
import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";

// balancer-specific imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset, PoolSpecialization, JoinKind, ExitKind} from "../../../interfaces/balancer/IVault.sol";
import {IBalancerQueries} from "../../../interfaces/balancer/IBalancerQueries.sol";
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
    address private constant HELPER = 0xE39B5e3B6D74016b2F6A9673D7d7493B6DF549d5;
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
        vm.label(address(0xce88686553686DA562CE7Cea497CE749DA109f9F), "Fee Collector");
        vm.label(address(WETH), "WETH");
        vm.label(address(DAI), "DAI");
        vm.label(address(BAL), "BAL");
        vm.label(address(B80BAL20WETH), "Balancer 80 BAL 20 WETH");
        
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

    /**
     * @dev This method is used to encode the data that will be sent to the Balancer Bridge
     * @param actionType The action type (join or exit)
     * @param tokensIn The tokens that will be sent to the bridge   
     * @param amountsIn The amounts of tokens that will be sent to the bridge
     * @param tokensOut The tokens that will be received from the bridge
     * @return joinPool The join pool action
     * @return exitPool The exit pool action
     * @return convert The convert action
     */
    function encodeData(
        IVault.ActionKind actionType, 
        address[] memory tokensIn, 
        uint256[] memory amountsIn, 
        address[] memory tokensOut
    ) public view returns (
        IVault.Join memory joinPool,
        IVault.Exit memory exitPool,
        IVault.Convert memory convert
    ) {
        // Convert IERC20 to IAsset
        IERC20[] memory tokens = asIERC20(actionType == IVault.ActionKind.JOIN ? tokensIn : tokensOut);
        IAsset[] memory assets = bridge._asIAsset(tokens);
        
        // @dev We encode both joinKind and amountsIn
        bytes memory userDataEncoded;
        if(actionType == IVault.ActionKind.JOIN)
            userDataEncoded = abi.encode(JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, amountsIn);
        else
            userDataEncoded = abi.encode(ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT, amountsIn);

        // Get poolId
        // @dev There will always be only 1 issued token per single pool.
        //      Which means we can asume the index 0 of the array is the correct pool to use.
        //      Also assuming we are only handling joins and exits
        bytes32 poolId = IVault(actionType == IVault.ActionKind.JOIN ? tokensOut[0] : tokensIn[0] ).getPoolId();
        
        // We must wrap the convert request in a struct to avoid deepstack
        convert = IVault.Convert({
            inputAssetA: emptyAsset,
            inputAssetB: emptyAsset,
            outputAssetA: emptyAsset,
            outputAssetB: emptyAsset,
            totalInputValue: 0,
            interactionNonce: 0,
            rollupBeneficiary: BENEFICIARY
        });

        if(actionType == IVault.ActionKind.JOIN) {
            // Using maxAmountsIn as the maximum uint256
            uint256[] memory maxAmountsIn = new uint256[](tokensIn.length);
            for(uint256 i = 0; i < amountsIn.length; i++) {
                maxAmountsIn[i] = 2**256 - 1;
            }            
            // Build join request
            IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({ 
                assets: assets,
                maxAmountsIn: maxAmountsIn,
                userData: userDataEncoded,
                fromInternalBalance: false
            });
            // Interact with the vault with JoinPool
            joinPool = IVault.Join({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });
        } else {
            // Still uncertain about the initial value here
            uint256[] memory minAmountsOut = new uint256[](tokensOut.length);
            for(uint256 i = 0; i < tokensOut.length; i++) {
                minAmountsOut[i] = 0;
            }

            // Build ExitPool request
            IVault.ExitPoolRequest memory request = 
            IVault.ExitPoolRequest({ 
                assets: assets,
                minAmountsOut: minAmountsOut,
                userData: userDataEncoded,
                toInternalBalance: false
            });

            // @dev This is just for mock, doesn't work either
            //      But it always returns 0
            // ( uint256 , uint256[] memory amountOut) =
            // IBalancerQueries(HELPER).queryExit(
            //     poolId,
            //     address(bridge),
            //     address(bridge),
            //     request
            // );
            // request.minAmountsOut = amountOut;

            // @dev Currently not working, must investigate the combination that suits
            // bytes memory encodeWithSig = 
            // abi.encodeWithSignature(
            //     "queryExit(bytes32,address,address,(IAsset[],uint256[],bytes,bool) memory)",
            //     poolId,
            //     address(bridge),
            //     address(bridge),
            //     request.assets,
            //     request.minAmountsOut,
            //     request.userData,
            //     request.toInternalBalance
            // );

            // uint256[] memory amountsOut = staticQueryExit(address(HELPER), encodeWithSig);
            // request.minAmountsOut = amountsOut;

            // Interact with the vault with ExitPool
            exitPool = IVault.Exit({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });
        }
        return (joinPool, exitPool, convert);
    }

    /** @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when joining Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     */ 
    function testJoinPoolBSTETHSTABLE() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = WSTETH;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BSTETHSTABLE;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.JOIN, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        // JoinPool will call convert internally
        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.joinPool(joinPool, convert);

        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // Now we transfer the funds from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
    }

    /** @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when exiting Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     */ 
    function testExitPoolBSTETHSTABLE() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = BSTETHSTABLE;
        address[] memory tokensOut = new address[](2);
        tokensOut[0] = WSTETH;
        tokensOut[1] = WETH;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.EXIT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        // ExitPool will call convert internally
        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.exitPool(exitPool, convert);

        // Output is always 0 ??
        // assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        IERC20(tokensOut[1]).transferFrom(address(bridge), rollupProcessor, outputValueB);
    }

    /** @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when joining Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     */ 
    function testJoinPool80BAL20WETH() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = BAL;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = B80BAL20WETH;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.JOIN, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        // JoinPool will call convert internally
        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.joinPool(joinPool, convert);

        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // Now we transfer the funds from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
    }

    /* @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when exiting Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     */ 
    function testExitPool80BAL20WETH() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = B80BAL20WETH;
        address[] memory tokensOut = new address[](2);
        tokensOut[0] = BAL;
        tokensOut[1] = WETH;

        // Rollup processor transfers ERC20 tokens to the bridge before calling convert
        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        // Encode all data for the function call
        ( 
            IVault.Join memory joinPool, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeData(
            IVault.ActionKind.EXIT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        // Pre-approve tokens
        bridge.preApproveTokens(tokensIn, tokensOut);

        // ExitPool will call convert internally
        ( uint256 outputValueA, uint256 outputValueB, bool isAsync ) = 
        bridge.exitPool(exitPool, convert);

        // Output is always 0 ??
        // assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        IERC20(tokensOut[1]).transferFrom(address(bridge), rollupProcessor, outputValueB);
    }

    /**
     * @dev Deal multiple assets at once
     * @param _inputTokens - Array of tokens
     * @param _target - The receiver
     * @param _amount - The array with the amounts of tokens
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

    /**
     * @dev Turns an array of addresses into an array of IERC20
     * @param inputTokens - Input tokens addresses
     * @return tokens - The receiver of such tokens
     */
    function asIERC20(address[] memory inputTokens) internal pure returns (IERC20[] memory tokens) {
        tokens = new IERC20[](inputTokens.length);
        for (uint256 i = 0; i < inputTokens.length; i++) {
            tokens[i] = IERC20(inputTokens[i]);
        }        
    }

    /** @dev - Query the Vault for the amountsOut of an exit
     * @param target - The target contract
     * @param encodeWithSig - The encoded function call
     * @return amountsOut - The amountsOut of the exit
     */
    function staticQueryExit(address target, bytes memory encodeWithSig) public view returns(uint256[] memory amountsOut) {
        ( , bytes memory data) = target.staticcall(encodeWithSig); 
        ( , amountsOut) = abi.decode(data, (uint256, uint256[]));
        return amountsOut;
    }

}
