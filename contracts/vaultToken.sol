// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VaultToken is ERC20 {
    address public immutable i_owner;

    constructor(address _vaultAddress) ERC20("VToken", "VTK") {
        i_owner=msg.sender;
        _mint(_vaultAddress, 20);
    }
}
