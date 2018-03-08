describe("Splitter", () => {
  const Splitter = artifacts.require("./Splitter.sol");
  let account_0;
  let account_1;
  let account_2;
  let account_3;
  // let splitter;
  beforeEach(() => {
    new Promise((resolve, reject) => {
      web3.eth.getAccounts((err, _accounts) => {
        console.log("accounts");
        if (err) reject(err);
        else resolve(_accounts);
      });
    })
      .then(_accounts => {
        console.log("setting accounts");
        account_0 = _accounts[0];
        account_1 = _accounts[1];
        account_2 = _accounts[2];
        account_3 = _accounts[3];
      })
      .then(() => {
        console.log("new splitter");
        console.log(account_0);
        Splitter.new({ from: account_0 });
      })
      .then(_splitter => {
        console.log("setting splitter");
        console.log(_splitter);
        // splitter = _splitter;
      });
  });
  contract("Splitter", () => {
    it("should split ether", () => {
      return Splitter.new({ from: account_0 }).then(_splitter => {
        const splitter = _splitter;
        splitter
          .split(account_2, account_3, {
            from: account_1,
            value: web3.toWei(2, "finney"),
            gas: 300000
          })
          .then(() => {
            splitter.balances(account_2).then(function(_balance) {
              console.log(
                _balance.toString(),
                " should be ",
                web3.toWei(1, "finney")
              );
              assert.equal(_balance.toNumber(), web3.toWei(1, "finney"));
            });
          });
      });
    });
    it("should withdraw ether", () => {
      console.log(account_2);
      return web3.eth.getBalance(account_2, _balance => {
        console.log(_balance);
      });
    });
  });
});
