
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    string[] public redeemableItems;

    constructor(address initialOwner) ERC20("Aryan Vishwakarma", "AK") Ownable() {
        redeemableItems.push("Item 1");
        redeemableItems.push("Item 2");
        redeemableItems.push("Item 3");
        redeemableItems.push("Item 4");
    }

    function mint(address to, uint256 value) public onlyOwner {
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid value");

        _mint(to, value);
        emit Mint(to, value);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid value");

        return super.transfer(to, value);
    }

    function redeem(uint256 itemId, uint256 cost) public {
        require(itemId < redeemableItems.length, "Item does not exist");
        require(balanceOf(msg.sender) >= cost, "Insufficient balance");

        _burn(msg.sender, cost);
        emit Redeem(msg.sender, itemId, redeemableItems[itemId], cost);
    }

    function burn(uint256 value) public {
        require(value > 0, "Invalid value");
        require(value <= balanceOf(msg.sender), "Insufficient balance");

        _burn(msg.sender, value);
        emit Burn(msg.sender, value);
    }

    function addRedeemableItem(string memory itemName) public onlyOwner {
        redeemableItems.push(itemName);
        emit ItemAdded(redeemableItems.length - 1, itemName);
    }

    function removeRedeemableItem(uint256 itemId) public onlyOwner {
        require(itemId < redeemableItems.length, "Item does not exist");
        
        redeemableItems[itemId] = redeemableItems[redeemableItems.length - 1];
        redeemableItems.pop();
        
        emit ItemRemoved(itemId);
    }

    event Mint(address indexed to, uint256 value);
    event Redeem(address indexed from, uint256 indexed itemId, string itemName, uint256 cost);
    event Burn(address indexed from, uint256 value);
    event ItemAdded(uint256 indexed itemId, string itemName);
    event ItemRemoved(uint256 indexed itemId);
}
