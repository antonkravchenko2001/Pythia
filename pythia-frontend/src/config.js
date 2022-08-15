export const serverUrl = 'https://jiissmcimlux.usemoralis.com:2053/server';
export const appId = '3APgJrIFnjueQ1M3pmhJiSCxS31uI7OpDfCL1jag';
export const marketsABI = [
	{
		"inputs": [
			{
				"internalType": "uint256[2]",
				"name": "_sharesOwned",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "_moneyWaged",
				"type": "uint256[2]"
			},
			{
				"internalType": "address",
				"name": "_priceFeedAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_strikePrice",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_resolutionDate",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_wageDeadline",
				"type": "uint256"
			}
		],
		"name": "createMarket",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes",
				"name": "performData",
				"type": "bytes"
			}
		],
		"name": "performUpkeep",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "payesTokenAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "priceFeederAddress",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			},
			{
				"internalType": "uint256[2]",
				"name": "_moneyToWage",
				"type": "uint256[2]"
			}
		],
		"name": "wageMoney",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			}
		],
		"name": "withdraw",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_playerAddress",
				"type": "address"
			}
		],
		"name": "_calcExpertScore",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_playerAddress",
				"type": "address"
			}
		],
		"name": "_calcReward",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes",
				"name": "checkData",
				"type": "bytes"
			}
		],
		"name": "checkUpkeep",
		"outputs": [
			{
				"internalType": "bool",
				"name": "upkeepNeeded",
				"type": "bool"
			},
			{
				"internalType": "bytes",
				"name": "performData",
				"type": "bytes"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			}
		],
		"name": "getMarketInfo",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getNumMarkets",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_player",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			}
		],
		"name": "getPlayerInfo",
		"outputs": [
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256[2]",
				"name": "",
				"type": "uint256[2]"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "numMarkets",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_marketId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_outcome",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_moneyToWage",
				"type": "uint256"
			}
		],
		"name": "numSharesForPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
export const marketsAddress = '0xDfEc2EC7E96f54fD41B229122c30874e49c23a5F';
export const ERC20ABI = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];
export const payTokenAddress = '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063';
export const chain = 'polygon';
export const chainId = "0x89";

export const minSharesCreate = 4;
export const minMoneyCreate = 4;

export const minMoney = 2;

export const incorrectChainMessage = 'Incorrect network: please switch to Polygon mainnet';
