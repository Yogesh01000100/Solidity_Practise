// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.17;

contract New {
    address richest;
    uint mostSent;

    mapping(address=>uint) pending;

    function pay() external payable returns(bool)
    {
        if(msg.value<=mostSent)
        {
            return false;
        }
        pending[richest]=pending[richest]+mostSent;
        richest=msg.sender;
        mostSent=msg.value;
        return true;
    }

    function withdraw() external {
        uint amount=pending[msg.sender];
        pending[msg.sender]=0;
        (bool sent, )=payable(msg.sender).call{value: amount}("");
        require(sent);
    }
    function getRichest() public view returns(address)
    {
        return richest;
    }
}