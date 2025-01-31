/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
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

export interface IHintHelpersInterface extends utils.Interface {
  functions: {
    "getApproxHint(uint256,uint256,uint256)": FunctionFragment;
    "getRedemptionHints(uint256,uint256,uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic: "getApproxHint" | "getRedemptionHints"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "getApproxHint",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "getRedemptionHints",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;

  decodeFunctionResult(
    functionFragment: "getApproxHint",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRedemptionHints",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IHintHelpers extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IHintHelpersInterface;

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
    getApproxHint(
      _CR: PromiseOrValue<BigNumberish>,
      _numTrials: PromiseOrValue<BigNumberish>,
      _inputRandomSeed: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, BigNumber] & {
        hintAddress: string;
        diff: BigNumber;
        latestRandomSeed: BigNumber;
      }
    >;

    getRedemptionHints(
      _LUSDamount: PromiseOrValue<BigNumberish>,
      _price: PromiseOrValue<BigNumberish>,
      _maxIterations: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, BigNumber] & {
        firstRedemptionHint: string;
        partialRedemptionHintNICR: BigNumber;
        truncatedLUSDamount: BigNumber;
      }
    >;
  };

  getApproxHint(
    _CR: PromiseOrValue<BigNumberish>,
    _numTrials: PromiseOrValue<BigNumberish>,
    _inputRandomSeed: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<
    [string, BigNumber, BigNumber] & {
      hintAddress: string;
      diff: BigNumber;
      latestRandomSeed: BigNumber;
    }
  >;

  getRedemptionHints(
    _LUSDamount: PromiseOrValue<BigNumberish>,
    _price: PromiseOrValue<BigNumberish>,
    _maxIterations: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<
    [string, BigNumber, BigNumber] & {
      firstRedemptionHint: string;
      partialRedemptionHintNICR: BigNumber;
      truncatedLUSDamount: BigNumber;
    }
  >;

  callStatic: {
    getApproxHint(
      _CR: PromiseOrValue<BigNumberish>,
      _numTrials: PromiseOrValue<BigNumberish>,
      _inputRandomSeed: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, BigNumber] & {
        hintAddress: string;
        diff: BigNumber;
        latestRandomSeed: BigNumber;
      }
    >;

    getRedemptionHints(
      _LUSDamount: PromiseOrValue<BigNumberish>,
      _price: PromiseOrValue<BigNumberish>,
      _maxIterations: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [string, BigNumber, BigNumber] & {
        firstRedemptionHint: string;
        partialRedemptionHintNICR: BigNumber;
        truncatedLUSDamount: BigNumber;
      }
    >;
  };

  filters: {};

  estimateGas: {
    getApproxHint(
      _CR: PromiseOrValue<BigNumberish>,
      _numTrials: PromiseOrValue<BigNumberish>,
      _inputRandomSeed: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRedemptionHints(
      _LUSDamount: PromiseOrValue<BigNumberish>,
      _price: PromiseOrValue<BigNumberish>,
      _maxIterations: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    getApproxHint(
      _CR: PromiseOrValue<BigNumberish>,
      _numTrials: PromiseOrValue<BigNumberish>,
      _inputRandomSeed: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRedemptionHints(
      _LUSDamount: PromiseOrValue<BigNumberish>,
      _price: PromiseOrValue<BigNumberish>,
      _maxIterations: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
