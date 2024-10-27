// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {VaultToken} from "./vaultToken.sol";

contract vault {
    address public immutable i_owner;
    struct Member {
        string role;
        string status;
        uint256 vaultToken;
        uint256 ethContributions;
    }
    VaultToken token;
    bool isMinted;
    mapping(address => Member) memberInfo;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Unauthorised!");
        _;
    }

    function mintTokens() public onlyOwner {
        require(!isMinted, "already minted tokens");
        token = new VaultToken(address(this));
        isMinted = true;
    }

    function getTokenBalance() external view onlyOwner returns (uint256) {
        require(isMinted, "not minted tokens");
        return token.balanceOf(address(this));
    }
}
