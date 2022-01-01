require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: '', // TODO: set here your Alchemy API url - https://www.alchemy.com/
      accounts: [''], // TODO: set here your private key from your Etherum (Rinkeby) wallet
    },
  },
  etherscan: {
    apiKey: "", // TODO: set here your etherscan API key to upload your source code to etherscan - https://etherscan.io/
  },
};