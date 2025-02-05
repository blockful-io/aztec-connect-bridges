/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type { ITroveManager, ITroveManagerInterface } from "../ITroveManager.js";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_price",
        type: "uint256",
      },
    ],
    name: "checkRecoveryMode",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_borrower",
        type: "address",
      },
    ],
    name: "closeTrove",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getBorrowingRateWithDecay",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_borrower",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_price",
        type: "uint256",
      },
    ],
    name: "getCurrentICR",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_borrower",
        type: "address",
      },
    ],
    name: "getEntireDebtAndColl",
    outputs: [
      {
        internalType: "uint256",
        name: "debt",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "coll",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "pendingLUSDDebtReward",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "pendingETHReward",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_price",
        type: "uint256",
      },
    ],
    name: "getTCR",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_borrower",
        type: "address",
      },
    ],
    name: "getTroveStatus",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_borrower",
        type: "address",
      },
    ],
    name: "liquidate",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_n",
        type: "uint256",
      },
    ],
    name: "liquidateTroves",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
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
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_LUSDAmount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_firstRedemptionHint",
        type: "address",
      },
      {
        internalType: "address",
        name: "_upperPartialRedemptionHint",
        type: "address",
      },
      {
        internalType: "address",
        name: "_lowerPartialRedemptionHint",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_partialRedemptionHintNICR",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_maxIterations",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_maxFee",
        type: "uint256",
      },
    ],
    name: "redeemCollateral",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class ITroveManager__factory {
  static readonly abi = _abi;
  static createInterface(): ITroveManagerInterface {
    return new utils.Interface(_abi) as ITroveManagerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ITroveManager {
    return new Contract(address, _abi, signerOrProvider) as ITroveManager;
  }
}
