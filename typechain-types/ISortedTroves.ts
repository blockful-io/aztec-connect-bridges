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

export interface ISortedTrovesInterface extends utils.Interface {
  functions: {
    "findInsertPosition(uint256,address,address)": FunctionFragment;
    "getLast()": FunctionFragment;
    "getNext(address)": FunctionFragment;
    "getPrev(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "findInsertPosition"
      | "getLast"
      | "getNext"
      | "getPrev"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "findInsertPosition",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(functionFragment: "getLast", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "getNext",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getPrev",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(
    functionFragment: "findInsertPosition",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "getLast", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getNext", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getPrev", data: BytesLike): Result;

  events: {};
}

export interface ISortedTroves extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: ISortedTrovesInterface;

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
    findInsertPosition(
      _ICR: PromiseOrValue<BigNumberish>,
      _prevId: PromiseOrValue<string>,
      _nextId: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[string, string]>;

    getLast(overrides?: CallOverrides): Promise<[string]>;

    getNext(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getPrev(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[string]>;
  };

  findInsertPosition(
    _ICR: PromiseOrValue<BigNumberish>,
    _prevId: PromiseOrValue<string>,
    _nextId: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<[string, string]>;

  getLast(overrides?: CallOverrides): Promise<string>;

  getNext(
    _id: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<string>;

  getPrev(
    _id: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<string>;

  callStatic: {
    findInsertPosition(
      _ICR: PromiseOrValue<BigNumberish>,
      _prevId: PromiseOrValue<string>,
      _nextId: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[string, string]>;

    getLast(overrides?: CallOverrides): Promise<string>;

    getNext(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<string>;

    getPrev(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<string>;
  };

  filters: {};

  estimateGas: {
    findInsertPosition(
      _ICR: PromiseOrValue<BigNumberish>,
      _prevId: PromiseOrValue<string>,
      _nextId: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getLast(overrides?: CallOverrides): Promise<BigNumber>;

    getNext(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getPrev(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    findInsertPosition(
      _ICR: PromiseOrValue<BigNumberish>,
      _prevId: PromiseOrValue<string>,
      _nextId: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getLast(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getNext(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getPrev(
      _id: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
