/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
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

export interface IChainlinkOracleInterface extends utils.Interface {
  functions: {
    "latestRoundData()": FunctionFragment;
  };

  getFunction(nameOrSignatureOrTopic: "latestRoundData"): FunctionFragment;

  encodeFunctionData(
    functionFragment: "latestRoundData",
    values?: undefined
  ): string;

  decodeFunctionResult(
    functionFragment: "latestRoundData",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IChainlinkOracle extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IChainlinkOracleInterface;

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
    latestRoundData(
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, BigNumber, BigNumber, BigNumber]>;
  };

  latestRoundData(
    overrides?: CallOverrides
  ): Promise<[BigNumber, BigNumber, BigNumber, BigNumber, BigNumber]>;

  callStatic: {
    latestRoundData(
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, BigNumber, BigNumber, BigNumber]>;
  };

  filters: {};

  estimateGas: {
    latestRoundData(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    latestRoundData(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}
