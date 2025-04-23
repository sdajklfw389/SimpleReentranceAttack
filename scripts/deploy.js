const hre = require("hardhat");

async function main() {
    const MiniBank = await hre.ethers.getContractFactory("MiniBank");
    const bank = await MiniBank.deploy();
    await bank.deployed();

    console.log("MiniBank deployed to:", bank.address);

    const ReentranceAttack = await hre.ethers.getContractFactory("ReentranceAttack");
    const attacker = await ReentranceAttack.deploy(bank.address);
    await attacker.deployed();

    console.log("ReentranceAttack deployed to:", attacker.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});