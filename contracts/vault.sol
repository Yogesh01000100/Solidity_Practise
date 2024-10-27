// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {VaultToken} from "./vaultToken.sol";

contract vault {
    address public immutable i_owner;
    struct Member {
        string role;
        uint256 vaultToken;
        uint256 ethContributions;
        bool isRegistered;
    }
    VaultToken token;
    bool isMinted;
    uint256 public constant tokenVaultPrice = 2 ether;
    mapping(address => Member) public memberInfo;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Unauthorised!");
        _;
    }

    modifier onlyUser() {
        require(msg.sender != i_owner, "Unauthorised!");
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

    function buyTokens() external payable onlyUser{
        require(msg.value >= 1 ether, "need to contribute atleast 1 ether!");
        require(msg.sender != i_owner, "Not allowed!");
        uint256 _vaultToken = msg.value / tokenVaultPrice;

        require(
            _vaultToken <= token.balanceOf(address(this)),
            "No VaultTokens left"
        );

        if (!memberInfo[msg.sender].isRegistered) {
            Member memory newUser = Member({
                role: "member",
                vaultToken: _vaultToken,
                ethContributions: msg.value,
                isRegistered: true
            });
            memberInfo[msg.sender] = newUser;
        } else {
            memberInfo[msg.sender].ethContributions += msg.value;
            memberInfo[msg.sender].vaultToken += _vaultToken;
        }
        token.transfer(msg.sender, _vaultToken);
    }

    function myStake() public view onlyUser returns (uint256) {
        return memberInfo[msg.sender].vaultToken;
    }

    function withDraw() external onlyUser{
        require(msg.sender != i_owner, "Not allowed!");
        uint256 share = memberInfo[msg.sender].vaultToken;
        memberInfo[msg.sender].vaultToken = 0;
        memberInfo[msg.sender].ethContributions = 0;
        payable(msg.sender).transfer(share * tokenVaultPrice);
    }
}
