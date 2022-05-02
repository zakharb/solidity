
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SmartVote", function () {
  /*
  it('only owner can add poll', async () => {
    try {
      await lottery.methods.pickWinner().send({
        from: accounts[1],
      });
      assert(false);
    } catch (err) {
      assert(err);
    }
  });
  */

  beforeEach(async function() {
    candidates = [["Joe",0,"0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]]
    Vote = await ethers.getContractFactory("SmartVote");
    vote = await Vote.deploy(candidates);
    await vote.deployed();
  });

  it("Should return the Candidates", async function () {
    const response = await vote.getCandidates();
    expect(response[0][0]).to.equal("Joe");
    expect(response[0][2]).to.equal("0x617F2E2fD72FD9D5503197092aC168c91465E7f2");
  });

  it("Should return the Polls", async function () {
    await vote.addPoll();
    const response = await vote.getPolls();
    expect(response[0][1]).to.equal(false);
  });

  it("Should close Poll correctly", async function () {
    await vote.addPoll();
    const response = await vote.closePoll(1);
    //console.log(response);
    expect(response[0][1]).to.equal(false);
  });

});

/*
const { expect } = require("chai");

describe("Minting the token and returning it", function () {
  it("should the contract be able to mint a function and return it", async function () {
    const metadata = "https://opensea-creatures-api.herokuapp.com/api/creature/1" //Random metadata url

    const FactoryContract = await ethers.getContractFactory("FactoryNFT"); // Getting the contract

    const factoryContract = await FactoryContract.deploy(); //Deploying the Contract

    const transaction = await factoryContract.createToken(metadata); // Minting the token
    const tx = await transaction.wait() // Waiting for the token to be minted

    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber(); // Getting the tokenID

    const tokenURI = await factoryContract.tokenURI(tokenId) // Using the tokenURI from ERC721 to retrieve de metadata

    expect(tokenURI).to.be.equal(metadata); // Comparing and testing

  });
});
*/
