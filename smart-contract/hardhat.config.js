require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: {
    version : "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 3333,
      },
    },
  },
  networks:{
    goerli:{
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [process.env.GOERLI_PRIVATE_KEY],
    },
    rinkeby:{
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [process.env.RINKEBY_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey:{
      rinkeby: process.env.ETHERSCAN_API_KEY,
    } 
  },
};
