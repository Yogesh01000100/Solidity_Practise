// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.17;

contract sol {

    mapping (address=>uint) balances;

    function deposit() external payable {
        balances[msg.sender]+=msg.value;
    }
    
    function withdraw(uint amount) external {
        uint balance=balances[msg.sender];
        require(balance>=amount,"Not sufficient balance");
        balances[msg.sender]=balances[msg.sender]-amount;
        (bool sent, )=payable(msg.sender).call{value:amount}("");
        require(sent);
    }
}         