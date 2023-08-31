// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.19;

contract puzzle {
    address owner;

    uint256[] _nums;
    uint256 _target;
    uint256 _prize;

    mapping(address => uint256) userChances;
    mapping(address => uint256) userBalances;

    constructor() {
        owner = msg.sender;
    }

    function verifySolution(uint256[] memory _solvedArray)
        internal
        view
        returns (bool)
    {
        bool userData = true;
        uint256 sum;
        for (uint256 i; i < _nums.length; i++) {
            if (userData) {
                uint256 givenElement = _nums[i];
                for (uint256 j; j < _solvedArray.length; j++) {
                    if (givenElement == _solvedArray[j]) {
                        break;
                    } else {
                        userData = false;
                    }
                }
            } else {
                break;
            }
        }

        for (uint256 m; m < _solvedArray.length; m++) {
            sum += _solvedArray[m];
        }
        if (sum != _target || userData == false) {
            return false;
        } else {
            return true;
        }
    }

    function createPuzzle(uint256[] memory nums, uint256 target)
        external
        payable
    {
        require(msg.sender == owner, "Only owner can create the puzzle!");
        _nums = nums;
        _target = target;
        _prize = msg.value;
    }

    function submitPuzzle(uint256[] memory _solvedArray, address addr) public {
        require(userChances[addr] < 1, "Already submitted challenge!");
        require(_solvedArray.length != 0, "Wrong input detected!");
        require(_prize != 0, "Challenge not created yet!");
        require(msg.sender != owner, "Restricted!");
        bool status = verifySolution(_solvedArray);
        if (status) {
            uint256 amountWon = _prize;
            _prize = 0;
            userBalances[addr] = amountWon;
            delete _nums;
            delete _target;
        }
        userChances[addr] += 1;
    }

    function claimReward() public {
        require(_prize != 0, "Puzzle already solved!");
        require(userChances[msg.sender] != 0, "Not yet submitted!");
        uint256 _amountToUser = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        userChances[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: _amountToUser}("");
        require(sent);
    }
}
