# Voting System Smart Contract

## Overview

This repository contains a Solidity smart contract for a voting system with delegation. The contract, named `Ballot`, allows voters to delegate their voting rights to another address and cast votes on various proposals.

## Smart Contract Details

The smart contract consists of the following main components:

### 1. Voter Struct

- `weight`: Accumulated weight by delegation.
- `voted`: Boolean indicating whether the voter has already voted.
- `delegate`: Address to which the voter has delegated their vote.
- `vote`: Index of the voted proposal.

### 2. Proposal Struct

- `name`: Short name of the proposal (up to 32 bytes).
- `voteCount`: Number of accumulated votes for the proposal.

### 3. Functionality

- `giveRightToVote(address voter)`: Allows the chairperson to give voting rights to a specific address.
- `delegate(address to)`: Allows a voter to delegate their vote to another address.
- `vote(uint proposal)`: Allows a voter to cast their vote for a specific proposal.
- `winningProposal()`: Computes the winning proposal taking all previous votes into account.
- `winnerName()`: Returns the name of the winning proposal.

## Getting Started

1. Deploy the smart contract to an Ethereum-compatible blockchain.
2. Initialize the contract with a list of proposal names.
3. Use `giveRightToVote` to grant voting rights to specific addresses.
4. Voters can delegate their votes using `delegate`.
5. Voters can cast their votes using `vote`.
6. Use `winningProposal` and `winnerName` to determine the winning proposal.

## Example Deployment

```solidity
// Deploy the contract with proposal names
Ballot ballot = new Ballot(["Proposal 1", "Proposal 2", "Proposal 3"]);

// Give voting rights to a specific address
ballot.giveRightToVote(address1);

// Delegate votes
ballot.delegate(address2);

// Cast votes
ballot.vote(0);
ballot.vote(1);

// Get the winning proposal name
bytes32 winner = ballot.winnerName();
```

## License

This smart contract is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

Feel free to use, modify, and distribute this code in accordance with the terms of the license.

## Disclaimer

This code is provided as-is, without any warranty. Use it at your own risk, and carefully review and test before deploying it on a live network.