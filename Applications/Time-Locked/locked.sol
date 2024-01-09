// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    address public owner;
    uint256 public unlockTime;
    uint256 public balance;

    event FundsDeposited(address indexed depositor, uint256 amount);
    event FundsWithdrawn(address indexed withdrawer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier timeLockPassed() {
        require(block.timestamp >= unlockTime, "Time lock not yet passed");
        _;
    }

    constructor(uint256 _lockDuration) {
        owner = msg.sender;
        unlockTime = block.timestamp + _lockDuration;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable onlyOwner {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balance += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner timeLockPassed {
        require(balance > 0, "No funds available for withdrawal");
        
        uint256 amountToWithdraw = balance;
        balance = 0;

        payable(owner).transfer(amountToWithdraw);
        emit FundsWithdrawn(msg.sender, amountToWithdraw);
    }

    function getUnlockTime() external view returns (uint256) {
        return unlockTime;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }
}
