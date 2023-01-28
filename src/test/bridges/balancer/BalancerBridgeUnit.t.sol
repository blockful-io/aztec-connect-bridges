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

    function justForTest() public {
        address inputA = BAL;
        address inputB = WETH;
        address outputA = B80BAL20WETH;

        address[] memory tokens = [address(inputA), address(inputB)];
        // uint64 auxData = avoidDeepStack(tokens, outputA);
    }

    function avoidDeepStack(address[] memory inputTokens, address[] calldata outputTokens) public returns (uint64 auxData) {
        // Pre-approve tokens
        bridge.preApproveTokens(inputTokens, outputTokens);

        // Prepare IAsset
        IERC20 token0 = IERC20(inputTokens[0]);
        IERC20 token1 = IERC20(inputTokens[1]);
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
        bytes32 poolId = IVault(outputTokens[0]).getPoolId();
        
        // Build request
        // @dev An equivalent for max uint256 can be the built-in (2**256 - 1)

        IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({ 
            assets: assets,
            maxAmountsIn: amountsIn,
            userData: userDataEncoded,
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

    /**
     * @dev Helper function to build AztecAsset
     * @param _id - The id of the asset
     * @param _address - The address of the asset
     * @return AztecAsset - The AztecAsset struct
     */
    function buildAztecAsset(
        uint256 _id, 
        address _address
    ) public pure returns (AztecTypes.AztecAsset memory) {
        AztecTypes.AztecAssetType _type = AztecTypes.AztecAssetType.ERC20; 
        if(_address == address(0)){
            _type = AztecTypes.AztecAssetType.ETH;
        }
        return AztecTypes.AztecAsset({id: _id, erc20Address: _address, assetType: _type});
    }

    /**
     * @dev Deal multiple assets based on input token array
     */
    function dealMultiple(address[] memory _inputTokens, address _target, uint256[] memory _amount) public {
        for(uint256 i = 0; i < _inputTokens.length; i++){
            deal(_inputTokens[i], _target, _amount[i]);
        }
    }

    /* @notice The purpose of this test is to directly test convert functionality of the bridge
     *         when joining Balancer 80 BAL 20 WETH WeightedPool2Tokens.
     * @dev In order to avoid overflows we set _depositAmount to be uint96 instead of uint256.
     */ 
    function testJoinBalancer80BAL20WETH() public {
        // Must be in the same order when returned from the Balancer Vault function: getPoolTokens()
        address[] memory tokensIn = new address[](2);
        address[] memory tokensOut = new address[](1);
        tokensIn[0] = BAL;
        tokensIn[1] = WETH;
        tokensOut[0] = B80BAL20WETH;

        // Prepare the assets for the bridge call, following AztecTypes standard
        AztecTypes.AztecAsset memory inputAssetA = buildAztecAsset(0, inputA);
        AztecTypes.AztecAsset memory inputAssetB = buildAztecAsset(1, inputB);
        AztecTypes.AztecAsset memory outputAssetA = buildAztecAsset(2, outputA);
                
        // Rollup processor transfers ERC20 tokens to the bridge before calling convert. Since we are calling
        // bridge.convert(...) function directly we have to transfer the funds in the test on our own. In this case
        // we'll solve it by directly minting the _depositAmount of Dai to the bridge.
        dealMultiple(tokensIn, address(bridge), [1e18, 1e18]);

        // Store weth balance before interaction to be able to verify the balance after interaction is correct
        uint256 balanceBefore = IERC20(outputA).balanceOf(address(bridge));
        assertEq(balanceBefore, 0);

        // Handle auxData in function to avoid deep stack
        uint64 auxData = avoidDeepStack(tokensIn, tokensOut);
        assertGt(auxData, 0);

        // Call the bridge contract
        // @notice There is no inputValue because they are in auxData
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

        uint256 balanceAfter = IERC20(outputA).balanceOf(address(bridge));
        assertEq(balanceAfter - balanceBefore, outputValueA, "Balances must match");

        assertEq(outputValueB, 0, "Output value B must be 0");
        assertTrue(!isAsync, "Bridge is incorrectly in an async mode");

        // // Now we transfer the funds back from the bridge to the rollup processor
        IERC20(outputAssetA.erc20Address).transferFrom(address(bridge), rollupProcessor, outputValueA);

    }
}
