# Solidity Polling System

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Description

This Solidity smart contract implements a basic polling system on the Ethereum blockchain. It allows users to create polls, vote on options, and view the results. The contract is designed to be simple, yet extensible, providing a foundation for building more sophisticated decentralized voting applications.


## Usage

The smart contract provides the following functionalities:

- Create a new poll
- Vote on poll options
- Close a poll
- Retrieve poll details and results

Here is a basic example of using the contract:

```solidity
// Deploy the contract
PollingSystem pollingSystem = new PollingSystem();

// Create a new poll
pollingSystem.createPoll("What is your favorite color?", ["Red", "Blue", "Green"]);

// Vote on the first option of the poll
pollingSystem.vote(0, "Red");

// Close the poll
pollingSystem.closePoll(0);

// Retrieve poll details and results
(string memory question, string[] memory options, uint256[] memory voteCounts) = pollingSystem.getPoll(0);
```

## Features

- **Create Polls:** Owners can create polls with a question and a list of options.
- **Vote:** Users can cast votes for their preferred options.
- **Close Polls:** Owners can close polls to stop further voting.
- **Retrieve Results:** Users can query the poll details and vote counts.


## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.