# NFT Marketplace Smart Contract

This Solidity smart contract implements a simple NFT marketplace where users can list, buy, and sell ERC-721 tokens. The marketplace charges a listing fee and facilitates the exchange of NFTs between users. The contract utilizes the OpenZeppelin library for ERC-721 and ERC-721URIStorage functionalities.

## Features

- List ERC-721 tokens for sale.
- Buy ERC-721 tokens from the marketplace.
- View all NFTs currently listed for sale.
- View NFTs owned or listed by the current user.

## Getting Started

### Prerequisites

- Solidity Compiler ^0.8.0
- Ethereum development environment (e.g., Remix, Truffle, or Hardhat)

## Usage

1. Deploy the contract, specifying the initial listing fee.

2. Users can create NFTs and list them for sale by calling the `createToken` function.

3. Buyers can purchase listed NFTs using the `executeSale` function by providing the correct payment.

4. Users can view all NFTs currently listed on the marketplace using the `getAllNFTs` function.

5. Users can view NFTs they own or have listed for sale using the `getMyNFTs` function.

6. The marketplace owner can update the listing fee using the `updateListPrice` function.

## Functions

### `createToken()`

Creates a new ERC-721 token, lists it for sale, and mints it to the creator.

### `executeSale()`

Allows a user to purchase a listed ERC-721 token, transferring ownership and payment.

### `getAllNFTs()`

Returns an array of all ERC-721 tokens currently listed on the marketplace.

### `getMyNFTs()`

Returns an array of ERC-721 tokens owned or listed by the calling user.

### `updateListPrice()`

Allows the marketplace owner to update the listing fee.

## Events

- `TokenListedSuccess`: Emitted when a new ERC-721 token is successfully listed.
- Other standard ERC-721 events.

## License

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.