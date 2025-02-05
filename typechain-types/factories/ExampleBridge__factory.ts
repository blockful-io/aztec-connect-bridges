/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../common.js";
import type { ExampleBridge, ExampleBridgeInterface } from "../ExampleBridge.js";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_rollupProcessor",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "AsyncDisabled",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidCaller",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidInputA",
    type: "error",
  },
  {
    inputs: [],
    name: "InvalidOutputA",
    type: "error",
  },
  {
    inputs: [],
    name: "MissingImplementation",
    type: "error",
  },
  {
    inputs: [],
    name: "ROLLUP_PROCESSOR",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "SUBSIDY",
    outputs: [
      {
        internalType: "contract ISubsidy",
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
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_inputAssetA",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_outputAssetA",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        internalType: "uint64",
        name: "",
        type: "uint64",
      },
    ],
    name: "computeCriteria",
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
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_inputAssetA",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_inputAssetB",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_outputAssetA",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "_outputAssetB",
        type: "tuple",
      },
      {
        internalType: "uint256",
        name: "_totalInputValue",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint64",
        name: "_auxData",
        type: "uint64",
      },
      {
        internalType: "address",
        name: "_rollupBeneficiary",
        type: "address",
      },
    ],
    name: "convert",
    outputs: [
      {
        internalType: "uint256",
        name: "outputValueA",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "erc20Address",
            type: "address",
          },
          {
            internalType: "enum AztecTypes.AztecAssetType",
            name: "assetType",
            type: "uint8",
          },
        ],
        internalType: "struct AztecTypes.AztecAsset",
        name: "",
        type: "tuple",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint64",
        name: "",
        type: "uint64",
      },
    ],
    name: "finalise",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
];

