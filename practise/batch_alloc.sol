// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Name {
    address[] holders;
    uint256[] balances;
    uint256 txRequired;

    uint256 processIndex;
    uint256 processStartIndex;

    uint256 currentHighestAmount;
    address currentHighestHolder;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function store(address[] memory _holders, uint256[] memory _balances)
        public
    {
        holders = _holders;
        balances = _balances;
        // make batches of 5 only for the transactions
        txRequired = holders.length / 5;

        if (txRequired * 5 < holders.length) {
            txRequired++;
        }

        processIndex = 5;

        if (processIndex > balances.length) {
            processIndex = balances.length;
        }
    }

    function process() public {
        require(txRequired > 0, "Already processed data");

        for (uint256 i = processStartIndex; i < processIndex; i++) {
            address currentHolder = holders[i];

            if (balances[i] > currentHighestAmount) {
                currentHighestAmount = balances[i];
                currentHighestHolder = currentHolder;
            }
        }

        processStartIndex = processIndex;
        processIndex += 5;

        if (processIndex > balances.length) {
            processIndex = balances.length;
        }
        txRequired--;
    }
}
