// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract StorageContract{
    uint16 _number;
    string _name;
    bool _value;
    address _address;


    function setNum(uint16 num) public {
        _number=num;
    }

    function getNum() public view returns(uint16){
        return _number;
    }

    function setName(string memory name) public{
        _name=name;
    }

    function getName() public view returns(string memory){
        return _name;
    }
    
}