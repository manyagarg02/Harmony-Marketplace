require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const privateKeyTest = '0x412bd2e0212118fa73e4bdf9bdb2a49cf903adb30f5111ca8e3b9d04869841e2';

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    testnet: {
      provider: () => {
        // use private key
        return new HDWalletProvider({
          //mnemonic,
          providerOrUrl: 'https://api.s0.b.hmny.io', // https://api.s0.t.hmny.io for mainnet
          privateKeys: [privateKeyTest],

          //derivationPath: `m/44'/1023'/0'/0/`
        });
      },
      network_id: 1666700000, // 1666600000 for mainnet
      gas: 20000000,   // <--- Twice as much
      gasPrice: 10000000000,
    },
  },
  contracts_directory: './contracts/',
  contracts_build_directory: './abis/',
  compilers: {
    solc: {
      version: "0.7.3",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