const _bytecode =
  "0x60a06040523480156200001157600080fd5b5060405162000bc238038062000bc28339810160408190526200003491620002d5565b6001600160a01b038116608052604080516002808252606082018352736b175474e89094c44da98b954eedeac495271d0f9273a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48926000929091602083019080368337505060408051600280825260608201835293945060009390925090602083019080368337505060408051600280825260608201835293945060009390925090602083019080368337019050506040516001600160601b0319606088901b166020820181905260348201529091506048016040516020818303038152906040528051906020012060001c8360008151811062000129576200012962000307565b60209081029190910181019190915260408051606087901b6001600160601b0319168184018190526034820152815160288183030181526048909101909152805191012083518490600190811062000185576200018562000307565b60200260200101818152505062011cc082600081518110620001ab57620001ab62000307565b602002602001019063ffffffff16908163ffffffff16815250506201397982600181518110620001df57620001df62000307565b602002602001019063ffffffff16908163ffffffff168152505060648160008151811062000211576200021162000307565b602002602001019063ffffffff16908163ffffffff168152505060968160018151811062000243576200024362000307565b63ffffffff909216602092830291909101909101526040516338d8461360e11b815273abc30e831b5cc173a9ed5941714a7845c909e7fa906371b08c2690620002959086908690869060040162000360565b600060405180830381600087803b158015620002b057600080fd5b505af1158015620002c5573d6000803e3d6000fd5b50505050505050505050620003d2565b600060208284031215620002e857600080fd5b81516001600160a01b03811681146200030057600080fd5b9392505050565b634e487b7160e01b600052603260045260246000fd5b600081518084526020808501945080840160005b838110156200035557815163ffffffff168752958201959082019060010162000331565b509495945050505050565b606080825284519082018190526000906020906080840190828801845b828110156200039b578151845292840192908401906001016200037d565b50505083810382850152620003b181876200031d565b9150508281036040840152620003c881856200031d565b9695505050505050565b6080516107c6620003fc600039600081816101060152818161017201526102f601526107c66000f3fe60806040526004361061005a5760003560e01c80639b07d342116100435780639b07d342146100e1578063ae9467b5146100f4578063dbeacd541461012857600080fd5b806326c3b5151461005f5780636508156e14610094575b600080fd5b61007261006d366004610570565b610156565b6040805193845260208401929092521515908201526060015b60405180910390f35b3480156100a057600080fd5b506100bc73abc30e831b5cc173a9ed5941714a7845c909e7fa81565b60405173ffffffffffffffffffffffffffffffffffffffff909116815260200161008b565b6100726100ef366004610602565b610441565b34801561010057600080fd5b506100bc7f000000000000000000000000000000000000000000000000000000000000000081565b34801561013457600080fd5b50610148610143366004610677565b610478565b60405190815260200161008b565b600080803373ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016146101c9576040517f48f5c3ed00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60026101db60608d0160408e01610712565b60038111156101ec576101ec6106e3565b14610223576040517fc582880b00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b61023360408c0160208d0161073a565b73ffffffffffffffffffffffffffffffffffffffff1661025960408b0160208c0161073a565b73ffffffffffffffffffffffffffffffffffffffff16146102a6576040517f6c98dcaf00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b8692506102b960408a0160208b0161073a565b6040517f095ea7b300000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000081166004830152602482018a9052919091169063095ea7b3906044016020604051808303816000875af1158015610350573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906103749190610755565b5073abc30e831b5cc173a9ed5941714a7845c909e7fa630d3b205261039c8d8d8d8d8b610478565b6040517fffffffff0000000000000000000000000000000000000000000000000000000060e084901b168152600481019190915273ffffffffffffffffffffffffffffffffffffffff871660248201526044016020604051808303816000875af115801561040e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906104329190610777565b50985098509895505050505050565b60008060006040517f26d18eab00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600061048a604087016020880161073a565b61049a604086016020870161073a565b6040517fffffffffffffffffffffffffffffffffffffffff000000000000000000000000606093841b811660208301529190921b166034820152604801604080517fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe081840301815291905280516020909101209695505050505050565b60006060828403121561052957600080fd5b50919050565b803567ffffffffffffffff8116811461054757600080fd5b919050565b803573ffffffffffffffffffffffffffffffffffffffff8116811461054757600080fd5b600080600080600080600080610200898b03121561058d57600080fd5b6105978a8a610517565b97506105a68a60608b01610517565b96506105b58a60c08b01610517565b95506105c58a6101208b01610517565b945061018089013593506101a089013592506105e46101c08a0161052f565b91506105f36101e08a0161054c565b90509295985092959890939650565b6000806000806000806101c0878903121561061c57600080fd5b6106268888610517565b95506106358860608901610517565b94506106448860c08901610517565b9350610654886101208901610517565b9250610180870135915061066b6101a0880161052f565b90509295509295509295565b60008060008060006101a0868803121561069057600080fd5b61069a8787610517565b94506106a98760608801610517565b93506106b88760c08801610517565b92506106c8876101208801610517565b91506106d7610180870161052f565b90509295509295909350565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b60006020828403121561072457600080fd5b81356004811061073357600080fd5b9392505050565b60006020828403121561074c57600080fd5b6107338261054c565b60006020828403121561076757600080fd5b8151801515811461073357600080fd5b60006020828403121561078957600080fd5b505191905056fea2646970667358221220317749f809ce6c71b4dc3d73a340a9cf64f26438d866ddf819adddf88dccb36e64736f6c634300080a0033";

type ExampleBridgeConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: ExampleBridgeConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class ExampleBridge__factory extends ContractFactory {
  constructor(...args: ExampleBridgeConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _rollupProcessor: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ExampleBridge> {
    return super.deploy(
      _rollupProcessor,
      overrides || {}
    ) as Promise<ExampleBridge>;
  }
  override getDeployTransaction(
    _rollupProcessor: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_rollupProcessor, overrides || {});
  }
  override attach(address: string): ExampleBridge {
    return super.attach(address) as ExampleBridge;
  }
  override connect(signer: Signer): ExampleBridge__factory {
    return super.connect(signer) as ExampleBridge__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): ExampleBridgeInterface {
    return new utils.Interface(_abi) as ExampleBridgeInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ExampleBridge {
    return new Contract(address, _abi, signerOrProvider) as ExampleBridge;
  }
}
