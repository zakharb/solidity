// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

/** 
 Smart voting system
 */
contract SmartVote {
   
    address public owner;
    uint  taxWallet;

    struct Voter {
        uint[] voted;
    }

    struct Candidate {
        string name;
        uint voteCount;
        address payable wallet;
    }

    mapping(address => Voter) voters;

    Candidate[] public candidates;

    struct Poll {
        uint pollWallet;
        bool isComplete;
        uint pollTime;
    }

    Poll[] public polls;

    constructor (Candidate[] memory _candidates) {
        // Must specified the Contract wallet for taxes
        // and candidates list with names and wallets
        owner = msg.sender;
        for (uint i = 0; i < _candidates.length; i++) {
            candidates.push(Candidate({
                name: _candidates[i].name,
                voteCount: 0,
                wallet: payable(_candidates[i].wallet)
            }));
        }
    }

    function vote(uint candidate, uint poll) public payable {
        // You can vote only 1 time
        // Must send 0.01 ehter by voting
        require(!polls[poll].isComplete, "The Poll is finished!");
        require(msg.value == 0.01 ether, "You need to send 0.01 ehter!");
        require(polls.length > poll, "Take right poll number!");
        require(candidates.length > candidate, "Take right candidate number!");
        require(polls[poll].pollTime + 259200 > block.timestamp, "Too late!");
        for (uint i; i < voters[msg.sender].voted.length; i++) {
            require(voters[msg.sender].voted[i] != poll, "Can't vote second time!");
        }
        voters[msg.sender].voted.push(poll);
        candidates[candidate].voteCount++;
        payable(owner).transfer(0.01 ether);
        polls[poll].pollWallet += 0.009 ether;
        taxWallet += 0.001 ether;
    }

    function addPoll() public {
        // Only owner can add the Poll
        // Poll time is 3 days long
        require(msg.sender == owner);
        polls.push(Poll({
            pollWallet: 0,
            isComplete: false,
            pollTime: block.timestamp
        }));
    }

    function closePoll(uint poll) public payable {
        // Can close the Poll after 3 days
        require(polls.length > poll, "Take right poll number!");
        require(polls[poll].pollTime + 259200 < block.timestamp, "Wait for finishing the poll!");
        polls[poll].isComplete = true;
    }

    function getWinner(uint poll) public view 
        returns (uint winningCandidate) {
        // Get Winner after the Poll is finished 
        require(polls.length > poll, "Take right poll number!");
        require(polls[poll].isComplete, "Finish the Poll first!");
        uint maxCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > maxCount) {
                maxCount = candidates[p].voteCount;
                winningCandidate = p;
            }
        }
    }

    function sendWinner(uint poll) public payable {
        // The Winner get 90% of the cash
        // 10% stay in Contract wallet
        require(msg.sender == owner, "You are not owner!");
        require(polls[poll].isComplete, "Finish the Poll first!");
        uint winner = getWinner(poll);
        candidates[winner].wallet.transfer(polls[poll].pollWallet / 100 * 90);
        polls[poll].pollWallet = 0;
    }

    function withdrawTax(address _wallet) public payable {
        // Withdraw tax to wallet
        require(msg.sender == owner, "You are not owner!");
        payable(_wallet).transfer(taxWallet);
        taxWallet = 0;
    }

    function getCandidates() public view
        returns (Candidate[] memory){
            return candidates;
        }

    function getPolls() public view 
        returns (Poll[] memory){
            return polls;
        }

}