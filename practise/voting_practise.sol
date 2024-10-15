// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Voting {

    struct User {
        string name;
        uint age;
    }

    uint public votingStart;
    address public owner;
    address[] public candidates;
    mapping(address => User) public voters;

    constructor() {
        votingStart = block.timestamp;
        owner = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == owner, "Only owner can call!");
        _;
    }

    modifier verifiedCandidate(address candidateAddress) {
        require(verifyCandidate(candidateAddress), "Unverified candidate!");
        _;
    }

    modifier verifiedUser() {
        require(verifyUser(msg.sender), "Failed to verify!");
        _;
    }

    function verifyCandidate(address addr) internal view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function verifyUser(address userAddress) internal view returns (bool) {
        uint age = voters[userAddress].age;
        return age >= 18;
    }

    function register(string memory _name, uint _age) external payable returns (bool) {
        require(msg.value== 1 ether,"Deposit 1 eth!");
        require(_age >= 18, "Only users aged 18 or older can register.");
        voters[msg.sender] = User(_name, _age);
        return true;
    }

    function registerCandidate(address candidateAddress) public onlyAdmin {
        require(candidateAddress != address(0), "Invalid candidate address");
        candidates.push(candidateAddress);
    }

    function vote(address candidateAddress) public verifiedCandidate(candidateAddress) verifiedUser() payable {
        // Implement voting logic here
    }

    function getVotes() public view returns (uint) {
        // Implement logic to get the number of votes for each candidate
        return 0;
    }
}
