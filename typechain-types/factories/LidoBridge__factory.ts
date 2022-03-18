/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { LidoBridge, LidoBridgeInterface } from "../LidoBridge";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_rollupProcessor",
        type: "address",
      },
      {
        internalType: "address",
        name: "_referral",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
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
        name: "inputAssetA",
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
        name: "outputAssetA",
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
        name: "inputValue",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "interactionNonce",
        type: "uint256",
      },
      {
        internalType: "uint64",
        name: "",
        type: "uint64",
      },
      {
        internalType: "address",
        name: "",
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
        name: "isAsync",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "curvePool",
    outputs: [
      {
        internalType: "contract ICurvePool",
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
  {
    inputs: [],
    name: "lido",
    outputs: [
      {
        internalType: "contract ILido",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "referral",
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
    name: "rollupProcessor",
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
    name: "wrappedStETH",
    outputs: [
      {
        internalType: "contract IWstETH",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    stateMutability: "payable",
    type: "receive",
  },
];

const _bytecode =
  "0x60a060405273ae7ab96520de3a18e5e111b5eaab095312d7fe84600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550737f39c581f595b53c5cb19bd0b3f8da6c935e2ca0600260006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555073dc24316b9ae028f1497c275eb9192a3ea0f67022600360006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000600460006101000a8154816fffffffffffffffffffffffffffffffff0219169083600f0b6fffffffffffffffffffffffffffffffff1602179055506001600460106101000a8154816fffffffffffffffffffffffffffffffff0219169083600f0b6fffffffffffffffffffffffffffffffff1602179055503480156200018a57600080fd5b5060405162001e9a38038062001e9a8339818101604052810190620001b0919062000296565b8173ffffffffffffffffffffffffffffffffffffffff1660808173ffffffffffffffffffffffffffffffffffffffff1681525050806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050620002dd565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006200025e8262000231565b9050919050565b620002708162000251565b81146200027c57600080fd5b50565b600081519050620002908162000265565b92915050565b60008060408385031215620002b057620002af6200022c565b5b6000620002c0858286016200027f565b9250506020620002d3858286016200027f565b9150509250929050565b608051611b8c6200030e6000396000818161023201528181610425015281816106db0152610c600152611b8c6000f3fe6080604052600436106100745760003560e01c806326c3b5151161004e57806326c3b515146101015780632a113d6e146101335780639b07d3421461015e578063d8e8cc56146101905761007b565b80631441a5a914610080578063218751b2146100ab57806323509a2d146100d65761007b565b3661007b57005b600080fd5b34801561008c57600080fd5b506100956101bb565b6040516100a29190611091565b60405180910390f35b3480156100b757600080fd5b506100c06101df565b6040516100cd919061110b565b60405180910390f35b3480156100e257600080fd5b506100eb610205565b6040516100f89190611147565b60405180910390f35b61011b6004803603810190610116919061122d565b61022b565b60405161012a93929190611312565b60405180910390f35b34801561013f57600080fd5b50610148610423565b6040516101559190611091565b60405180910390f35b61017860048036038101906101739190611349565b610447565b60405161018793929190611312565b60405180910390f35b34801561019c57600080fd5b506101a5610462565b6040516101b291906113fb565b60405180910390f35b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60008060007f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102be576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016102b590611473565b60405180910390fd5b6000600160038111156102d4576102d3611493565b5b8c60400160208101906102e791906114e7565b60038111156102f9576102f8611493565b5b14905060006002600381111561031257610311611493565b5b8d604001602081019061032591906114e7565b600381111561033757610336611493565b5b1480156103a35750600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168d602001602081019061038b9190611514565b73ffffffffffffffffffffffffffffffffffffffff16145b905081806103ae5750805b6103ed576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016103e49061158d565b60405180910390fd5b600092508161040657610401898c8a610488565b610411565b610410898c61076d565b5b94505050985098509895505050505050565b7f000000000000000000000000000000000000000000000000000000000000000081565b60008060008061045657600080fd5b96509650969350505050565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60006001600381111561049e5761049d611493565b5b8360400160208101906104b191906114e7565b60038111156104c3576104c2611493565b5b14610503576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016104fa906115f9565b60405180910390fd5b6000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663de0e9a3e866040518263ffffffff1660e01b81526004016105609190611619565b6020604051808303816000875af115801561057f573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105a39190611649565b9050610614600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1682600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16610cd19092919063ffffffff16565b600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16633df02124600460109054906101000a9004600f0b600460009054906101000a9004600f0b8460006040518563ffffffff1660e01b815260040161069494939291906116cd565b6020604051808303816000875af11580156106b3573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906106d79190611649565b91507f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff166312a5362383856040518363ffffffff1660e01b81526004016107339190611619565b6000604051808303818588803b15801561074c57600080fd5b505af1158015610760573d6000803e3d6000fd5b5050505050509392505050565b60006002600381111561078357610782611493565b5b82604001602081019061079691906114e7565b60038111156107a8576107a7611493565b5b1480156108145750600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168260200160208101906107fc9190611514565b73ffffffffffffffffffffffffffffffffffffffff16145b610853576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161084a906115f9565b60405180910390fd5b60008390506000600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16635e0d443f600460009054906101000a9004600f0b600460109054906101000a9004600f0b886040518463ffffffff1660e01b81526004016108d793929190611712565b602060405180830381865afa1580156108f4573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109189190611649565b9050818111156109eb57600360009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16633df0212486600460009054906101000a9004600f0b600460109054906101000a9004600f0b89876040518663ffffffff1660e01b81526004016109a29493929190611749565b60206040518083038185885af11580156109c0573d6000803e3d6000fd5b50505050506040513d601f19601f820116820180604052508101906109e59190611649565b50610aac565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663a1903eab8660008054906101000a900473ffffffffffffffffffffffffffffffffffffffff166040518363ffffffff1660e01b8152600401610a679190611091565b60206040518083038185885af1158015610a85573d6000803e3d6000fd5b50505050506040513d601f19601f82011682018060405250810190610aaa9190611649565b505b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166370a08231306040518263ffffffff1660e01b8152600401610b099190611091565b602060405180830381865afa158015610b26573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b4a9190611649565b9050610bbb600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1682600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16610cd19092919063ffffffff16565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663ea598cb0826040518263ffffffff1660e01b8152600401610c169190611619565b6020604051808303816000875af1158015610c35573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c599190611649565b9350610cc87f000000000000000000000000000000000000000000000000000000000000000085600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16610cd19092919063ffffffff16565b50505092915050565b6000818473ffffffffffffffffffffffffffffffffffffffff1663dd62ed3e30866040518363ffffffff1660e01b8152600401610d0f92919061178e565b602060405180830381865afa158015610d2c573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610d509190611649565b610d5a91906117e6565b9050610ddd8463095ea7b360e01b8584604051602401610d7b92919061183c565b604051602081830303815290604052907bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19166020820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff8381831617835250505050610de3565b50505050565b6000610e45826040518060400160405280602081526020017f5361666545524332303a206c6f772d6c6576656c2063616c6c206661696c65648152508573ffffffffffffffffffffffffffffffffffffffff16610eaa9092919063ffffffff16565b9050600081511115610ea55780806020019051810190610e659190611891565b610ea4576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610e9b90611930565b60405180910390fd5b5b505050565b6060610eb98484600085610ec2565b90509392505050565b606082471015610f07576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610efe906119c2565b60405180910390fd5b610f1085610fd6565b610f4f576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610f4690611a2e565b60405180910390fd5b6000808673ffffffffffffffffffffffffffffffffffffffff168587604051610f789190611ac8565b60006040518083038185875af1925050503d8060008114610fb5576040519150601f19603f3d011682016040523d82523d6000602084013e610fba565b606091505b5091509150610fca828286610fe9565b92505050949350505050565b600080823b905060008111915050919050565b60608315610ff957829050611049565b60008351111561100c5782518084602001fd5b816040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016110409190611b34565b60405180910390fd5b9392505050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061107b82611050565b9050919050565b61108b81611070565b82525050565b60006020820190506110a66000830184611082565b92915050565b6000819050919050565b60006110d16110cc6110c784611050565b6110ac565b611050565b9050919050565b60006110e3826110b6565b9050919050565b60006110f5826110d8565b9050919050565b611105816110ea565b82525050565b600060208201905061112060008301846110fc565b92915050565b6000611131826110d8565b9050919050565b61114181611126565b82525050565b600060208201905061115c6000830184611138565b92915050565b600080fd5b600080fd5b60006060828403121561118257611181611167565b5b81905092915050565b6000819050919050565b61119e8161118b565b81146111a957600080fd5b50565b6000813590506111bb81611195565b92915050565b600067ffffffffffffffff82169050919050565b6111de816111c1565b81146111e957600080fd5b50565b6000813590506111fb816111d5565b92915050565b61120a81611070565b811461121557600080fd5b50565b60008135905061122781611201565b92915050565b600080600080600080600080610200898b03121561124e5761124d611162565b5b600061125c8b828c0161116c565b985050606061126d8b828c0161116c565b97505060c061127e8b828c0161116c565b9650506101206112908b828c0161116c565b9550506101806112a28b828c016111ac565b9450506101a06112b48b828c016111ac565b9350506101c06112c68b828c016111ec565b9250506101e06112d88b828c01611218565b9150509295985092959890939650565b6112f18161118b565b82525050565b60008115159050919050565b61130c816112f7565b82525050565b600060608201905061132760008301866112e8565b61133460208301856112e8565b6113416040830184611303565b949350505050565b6000806000806000806101c0878903121561136757611366611162565b5b600061137589828a0161116c565b965050606061138689828a0161116c565b95505060c061139789828a0161116c565b9450506101206113a989828a0161116c565b9350506101806113bb89828a016111ac565b9250506101a06113cd89828a016111ec565b9150509295509295509295565b60006113e5826110d8565b9050919050565b6113f5816113da565b82525050565b600060208201905061141060008301846113ec565b92915050565b600082825260208201905092915050565b7f4c69646f4272696467653a20496e76616c69642043616c6c6572000000000000600082015250565b600061145d601a83611416565b915061146882611427565b602082019050919050565b6000602082019050818103600083015261148c81611450565b9050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b600481106114cf57600080fd5b50565b6000813590506114e1816114c2565b92915050565b6000602082840312156114fd576114fc611162565b5b600061150b848285016114d2565b91505092915050565b60006020828403121561152a57611529611162565b5b600061153884828501611218565b91505092915050565b7f4c69646f4272696467653a20496e76616c696420496e70757400000000000000600082015250565b6000611577601983611416565b915061158282611541565b602082019050919050565b600060208201905081810360008301526115a68161156a565b9050919050565b7f4c69646f4272696467653a20496e76616c6964204f757470757420546f6b656e600082015250565b60006115e3602083611416565b91506115ee826115ad565b602082019050919050565b60006020820190508181036000830152611612816115d6565b9050919050565b600060208201905061162e60008301846112e8565b92915050565b60008151905061164381611195565b92915050565b60006020828403121561165f5761165e611162565b5b600061166d84828501611634565b91505092915050565b600081600f0b9050919050565b61168c81611676565b82525050565b6000819050919050565b60006116b76116b26116ad84611692565b6110ac565b61118b565b9050919050565b6116c78161169c565b82525050565b60006080820190506116e26000830187611683565b6116ef6020830186611683565b6116fc60408301856112e8565b61170960608301846116be565b95945050505050565b60006060820190506117276000830186611683565b6117346020830185611683565b61174160408301846112e8565b949350505050565b600060808201905061175e6000830187611683565b61176b6020830186611683565b61177860408301856112e8565b61178560608301846112e8565b95945050505050565b60006040820190506117a36000830185611082565b6117b06020830184611082565b9392505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006117f18261118b565b91506117fc8361118b565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff03821115611831576118306117b7565b5b828201905092915050565b60006040820190506118516000830185611082565b61185e60208301846112e8565b9392505050565b61186e816112f7565b811461187957600080fd5b50565b60008151905061188b81611865565b92915050565b6000602082840312156118a7576118a6611162565b5b60006118b58482850161187c565b91505092915050565b7f5361666545524332303a204552433230206f7065726174696f6e20646964206e60008201527f6f74207375636365656400000000000000000000000000000000000000000000602082015250565b600061191a602a83611416565b9150611925826118be565b604082019050919050565b600060208201905081810360008301526119498161190d565b9050919050565b7f416464726573733a20696e73756666696369656e742062616c616e636520666f60008201527f722063616c6c0000000000000000000000000000000000000000000000000000602082015250565b60006119ac602683611416565b91506119b782611950565b604082019050919050565b600060208201905081810360008301526119db8161199f565b9050919050565b7f416464726573733a2063616c6c20746f206e6f6e2d636f6e7472616374000000600082015250565b6000611a18601d83611416565b9150611a23826119e2565b602082019050919050565b60006020820190508181036000830152611a4781611a0b565b9050919050565b600081519050919050565b600081905092915050565b60005b83811015611a82578082015181840152602081019050611a67565b83811115611a91576000848401525b50505050565b6000611aa282611a4e565b611aac8185611a59565b9350611abc818560208601611a64565b80840191505092915050565b6000611ad48284611a97565b915081905092915050565b600081519050919050565b6000601f19601f8301169050919050565b6000611b0682611adf565b611b108185611416565b9350611b20818560208601611a64565b611b2981611aea565b840191505092915050565b60006020820190508181036000830152611b4e8184611afb565b90509291505056fea26469706673582212206562c55e6d0be2720bc634d486f764511e53b465468a06d0760c76c20f76389664736f6c634300080a0033";

type LidoBridgeConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: LidoBridgeConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class LidoBridge__factory extends ContractFactory {
  constructor(...args: LidoBridgeConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
    this.contractName = "LidoBridge";
  }

  deploy(
    _rollupProcessor: string,
    _referral: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<LidoBridge> {
    return super.deploy(
      _rollupProcessor,
      _referral,
      overrides || {}
    ) as Promise<LidoBridge>;
  }
  getDeployTransaction(
    _rollupProcessor: string,
    _referral: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(
      _rollupProcessor,
      _referral,
      overrides || {}
    );
  }
  attach(address: string): LidoBridge {
    return super.attach(address) as LidoBridge;
  }
  connect(signer: Signer): LidoBridge__factory {
    return super.connect(signer) as LidoBridge__factory;
  }
  static readonly contractName: "LidoBridge";
  public readonly contractName: "LidoBridge";
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): LidoBridgeInterface {
    return new utils.Interface(_abi) as LidoBridgeInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): LidoBridge {
    return new Contract(address, _abi, signerOrProvider) as LidoBridge;
  }
}
