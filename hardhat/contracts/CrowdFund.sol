// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfund {
    struct Creator {
        string name;
        address wallet;
    }

    mapping(address => Creator) public creators;

    function register(string memory _name) public {
        creators[msg.sender] = Creator(_name, msg.sender);
    }
}
