// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingAndLendingApp {
    address public owner;
    
    mapping(address => uint256) public savings;
    mapping(address => uint256) public loanBalances;
    mapping(address => uint256) public loanCollateral;
    
    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);
    event Borrow(address indexed borrower, uint256 amount, uint256 collateral);
    event Repay(address indexed borrower, uint256 amount);
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        savings[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0 && amount <= savings[msg.sender], "Invalid withdrawal amount");
        savings[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function borrow(uint256 amount, uint256 collateral) external {
        require(amount > 0 && collateral > 0, "Invalid borrow parameters");
        require(savings[msg.sender] >= collateral, "Insufficient savings for collateral");

        loanBalances[msg.sender] += amount;
        loanCollateral[msg.sender] += collateral;
        savings[msg.sender] -= collateral;

        emit Borrow(msg.sender, amount, collateral);
    }

    function repay() external payable {
        require(msg.value > 0, "Repayment amount must be greater than 0");
        require(msg.value <= loanBalances[msg.sender], "Invalid repayment amount");

        loanBalances[msg.sender] -= msg.value;
        // Optionally, return excess collateral to the borrower
        uint256 excessCollateral = loanCollateral[msg.sender] - loanBalances[msg.sender];
        if (excessCollateral > 0) {
            savings[msg.sender] += excessCollateral;
            loanCollateral[msg.sender] -= excessCollateral;
        }

        emit Repay(msg.sender, msg.value);
    }

    // In a real-world scenario, you may want to add more functions for interest calculations,
    // loan terms, and other features.
}
