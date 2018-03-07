pragma solidity ^0.4.19;

import "./Owned.sol";

contract Stoppable is Owned {
    bool active;

    function Stoppable() public {}

    function pause() public ownerOnly isActive {
        active = false;
    }

    function resume() public ownerOnly isPaused {
        active = true;
    }

    modifier isActive {
        require(active);
        _;
    }

    modifier isPaused {
        require(!active);
        _;
    }
}