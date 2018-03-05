pragma solidity ^0.4.19;

contract ThreeWaySplitter {
    // given a small number of users, arrays seem like a reasonable solution
    // mapping has the issue of checking the balance, but also whether or not they are a valid user
    // mapping(address => User) seems like a good approach for more scaling
    address[3] public users;
    uint[3] public userBalances;
    
    // requirement - there are 3 people: Alice, Bob and Carol
    function ThreeWaySplitter(address[3] _users) public {
        users = _users;
    }
    
    // requirement - whenever Alice sends ether to the contract, half of it goes to Bob and the other half to Carol
    function() public payable {
        bool validUser;
        uint8 idx;
        (validUser, idx) = validateUserAndGetIndex(msg.sender);
        require(validUser);
        split(msg.sender, msg.value);
    }
    
    // requirement - Alice can use the Web page to split her ether
    function splitFromBalance(uint amount) public {
        bool validUser;
        uint8 idx;
        (validUser, idx) = validateUserAndGetIndex(msg.sender);
        require(validUser);
        uint userBalance = userBalances[idx];
        require(userBalance >= amount);
        setUserBalance(msg.sender, userBalance - amount);
        split(msg.sender, amount);
    }
    
    function split(address from, uint amount) private {
        uint8[2] memory otherUsers;
        otherUsers = getOtherUserIndexes(from);
        uint newValue;
        if(isOdd(amount))
            newValue = (amount -1) / 2; // I'll be taking that...
        else
            newValue = amount / 2;
        for(uint8 i = 0; i <= 1; i++) {
            uint oldValue = userBalances[otherUsers[i]];
            userBalances[otherUsers[i]] = oldValue + newValue;
        }
    }
    
    // Nice to have state readers
    function getUsers() public view returns(address[3]) {
        return users;
    }
    
    function getUserBalances() public view returns(uint[3]) {
        return userBalances;
    }
    
    // requirement - we can see the balance of the Splitter contract on the Web page
    function getBalance() public view returns(uint) {
        return this.balance;
    }
    
    // requirement - we can see the balances of Alice, Bob and Carol on the Web page
    function getUserBalance(address user) public view returns(uint) {
        bool validUser;
        uint8 idx;
        (validUser, idx) = validateUserAndGetIndex(user);
        require(validUser);
        return userBalances[idx];
    }
    
    function setUserBalance(address user, uint newValue) private {
        bool validUser;
        uint8 idx;
        (validUser, idx) = validateUserAndGetIndex(user);
        userBalances[idx] = newValue;
    }
    
    // Other helper nonsense
    function validateUserAndGetIndex(address user) private view returns(bool, uint8) {
        for(uint8 i = 0; i <= 2; i++) {
            if(users[i] == user) {
                return (true, i);
            }
        }
        return (false, 0);
    }
    
    function getOtherUserIndexes(address user) private view returns(uint8[2]) {
        uint8 userCount = 0;
        uint8[2] memory otherUsers;
        for(uint8 i = 0; i <= 2; i++) {
            if(users[i] != user) {
                otherUsers[userCount] = i;
                userCount++;
            }
        }
        return otherUsers;
    }
    
    function isOdd(uint amount) private pure returns(bool) {
        return amount % 2 == 1;
    }
}