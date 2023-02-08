// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";
import {BalancerBridge} from "../../../bridges/balancer/BalancerBridge.sol";
import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";
import {IRollupProcessor} from "rollup-encoder/interfaces/IRollupProcessor.sol";
import {ErrorLib} from "../../../bridges/base/ErrorLib.sol";

// balancer-specific imports
import {IBalancerQueries} from "../../../interfaces/balancer/IBalancerQueries.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset} from "../../../interfaces/balancer/IVault.sol";

import "forge-std/Test.sol";

// @notice The purpose of this test is to directly test the convert functionality of the bridge.
contract BalancerBridgeUnitTest is BridgeTestBase {
    // Bridge and Rollup
    address private constant BENEFICIARY = address(11);
    address private rollupProcessor;
    BalancerBridge private bridge;
    // Balancer Vault and Commons
    address private constant VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address private constant HELPER = 0xE39B5e3B6D74016b2F6A9673D7d7493B6DF549d5;
    address private constant FEE_COLLECTOR = 0xce88686553686DA562CE7Cea497CE749DA109f9F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // Balancer 80 BAL 20 WETH
    address private constant B80BAL20WETH = 0x5c6Ee304399DBdB9C8Ef030aB642B10820DB8F56;
    address private constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;
    // Balancer stETH Stable Pool
    address private constant BSTETHSTABLE = 0x32296969Ef14EB0c6d29669C550D4a0449130230;
    address private constant WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    // Balancer rETH Stable Pool
    address private constant BRETHSTABLE = 0x1E19CF2D73a72Ef1332C882F20534B6519Be0276;
    address private constant RETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;

    /** 
     *  @notice - This method exists on RollupProcessor.sol. It's defined here in order 
     *            to be able to receive ETH as a real rollup processor would.
     */
    function receiveEthFromBridge(
        uint256 _interactionNonce
    ) external payable {}

    function setUp(
    ) public {
        // In unit tests we set the address of rollupProcessor to the address of this test contract
        rollupProcessor = address(this);

        // Deploy a new balancer bridge and pass the pool rollup processor
        bridge = new BalancerBridge(rollupProcessor);
        
        // Set ETH balance of bridge and BENEFICIARY to 0 for clarity
        vm.deal(address(bridge), 0);
        vm.deal(BENEFICIARY, 0);

        // Use the label cheat code to mark the address with "balancer Bridge" in the traces
        vm.label(address(bridge), "Balancer Bridge");
        vm.label(address(VAULT), "Balancer Vault");
        vm.label(address(FEE_COLLECTOR), "Fee Collector");
        vm.label(address(WETH), "WETH");
        vm.label(address(DAI), "DAI");
        vm.label(address(BAL), "BAL");
        vm.label(address(RETH), "Rocket Pool ETH");
        vm.label(address(WSTETH), "Wrapped liquid staked Ether 2.0");

        vm.label(address(B80BAL20WETH), "Balancer 80 BAL 20 WETH");
        vm.label(address(BSTETHSTABLE), "Balancer stETH Stable Pool");
        vm.label(address(BRETHSTABLE), "Balancer rETH Stable Pool");
    }
    
    /** 
     * @notice - The purpose is to directly test the convert functionality of the bridge
     *            when swapping WETH to DAI.
     */ 
    function testSwapWETHtoDAI(
    ) public {
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BAL;

        uint256 amountIn = 1e18;
        deal(WETH, address(bridge), amountIn);

        bytes32 poolId = IVault(B80BAL20WETH).getPoolId();

        ( 
            IVault.Swap memory swap,
            IVault.Convert memory convert
        ) = encodeSwap(
            poolId,
            IVault.SwapKind.GIVEN_IN, 
            tokensIn[0],
            tokensOut[0],
            amountIn);

        bridge.preApproveTokens(tokensIn, tokensOut);

        (
            uint256 outputValueA,
            uint256 outputValueB,
            bool isAsync
        ) = bridge.swap(
            swap, 
            convert);

        assertGt(outputValueA, 0, "OutputValueA must be greater than 0");
        assertEq(outputValueB, 0, "OutputValueB must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        IERC20(BAL).transferFrom(address(bridge), rollupProcessor, outputValueA);

        assertEq(
            IERC20(BAL).balanceOf(address(bridge)), 
            0,
            "Bridge BAL balance must be 0");
        assertEq(
            IERC20(WETH).balanceOf(address(bridge)), 
            0,
            "Bridge WETH balance must be 0");
        assertEq(
            IERC20(BAL).balanceOf(address(rollupProcessor)), 
            outputValueA,
            "Rollup WETH balance must match the output");
    }

    /** 
     * @notice - The purpose is to directly test the convert functionality of the bridge
     *            when batchSwapping BAL to WSTETH. Running through 2 hops.
     */ 
    function testBatchSwapBALtoWSTETH(
    ) public {
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = BAL;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](2);
        tokensOut[0] = WETH;
        tokensOut[1] = WSTETH;
        address[] memory poolAddr = new address[](2);
        poolAddr[0] = B80BAL20WETH;
        poolAddr[1] = BSTETHSTABLE;

        uint256 amountsIn = 10e18;
        deal(tokensIn[0], address(bridge), amountsIn);

        IVault.Trade[] memory trades = makeTrades(tokensIn, tokensOut, poolAddr, amountsIn);

        ( 
            IVault.BatchSwap memory batchSwap,
            IVault.Convert memory convert
        ) = encodeBatchSwap(
            IVault.SwapKind.GIVEN_IN,
            trades);

        bridge.preApproveTokens(tokensIn, tokensOut);

        (
            uint256 outputValueA,
            uint256 outputValueB,
            bool isAsync
        ) = bridge.batchSwap(
            batchSwap, 
            convert);

        assertGt(outputValueA, 0, "OutputValueA must be greater than 0");
        assertEq(outputValueB, 0, "OutputValueB must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");
        
        assertEq(
            IERC20(tokensOut[1]).balanceOf(address(bridge)), 
            outputValueA, 
            "Bridge must have a balance greater than 0");

        IERC20(tokensOut[1]).transferFrom(address(bridge), rollupProcessor, outputValueA);

        assertEq(
            IERC20(tokensOut[1]).balanceOf(rollupProcessor), 
            outputValueA, 
            "Rollup should should receive the output from the bridge");

    }

    /** 
     * @notice - The purpose is to directly test the convert functionality of the bridge
     *           when joinning Balancer stETH Stable Pool.
     */ 
    function testJoinPoolBSTETHSTABLE(
    ) public {
        // @dev - TokensIn must be in the same order as the returned value from getPoolTokens
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = WSTETH;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BSTETHSTABLE;

        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        ( 
            IVault.Join memory joinPool,, 
            IVault.Convert memory convert
        ) = encodeDataJoinOrExit(
            IVault.ActionKind.JOIN, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( 
            uint256 outputValueA, 
            uint256 outputValueB, 
            bool isAsync 
        ) = bridge.joinPool(
            joinPool, 
            convert);

        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        assertEq(
            IERC20(tokensOut[0]).balanceOf(address(bridge)), 
            outputValueA, 
            "Bridge must have a balance greater than 0");

        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);

        assertEq(
            IERC20(tokensOut[0]).balanceOf(rollupProcessor), 
            outputValueA, 
            "Rollup should should receive the output from the bridge");
    }

    /** 
     * @notice - The purpose is to directly test the convert functionality of the bridge
     *           when joinning Balancer 80 BAL 20 WETH.
     */ 
    function testJoinPool80BAL20WETH(        
    ) public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = BAL;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = B80BAL20WETH;

        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 80e17;
        amountsIn[1] = 20e17;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        ( 
            IVault.Join memory joinPool,, 
            IVault.Convert memory convert
        ) = encodeDataJoinOrExit(
            IVault.ActionKind.JOIN, 
            tokensIn, 
            amountsIn, 
            tokensOut);
        
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( 
            uint256 outputValueA, 
            uint256 outputValueB, 
            bool isAsync 
        ) = bridge.joinPool(
            joinPool, 
            convert);

        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        assertEq(
            IERC20(tokensOut[0]).balanceOf(address(bridge)), 
            outputValueA, 
            "Bridge must have a balance greater than 0");

        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);

        assertEq(
            IERC20(tokensOut[0]).balanceOf(rollupProcessor), 
            outputValueA, 
            "Rollup should should receive the output from the bridge");
    }

    /**
     *  @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when joining Balancer rETH Stable Pool.
     */ 
    function testJoinPoolBRETHSTABLE(        
    ) public {
        address[] memory tokensIn = new address[](2);
        tokensIn[0] = RETH;
        tokensIn[1] = WETH;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = BRETHSTABLE;

        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        amountsIn[1] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        ( 
            IVault.Join memory joinPool,, 
            IVault.Convert memory convert
        ) = encodeDataJoinOrExit(
            IVault.ActionKind.JOIN, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( 
            uint256 outputValueA, 
            uint256 outputValueB, 
            bool isAsync 
        ) = bridge.joinPool(
            joinPool, 
            convert);

        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        assertEq(
            IERC20(tokensOut[0]).balanceOf(address(bridge)), 
            outputValueA, 
            "Bridge must have a balance greater than 0");

        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);

        assertEq(
            IERC20(tokensOut[0]).balanceOf(rollupProcessor), 
            outputValueA, 
            "Rollup should should receive the output from the bridge");
    }

    /** 
     * @notice - The purpose of this test is to directly test convert functionality of the bridge
     *            when exiting Balancer stETH Stable Pool.
     *  @dev    - There is two assertions commented, if you uncomment then, you'll find that
     *            exitPool is only using 64 fixed units from the input asset, altough the function
     *            is returning as success. 
     *            Came to my attention, regarding userData when exiting a pool: the minAmountsOut
     *            cannot differs from 0, otherise onExitPool will throw error. 
     */ 
    function testExitPoolBSTETHSTABLE(        
    ) public {
        // Must be in the same order when returned from the Balancer Vault function getPoolTokens()
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = BSTETHSTABLE;
        address[] memory tokensOut = new address[](2);
        tokensOut[0] = WSTETH;
        tokensOut[1] = WETH;

        uint256[] memory amountsIn = new uint256[](1);
        amountsIn[0] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        assertEq(
            IERC20(BSTETHSTABLE).balanceOf(address(bridge)),
            amountsIn[0],
            "Initial balance must match deal amount"
        );

        (, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeDataJoinOrExit(
            IVault.ActionKind.EXIT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( 
            uint256 outputValueA, 
            uint256 outputValueB, 
            bool isAsync 
        ) = bridge.exitPool(
            exitPool, 
            convert);

        assertEq(
            IERC20(BSTETHSTABLE).balanceOf(address(bridge)),
            0,
            "Should've consumed the entire amountIn, but it is only using 64 units"
        );

        // Output is always 0 ??
        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertGt(outputValueB, 0, "Output value B must be greater than 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        IERC20(tokensOut[1]).transferFrom(address(bridge), rollupProcessor, outputValueB);
    }

    /** 
     * @notice - The purpose of this test is to directly test convert functionality of the bridge
     *         when exiting Balancer 80 BAL 20 WETH.
     */ 
    function testExitPool80BAL20WETH(
    ) public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = B80BAL20WETH;
        address[] memory tokensOut = new address[](2);
        tokensOut[0] = BAL;
        tokensOut[1] = WETH;

        uint256[] memory amountsIn = new uint256[](tokensIn.length);
        amountsIn[0] = 1e18;
        dealMultiple(tokensIn, address(bridge), amountsIn);

        (, 
            IVault.Exit memory exitPool, 
            IVault.Convert memory convert
        ) = encodeDataJoinOrExit(
            IVault.ActionKind.EXIT, 
            tokensIn, 
            amountsIn, 
            tokensOut
        );
        
        bridge.preApproveTokens(tokensIn, tokensOut);

        ( 
            uint256 outputValueA, 
            uint256 outputValueB, 
            bool isAsync 
        ) = bridge.exitPool(
            exitPool, 
            convert);

        assertEq(
            IERC20(BSTETHSTABLE).balanceOf(address(bridge)),
            0,
            "Should've consumed the entire amountIn, but it is only using 64 units"
        );

        // Output is always 0 ??
        assertGt(outputValueA, 0, "Output value A must be greater than 0");
        assertGt(outputValueB, 0, "Output value B must be greater than 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        IERC20(tokensOut[0]).transferFrom(address(bridge), rollupProcessor, outputValueA);
        IERC20(tokensOut[1]).transferFrom(address(bridge), rollupProcessor, outputValueB);
    }

    /**
     * @notice Encode data for join or exit pool and mount the convert struct
     * @param _actionType - The action kind: JOIN or EXIT
     * @param _tokensIn - The tokens that will be sent to the Vault   
     * @param _amountsIn - The amounts of tokens itself
     * @param _tokensOut - The tokens retrieved from the Vault
     * @return joinPool - The join pool struct
     * @return exitPool - The exit pool struct
     * @return convert - The convert struct
     */
    function encodeDataJoinOrExit(
        IVault.ActionKind _actionType, 
        address[] memory _tokensIn, 
        uint256[] memory _amountsIn, 
        address[] memory _tokensOut
    ) public view returns (
        IVault.Join memory joinPool,
        IVault.Exit memory exitPool,
        IVault.Convert memory convert
    ) {
        require( // Sanity check
            _actionType == IVault.ActionKind.JOIN || 
            _actionType == IVault.ActionKind.EXIT, 
            "Invalid action type");

        // We must wrap the convert request in a struct to avoid deepstack
        // This could be hardcoded, but we are doing it dynamically to avoid
        convert = IVault.Convert({
            inputAssetA: emptyAsset,
            inputAssetB: emptyAsset,
            outputAssetA: emptyAsset,
            outputAssetB: emptyAsset,
            totalInputValue: 0,
            interactionNonce: 0,
            rollupBeneficiary: BENEFICIARY
        });

        // Convert IERC20 to IAsset
        IERC20[] memory tokens = asIERC20(_actionType == IVault.ActionKind.JOIN ? _tokensIn : _tokensOut);
        IAsset[] memory assets = bridge._asIAsset(tokens);
        
        // @dev We encode both joinKind and amountsIn as pointed out at the docs 04/fev/2023
        //      We are only using EXACT inputs due to an error when encoding the data for
        //      static queries on-chain.
        bytes memory userData;
        if(_actionType == IVault.ActionKind.JOIN)
            userData = abi.encode(IVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, _amountsIn);
        else
            userData = abi.encode(IVault.ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT, _amountsIn);

        // @dev There will always be only 1 issued token per pool.
        //      Which means we can asume that index0 in the arrays tokensIn and Out will be the target pool
        bytes32 poolId = IVault(
            _actionType == 
            IVault.ActionKind.JOIN ? 
            _tokensOut[0] : 
            _tokensIn[0] 
        ).getPoolId();

        if(_actionType == IVault.ActionKind.JOIN) {
            // Using maxAmountsIn as the maximum uint256
            uint256[] memory maxAmountsIn = new uint256[](_tokensIn.length);
            for(uint256 i = 0; i < _amountsIn.length; i++) {
                maxAmountsIn[i] = 2**256 - 1;
            }            
            IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({ 
                assets: assets,
                maxAmountsIn: maxAmountsIn,
                userData: userData,
                fromInternalBalance: false
            });
            joinPool = IVault.Join({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });

        } else {
            // @dev Still uncertain about the initial value here.
            //      It'll throw error for any value different than 0,
            //      which I suspect is why it's not consuming the input tokens
            uint256[] memory minAmountsOut = new uint256[](_tokensOut.length);
            for(uint256 i = 0; i < _tokensOut.length; i++) {
                minAmountsOut[i] = 0;
            }

            // Build ExitPool request
            IVault.ExitPoolRequest memory request = 
            IVault.ExitPoolRequest({ 
                assets: assets,
                minAmountsOut: minAmountsOut,
                userData: userData,
                toInternalBalance: false
            });

            // @dev This is just for mock, doesn't work either.
            //      It always returns 0
            // ( uint256 , uint256[] memory amountOut) =
            // IBalancerQueries(HELPER).queryExit(
            //     poolId,
            //     address(bridge),
            //     address(bridge),
            //     request
            // );
            // request.minAmountsOut = amountOut;

            // @dev Currently not working as well, must investigate the combination that suits
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

            exitPool = IVault.Exit({
                poolId: poolId,
                sender: address(bridge),
                recipient: address(bridge),
                request: request
            });
        }

        return (joinPool, exitPool, convert);
    }

    /**
     * @dev Encode a swap request and mount the convert struct
     * @param _poolId - The pool id
     * @param _kind - The swap kind
     * @param _inputAssetA - The input asset
     * @param _outputAssetA - The output asset
     * @param _totalInputValue - The total input value
     * @return swap - The single swap struct
     * @return convert - The convert struct
     */
    function encodeSwap(
        bytes32 _poolId, 
        IVault.SwapKind _kind,
        address _inputAssetA, 
        address _outputAssetA, 
        uint256 _totalInputValue
    ) public view returns (
        IVault.Swap memory swap,
        IVault.Convert memory convert
    ) {
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

        IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
            poolId: _poolId,
            kind: _kind,
            assetIn: IAsset(_inputAssetA),
            assetOut: IAsset(_outputAssetA),
            amount: _totalInputValue,
            userData: ""
        });

        IVault.FundManagement memory fundManagement = IVault.FundManagement({
            sender: address(bridge), 
            fromInternalBalance: false,
            recipient: payable(address(bridge)),
            toInternalBalance: false
        });

        swap = IVault.Swap({
            singleSwap: singleSwap,
            funds: fundManagement,
            limit: 0,
            deadline: block.timestamp
        });

    }

    /**
     * @dev Encode a batch swap request and mount the convert struct
     * @param _kind - The swap kind
     * @param _trades - The trades
     * @return batchSwap - The batch swap struct
     * @return convert - The convert struct
     */
    function encodeBatchSwap(
        IVault.SwapKind _kind,
        IVault.Trade[] memory _trades
    ) public view returns (
        IVault.BatchSwap memory batchSwap, 
        IVault.Convert memory convert
    ) {
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

        IERC20[] memory tokenAddresses = new IERC20[](_trades.length+1);
        // There will be at least 1 token more than trades. We assume that the first token 
        // is the one that will be used to join the pool and the others will fill as the 
        // subsequent outputs. Trades starts at index [0,1] and runs until [n-1,n]
        for(uint256 i = 1; i < _trades.length+1; i++) {
            if(i == 1){
                tokenAddresses[i-1] = IERC20(_trades[i-1].tokenIn);
                tokenAddresses[i] = IERC20(_trades[i-1].tokenOut);
            } else {
                tokenAddresses[i] = IERC20(_trades[i-1].tokenOut);
            }

        }

        IVault.BatchSwapStep[] memory swapStep = new IVault.BatchSwapStep[](_trades.length);
        for(uint256 i = 0; i < _trades.length; i++) {
            swapStep[i] = IVault.BatchSwapStep({
                poolId: _trades[i].poolId,
                assetInIndex: i,
                assetOutIndex: i+1,
                amount: _trades[i].amount,
                userData: ''
            });
        }    
    
        IVault.FundManagement memory fundManagement = IVault.FundManagement({
            sender: address(bridge), 
            fromInternalBalance: false,
            recipient: payable(address(bridge)),
            toInternalBalance: false
        });

        // This can have Deltas as well, but for now we'll just use the max value
        int256[] memory limits = new int256[](tokenAddresses.length);
        for(uint i = 0; i < limits.length; i++) {
            limits[i] = type(int256).max;
        }

        batchSwap = IVault.BatchSwap({
            kind: _kind,
            swaps: swapStep,
            assets: bridge._asIAsset(tokenAddresses),
            funds: fundManagement,
            limits: limits,
            deadline: type(uint256).max
        });
    }

    /**
     * @dev Make a trade before encoding the batchSwap
     * @param _tokensIn - The array of tokens to be used as input
     * @param _tokensOut - The array of tokens to be used as output
     * @param _poolAddr - The array of pool addresses
     * @param _amount - The amount to be used as input
     * @return trades - The trades
     */
    function makeTrades(
        address[] memory _tokensIn,
        address[] memory _tokensOut,
        address[] memory _poolAddr,
        uint256 _amount
    ) public view returns (
        IVault.Trade[] memory trades
    ){
        // Each swap will share the same indexes in all initial variables
        trades = new IVault.Trade[](2);
        for(uint256 i = 0; i < trades.length; i++){
            trades[i] = IVault.Trade({
                poolId: IVault(_poolAddr[i]).getPoolId(),
                tokenIn: _tokensIn[i],
                tokenOut: _tokensOut[i],
                amount: i == 0 ? _amount : 0
            });
        }
    }

    /**
     * @dev Deal multiple assets at once
     * @param _inputTokens - The array of tokens
     * @param _target - The receiver
     * @param _amount - The array with the amounts of tokens
     */
    function dealMultiple(
        address[] memory _inputTokens, 
        address _target, 
        uint256[] memory _amount
    ) public {
        for(uint256 i = 0; i < _inputTokens.length; i++){
            // If the token is 0x0, then we are dealing with ETH
            if(_inputTokens[i] == address(0)) {
                vm.deal(address(bridge), _amount[i]);
            } else {
                deal(_inputTokens[i], _target, _amount[i]);
            }
        }
    }

    /**
     * @dev Turns an array of addresses into an array of IERC20
     * @param _inputTokens - Input tokens addresses
     * @return tokens - The output tokens as IERC20
     */
    function asIERC20(
        address[] memory _inputTokens
    ) internal pure returns (
        IERC20[] memory tokens
    ) {
        tokens = new IERC20[](_inputTokens.length);
        for (uint256 i = 0; i < _inputTokens.length; i++) {
            tokens[i] = IERC20(_inputTokens[i]);
        }        
    }

    /** 
     * @dev - Query the Vault for the amountsOut of an exit
     *         Currently not working, check encodeJoinOrExit
     * @param _target - The target contract
     * @param _encodeWithSig - The encoded function call
     * @return amountsOut - The amountsOut of the exit
     */
    function staticQueryExit(
        address _target, 
        bytes memory _encodeWithSig
    ) public view returns(
        uint256[] memory amountsOut
    ) {
        ( , bytes memory data) = _target.staticcall(_encodeWithSig); 
        ( , amountsOut) = abi.decode(data, (uint256, uint256[]));
        return amountsOut;
    }
}