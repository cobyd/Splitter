describe("Splitter", () => {
  const Splitter = artifacts.require("./Splitter.sol");
  beforeEach(() => {
    web3.eth.getAccounts((err, _accounts) => {
      return Splitter.new({ from: accounts[0], gas: 3000000 }).then(
        _splitter => {
          const splitter = _splitter;
        }
      );
    });
  });
  contract("Splitter", () => {
    it("should split ether", () => {
      web3.eth.getAccounts((err, _accounts) => {
        const account_0 = _accounts[0];
        const account_1 = _accounts[1];
        const account_2 = _accounts[2];
        const account_3 = _accounts[3];
        return Splitter.new({ from: account_0 }).then(_splitter => {
          const splitter = _splitter;
          splitter
            .split([account_2, account_3], {
              from: account_1,
              value: web3.toWei(2, "ether"),
              gas: 300000
            })
            .then(() => {
              // splitter.balances(account_1).then(function(_balance) {
              //   conslole.log("here!");
              //   assertEqual(_balance, web3.toWei(1, "ether"));
              // });
            });
        });
      });
    });
  });
});

// it("should call a function that depends on a linked library", function() {
//   var meta;
//   var metaCoinBalance;
//   var metaCoinEthBalance;

//   return MetaCoin.deployed()
//     .then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(accounts[0]);
//     })
//     .then(function(outCoinBalance) {
//       metaCoinBalance = outCoinBalance.toNumber();
//       return meta.getBalanceInEth.call(accounts[0]);
//     })
//     .then(function(outCoinBalanceEth) {
//       metaCoinEthBalance = outCoinBalanceEth.toNumber();
//     })
//     .then(function() {
//       assert.equal(
//         metaCoinEthBalance,
//         2 * metaCoinBalance,
//         "Library function returned unexpected function, linkage may be broken"
//       );
//     });
// });
// it("should send coin correctly", function() {
//   var meta;

//   // Get initial balances of first and second account.
//   var account_one = accounts[0];
//   var account_two = accounts[1];

//   var account_one_starting_balance;
//   var account_two_starting_balance;
//   var account_one_ending_balance;
//   var account_two_ending_balance;

//   var amount = 10;

//   return MetaCoin.deployed()
//     .then(function(instance) {
//       meta = instance;
//       return meta.getBalance.call(account_one);
//     })
//     .then(function(balance) {
//       account_one_starting_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     })
//     .then(function(balance) {
//       account_two_starting_balance = balance.toNumber();
//       return meta.sendCoin(account_two, amount, { from: account_one });
//     })
//     .then(function() {
//       return meta.getBalance.call(account_one);
//     })
//     .then(function(balance) {
//       account_one_ending_balance = balance.toNumber();
//       return meta.getBalance.call(account_two);
//     })
//     .then(function(balance) {
//       account_two_ending_balance = balance.toNumber();

//       assert.equal(
//         account_one_ending_balance,
//         account_one_starting_balance - amount,
//         "Amount wasn't correctly taken from the sender"
//       );
//       assert.equal(
//         account_two_ending_balance,
//         account_two_starting_balance + amount,
//         "Amount wasn't correctly sent to the receiver"
//       );
//     });
// });
