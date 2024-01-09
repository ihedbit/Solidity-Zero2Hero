# Time-Locked Wallet Smart Contract

This Solidity smart contract represents a time-locked wallet that restricts access to funds until a specified time has passed. The contract allows the owner to deposit funds and withdraw them only after the predefined time lock duration has elapsed.

## Features

- **Deposit Funds:** The owner can deposit funds into the wallet at any time.
- **Time-Locked Withdrawal:** The owner can initiate a withdrawal, but it is only possible after the specified time lock duration has passed.
- **Event Logging:** The contract emits events for both funds deposited and funds withdrawn, providing transparency and traceability.

## Smart Contract Details

### Variables

- `owner`: The address of the wallet owner.
- `unlockTime`: The timestamp representing when the time lock will expire.
- `balance`: The current balance of the wallet.

### Modifiers

- `onlyOwner`: Restricts certain functions to be callable only by the owner of the wallet.
- `timeLockPassed`: Ensures that a function can only be executed after the specified time lock duration has passed.

### Functions

- `constructor(uint256 _lockDuration)`: Initializes the wallet with the owner's address and sets the unlock time based on the provided lock duration.
- `receive() external payable`: Allows users to send funds directly to the contract by triggering the `deposit` function.
- `deposit() public payable`: Allows the owner to deposit funds into the wallet.
- `withdraw() external`: Allows the owner to withdraw funds from the wallet after the time lock has passed.
- `getUnlockTime() external view returns (uint256)`: Retrieves the current unlock time.
- `getBalance() external view returns (uint256)`: Retrieves the current balance of the wallet.

## Usage

1. Deploy the contract to the Ethereum blockchain, specifying the desired time lock duration in the constructor.
2. Deposit funds into the wallet using the `deposit` function.
3. Wait for the specified time lock duration to pass.
4. Execute the `withdraw` function to retrieve the funds.

## Important Notes

- Ensure that the contract is thoroughly tested in a development environment before deployment.
- Adapt the contract according to your specific use case and security considerations.
- Make sure to comply with any applicable regulations and best practices for smart contract development.

