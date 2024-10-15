// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0

contract Bank {
    address owner; // Contract owner's address
    mapping(address => uint256) balances; // User balances
    mapping(address => uint256) count; // Number of deposits made by each user
    uint256 feesCollected; // Total fees collected by the bank
    uint256 constant txfee = 1 ether; // Transaction fee amount

    constructor() {
        owner = msg.sender; // Set the contract owner as the deployer
    }

    event Withdraw(address indexed addr, uint256 balance);
    event Deposit(address indexed addr, uint256 count, uint256 amount);
    event FeeCollect(address indexed addr, uint256 balance);

    receive() external payable {
        // Receive Ether and process deposits
        require(msg.value >= 1 ether, "Please deposit at least 1 ether!");
        require(msg.sender != owner, "Restricted function!");
        uint256 depositfee;
        uint256 depositValue;
        depositfee = txfee;
        if (count[msg.sender] == 0) {
            balances[msg.sender] += msg.value;
            count[msg.sender]++;
        } else {
            require(msg.value > depositfee, "Insufficient fee detected!");
            depositValue = msg.value - depositfee;
            balances[msg.sender] += depositValue;
            feesCollected += depositfee;
            count[msg.sender]++;
        }
        emit Deposit(msg.sender, count[msg.sender], msg.value);
    }

    function withdraw(uint256 amount) external {
        // Withdraw funds from the account
        require(msg.sender != owner, "Not allowed restricted operation!");
        require(
            balances[msg.sender] >= amount,
            "Not sufficient funds in account!"
        );
        uint256 balanceLeft = balances[msg.sender] - amount;
        balances[msg.sender] = balanceLeft;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Withdrawal failed");
        emit Withdraw(msg.sender, amount);
    }

    function checkBalance(address addr) external view returns (uint256) {
        // Check balance of an address
        require(msg.sender == addr, "Restricted!");
        return balances[addr];
    }

    function collectFees() external {
        // Collect accumulated fees by the owner
        uint256 amount = feesCollected;
        require(msg.sender == owner, "Restricted!");
        feesCollected = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Fee collection failed");
        emit FeeCollect(msg.sender, amount);
    }
}
