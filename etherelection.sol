// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.19;

contract election {
    address owner;
    mapping(address => uint256) candidateData;
    uint256 constant txfee = 10000 wei;
    address winner;
    uint256 feeCollect;

    constructor() {
        owner = msg.sender;
    }

    function enroll(address addr) external payable returns (bool) {
        require(msg.value == 1 ether, "1 ether needs to be deposited!");
        require(candidateData[addr] < 5, "Winner Already declared!");
        candidateData[addr] = 0;
        return true;
    }

    function vote(address addr) public payable {
        require(msg.value == 10000 wei, "Insufficient fee!");
        require(msg.sender != owner, "Not allowed!");
        candidateData[addr] += 1;
        feeCollect += txfee;
        if (candidateData[addr] > 4) {
            winner = addr;
        }
    }

    function getWinner() public view returns (address) {
        return winner;
    }

    function claimReward() public {
        require(msg.sender == winner, "not allowed!");
        (bool sent, ) = payable(msg.sender).call{value: 3 ether}("");
        require(sent);
    }

    function collectFee() external {
        require(msg.sender == owner, "Not allowed!");
        uint256 amount = feeCollect;
        feeCollect = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent);
    }
}
