module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      gas: 4000000,
      network_id: "*"
    },
    net42: {
      host: "localhost",
      port: 8545,
      network_id: 42,
      gas: 4000000
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
