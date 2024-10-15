// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract AdvancedCounter{

    address owner;
    mapping(address=>bool) status;
    mapping(address=>string[]) counter;

    constructor(){
        owner=msg.sender;    
    }

    function createCoutner(string memory id) public
    {
        require(status[msg.sender]!=false,"This id doesn't have any counter!");
        require(counter[msg.sender].length<3,"Only 3 counter allowed!");
        counter[msg.sender].push(id);
        status[msg.sender]=true;
    }

    function getCounter(address addr) public view returns(string[] memory)
    {
        require(msg.sender==addr,"Not allowed!");
        return counter[addr];
    }

}