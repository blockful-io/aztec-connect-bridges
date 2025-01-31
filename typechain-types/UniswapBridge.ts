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
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "./common.js";

export declare namespace AztecTypes {
  export type AztecAssetStruct = {
    id: PromiseOrValue<BigNumberish>;
    erc20Address: PromiseOrValue<string>;
    assetType: PromiseOrValue<BigNumberish>;
  };

  export type AztecAssetStructOutput = [BigNumber, string, number] & {
    id: BigNumber;
    erc20Address: string;
    assetType: number;
  };
}

export declare namespace UniswapBridge {
  export type SplitPathStruct = {
    percentage: PromiseOrValue<BigNumberish>;
    fee1: PromiseOrValue<BigNumberish>;
    token1: PromiseOrValue<string>;
    fee2: PromiseOrValue<BigNumberish>;
    token2: PromiseOrValue<string>;
    fee3: PromiseOrValue<BigNumberish>;
  };

  export type SplitPathStructOutput = [
    BigNumber,
    BigNumber,
    string,
    BigNumber,
    string,
    BigNumber
  ] & {
    percentage: BigNumber;
    fee1: BigNumber;
    token1: string;
    fee2: BigNumber;
    token2: string;
    fee3: BigNumber;
  };
}

export interface UniswapBridgeInterface extends utils.Interface {
  functions: {
    "BUSD()": FunctionFragment;
    "DAI()": FunctionFragment;
    "EXPONENT_MASK()": FunctionFragment;
    "FEE_MASK()": FunctionFragment;
    "FRAX()": FunctionFragment;
    "PRICE_BIT_LENGTH()": FunctionFragment;
    "PRICE_MASK()": FunctionFragment;
    "QUOTER()": FunctionFragment;
    "ROLLUP_PROCESSOR()": FunctionFragment;
    "ROUTER()": FunctionFragment;
    "SPLIT_PATHS_BIT_LENGTH()": FunctionFragment;
    "SPLIT_PATH_BIT_LENGTH()": FunctionFragment;
    "SPLIT_PATH_MASK()": FunctionFragment;
    "SUBSIDY()": FunctionFragment;
    "TOKEN_MASK()": FunctionFragment;
    "USDC()": FunctionFragment;
    "USDT()": FunctionFragment;
    "WBTC()": FunctionFragment;
    "WETH()": FunctionFragment;
    "computeCriteria((uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),uint64)": FunctionFragment;
    "convert((uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),uint256,uint256,uint64,address)": FunctionFragment;
    "encodePath(uint256,uint256,address,(uint256,uint256,address,uint256,address,uint256),(uint256,uint256,address,uint256,address,uint256))": FunctionFragment;
    "finalise((uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),(uint256,address,uint8),uint256,uint64)": FunctionFragment;
    "preApproveTokens(address[],address[])": FunctionFragment;
    "quote(uint256,address,uint64,address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "BUSD"
      | "DAI"
      | "EXPONENT_MASK"
      | "FEE_MASK"
      | "FRAX"
      | "PRICE_BIT_LENGTH"
      | "PRICE_MASK"
      | "QUOTER"
      | "ROLLUP_PROCESSOR"
      | "ROUTER"
      | "SPLIT_PATHS_BIT_LENGTH"
      | "SPLIT_PATH_BIT_LENGTH"
      | "SPLIT_PATH_MASK"
      | "SUBSIDY"
      | "TOKEN_MASK"
      | "USDC"
      | "USDT"
      | "WBTC"
      | "WETH"
      | "computeCriteria"
      | "convert"
      | "encodePath"
      | "finalise"
      | "preApproveTokens"
      | "quote"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "BUSD", values?: undefined): string;
  encodeFunctionData(functionFragment: "DAI", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "EXPONENT_MASK",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "FEE_MASK", values?: undefined): string;
  encodeFunctionData(functionFragment: "FRAX", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "PRICE_BIT_LENGTH",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "PRICE_MASK",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "QUOTER", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "ROLLUP_PROCESSOR",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "ROUTER", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "SPLIT_PATHS_BIT_LENGTH",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "SPLIT_PATH_BIT_LENGTH",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "SPLIT_PATH_MASK",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "SUBSIDY", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "TOKEN_MASK",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "USDC", values?: undefined): string;
  encodeFunctionData(functionFragment: "USDT", values?: undefined): string;
  encodeFunctionData(functionFragment: "WBTC", values?: undefined): string;
  encodeFunctionData(functionFragment: "WETH", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "computeCriteria",
    values: [
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "convert",
    values: [
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "encodePath",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      UniswapBridge.SplitPathStruct,
      UniswapBridge.SplitPathStruct
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "finalise",
    values: [
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      AztecTypes.AztecAssetStruct,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "preApproveTokens",
    values: [PromiseOrValue<string>[], PromiseOrValue<string>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "quote",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;

  decodeFunctionResult(functionFragment: "BUSD", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "DAI", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "EXPONENT_MASK",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "FEE_MASK", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "FRAX", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "PRICE_BIT_LENGTH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "PRICE_MASK", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "QUOTER", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "ROLLUP_PROCESSOR",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "ROUTER", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "SPLIT_PATHS_BIT_LENGTH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "SPLIT_PATH_BIT_LENGTH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "SPLIT_PATH_MASK",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "SUBSIDY", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "TOKEN_MASK", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "USDC", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "USDT", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "WBTC", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "WETH", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "computeCriteria",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "convert", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "encodePath", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "finalise", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "preApproveTokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "quote", data: BytesLike): Result;

  events: {
    "DefaultDecimalsWarning()": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "DefaultDecimalsWarning"): EventFragment;
}

export interface DefaultDecimalsWarningEventObject {}
export type DefaultDecimalsWarningEvent = TypedEvent<
  [],
  DefaultDecimalsWarningEventObject
>;

export type DefaultDecimalsWarningEventFilter =
  TypedEventFilter<DefaultDecimalsWarningEvent>;

export interface UniswapBridge extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: UniswapBridgeInterface;

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
    BUSD(overrides?: CallOverrides): Promise<[string]>;

    DAI(overrides?: CallOverrides): Promise<[string]>;

    EXPONENT_MASK(overrides?: CallOverrides): Promise<[BigNumber]>;

    FEE_MASK(overrides?: CallOverrides): Promise<[BigNumber]>;

    FRAX(overrides?: CallOverrides): Promise<[string]>;

    PRICE_BIT_LENGTH(overrides?: CallOverrides): Promise<[BigNumber]>;

    PRICE_MASK(overrides?: CallOverrides): Promise<[BigNumber]>;

    QUOTER(overrides?: CallOverrides): Promise<[string]>;

    ROLLUP_PROCESSOR(overrides?: CallOverrides): Promise<[string]>;

    ROUTER(overrides?: CallOverrides): Promise<[string]>;

    SPLIT_PATHS_BIT_LENGTH(overrides?: CallOverrides): Promise<[BigNumber]>;

    SPLIT_PATH_BIT_LENGTH(overrides?: CallOverrides): Promise<[BigNumber]>;

    SPLIT_PATH_MASK(overrides?: CallOverrides): Promise<[BigNumber]>;

    SUBSIDY(overrides?: CallOverrides): Promise<[string]>;

    TOKEN_MASK(overrides?: CallOverrides): Promise<[BigNumber]>;

    USDC(overrides?: CallOverrides): Promise<[string]>;

    USDT(overrides?: CallOverrides): Promise<[string]>;

    WBTC(overrides?: CallOverrides): Promise<[string]>;

    WETH(overrides?: CallOverrides): Promise<[string]>;

    computeCriteria(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    convert(
      _inputAssetA: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      _outputAssetA: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      _totalInputValue: PromiseOrValue<BigNumberish>,
      _interactionNonce: PromiseOrValue<BigNumberish>,
      _auxData: PromiseOrValue<BigNumberish>,
      arg7: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    encodePath(
      _amountIn: PromiseOrValue<BigNumberish>,
      _minAmountOut: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _splitPath1: UniswapBridge.SplitPathStruct,
      _splitPath2: UniswapBridge.SplitPathStruct,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    finalise(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      arg5: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    preApproveTokens(
      _tokensIn: PromiseOrValue<string>[],
      _tokensOut: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    quote(
      _amountIn: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _path: PromiseOrValue<BigNumberish>,
      _tokenOut: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  BUSD(overrides?: CallOverrides): Promise<string>;

  DAI(overrides?: CallOverrides): Promise<string>;

  EXPONENT_MASK(overrides?: CallOverrides): Promise<BigNumber>;

  FEE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

  FRAX(overrides?: CallOverrides): Promise<string>;

  PRICE_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

  PRICE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

  QUOTER(overrides?: CallOverrides): Promise<string>;

  ROLLUP_PROCESSOR(overrides?: CallOverrides): Promise<string>;

  ROUTER(overrides?: CallOverrides): Promise<string>;

  SPLIT_PATHS_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

  SPLIT_PATH_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

  SPLIT_PATH_MASK(overrides?: CallOverrides): Promise<BigNumber>;

  SUBSIDY(overrides?: CallOverrides): Promise<string>;

  TOKEN_MASK(overrides?: CallOverrides): Promise<BigNumber>;

  USDC(overrides?: CallOverrides): Promise<string>;

  USDT(overrides?: CallOverrides): Promise<string>;

  WBTC(overrides?: CallOverrides): Promise<string>;

  WETH(overrides?: CallOverrides): Promise<string>;

  computeCriteria(
    arg0: AztecTypes.AztecAssetStruct,
    arg1: AztecTypes.AztecAssetStruct,
    arg2: AztecTypes.AztecAssetStruct,
    arg3: AztecTypes.AztecAssetStruct,
    arg4: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  convert(
    _inputAssetA: AztecTypes.AztecAssetStruct,
    arg1: AztecTypes.AztecAssetStruct,
    _outputAssetA: AztecTypes.AztecAssetStruct,
    arg3: AztecTypes.AztecAssetStruct,
    _totalInputValue: PromiseOrValue<BigNumberish>,
    _interactionNonce: PromiseOrValue<BigNumberish>,
    _auxData: PromiseOrValue<BigNumberish>,
    arg7: PromiseOrValue<string>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  encodePath(
    _amountIn: PromiseOrValue<BigNumberish>,
    _minAmountOut: PromiseOrValue<BigNumberish>,
    _tokenIn: PromiseOrValue<string>,
    _splitPath1: UniswapBridge.SplitPathStruct,
    _splitPath2: UniswapBridge.SplitPathStruct,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  finalise(
    arg0: AztecTypes.AztecAssetStruct,
    arg1: AztecTypes.AztecAssetStruct,
    arg2: AztecTypes.AztecAssetStruct,
    arg3: AztecTypes.AztecAssetStruct,
    arg4: PromiseOrValue<BigNumberish>,
    arg5: PromiseOrValue<BigNumberish>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  preApproveTokens(
    _tokensIn: PromiseOrValue<string>[],
    _tokensOut: PromiseOrValue<string>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  quote(
    _amountIn: PromiseOrValue<BigNumberish>,
    _tokenIn: PromiseOrValue<string>,
    _path: PromiseOrValue<BigNumberish>,
    _tokenOut: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    BUSD(overrides?: CallOverrides): Promise<string>;

    DAI(overrides?: CallOverrides): Promise<string>;

    EXPONENT_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    FEE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    FRAX(overrides?: CallOverrides): Promise<string>;

    PRICE_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    PRICE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    QUOTER(overrides?: CallOverrides): Promise<string>;

    ROLLUP_PROCESSOR(overrides?: CallOverrides): Promise<string>;

    ROUTER(overrides?: CallOverrides): Promise<string>;

    SPLIT_PATHS_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    SPLIT_PATH_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    SPLIT_PATH_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    SUBSIDY(overrides?: CallOverrides): Promise<string>;

    TOKEN_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    USDC(overrides?: CallOverrides): Promise<string>;

    USDT(overrides?: CallOverrides): Promise<string>;

    WBTC(overrides?: CallOverrides): Promise<string>;

    WETH(overrides?: CallOverrides): Promise<string>;

    computeCriteria(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    convert(
      _inputAssetA: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      _outputAssetA: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      _totalInputValue: PromiseOrValue<BigNumberish>,
      _interactionNonce: PromiseOrValue<BigNumberish>,
      _auxData: PromiseOrValue<BigNumberish>,
      arg7: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, boolean] & { outputValueA: BigNumber }>;

    encodePath(
      _amountIn: PromiseOrValue<BigNumberish>,
      _minAmountOut: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _splitPath1: UniswapBridge.SplitPathStruct,
      _splitPath2: UniswapBridge.SplitPathStruct,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    finalise(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      arg5: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, boolean]>;

    preApproveTokens(
      _tokensIn: PromiseOrValue<string>[],
      _tokensOut: PromiseOrValue<string>[],
      overrides?: CallOverrides
    ): Promise<void>;

    quote(
      _amountIn: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _path: PromiseOrValue<BigNumberish>,
      _tokenOut: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  filters: {
    "DefaultDecimalsWarning()"(): DefaultDecimalsWarningEventFilter;
    DefaultDecimalsWarning(): DefaultDecimalsWarningEventFilter;
  };

  estimateGas: {
    BUSD(overrides?: CallOverrides): Promise<BigNumber>;

    DAI(overrides?: CallOverrides): Promise<BigNumber>;

    EXPONENT_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    FEE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    FRAX(overrides?: CallOverrides): Promise<BigNumber>;

    PRICE_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    PRICE_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    QUOTER(overrides?: CallOverrides): Promise<BigNumber>;

    ROLLUP_PROCESSOR(overrides?: CallOverrides): Promise<BigNumber>;

    ROUTER(overrides?: CallOverrides): Promise<BigNumber>;

    SPLIT_PATHS_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    SPLIT_PATH_BIT_LENGTH(overrides?: CallOverrides): Promise<BigNumber>;

    SPLIT_PATH_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    SUBSIDY(overrides?: CallOverrides): Promise<BigNumber>;

    TOKEN_MASK(overrides?: CallOverrides): Promise<BigNumber>;

    USDC(overrides?: CallOverrides): Promise<BigNumber>;

    USDT(overrides?: CallOverrides): Promise<BigNumber>;

    WBTC(overrides?: CallOverrides): Promise<BigNumber>;

    WETH(overrides?: CallOverrides): Promise<BigNumber>;

    computeCriteria(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    convert(
      _inputAssetA: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      _outputAssetA: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      _totalInputValue: PromiseOrValue<BigNumberish>,
      _interactionNonce: PromiseOrValue<BigNumberish>,
      _auxData: PromiseOrValue<BigNumberish>,
      arg7: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    encodePath(
      _amountIn: PromiseOrValue<BigNumberish>,
      _minAmountOut: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _splitPath1: UniswapBridge.SplitPathStruct,
      _splitPath2: UniswapBridge.SplitPathStruct,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    finalise(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      arg5: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    preApproveTokens(
      _tokensIn: PromiseOrValue<string>[],
      _tokensOut: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    quote(
      _amountIn: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _path: PromiseOrValue<BigNumberish>,
      _tokenOut: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    BUSD(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    DAI(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    EXPONENT_MASK(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    FEE_MASK(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    FRAX(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    PRICE_BIT_LENGTH(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    PRICE_MASK(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    QUOTER(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    ROLLUP_PROCESSOR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    ROUTER(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    SPLIT_PATHS_BIT_LENGTH(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    SPLIT_PATH_BIT_LENGTH(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    SPLIT_PATH_MASK(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    SUBSIDY(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    TOKEN_MASK(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    USDC(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    USDT(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    WBTC(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    WETH(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    computeCriteria(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    convert(
      _inputAssetA: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      _outputAssetA: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      _totalInputValue: PromiseOrValue<BigNumberish>,
      _interactionNonce: PromiseOrValue<BigNumberish>,
      _auxData: PromiseOrValue<BigNumberish>,
      arg7: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    encodePath(
      _amountIn: PromiseOrValue<BigNumberish>,
      _minAmountOut: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _splitPath1: UniswapBridge.SplitPathStruct,
      _splitPath2: UniswapBridge.SplitPathStruct,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    finalise(
      arg0: AztecTypes.AztecAssetStruct,
      arg1: AztecTypes.AztecAssetStruct,
      arg2: AztecTypes.AztecAssetStruct,
      arg3: AztecTypes.AztecAssetStruct,
      arg4: PromiseOrValue<BigNumberish>,
      arg5: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    preApproveTokens(
      _tokensIn: PromiseOrValue<string>[],
      _tokensOut: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    quote(
      _amountIn: PromiseOrValue<BigNumberish>,
      _tokenIn: PromiseOrValue<string>,
      _path: PromiseOrValue<BigNumberish>,
      _tokenOut: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
