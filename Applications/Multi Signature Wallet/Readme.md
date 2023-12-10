
# Multi-Signature Wallet Smart Contract

Smart contract for a multi-signature wallet implemented in Solidity.

## Overview

This smart contract allows multiple owners to collectively manage a wallet. Transactions can be submitted, confirmed, executed, and revoked based on the consensus of the owners.

## Contract Details

### Events

- **Deposit Event (`Deposit`):**
  - Emits when Ether is deposited into the contract.
  - Parameters: `sender` (address), `amount` (amount deposited), `balance` (current contract balance).

- **Submit Transaction Event (`SubmitTransaction`):**
  - Emits when a transaction is submitted by an owner.
  - Parameters: `owner` (address), `txIndex` (index of the transaction), `to` (address of the recipient), `value` (amount of Ether), `data` (transaction data).

- **Confirm Transaction Event (`ConfirmTransaction`):**
  - Emits when an owner confirms a submitted transaction.
  - Parameters: `owner` (address), `txIndex` (index of the transaction).

- **Revoke Confirmation Event (`RevokeConfirmation`):**
  - Emits when an owner revokes a previously confirmed transaction.
  - Parameters: `owner` (address), `txIndex` (index of the transaction).

- **Execute Transaction Event (`ExecuteTransaction`):**
  - Emits when a transaction is successfully executed.
  - Parameters: `owner` (address), `txIndex` (index of the executed transaction).

### State Variables

- `owners`: An array containing the addresses of all owners.
- `isOwner`: A mapping from address to boolean indicating ownership status.
- `numConfirmationsRequired`: The number of confirmations required for a transaction to be executed.
- `transactions`: An array storing information about each submitted transaction.
- `isConfirmed`: A mapping from transaction index to owner addresses indicating confirmation status.

### Modifiers

- `onlyOwner`: Ensures that the caller is one of the owners.
- `txExists`: Ensures that the specified transaction index exists.
- `notExecuted`: Ensures that the specified transaction has not been executed.
- `notConfirmed`: Ensures that the specified transaction has not been confirmed by the caller.

### Constructor

- Initializes the multi-signature wallet with specified owners and required confirmations.
- Parameters: `owners` (array of owner addresses), `numConfirmationsRequired` (required confirmations for transaction execution).

### Receive Function

- External payable function to receive Ether, emitting a `Deposit` event.
- It enables contract to receive Ether.

### Submit Transaction Function (`submitTransaction`)

- Allows an owner to submit a transaction for approval.
- Parameters: `to` (address of the recipient), `value` (amount of Ether), `data` (transaction data).

### Confirm Transaction Function (`confirmTransaction`)

- Allows an owner to confirm a submitted transaction.
- Parameters: `txIndex` (index of the transaction).

### Revoke Confirmation Function (`revokeConfirmation`)

- Allows an owner to revoke a previously confirmed transaction.
- Parameters: `txIndex` (index of the transaction).

### Execute Transaction Function (`executeTransaction`)

- Allows an owner to execute a transaction after receiving sufficient confirmations.
- Parameters: `txIndex` (index of the transaction).

### View Functions

- `getOwners`: Returns an array containing all owner addresses.
- `getTransactionCount`: Returns the total number of submitted transactions.
- `getTransaction`: Returns details of a specific transaction.
  - Parameters: `txIndex` (index of the transaction).

## Usage

1. Deploy the contract by providing an array of owner addresses and the required number of confirmations.
2. Owners can deposit Ether into the contract using the `receive` function.
3. Owners can submit transactions using the `submitTransaction` function.
4. Other owners can confirm the submitted transactions using the `confirmTransaction` function.
5. Once a transaction has enough confirmations, any owner can execute it using the `executeTransaction` function.
6. Owners can revoke their confirmation using the `revokeConfirmation` function.

Feel free to use, modify, and contribute to this multi-signature wallet contract. If you have any questions or improvements, please let us know!
