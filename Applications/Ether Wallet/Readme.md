# Ethereum Wallet Smart Contract

## Overview
This Ethereum smart contract, named `maktabwallet`, serves as a simple and secure Ether wallet. It allows users to manage Ether funds with specific functionalities designed for ease of use and security. The contract is written in Solidity, a language specifically designed for Ethereum smart contracts.

## Features
### 1. Ownership
The wallet is initialized with an owner, who has exclusive control over certain operations. This ensures that only authorized parties can perform critical actions on the contract.

```solidity
address payable public owner;

constructor(){
    owner = payable (msg.sender);
}
```

### 2. Deposit Ether
Users can deposit Ether into the wallet by sending funds directly to the contract's address. The `receive` function facilitates this.

```solidity
receive() external payable { }
```

### 3. Check Balance
The contract provides a function to check the current balance of Ether held within it.

```solidity
function getBalance() external view returns (uint){
    return address(this).balance;
}
```

### 4. Withdraw Ether
The owner can initiate withdrawals to specific addresses, ensuring that only authorized parties can access the funds.

```solidity
function withdraw(address to, uint amount) external onlyowner checkamount(amount) {
    payable(to).transfer(amount);
}
```

### 5. Multi-Send Functionality
The contract includes a `multi_send` function that allows the owner to send Ether to multiple recipients simultaneously. This function enhances efficiency and flexibility.

```solidity
function multi_send(address[] calldata recipients, uint256[] calldata amounts) external onlyowner {
    // Implementation details
}
```

## Security Measures
- The `onlyowner` modifier restricts certain functions to be accessible only by the owner, enhancing security.
- The `checkamount` modifier ensures that withdrawal amounts are within the available balance.

## Usage
Developers and users can deploy this contract on the Ethereum blockchain to create their own secure and customizable Ether wallet.

## License
This smart contract is released under the MIT License.

**Note**: Ensure proper testing and auditing before deploying this contract in a live environment.