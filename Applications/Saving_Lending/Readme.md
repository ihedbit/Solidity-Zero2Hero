# Saving and Lending Application Smart Contract

## Overview

This repository contains a Solidity smart contract for a basic Saving and Lending application. The contract, named `SavingAndLendingApp`, allows users to deposit funds, borrow against their savings by providing collateral, and repay borrowed amounts.

## Smart Contract Details

The smart contract consists of the following main components:

### 1. State Variables

- `owner`: Address of the contract owner.
- `savings`: Mapping of user addresses to their saved funds.
- `loanBalances`: Mapping of user addresses to their borrowed amounts.
- `loanCollateral`: Mapping of user addresses to their provided collateral.

### 2. Events

- `Deposit(address indexed account, uint256 amount)`: Triggered when a user deposits funds.
- `Withdraw(address indexed account, uint256 amount)`: Triggered when a user withdraws funds.
- `Borrow(address indexed borrower, uint256 amount, uint256 collateral)`: Triggered when a user borrows funds.
- `Repay(address indexed borrower, uint256 amount)`: Triggered when a user repays borrowed funds.

### 3. Functions

- `deposit() external payable`: Allows users to deposit funds into their savings.
- `withdraw(uint256 amount) external`: Allows users to withdraw funds from their savings.
- `borrow(uint256 amount, uint256 collateral) external`: Allows users to borrow funds by providing collateral.
- `repay() external payable`: Allows users to repay borrowed funds.

## Getting Started

1. Deploy the smart contract to an Ethereum-compatible blockchain.
2. Users can interact with the contract using functions like `deposit`, `withdraw`, `borrow`, and `repay`.

## Example Usage

```solidity
// Deploy the contract
SavingAndLendingApp app = new SavingAndLendingApp();

// User actions
app.deposit{value: 10}(); // Deposit 10 Ether
app.borrow(5, 3); // Borrow 5 Ether with 3 Ether collateral
app.repay{value: 7}(); // Repay 7 Ether (includes excess collateral)

// Check balances and loan details
uint256 userSavings = app.savings(msg.sender);
uint256 userLoanBalance = app.loanBalances(msg.sender);
uint256 userLoanCollateral = app.loanCollateral(msg.sender);
```

## License

This smart contract is licensed under the [MIT License](LICENSE).

Feel free to use, modify, and distribute this code in accordance with the terms of the license.

## Disclaimer

This code is provided as-is, without any warranty. Use it at your own risk, and carefully review and test before deploying it on a live network. Additionally, consider adding additional features and security measures based on the specific requirements of your application.