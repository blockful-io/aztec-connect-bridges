// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {AztecTypes} from "rollup-encoder/libraries/AztecTypes.sol";
import {BridgeBase} from "../base/BridgeBase.sol";
import {ISubsidy} from "../../aztec/interfaces/ISubsidy.sol";
import {ErrorLib} from "../base/ErrorLib.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVault, IAsset} from "../../interfaces/balancer/IVault.sol";

/**
 * @title - Balancer Bridge Contract.
 * @author - Blockful (@Blockful_io on twitter)
 * @dev - This bridge demonstrates the flow of Balancer Vault activities in the convert(...) function.
 * Run this bridge by running: (use -vvvvv for maximum verbosity)
 * forge test --match-contract BalancerBridge -f https://mainnet.infura.io/v3/9928b52099854248b3a096be07a6b23c --fork-block-number 16400000 -vvvvv
 */
contract BalancerBridge is BridgeBase {
    IVault public constant VAULT = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    // @dev - Vault actions inthis bridge must be stored/deketed within the same tx.
    //        It's done in this way because Balancer handles more tokens and more
    //        complex data than the rollup processor is used to. Without altering
    //        the core mechanics of the rollup, the only other option is to hardcode
    //        most of the commom vault action.
    mapping(uint64 => IVault.Join) private commitsJoin;
    mapping(uint64 => IVault.Exit) private commitsExit;
    mapping(uint64 => IVault.Swap) private commitsSwap;
    mapping(uint64 => IVault.BatchSwap) private commitsBatchSwap;
    mapping(uint64 => IVault.ActionKind) private actions;

    // @dev Empty method which is present here in order to be able to receive ETH when unwrapping WETH.
    receive() external payable {}

    /** @notice Set address of rollup processor
     *  @param _rollupProcessor Address of rollup processor
     */
    constructor(address _rollupProcessor) BridgeBase(_rollupProcessor) {}

    /** @notice - Sets all the important approvals
     *  @param _tokensIn - An array of address of input tokens (tokens to later swap in the convert(...) function)
     *  @param _tokensOut - An array of address of output tokens (tokens to later return to rollup processor)
     *  @dev - SwapBridge never holds any ERC20 tokens after or before an invocation of any of its functions. For this
     *         reason the following is not a security risk and makes convert(...) function more gas efficient.
     *         Notice that sometimes it is needed for the approval to come from within the convert(...) function.
     *         It ignore ETH requests.
     */
    function preApproveTokens(address[] calldata _tokensIn, address[] calldata _tokensOut) external {
        for (uint i = 0; i < _tokensIn.length; ) {
            if (address(0) == _tokensIn[i]) {
                unchecked {
                    ++i;
                }
                continue;
            }
            address tokenIn = _tokensIn[i];
            IERC20(tokenIn).approve(address(VAULT), 0);
            IERC20(tokenIn).approve(address(VAULT), type(uint256).max);
            unchecked {
                ++i;
            }
        }
        for (uint i = 0; i < _tokensOut.length; ) {
            if (address(0) == _tokensOut[i]) {
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

    /** @notice Build the parameters for a joinPool
     *  @param _joinPool - The struct containing the parameters for the vault action
     *  @return auxData - The hash in uint64
     */
    function commitJoin(IVault.Join memory _joinPool) internal returns (uint64 auxData) {
        auxData = uint64(uint256(keccak256(abi.encode(_joinPool))));
        commitsJoin[auxData] = _joinPool;
        actions[auxData] = IVault.ActionKind.JOIN;
    }

    /** @notice Build the parameters for an exitPool
     *  @param _exitPool - The struct containing the parameters for the vault action
     *  @return auxData - The hash in uint64
     */
    function commitExit(IVault.Exit memory _exitPool) internal returns (uint64 auxData) {
        auxData = uint64(uint256(keccak256(abi.encode(_exitPool))));
        commitsExit[auxData] = _exitPool;
        actions[auxData] = IVault.ActionKind.EXIT;
    }

    /** @notice Build the parameters for a swap
     * @param _swap - The struct containing the parameters for the vault action
     * @return auxData - The hash in uint64
     */
    function commitSwap(IVault.Swap calldata _swap) internal returns (uint64 auxData) {
        auxData = uint64(uint256(keccak256(abi.encode(_swap))));
        commitsSwap[auxData] = _swap;
        actions[auxData] = IVault.ActionKind.SWAP;
    }

    /** @notice Build the parameters for a batchSwap
     * @param _batchSwap - The struct containing the parameters for the vault action
     * @return auxData - The hash in uint64
     */
    function commitBatchSwap(IVault.BatchSwap calldata _batchSwap) internal returns (uint64 auxData) {
        auxData = uint64(uint256(keccak256(abi.encode(_batchSwap))));
        commitsBatchSwap[auxData] = _batchSwap;
        actions[auxData] = IVault.ActionKind.BATCHSWAP;
    }

    /** @notice - Executes the JOIN vault action through the convert(...) function.
     *  @param _joinPool - The struct containing the parameters for the vault action
     *  @param _convert - The struct containing the parameters for the convert(...) function
     *  @return outputValueA - The amount of output token A
     *  @return outputValueB - The amount of output token B
     *  @return async - True if the vault action is async
     */
    function joinPool(
        IVault.Join memory _joinPool,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        (outputValueA, outputValueB, async) = convert(
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

    /** @notice - Executes the EXIT vault action through the convert(...) function.
     * @param _exitPool - The struct containing the parameters for the vault action
     * @param _convert - The struct containing the parameters for the convert(...) function
     * @return outputValueA - The amount of output token A
     * @return outputValueB - The amount of output token B
     * @return async - True if the vault action is async
     */
    function exitPool(
        IVault.Exit memory _exitPool,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        (outputValueA, outputValueB, async) = convert(
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

    /** @notice - Executes the SWAP vault action through the convert(...) function.
     *  @param _swap - The struct containing the parameters for the vault action
     *  @param _convert - The struct containing the parameters for the convert(...) function
     *  @return outputValueA - The amount of output token A
     *  @return outputValueB - The amount of output token B
     *  @return async - True if the vault action is async
     */
    function swap(
        IVault.Swap calldata _swap,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        (outputValueA, outputValueB, async) = convert(
            _convert.inputAssetA,
            _convert.inputAssetB,
            _convert.outputAssetA,
            _convert.outputAssetB,
            _swap.singleSwap.amount,
            _convert.interactionNonce,
            commitSwap(_swap),
            _convert.rollupBeneficiary
        );
    }

    /** @notice - Executes the BATCHSWAP vault action through the convert(...) function.
     *  @param _batchSwap - The struct containing the parameters for the vault action
     *  @param _convert - The struct containing the parameters for the convert(...) function
     *  @return outputValueA - The amount of output token A
     *  @return outputValueB - The amount of output token B
     *  @return async - True if the vault action is async
     */
    function batchSwap(
        IVault.BatchSwap calldata _batchSwap,
        IVault.Convert calldata _convert
    ) public payable returns (uint256 outputValueA, uint256 outputValueB, bool async) {
        (outputValueA, outputValueB, async) = convert(
            _convert.inputAssetA,
            _convert.inputAssetB,
            _convert.outputAssetA,
            _convert.outputAssetB,
            _convert.totalInputValue,
            _convert.interactionNonce,
            commitBatchSwap(_batchSwap),
            _convert.rollupBeneficiary
        );
    }

    /**
     * @notice - A function which takes input assets and a initial quantity to convert to another asset
     *           and return the outputValue
     * @param _inputAssetA - Input token
     * @param _outputAssetA - Tutput token
     * @param _totalInputValue - The amount of input token to convert
     * @param _rollupBeneficiary - Address of the contract which receives subsidy in case subsidy was set for a given
     *                             criteria
     * @return outputValueA - the amount of output asset to return
     * @dev - We are only the _auxData and the _rollupBeneficiary field due to lack of field availability
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
    ) public payable override(BridgeBase) onlyRollup returns (uint256 outputValueA, uint256 outputValueB, bool) {
        if (actions[_auxData] == IVault.ActionKind.JOIN) {
            paySubsidyJoinOrExit(commitsJoin[_auxData].poolId, IVault.ActionKind.JOIN, _rollupBeneficiary);

            outputValueA = joinPool(commitsJoin[_auxData]);
            delete (commitsJoin[_auxData]);
        } else if (actions[_auxData] == IVault.ActionKind.EXIT) {
            paySubsidyJoinOrExit(commitsExit[_auxData].poolId, IVault.ActionKind.EXIT, _rollupBeneficiary);

            uint256[] memory outputValue = exitPool(commitsExit[_auxData]);
            delete (commitsExit[_auxData]);

            // Temporarily solution for the bridge size limitation
            outputValueA = outputValue[0];
            outputValueB = outputValue[1];
        } else if (actions[_auxData] == IVault.ActionKind.SWAP) {
            paySubsidySwap(
                address(commitsSwap[_auxData].singleSwap.assetIn),
                address(commitsSwap[_auxData].singleSwap.assetOut),
                _rollupBeneficiary
            );

            outputValueA = singleSwap(commitsSwap[_auxData]);
            delete (commitsBatchSwap[_auxData]);
        } else if (actions[_auxData] == IVault.ActionKind.BATCHSWAP) {
            paySubsidyBatchSwap(commitsBatchSwap[_auxData].assets, _rollupBeneficiary);

            outputValueA = batchSwap(commitsBatchSwap[_auxData]);
            delete (commitsBatchSwap[_auxData]);
        } else {
            revert ErrorLib.InvalidAuxData();
        }
        delete (actions[_auxData]);
    }

    /** @notice - Calls joinPool on Balancer Vault
     *  @param _inputs - The inputs struct
     *  @return outputValue - the amount of output asset to return
     */
    function joinPool(IVault.Join memory _inputs) internal returns (uint256 outputValue) {
        // Get the address of the pool
        (address poolAddr, ) = VAULT.getPool(_inputs.poolId);

        // Then the balance, before and after the vault action
        outputValue = IERC20(poolAddr).balanceOf(_inputs.recipient);

        // @dev - Was checking if the input is eth, but I don't
        //        think Balancer supports ETH as an input
        bool isEth = false;
        for (uint i = 0; i < _inputs.request.assets.length; ) {
            if (_inputs.request.assets[i] == IAsset(address(0))) {
                isEth = true;
            }
            unchecked {
                i++;
            }
        }

        VAULT.joinPool{value: isEth ? msg.value : 0}(
            _inputs.poolId,
            _inputs.sender,
            _inputs.recipient,
            _inputs.request
        );

        outputValue = IERC20(poolAddr).balanceOf(_inputs.recipient) - outputValue;
    }

    /** @notice - Calls exitPool on Balancer Vault
     *  @param _inputs - The inputs struct
     *  @return outputValue - the amount of output asset to return
     */
    function exitPool(IVault.Exit memory _inputs) internal returns (uint256[] memory outputValue) {
        // Load the tokens from the pool, given its poolID
        (IERC20[] memory tokens, , ) = VAULT.getPoolTokens(_inputs.poolId);

        // then set their balance, before and after the vault action
        outputValue = new uint256[](tokens.length);
        for (uint i = 0; i < tokens.length; ) {
            outputValue[i] = tokens[i].balanceOf(_inputs.recipient);
            unchecked {
                i++;
            }
        }

        VAULT.exitPool(_inputs.poolId, _inputs.sender, payable(_inputs.recipient), _inputs.request);

        for (uint i = 0; i < tokens.length; ) {
            outputValue[i] = tokens[i].balanceOf(_inputs.recipient) - outputValue[i];
            unchecked {
                i++;
            }
        }
    }

    /** @notice - Calls singleSwap on Balancer Vault
     *  @param _swap - The swap struct
     *  @return outputValueA - the amount of output asset
     */
    function singleSwap(IVault.Swap memory _swap) internal returns (uint256 outputValueA) {
        outputValueA = VAULT.swap(_swap.singleSwap, _swap.funds, _swap.limit, _swap.deadline);
    }

    /** @notice - Calls batchSwap on Balancer Vault
     *  @param _swap - The struct containing the parameters for the vault action
     *  @return outputValueA - the amount of output assets returned
     */
    function batchSwap(IVault.BatchSwap memory _swap) internal returns (uint256 outputValueA) {
        // @dev - int256 uses delta to return values, but Aztec only return uint256.
        //        Measuring the balance is a turn around
        uint256 balanceBefore = IERC20(address(_swap.assets[_swap.assets.length - 1])).balanceOf(address(this));

        VAULT.batchSwap(_swap.kind, _swap.swaps, _swap.assets, _swap.funds, _swap.limits, _swap.deadline);

        uint256 balanceAfter = IERC20(address(_swap.assets[_swap.assets.length - 1])).balanceOf(address(this));

        outputValueA = balanceAfter - balanceBefore;
    }

    /** @notice - Calculate and claim subsidy for a join or exit
     *  @param poolId - The poolID of the pool
     *  @param kind - The kind of vault action
     *  @param _rollupBeneficiary - The address of the rollup beneficiary
     *  @dev - Joins and Exits are usually 1-n or n-1 swaps. Meaning  we must handle
     *         the case where the user is swapping in or out of the pool and calculate
     *         the subsidy path accordingly.
     *         Since the tokensOut is not present in the original join/exit structs,
     *         we must get the the tokens directly from the poolId.
     */
    function paySubsidyJoinOrExit(bytes32 poolId, IVault.ActionKind kind, address _rollupBeneficiary) public {
        // Load the tokens from the pool given its poolID
        (IERC20[] memory tokens, , ) = VAULT.getPoolTokens(poolId);

        // Create an array of addresses of the tokens in the pool
        address[] memory poolTokens = new address[](tokens.length);

        // Change from IERC20 to address and add to the array
        for (uint i = 0; i < tokens.length; ) {
            poolTokens[i] = address(tokens[i]);
            unchecked {
                i++;
            }
        }

        // The pool issue an ERC20 which is the output of
        // a join and also the input of an exit
        address[] memory contractToken = new address[](1);
        (contractToken[0], ) = VAULT.getPool(poolId);

        // Reverts the result based on Join or Exit
        if (kind == IVault.ActionKind.JOIN) {
            // In the Join action, the contract token is the output
            SUBSIDY.claimSubsidy(_computeManyCriteria(poolTokens, contractToken), _rollupBeneficiary);
        } else {
            // In the Exit action, the contract token is the input
            SUBSIDY.claimSubsidy(_computeManyCriteria(contractToken, poolTokens), _rollupBeneficiary);
        }
    }

    /** @notice - Calculate and claim subsidy for a swap
     *  @param _tokensIn - The tokenIn that has amount
     *  @param _tokensOut - The tokenOut that will be received
     *  @param _rollupBeneficiary - The address of the rollup beneficiary
     */
    function paySubsidySwap(address _tokensIn, address _tokensOut, address _rollupBeneficiary) public {
        SUBSIDY.claimSubsidy(_computeCriteria(_tokensIn, _tokensOut), _rollupBeneficiary);
    }

    /** @notice - Calculate and claim subsidy for a batchSwap
     *  @param _assets - The assets that are being swapped
     *  @param _rollupBeneficiary - The address of the rollup beneficiary
     *  @dev - We are assuming the first token is the input and the last is the output
     *         It must be better elaborated in the future to handle more rich swaps
     */
    function paySubsidyBatchSwap(IAsset[] memory _assets, address _rollupBeneficiary) public {
        SUBSIDY.claimSubsidy(
            _computeCriteria(address(_assets[0]), address(_assets[_assets.length - 1])),
            _rollupBeneficiary
        );
    }

    /** @notice - Registers subsidy criteria for a given token pair
     *  @param _criteria - The criteria to register
     */
    function registerSubsidyCriteria(uint256 _criteria) external {
        SUBSIDY.setGasUsageAndMinGasPerMinute({
            _criteria: _criteria,
            _gasUsage: uint32(300000), // 300k gas (Note: this is a gas usage when only 1 split path is used)
            _minGasPerMinute: uint32(100) // 1 fully subsidized call per 2 days (300k / (24 * 60) / 2)
        });
    }

    /** @notice - Computes many paths as the criteria when claiming subsidy
     *  @param _inputTokens - The input assetA
     *  @param _outputTokens - The output asset
     *  @return - The encoded uint256
     */
    function _computeManyCriteria(
        address[] memory _inputTokens,
        address[] memory _outputTokens
    ) public pure returns (uint256) {
        bytes memory encoded;

        for (uint i = 0; i < _inputTokens.length; ) {
            encoded = abi.encodePacked(encoded, _inputTokens[i]);
            unchecked {
                i++;
            }
        }

        for (uint i = 0; i < _outputTokens.length; ) {
            encoded = abi.encodePacked(encoded, _outputTokens[i]);
            unchecked {
                i++;
            }
        }

        return uint256(keccak256(encoded));
    }

    /** @notice - Directly computes the criteria that is passed when claiming subsidy
     *  @param _inputTokens The input assetA
     *  @param _outputTokens The output asset
     *  @return The criteria
     */
    function _computeCriteria(address _inputTokens, address _outputTokens) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_inputTokens, _outputTokens)));
    }

    /** @notice - Cast a low-level call conversion
     *  @param _tokens - an array of IERC20 tokens
     *  @return _assets - an array of IAssets
     */
    function _asIAsset(IERC20[] memory _tokens) public pure returns (IAsset[] memory _assets) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            _assets := _tokens
        }
    }

    /** @notice - Cast a low-level call conversion
     *  @param _assets - an array of IAssets
     *  @return _tokens - an array of IERC20 tokens
     */
    function _asIERC20(IAsset[] memory _assets) public pure returns (IERC20[] memory _tokens) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            _tokens := _assets
        }
    }
}
