// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <=0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("Emergency Access Token", "EAT") {
        _mint(msg.sender, initialSupply);
        // checking git commit -s
    }
}