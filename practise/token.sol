// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;
    uint256 public tokenPrice = 1e16;

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        owner = msg.sender;
        _mint(owner, initialSupply);
    }
    modifier onlyOwner{
        require(msg.sender==owner, "Only owner can access this!");
        _;
    }

    function purchaseTokens() external payable {
        require(msg.value > 0, "send ETH to buy tokens");
        uint256 amountToBuy = msg.value / tokenPrice;

        require(
            balanceOf(owner) >= amountToBuy,
            "Not enough tokens in reserve!"
        );
        _transfer(owner, msg.sender, amountToBuy);
    }

    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function withdraw() external onlyOwner {
        require(address(this).balance>3 ether, "You can't withdraw now!");
        uint256 amount = address(this).balance;
        payable(owner).transfer(amount);
    }
}
