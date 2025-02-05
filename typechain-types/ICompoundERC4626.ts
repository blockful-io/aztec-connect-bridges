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

export interface ICompoundERC4626Interface extends utils.Interface {
  functions: {
    "cToken()": FunctionFragment;
  };

  getFunction(nameOrSignatureOrTopic: "cToken"): FunctionFragment;

  encodeFunctionData(functionFragment: "cToken", values?: undefined): string;

  decodeFunctionResult(functionFragment: "cToken", data: BytesLike): Result;

  events: {};
}

export interface ICompoundERC4626 extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: ICompoundERC4626Interface;

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
    cToken(overrides?: CallOverrides): Promise<[string]>;
  };

  cToken(overrides?: CallOverrides): Promise<string>;

  callStatic: {
    cToken(overrides?: CallOverrides): Promise<string>;
  };

  filters: {};

  estimateGas: {
    cToken(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    cToken(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}
