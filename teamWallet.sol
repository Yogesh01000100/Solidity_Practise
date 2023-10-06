// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TeamWallet {
    address deployer;
    address[] members;
    uint256 public totalCredits;
    bool walletInitialized;

    enum TransactionState {
        Pending,
        Approved,
        Rejected
    }

    struct Transaction {
        address sender;
        uint256 amount;
        TransactionState state;
        uint256 approvals;
        uint256 rejections;
    }
    Transaction[] transactions;
    mapping(address => mapping(uint256 => bool)) public ApprovalStatus;

    constructor() {
        deployer = msg.sender;
    }

    function isTeamMember(address member) internal view returns (bool) {
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i] == member) {
                return true;
            }
        }
        return false;
    }

    modifier onlyDeployer() {
        require(
            msg.sender == deployer,
            "Only the deployer can call this function"
        );
        _;
    }

    modifier walletNotInitialized() {
        require(!walletInitialized, "Wallet is already initialized");
        _;
    }

    modifier onlyTeamMember() {
        require(isTeamMember(msg.sender), "Access denied! Only Team members");
        _;
    }

    modifier transactionExists(uint256 n) {
        require(n < transactions.length, "Transaction does not exist!");
        _;
    }

    modifier transactionPending(uint256 n) {
        require(
            n <= transactions.length &&
                transactions[n].state == TransactionState.Pending,
            "Transaction already done!"
        );
        _;
    }

    modifier notApprovalStatus(uint256 n) {
        require(
            n <= transactions.length && !ApprovalStatus[msg.sender][n],
            "Already performed this action!"
        );
        _;
    }

    modifier notSpender(uint256 n) {
        require(
            msg.sender != transactions[n].sender,
            "Spender cannot approve their own transaction"
        );
        _;
    }

    function initializeWallet(address[] memory _members, uint256 _credits)
        internal
    {
        require(_members.length >= 1, "At least one member is required");
        require(_credits > 0, "Credits must be greater than 0");

        // The deployer is not in the list of members
        for (uint256 i = 0; i < _members.length; i++) {
            require(
                _members[i] != deployer,
                "Deployer cannot be a member of the team"
            );
        }

        members = _members;
        totalCredits = _credits;
        walletInitialized = true;
    }

    function setWallet(address[] memory _members, uint256 _credits)
        public
        onlyDeployer
        walletNotInitialized
    {
        initializeWallet(_members, _credits);
    }

    function spend(uint256 amount) public onlyTeamMember {
            require(amount > 0, "Low amount!");

        if (members.length == 1) {
            if (amount > totalCredits) {
                transactions.push(
                    Transaction({
                        sender: msg.sender,
                        amount: amount,
                        state: TransactionState.Rejected,
                        approvals: 0,
                        rejections: 0
                    })
                );
            } else {
                transactions.push(
                    Transaction({
                        sender: msg.sender,
                        amount: amount,
                        state: TransactionState.Approved,
                        approvals: 1,
                        rejections: 0
                    })
                );
                totalCredits -= amount; 
            }
        } else {
            if (amount > totalCredits) {
                transactions.push(
                    Transaction({
                        sender: msg.sender,
                        amount: amount,
                        state: TransactionState.Rejected,
                        approvals: 0,
                        rejections: 0
                    })
                );
            } else {
                transactions.push(
                    Transaction({
                        sender: msg.sender,
                        amount: amount,
                        state: TransactionState.Pending,
                        approvals: 0,
                        rejections: 0
                    })
                );
            }
        }
    }

    function approve(uint256 n)
        public
        onlyTeamMember
        notSpender(n - 1) 
        transactionExists(n - 1)
        transactionPending(n - 1) 
        notApprovalStatus(n - 1)
    {
        uint256 index = n - 1;
        if (transactions[index].amount > totalCredits) {
            transactions[index].state = TransactionState.Rejected;
            revert("Insufficient credits!");
        }
        transactions[index].approvals++;
        ApprovalStatus[msg.sender][index] = true;

        if (
            transactions[index].approvals * 100 >= ((members.length - 1) * 70)
        ) {
            transactions[index].state = TransactionState.Approved;
            totalCredits -= transactions[index].amount;
        }
    }

    function reject(uint256 n)
        public
        onlyTeamMember
        notSpender(n - 1)
        transactionExists(n - 1)
        transactionPending(n - 1) 
        notApprovalStatus(n - 1) 
    {
        uint256 index = n - 1; 
        transactions[index].rejections++;
        ApprovalStatus[msg.sender][index] = true;

        if (
            transactions[index].rejections * 100 > ((members.length - 1) * 30)
        ) {
            transactions[index].state = TransactionState.Rejected;
        }
    }

    function credits() public view onlyTeamMember returns (uint256) {
        return totalCredits;
    }

    function viewTransaction(uint256 n)
        public
        view
        onlyTeamMember
        transactionExists(n - 1)
        returns (uint256, string memory)
    {
        uint256 index = n - 1;
        uint256 amount = transactions[index].amount;
        string memory status;

        if (transactions[index].state == TransactionState.Pending) {
            status = "pending";
        } else if (transactions[index].state == TransactionState.Approved) {
            status = "debited";
        } else if (transactions[index].state == TransactionState.Rejected) {
            status = "failed";
        } else {
            status = "unknown";
        }

        return (amount, status);
    }
    function transactionStats()
    public
    view
    onlyTeamMember
    returns (uint256 debitedCount, uint256 pendingCount, uint256 failedCount)
    {
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].state == TransactionState.Approved) {
                debitedCount++;
            } else if (transactions[i].state == TransactionState.Pending) {
                pendingCount++;
            } else if (transactions[i].state == TransactionState.Rejected) {
                failedCount++;
            }
        }
        return (debitedCount, pendingCount, failedCount);
    }

}