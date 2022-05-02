require("@nomiclabs/hardhat-waffle");
require('solidity-coverage')
require('dotenv').config();

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: API_URL,
      accounts: [PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }

};


