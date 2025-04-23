// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract MiniBank{
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        console.log("Total ETH in bank in deposit():", address(this).balance);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        console.log("Total ETH in bank before withdraw:", address(this).balance);
        payable(msg.sender).call{value: amount}("");
        balances[msg.sender] -= amount;
        console.log("Total ETH in bank after withdraw:", address(this).balance);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}