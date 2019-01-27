const path = require("path");
const HDWallet = require('truffle-hdwallet-provider');
const infuraKey = "0a8a1b09e0b64fa0aa5f4c3f78a66763";

const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),

  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
        provider: () => new HDWallet(mnemonic, `https://rinkeby.infura.io/${infuraKey}`),
        network_id: 4,   // Rinkeby's id
        gas: 5500000,
      },
  }
};
