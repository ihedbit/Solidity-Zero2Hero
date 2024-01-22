# CrowdFund Smart Contract

This Solidity smart contract implements a crowdfunding platform where creators can launch campaigns, and participants can pledge funds. The contract supports campaign creation, cancellation, pledging, unpledging, claiming funds, and refunding. The crowdfunding is denominated in ERC-20 tokens.

## Features

- Campaign creation with specified goals and duration.
- Campaign cancellation by the creator before the campaign starts.
- Pledging funds to ongoing campaigns.
- Unpledging funds from ongoing campaigns.
- Claiming funds by the campaign creator after the campaign ends and the goal is reached.
- Refunding funds to participants if the campaign ends without reaching its goal.

## Getting Started

### Prerequisites

- Solidity Compiler ^0.8.13
- Ethereum development environment (e.g., Remix, Truffle, or Hardhat)
- ERC-20 compatible token contract


## Usage

1. Deploy the contract, specifying the address of the ERC-20 token contract.

2. Launch a campaign using the `launch` function, specifying the goal, start time, and end time.

3. Participants can pledge funds to ongoing campaigns using the `pledge` function.

4. The campaign creator can cancel the campaign before it starts using the `cancel` function.

5. Participants can unpledge funds from ongoing campaigns using the `unpledge` function.

6. After the campaign ends, the creator can claim the funds if the goal is reached using the `claim` function.

7. If the campaign ends without reaching the goal, participants can refund their funds using the `refund` function.

## Functions

### `launch()`

Launches a new crowdfunding campaign with a specified goal, start time, and end time.

### `cancel()`

Cancels a crowdfunding campaign before it starts. Only the creator can cancel.

### `pledge()`

Allows participants to pledge funds to ongoing campaigns.

### `unpledge()`

Allows participants to unpledge funds from ongoing campaigns.

### `claim()`

Allows the creator to claim funds after the campaign ends and the goal is reached.

### `refund()`

Allows participants to refund their funds if the campaign ends without reaching the goal.

## Events

- `Launch`: Emitted when a new campaign is launched.
- `Cancel`: Emitted when a campaign is canceled.
- `Pledge`: Emitted when funds are pledged to a campaign.
- `Unpledge`: Emitted when funds are unpledged from a campaign.
- `Claim`: Emitted when the campaign creator claims funds.
- `Refund`: Emitted when a participant receives a refund.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
