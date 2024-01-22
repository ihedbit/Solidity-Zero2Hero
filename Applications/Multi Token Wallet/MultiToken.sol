// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MultiTokenWallet {
    using SafeMath for uint256;

    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowedTokens;

    event Deposit(address indexed token, address indexed sender, uint256 amount);
    event Withdraw(address indexed token, address indexed recipient, uint256 amount);
    event AllowanceUpdated(address indexed token, address indexed spender, uint256 allowance);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit(address token, uint256 amount) external {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid deposit amount");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[token] = balances[token].add(amount);

        emit Deposit(token, msg.sender, amount);
    }

    function withdraw(address token, address recipient, uint256 amount) external {
        require(token != address(0), "Invalid token address");
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Invalid withdrawal amount");
        require(balances[token] >= amount, "Insufficient balance");

        IERC20(token).transfer(recipient, amount);
        balances[token] = balances[token].sub(amount);

        emit Withdraw(token, recipient, amount);
    }

    function setAllowance(address token, address spender, uint256 allowance) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(spender != address(0), "Invalid spender address");

        allowedTokens[token][spender] = allowance;

        emit AllowanceUpdated(token, spender, allowance);
    }

    function transferFromWallet(
        address token,
        address recipient,
        uint256 amount
    ) external {
        require(token != address(0), "Invalid token address");
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Invalid transfer amount");
        require(allowedTokens[token][msg.sender] >= amount, "Insufficient allowance");
        require(balances[token] >= amount, "Insufficient balance");

        IERC20(token).transfer(recipient, amount);
        allowedTokens[token][msg.sender] = allowedTokens[token][msg.sender].sub(amount);
        balances[token] = balances[token].sub(amount);
    }
}
