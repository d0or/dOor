const path = require("path");
require('dotenv').config();
const MNEMONIC = process.env.MNENOMIC;
const INFURA_ID = process.env.INFURA_API_KEY;

const HDWalletProvider = require("truffle-hdwallet-provider");
// Create your own key for Production environments (https://infura.io/)


module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, 'https://ropsten.infura.io/v3/' + INFURA_ID)
      },
      network_id: '3',
      gas: 4465030,
      gasPrice: 10000000000,
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, 'https://kovan.infura.io/v3/' + INFURA_ID)
      },
      network_id: '42',
      gas: 4465030,
      gasPrice: 10000000000,
    },
    rinkeby: {
      provider: () => new HDWalletProvider(MNEMONIC, "https://rinkeby.infura.io/v3/" + INFURA_ID),
      network_id: 4,
      gas: 3000000,
      gasPrice: 10000000000
    },
    goerli: {
      provider: () => new HDWalletProvider(MNEMONIC, "https://goerli.infura.io/v3/" + INFURA_ID),
      network_id: 5,
      gas: 3000000,
      gasPrice: 10000000000
    },
    // main ethereum network(mainnet)
    main: {
      provider: () => new HDWalletProvider(MNEMONIC, "https://mainnet.infura.io/v3/" + INFURA_ID),
      network_id: 1,
      gas: 3000000,
      gasPrice: 10000000000
    }
  }
};
