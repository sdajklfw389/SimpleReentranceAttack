const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ReentranceAttack", function () {
    it("Should drain the MiniBank", async function () {
        const [owner, user] = await ethers.getSigners();

        const MiniBank = await ethers.getContractFactory("MiniBank");
        const bank = await MiniBank.deploy();
        await bank.waitForDeployment();
        const bankAddress = await bank.getAddress();

        await bank.connect(user).deposit({value: ethers.parseEther("5")});

        const Attack = await ethers.getContractFactory("ReentranceAttack");
        const attacker = await Attack.deploy(bankAddress);
        await attacker.waitForDeployment();

        // Initiate the attack
        await attacker.attack({value: ethers.parseEther("2")});

        // Make sure attacker has drained the bank
        const attackerAddress = await attacker.getAddress();
        const attackerBalance = await ethers.provider.getBalance(attackerAddress);
        console.log("Attacker balance:", attackerBalance);

        expect(attackerBalance).to.be.gt(ethers.parseEther("0.9"));
});
});        