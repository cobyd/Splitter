pragma solidity ^0.4.18;

contract Splitter {
    mapping(address=>uint) public balances;
    address[] public activeUsers;
    address public owner;
    
    /*
    
    Splitter contract:
    
    ether in -> only payable function is splitFromTransaction.  When a 
                user calls this function, the value of the transaction
                will be split between their given target addresses
    
    ether out -> A user can call withdraw to cash out their balance
                 The owner can call killswitch to cash out all users (not yet implemented)
    
    other state changes -> splitFromBalance allows a user to split ether that is 
                           in their balance without sending any additional ether
    
    */
    
    // requirement - make the contract a utility that can be used by David, Emma and 
    // anybody with an address to split Ether between any 2 other addresses of their own choice
    function Splitter() public {
        owner = msg.sender;
    }
    
    // requirement - whenever Alice sends ether to the contract, half of it goes to Bob and the other half to Carol
    function splitFromTransaction(address[2] to) public payable {
        validateInput(to);
        addActiveUser(to[0]);
        addActiveUser(to[1]);
        uint valueToSplit = msg.value;
        uint half = valueToSplit / 2;
        balances[to[0]] += half;
        balances[to[1]] += half;
        balances[owner] += valueToSplit % 2;
    }
    
    function withdraw() public {
        uint toSend = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(toSend);
    }
    
    function validateInput(address[2] to) private view {
        require(msg.sender != to[0]);
        require(msg.sender != to[1]);
        require(to[0] != to[1]);
        require(to[0] != 0x00);
        require(to[1] != 0x00);
    }

    // track unique list of users in case of killswitch
    function addActiveUser(address newUser) public {
        if (balances[newUser] == 0) {
            activeUsers.push(newUser); 
        }
    }
    
    // requirement - we can see the balance of the Splitter contract on the Web page
    function getBalance() public view returns(uint) {
        return this.balance;
    }
    
    // requirement - we can see the balances of Alice, Bob and Carol on the Web page
    function getUserBalance(address user) public view returns(uint) {
        return balances[user];
    }

}
