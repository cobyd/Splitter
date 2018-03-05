pragma solidity ^0.4.19;

contract Splitter {
    mapping(address=>uint) users;
    address owner;
    
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
    
    // requirement - Alice can use the Web page to split her ether
    function splitFromBalance(uint valueToSplit, address[2] to) public {
        require(msg.sender != to[0]);
        require(msg.sender != to[1]);
        uint userBalance = users[msg.sender];
        require(userBalance >= valueToSplit);
        users[msg.sender] -= valueToSplit;
        split(to, valueToSplit);
    }
    
    // requirement - whenever Alice sends ether to the contract, half of it goes to Bob and the other half to Carol
    function splitFromTransaction(address[2] to) public payable {
        require(msg.sender != to[0]);
        require(msg.sender != to[1]);
        uint valueToSplit = msg.value;
        split(to, valueToSplit);
    }
    
    // private function that is used by splitFromBalance and splitFromTransaction
    function split(address[2] to, uint valueToSplit) private {
        require(to[0] != to[1]);
        uint half = valueToSplit / 2;
        users[to[0]] += half;
        users[to[1]] += half;
        // extra 1 wei in some cases will be credited to contract owner upon killswitch
    }
    
    function withdraw() public {
        msg.sender.transfer(users[msg.sender]);
        users[msg.sender] = 0;
    }
    
    // requirement - we can see the balance of the Splitter contract on the Web page
    function getBalance() public view returns(uint) {
        return this.balance;
    }
    
    // requirement - we can see the balances of Alice, Bob and Carol on the Web page
    function getUserBalance(address user) public view returns(uint) {
        return users[user];
    }
}
