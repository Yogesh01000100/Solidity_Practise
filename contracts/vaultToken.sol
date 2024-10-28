// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VaultToken is ERC20 {
    address public immutable i_owner;

    constructor() ERC20("VToken", "VTK") {
        i_owner = msg.sender;
    }

    function mintTokens(address _vaultAddress) external {
        require(msg.sender == i_owner, "Unathorised!");
        _mint(_vaultAddress, 20);
    }

    function approveTokens(address _vaultAddress) external {
        _approve(msg.sender, _vaultAddress, 20);
    }
    
    function burnTokens(address _vaultAddress, uint256 _value) external {
        _burn(_vaultAddress, _value);
    }
}
