/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "./common.js";

export interface IRollupProcessorInterface extends utils.Interface {
  functions: {
    "allowThirdPartyContracts()": FunctionFragment;
    "approveProof(bytes32)": FunctionFragment;
    "assetGasLimits(uint256)": FunctionFragment;
    "bridgeGasLimits(uint256)": FunctionFragment;
    "defiBridgeProxy()": FunctionFragment;
    "depositPendingFunds(uint256,uint256,address,bytes32)": FunctionFragment;
    "getAsyncDefiInteractionHashesLength()": FunctionFragment;
    "getDataSize()": FunctionFragment;
    "getDefiInteractionHashesLength()": FunctionFragment;
    "getEscapeHatchStatus()": FunctionFragment;
    "getPendingDefiInteractionHashesLength()": FunctionFragment;
    "getSupportedAsset(uint256)": FunctionFragment;
    "getSupportedAssetsLength()": FunctionFragment;
    "getSupportedBridge(uint256)": FunctionFragment;
    "getSupportedBridgesLength()": FunctionFragment;
    "offchainData(uint256,uint256,uint256,bytes)": FunctionFragment;
    "pause()": FunctionFragment;
    "paused()": FunctionFragment;
    "prevDefiInteractionsHash()": FunctionFragment;
    "processAsyncDefiInteraction(uint256)": FunctionFragment;
    "processRollup(bytes,bytes)": FunctionFragment;
    "receiveEthFromBridge(uint256)": FunctionFragment;
    "rollupStateHash()": FunctionFragment;
    "setAllowThirdPartyContracts(bool)": FunctionFragment;
    "setDefiBridgeProxy(address)": FunctionFragment;
    "setRollupProvider(address,bool)": FunctionFragment;
    "setSupportedAsset(address,uint256)": FunctionFragment;
    "setSupportedBridge(address,uint256)": FunctionFragment;
    "setVerifier(address)": FunctionFragment;
    "unpause()": FunctionFragment;
    "userPendingDeposits(uint256,address)": FunctionFragment;
    "verifier()": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "allowThirdPartyContracts"
      | "approveProof"
      | "assetGasLimits"
      | "bridgeGasLimits"
      | "defiBridgeProxy"
      | "depositPendingFunds"
      | "getAsyncDefiInteractionHashesLength"
      | "getDataSize"
      | "getDefiInteractionHashesLength"
      | "getEscapeHatchStatus"
      | "getPendingDefiInteractionHashesLength"
      | "getSupportedAsset"
      | "getSupportedAssetsLength"
      | "getSupportedBridge"
      | "getSupportedBridgesLength"
      | "offchainData"
      | "pause"
      | "paused"
      | "prevDefiInteractionsHash"
      | "processAsyncDefiInteraction"
      | "processRollup"
      | "receiveEthFromBridge"
      | "rollupStateHash"
      | "setAllowThirdPartyContracts"
      | "setDefiBridgeProxy"
      | "setRollupProvider"
      | "setSupportedAsset"
      | "setSupportedBridge"
      | "setVerifier"
      | "unpause"
      | "userPendingDeposits"
      | "verifier"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "allowThirdPartyContracts",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "approveProof",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "assetGasLimits",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "bridgeGasLimits",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "defiBridgeProxy",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "depositPendingFunds",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "getAsyncDefiInteractionHashesLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getDataSize",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getDefiInteractionHashesLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getEscapeHatchStatus",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getPendingDefiInteractionHashesLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getSupportedAsset",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getSupportedAssetsLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getSupportedBridge",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getSupportedBridgesLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "offchainData",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>
    ]
  ): string;
  encodeFunctionData(functionFragment: "pause", values?: undefined): string;
  encodeFunctionData(functionFragment: "paused", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "prevDefiInteractionsHash",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "processAsyncDefiInteraction",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "processRollup",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "receiveEthFromBridge",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "rollupStateHash",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setAllowThirdPartyContracts",
    values: [PromiseOrValue<boolean>]
  ): string;
  encodeFunctionData(
    functionFragment: "setDefiBridgeProxy",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setRollupProvider",
    values: [PromiseOrValue<string>, PromiseOrValue<boolean>]
  ): string;
  encodeFunctionData(
    functionFragment: "setSupportedAsset",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setSupportedBridge",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setVerifier",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(functionFragment: "unpause", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "userPendingDeposits",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(functionFragment: "verifier", values?: undefined): string;

  decodeFunctionResult(
    functionFragment: "allowThirdPartyContracts",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "approveProof",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "assetGasLimits",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bridgeGasLimits",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "defiBridgeProxy",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "depositPendingFunds",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAsyncDefiInteractionHashesLength",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getDataSize",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getDefiInteractionHashesLength",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getEscapeHatchStatus",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getPendingDefiInteractionHashesLength",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getSupportedAsset",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getSupportedAssetsLength",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getSupportedBridge",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getSupportedBridgesLength",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "offchainData",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "pause", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "paused", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "prevDefiInteractionsHash",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "processAsyncDefiInteraction",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "processRollup",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "receiveEthFromBridge",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "rollupStateHash",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setAllowThirdPartyContracts",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setDefiBridgeProxy",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setRollupProvider",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setSupportedAsset",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setSupportedBridge",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setVerifier",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unpause", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "userPendingDeposits",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "verifier", data: BytesLike): Result;

  events: {};
}

export interface IRollupProcessor extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IRollupProcessorInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    allowThirdPartyContracts(overrides?: CallOverrides): Promise<[boolean]>;

    approveProof(
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    assetGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    bridgeGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    defiBridgeProxy(overrides?: CallOverrides): Promise<[string]>;

    depositPendingFunds(
      _assetId: PromiseOrValue<BigNumberish>,
      _amount: PromiseOrValue<BigNumberish>,
      _owner: PromiseOrValue<string>,
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getAsyncDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getDataSize(overrides?: CallOverrides): Promise<[BigNumber]>;

    getDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getEscapeHatchStatus(
      overrides?: CallOverrides
    ): Promise<[boolean, BigNumber]>;

    getPendingDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getSupportedAsset(
      _assetId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getSupportedAssetsLength(overrides?: CallOverrides): Promise<[BigNumber]>;

    getSupportedBridge(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getSupportedBridgesLength(overrides?: CallOverrides): Promise<[BigNumber]>;

    offchainData(
      _rollupId: PromiseOrValue<BigNumberish>,
      _chunk: PromiseOrValue<BigNumberish>,
      _totalChunks: PromiseOrValue<BigNumberish>,
      _offchainTxData: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    paused(overrides?: CallOverrides): Promise<[boolean]>;

    prevDefiInteractionsHash(overrides?: CallOverrides): Promise<[string]>;

    processAsyncDefiInteraction(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    processRollup(
      _encodedProofData: PromiseOrValue<BytesLike>,
      _signatures: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    receiveEthFromBridge(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    rollupStateHash(overrides?: CallOverrides): Promise<[string]>;

    setAllowThirdPartyContracts(
      _allowThirdPartyContracts: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setDefiBridgeProxy(
      _defiBridgeProxy: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setRollupProvider(
      _provider: PromiseOrValue<string>,
      _valid: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setSupportedAsset(
      _token: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setSupportedBridge(
      _bridge: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setVerifier(
      _verifier: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    userPendingDeposits(
      _assetId: PromiseOrValue<BigNumberish>,
      _user: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    verifier(overrides?: CallOverrides): Promise<[string]>;
  };

  allowThirdPartyContracts(overrides?: CallOverrides): Promise<boolean>;

  approveProof(
    _proofHash: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  assetGasLimits(
    _bridgeAddressId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  bridgeGasLimits(
    _bridgeAddressId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  defiBridgeProxy(overrides?: CallOverrides): Promise<string>;

  depositPendingFunds(
    _assetId: PromiseOrValue<BigNumberish>,
    _amount: PromiseOrValue<BigNumberish>,
    _owner: PromiseOrValue<string>,
    _proofHash: PromiseOrValue<BytesLike>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getAsyncDefiInteractionHashesLength(
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getDataSize(overrides?: CallOverrides): Promise<BigNumber>;

  getDefiInteractionHashesLength(overrides?: CallOverrides): Promise<BigNumber>;

  getEscapeHatchStatus(
    overrides?: CallOverrides
  ): Promise<[boolean, BigNumber]>;

  getPendingDefiInteractionHashesLength(
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getSupportedAsset(
    _assetId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  getSupportedAssetsLength(overrides?: CallOverrides): Promise<BigNumber>;

  getSupportedBridge(
    _bridgeAddressId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  getSupportedBridgesLength(overrides?: CallOverrides): Promise<BigNumber>;

  offchainData(
    _rollupId: PromiseOrValue<BigNumberish>,
    _chunk: PromiseOrValue<BigNumberish>,
    _totalChunks: PromiseOrValue<BigNumberish>,
    _offchainTxData: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  pause(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  paused(overrides?: CallOverrides): Promise<boolean>;

  prevDefiInteractionsHash(overrides?: CallOverrides): Promise<string>;

  processAsyncDefiInteraction(
    _interactionNonce: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  processRollup(
    _encodedProofData: PromiseOrValue<BytesLike>,
    _signatures: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  receiveEthFromBridge(
    _interactionNonce: PromiseOrValue<BigNumberish>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  rollupStateHash(overrides?: CallOverrides): Promise<string>;

  setAllowThirdPartyContracts(
    _allowThirdPartyContracts: PromiseOrValue<boolean>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setDefiBridgeProxy(
    _defiBridgeProxy: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setRollupProvider(
    _provider: PromiseOrValue<string>,
    _valid: PromiseOrValue<boolean>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setSupportedAsset(
    _token: PromiseOrValue<string>,
    _gasLimit: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setSupportedBridge(
    _bridge: PromiseOrValue<string>,
    _gasLimit: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setVerifier(
    _verifier: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  unpause(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  userPendingDeposits(
    _assetId: PromiseOrValue<BigNumberish>,
    _user: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  verifier(overrides?: CallOverrides): Promise<string>;

  callStatic: {
    allowThirdPartyContracts(overrides?: CallOverrides): Promise<boolean>;

    approveProof(
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    assetGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bridgeGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    defiBridgeProxy(overrides?: CallOverrides): Promise<string>;

    depositPendingFunds(
      _assetId: PromiseOrValue<BigNumberish>,
      _amount: PromiseOrValue<BigNumberish>,
      _owner: PromiseOrValue<string>,
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    getAsyncDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getDataSize(overrides?: CallOverrides): Promise<BigNumber>;

    getDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getEscapeHatchStatus(
      overrides?: CallOverrides
    ): Promise<[boolean, BigNumber]>;

    getPendingDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSupportedAsset(
      _assetId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    getSupportedAssetsLength(overrides?: CallOverrides): Promise<BigNumber>;

    getSupportedBridge(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    getSupportedBridgesLength(overrides?: CallOverrides): Promise<BigNumber>;

    offchainData(
      _rollupId: PromiseOrValue<BigNumberish>,
      _chunk: PromiseOrValue<BigNumberish>,
      _totalChunks: PromiseOrValue<BigNumberish>,
      _offchainTxData: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    pause(overrides?: CallOverrides): Promise<void>;

    paused(overrides?: CallOverrides): Promise<boolean>;

    prevDefiInteractionsHash(overrides?: CallOverrides): Promise<string>;

    processAsyncDefiInteraction(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    processRollup(
      _encodedProofData: PromiseOrValue<BytesLike>,
      _signatures: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    receiveEthFromBridge(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    rollupStateHash(overrides?: CallOverrides): Promise<string>;

    setAllowThirdPartyContracts(
      _allowThirdPartyContracts: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<void>;

    setDefiBridgeProxy(
      _defiBridgeProxy: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setRollupProvider(
      _provider: PromiseOrValue<string>,
      _valid: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<void>;

    setSupportedAsset(
      _token: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setSupportedBridge(
      _bridge: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setVerifier(
      _verifier: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    unpause(overrides?: CallOverrides): Promise<void>;

    userPendingDeposits(
      _assetId: PromiseOrValue<BigNumberish>,
      _user: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    verifier(overrides?: CallOverrides): Promise<string>;
  };

  filters: {};

  estimateGas: {
    allowThirdPartyContracts(overrides?: CallOverrides): Promise<BigNumber>;

    approveProof(
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    assetGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bridgeGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    defiBridgeProxy(overrides?: CallOverrides): Promise<BigNumber>;

    depositPendingFunds(
      _assetId: PromiseOrValue<BigNumberish>,
      _amount: PromiseOrValue<BigNumberish>,
      _owner: PromiseOrValue<string>,
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getAsyncDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getDataSize(overrides?: CallOverrides): Promise<BigNumber>;

    getDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getEscapeHatchStatus(overrides?: CallOverrides): Promise<BigNumber>;

    getPendingDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSupportedAsset(
      _assetId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSupportedAssetsLength(overrides?: CallOverrides): Promise<BigNumber>;

    getSupportedBridge(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSupportedBridgesLength(overrides?: CallOverrides): Promise<BigNumber>;

    offchainData(
      _rollupId: PromiseOrValue<BigNumberish>,
      _chunk: PromiseOrValue<BigNumberish>,
      _totalChunks: PromiseOrValue<BigNumberish>,
      _offchainTxData: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    paused(overrides?: CallOverrides): Promise<BigNumber>;

    prevDefiInteractionsHash(overrides?: CallOverrides): Promise<BigNumber>;

    processAsyncDefiInteraction(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    processRollup(
      _encodedProofData: PromiseOrValue<BytesLike>,
      _signatures: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    receiveEthFromBridge(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    rollupStateHash(overrides?: CallOverrides): Promise<BigNumber>;

    setAllowThirdPartyContracts(
      _allowThirdPartyContracts: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setDefiBridgeProxy(
      _defiBridgeProxy: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setRollupProvider(
      _provider: PromiseOrValue<string>,
      _valid: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setSupportedAsset(
      _token: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setSupportedBridge(
      _bridge: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setVerifier(
      _verifier: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    userPendingDeposits(
      _assetId: PromiseOrValue<BigNumberish>,
      _user: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    verifier(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    allowThirdPartyContracts(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    approveProof(
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    assetGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    bridgeGasLimits(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    defiBridgeProxy(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    depositPendingFunds(
      _assetId: PromiseOrValue<BigNumberish>,
      _amount: PromiseOrValue<BigNumberish>,
      _owner: PromiseOrValue<string>,
      _proofHash: PromiseOrValue<BytesLike>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getAsyncDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getDataSize(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getEscapeHatchStatus(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getPendingDefiInteractionHashesLength(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getSupportedAsset(
      _assetId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getSupportedAssetsLength(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getSupportedBridge(
      _bridgeAddressId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getSupportedBridgesLength(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    offchainData(
      _rollupId: PromiseOrValue<BigNumberish>,
      _chunk: PromiseOrValue<BigNumberish>,
      _totalChunks: PromiseOrValue<BigNumberish>,
      _offchainTxData: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    paused(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    prevDefiInteractionsHash(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    processAsyncDefiInteraction(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    processRollup(
      _encodedProofData: PromiseOrValue<BytesLike>,
      _signatures: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    receiveEthFromBridge(
      _interactionNonce: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    rollupStateHash(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    setAllowThirdPartyContracts(
      _allowThirdPartyContracts: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setDefiBridgeProxy(
      _defiBridgeProxy: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setRollupProvider(
      _provider: PromiseOrValue<string>,
      _valid: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setSupportedAsset(
      _token: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setSupportedBridge(
      _bridge: PromiseOrValue<string>,
      _gasLimit: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setVerifier(
      _verifier: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    userPendingDeposits(
      _assetId: PromiseOrValue<BigNumberish>,
      _user: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    verifier(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}
