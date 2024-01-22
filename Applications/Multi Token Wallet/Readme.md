# Multi-Token Wallet Smart Contract

This Solidity smart contract implements a basic Multi-Token Wallet allowing users to manage multiple ERC-20 tokens within a single contract. Users can deposit tokens, withdraw tokens, set allowances for spending, and transfer tokens from the wallet to other addresses.

## Features

- Deposit ERC-20 tokens into the wallet.
- Withdraw ERC-20 tokens from the wallet.
- Set allowances for specific addresses to spend tokens.
- Transfer tokens from the wallet to another address using allowances.

## Getting Started

### Prerequisites

- Solidity Compiler ^0.8.0
- Ethereum development environment (e.g., Remix, Truffle, or Hardhat)
- OpenZeppelin Contracts (IERC20, SafeMath)


## Usage

1. Deploy the contract.

2. Use the `deposit` function to deposit ERC-20 tokens into the wallet.

3. Use the `withdraw` function to withdraw ERC-20 tokens from the wallet.

4. Use the `setAllowance` function to set allowances for specific addresses to spend tokens.

5. Use the `transferFromWallet` function to transfer tokens from the wallet to another address using allowances.

## Functions

### `deposit()`

Deposits ERC-20 tokens into the wallet.

### `withdraw()`

Withdraws ERC-20 tokens from the wallet.

### `setAllowance()`

Sets allowances for specific addresses to spend tokens from the wallet.

### `transferFromWallet()`

Transfers tokens from the wallet to another address using allowances.

## Events

- `Deposit`: Emitted when tokens are deposited into the wallet.
- `Withdraw`: Emitted when tokens are withdrawn from the wallet.
- `AllowanceUpdated`: Emitted when allowances are set for specific addresses.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
