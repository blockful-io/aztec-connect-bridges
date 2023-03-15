// // SPDX-License-Identifier: Apache-2.0
// // Copyright 2022 Aztec.
// pragma solidity >=0.8.4;

// import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";
// import {BridgeTestBase} from "./../../aztec/base/BridgeTestBase.sol";

// // balancer-specific imports
// import {BalancerBridge} from "../../../bridges/balancer/BalancerBridge.sol";
// import {IVault, IAsset} from "../../../interfaces/balancer/IVault.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {ErrorLib} from "../../../bridges/base/ErrorLib.sol";

// /**
//  * @notice The purpose of this test is to test the bridge in an environment that is as close to the final deployment
//  *         as possible without spinning up all the rollup infrastructure (sequencer, proof generator etc.).
//  */
// contract BalancerBridgeE2ETest is BridgeTestBase {
//     // Bridge and Rollup
//     address private constant BENEFICIARY = address(11);
//     address private rollupProcessor;
//     BalancerBridge private bridge;
//     // Balancer Vault and Commons
//     address private constant VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
//     address private constant HELPER = 0xE39B5e3B6D74016b2F6A9673D7d7493B6DF549d5;
//     address private constant FEE_COLLECTOR = 0xce88686553686DA562CE7Cea497CE749DA109f9F;
//     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
//     // Balancer 80 BAL 20 WETH
//     address private constant B80BAL20WETH = 0x5c6Ee304399DBdB9C8Ef030aB642B10820DB8F56;
//     address private constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;
//     // Balancer stETH Stable Pool
//     address private constant BSTETHSTABLE = 0x32296969Ef14EB0c6d29669C550D4a0449130230;
//     address private constant WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
//     // Balancer rETH Stable Pool
//     address private constant BRETHSTABLE = 0x1E19CF2D73a72Ef1332C882F20534B6519Be0276;
//     address private constant RETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;

//     // To store the id of the swap bridge after being added
//     uint256 private id;

//     function setUp() public {
//         // Deploy a new balancer bridge
//         bridge = new BalancerBridge(address(ROLLUP_PROCESSOR));

//         // Use the label cheat code to mark the addresses when using verbosity
//         vm.label(address(bridge), "Balancer Bridge");
//         vm.label(address(VAULT), "Balancer Vault");
//         vm.label(address(FEE_COLLECTOR), "Fee Collector");
//         vm.label(address(WETH), "WETH");
//         vm.label(address(DAI), "DAI");
//         vm.label(address(BAL), "BAL");
//         vm.label(address(RETH), "Rocket Pool ETH");
//         vm.label(address(WSTETH), "Wrapped liquid staked Ether 2.0");

//         vm.label(address(B80BAL20WETH), "Balancer 80 BAL 20 WETH");
//         vm.label(address(BSTETHSTABLE), "Balancer stETH Stable Pool");
//         vm.label(address(BRETHSTABLE), "Balancer rETH Stable Pool");

//         // Impersonate the multi-sig to add a new bridge
//         vm.startPrank(MULTI_SIG);

//         // List the bridge with a gasLimit of 1kk
//         // WARNING: If you set this value too low the interaction will fail for seemingly no reason!
//         // OTOH if you se it too high bridge users will pay too much
//         ROLLUP_PROCESSOR.setSupportedBridge(address(bridge), 1000000);

//         // Note: necessary for assets which are not already registered on RollupProcessor
//         ROLLUP_PROCESSOR.setSupportedAsset(WETH, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(DAI, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(BAL, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(RETH, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(WSTETH, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(B80BAL20WETH, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(BSTETHSTABLE, 100000);
//         ROLLUP_PROCESSOR.setSupportedAsset(BRETHSTABLE, 100000);

//         vm.stopPrank();

//         // Fetch the id of the balancer bridge
//         id = ROLLUP_PROCESSOR.getSupportedBridgesLength();

//         // Subsidize the bridge when used with USDC and register a beneficiary
//         // bridge.registerSubsidyCriteria(BAL, WETH, B80BAL20WETH);
//         // SUBSIDY.subsidize{value: 1e17}(
//         //     address(bridge), bridge._computeCriteria(BAL, WETH, B80BAL20WETH), uint32(100)
//         // );
//         // SUBSIDY.registerBeneficiary(BENEFICIARY);
//     }

