const marketsABI = [
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
const marketsAddress = '0x0650f7C019D26D913C42472aE52D2Cf414C7BeC4';
const chain = 'mumbai';