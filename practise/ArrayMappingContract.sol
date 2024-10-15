// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayMappingContract {
    mapping(address => uint16) store;
    uint[] public balance;

    constructor(uint _length) {
        for(uint i=0; i<_length;i++){
            balance[i]=i+1;
        }
    }

    function getBalances() public view returns(uint[] memory){
        return balance;
    }

    function getValue(uint _i) public view returns(uint){
        return balance[_i];
    }
}