//     /**
//      * @notice - The purpose is to directly test the convert functionality of the bridge
//      *            when swapping WETH to DAI.
//      */
//     function testSwapWETHtoDAI() public {
//         // Token address being inputed and its outcome from the pool
//         address[] memory tokensIn = new address[](1);
//         tokensIn[0] = WETH;
//         address[] memory tokensOut = new address[](1);
//         tokensOut[0] = BAL;

//         // The amount being sent to the bridge
//         uint256 amountIn = 1e18;
//         deal(WETH, address(ROLLUP_PROCESSOR), amountIn);

//         // Fetching poolId to generate the swap
//         bytes32 poolId = IVault(B80BAL20WETH).getPoolId();

//         // Encode the swap for further use
//         (IVault.Swap memory swap, IVault.Convert memory convert) = encodeSwap(
//             poolId,
//             IVault.SwapKind.GIVEN_IN,
//             tokensIn[0],
//             tokensOut[0],
//             amountIn
//         );

//         // Pre-aprove tokens
//         bridge.preApproveTokens(tokensIn, tokensOut);

//         // Computes the encoded data for the specific bridge interaction
//         // This cannot be use since the rollup is not allowing us to create custom calls to the rollup
//         // but rather make us use the convert(...) function, which does not attend to Balancer's need
//         // uint256 bridgeCallData = ROLLUP_ENCODER.defiInteractionL2(
//         //     id,
//         //     emptyAsset,
//         //     emptyAsset,
//         //     emptyAsset,
//         //     emptyAsset,
//         //     uint64(uint256(keccak256(abi.encode(swap)))),
//         //     amountIn
//         // );

//         // This would be the on-chain query to fetch the result from the swap
//         // Cannot be done since query on Vault requiries a simulation of a transaction
//         // and it cannot be achieved within this solidity+rollup perspective
//         // uint256 queryResult = BalancerVault.query(swapStuff)

//         // ROLLUP_ENCODER.registerEventToBeChecked(
//         //     bridgeCallData,
//         //     ROLLUP_ENCODER.getNextNonce(),
//         //     amountIn,
//         //     quote,
//         //     0,
//         //     true,
//         //     ""
//         // );
//         // ROLLUP_ENCODER.processRollup();
//     }

//     /**
//      * @dev Encode a swap request and mount the convert struct
//      * @param _poolId - The pool id
//      * @param _kind - The swap kind
//      * @param _inputAssetA - The input asset
//      * @param _outputAssetA - The output asset
//      * @param _totalInputValue - The total input value
//      * @return swap - The single swap struct
//      * @return convert - The convert struct
//      */
//     function encodeSwap(
//         bytes32 _poolId,
//         IVault.SwapKind _kind,
//         address _inputAssetA,
//         address _outputAssetA,
//         uint256 _totalInputValue
//     ) public view returns (IVault.Swap memory swap, IVault.Convert memory convert) {
//         // We must wrap the convert request in a struct to avoid deepstack
//         convert = prepareConvert();

//         IVault.SingleSwap memory singleSwap = IVault.SingleSwap({
//             poolId: _poolId,
//             kind: _kind,
//             assetIn: IAsset(_inputAssetA),
//             assetOut: IAsset(_outputAssetA),
//             amount: _totalInputValue,
//             userData: ""
//         });

//         IVault.FundManagement memory fundManagement = IVault.FundManagement({
//             sender: address(bridge),
//             fromInternalBalance: false,
//             recipient: payable(address(bridge)),
//             toInternalBalance: false
//         });

//         swap = IVault.Swap({singleSwap: singleSwap, funds: fundManagement, limit: 0, deadline: block.timestamp});
//     }

//     /**
//      * @dev - Will generate an empty convert struct to call convert function.
//      *        The data field is not setled yet.
//      *        Most of the nonutilized variables can be hardcoded.
//      * @return convert - The empty convert struct
//      */
//     function prepareConvert() public view returns (IVault.Convert memory convert) {
//         convert = IVault.Convert({
//             inputAssetA: emptyAsset,
//             inputAssetB: emptyAsset,
//             outputAssetA: emptyAsset,
//             outputAssetB: emptyAsset,
//             totalInputValue: 0,
//             interactionNonce: 0,
//             rollupBeneficiary: BENEFICIARY
//         });
//     }
// }
