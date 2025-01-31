/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type { ILiquityBase, ILiquityBaseInterface } from "../ILiquityBase.js";

const _abi = [
  {
    inputs: [],
    name: "priceFeed",
    outputs: [
      {
        internalType: "contract IPriceFeed",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class ILiquityBase__factory {
  static readonly abi = _abi;
  static createInterface(): ILiquityBaseInterface {
    return new utils.Interface(_abi) as ILiquityBaseInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ILiquityBase {
    return new Contract(address, _abi, signerOrProvider) as ILiquityBase;
  }
}
