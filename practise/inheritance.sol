// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Parent {
    string public parentMessage;

    function setMessage(string memory _message) public {
        parentMessage = _message;
    }

    function getMessage() public view returns (string memory) {
        return parentMessage;
    }
}

contract Child is Parent {
    string public childMessage;
    string public craft;

    function setChildMessage(string memory _childMessage) public {
        childMessage = _childMessage;
    }

    function setMesage(string memory message) public {
        craft=message;
    }   
}
