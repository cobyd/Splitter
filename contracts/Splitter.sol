pragma solidity ^0.4.18;

import "./Stoppable.sol";

contract Splitter is Stoppable {
    mapping(address=>uint) public balances;
    
    /*
    
    Splitter contract:
    
    ether in -> only payable function is split.  When a user calls this function, 
                the value of the transaction will be split between their given target addresses
    
    ether out -> A user can call withdraw to cash out their balance
    
    other state changes -> Splitter is Stoppable is Owned
                           Owned contracts have an owner set on initialization as msg.sender
                           Stoppable contracts have an 'active' flag that can be toggled with pause() and resume()
                           Both stoppable functions are only callable by the contract owner
                           When the contract is paused, the owner can call forceRefund() to send any user their balance
    
    */

    function Splitter() public {
        active = true;
    }

    event LogSplit(address indexed from, address indexed toOne, address indexed toTwo, uint value);
    event LogWithdrawl(address indexed to, uint value, bool forced);
    
    function split(address toOne, address toTwo) public payable isActive {
        require(msg.sender != toOne);
        require(msg.sender != toTwo);
        require(toOne != toTwo);
        LogSplit(msg.sender, toOne, toTwo, msg.value);
        uint valueToSplit = msg.value;
        uint half = valueToSplit / 2;
        balances[toOne] += half;
        balances[toTwo] += half;
        balances[owner] += valueToSplit % 2;
    }
    
    function withdraw() public isActive {
        uint toSend = balances[msg.sender];
        require(toSend > 0);
        LogWithdrawl(msg.sender,toSend,false);
        balances[msg.sender] = 0;
        msg.sender.transfer(toSend);
    }
    
    function validateInput(address[] to) private view {
        require(msg.sender != to[0]);
        require(msg.sender != to[1]);
        require(to[0] != to[1]);
        require(to[0] != 0x00);
        require(to[1] != 0x00);
    }

    function forceRefund(address to) public isPaused {
        uint toSend = balances[to];
        require(toSend > 0);
        LogWithdrawl(to,toSend,true);
        balances[msg.sender] = 0;
        msg.sender.transfer(toSend);
    }
}
