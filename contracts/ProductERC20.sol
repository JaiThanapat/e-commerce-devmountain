// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
contract ProductERC20 is ERC20, Ownable {

    event Transfer(address indexed sender, address indexed recipient, uint256 amount, uint256 indexed timestamp);
    constructor(address owner,string memory name, string memory symbol, uint256 amount) ERC20(name, symbol) {
        _mint(msg.sender,amount);
        _transferOwnership(owner);
       
    }

    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }

    function burnFrom(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, to, amount);
        emit Transfer(msg.sender, to, amount, block.timestamp);
        return true;
    }
}