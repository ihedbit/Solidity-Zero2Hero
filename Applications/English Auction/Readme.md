# English Auction Smart Contract

This Solidity smart contract implements an English Auction for a non-fungible token (NFT) using the ERC-721 standard. Participants can place bids, and the highest bidder at the end of the auction period wins the NFT.

## Features

- English auction mechanism.
- Bid withdrawals for participants.
- Automatic NFT transfer to the highest bidder at the end of the auction.
- ETH transfer to the seller.

## Getting Started

### Prerequisites

- Solidity Compiler ^0.8.13
- Ethereum development environment (e.g., Remix, Truffle, or Hardhat)
- ERC-721 compatible NFT contract

## Usage

1. Deploy the contract, specifying the address of the ERC-721 NFT contract, the NFT ID, and the starting bid.

2. Start the auction using the `start` function. Only the seller can start the auction.

3. Participants can place bids using the `bid` function.

4. The auction ends automatically after 7 days (configurable), or the seller can manually end the auction using the `end` function.

5. The highest bidder wins the NFT, and the bid amount is transferred to the seller.

## Functions

### `start()`

Starts the auction. Only the seller can start the auction.

### `bid()`

Allows participants to place bids during the auction.

### `withdraw()`

Allows participants to withdraw their bids.

### `end()`

Ends the auction and transfers the NFT to the highest bidder, along with the bid amount to the seller.

## Events

- `Start`: Emitted when the auction starts.
- `Bid`: Emitted when a participant places a bid.
- `Withdraw`: Emitted when a participant withdraws their bid.
- `End`: Emitted when the auction ends, indicating the winner and the winning bid amount.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

