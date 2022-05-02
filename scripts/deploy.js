require('dotenv').config();

const { WALLET, CANDIDATES } = process.env;


const hre = require("hardhat"); //import the hardhat

async function main() {
  const [deployer] = await ethers.getSigners(); //get the account to deploy the contract

  console.log("Deploying contracts with the account:", deployer.address); 

  const SmartVoter = await hre.ethers.getContractFactory("SmartVote"); // Getting the Contract
  const smartvoter = await SmartVoter.deploy(WALLET, CANDIDATES); //deploying the contract

  await smartvoter.deployed(); // waiting for the contract to be deployed

  console.log("SmartVoter deployed to:", smartvoter.address); // Returning the contract address on the rinkeby
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); // Calling the function to deploy the contract 