# Solidity Hard Questions Answers

# 1. How does fixed point arithmetic represent numbers?
Fixed-point arithmetic is a method of representing and manipulating numbers with fractional parts in Solidity. Unlike traditional floating-point numbers, fixed-point numbers have a fixed number of decimal places.

In Solidity, fixed-point numbers are implemented using the `fixed` type, which has the following format:

```
fixed<M>xN
```

- **`M`**: The number of bits used to represent the integer part.
- **`N`**: The total number of bits used to represent the fixed-point number.

For example, `fixed8x18` indicates a fixed-point number with 8 bits for the integer part and a total of 18 bits.

### Conversion to Integer Representation

Fixed-point numbers are stored as integers, and the conversion between the fixed-point representation and the actual value involves scaling. The scaling factor is determined by the number of decimal places in the fixed-point format.

For a `fixed<M>xN` type, the scaling factor is 2^N. To convert a fixed-point value to its actual representation, you divide the integer value by 2^N. Conversely, to convert an actual value to its fixed-point representation, you multiply the value by 2^N.

### Arithmetic Operations

Arithmetic operations on fixed-point numbers involve careful handling of the scaling factor. When you add or subtract fixed-point numbers, the scaling factor remains the same. However, when you multiply fixed-point numbers, the scaling factor increases (it's the sum of the scaling factors of the operands). For division, the scaling factor decreases.

### Example

Consider a `fixed8x18` type. The scaling factor is 2^18. If you have a fixed-point value of 100, it is represented as 100 * 2^18 in the integer storage.

```solidity
fixed8x18 value = 100;
uint256 integerValue = uint256(value); // integerValue is 100 * 2^18
```

Understanding the fixed-point format and its scaling factor is crucial for precise and accurate arithmetic operations in Solidity when dealing with fractional numbers.

# 2. What is an ERC20 approval frontrunning attack?

In the context of Ethereum and ERC20 tokens, a frontrunning attack refers to a scenario where an attacker exploits the order of transactions to gain an unfair advantage. Specifically, an ERC20 approval frontrunning attack targets the `approve` function in ERC20 token contracts.

### ERC20 Token Approval Mechanism

The `approve` function in ERC20 token contracts is used to grant permission to another address (typically a smart contract) to spend a certain amount of tokens on behalf of the owner. This mechanism is crucial for various decentralized applications (DApps) and protocols that rely on token allowances.

### Frontrunning Attack Scenario

In an ERC20 approval frontrunning attack, the attacker monitors the Ethereum mempool for pending transactions, particularly those involving the `approve` function. When a user initiates an approval transaction to grant spending permissions, the attacker quickly submits a transaction with a higher gas price to replace the user's transaction in the queue.

As a result, the attacker's transaction gets mined before the user's transaction, allowing them to gain control of the approved amount before the intended recipient. This can lead to undesirable consequences, such as front-runners front-running another user's transaction to take advantage of market conditions or exploit vulnerabilities in smart contracts.

### Mitigation Strategies

To mitigate ERC20 approval frontrunning attacks, users and developers can consider the following strategies:

1. **Use Flash Loans**: Utilize flash loans to perform multi-step transactions in a single atomic transaction, reducing the window of opportunity for frontrunners.
   
2. **Use Reentrancy Guards**: Implement reentrancy guards in smart contracts to minimize the risk of reentrancy attacks, which can be part of frontrunning strategies.

3. **Private Transactions**: Leverage privacy-focused solutions or layer-2 scaling solutions to make transactions less transparent and reduce the likelihood of frontrunning.

4. **Optimistic Rollups**: Consider using layer-2 solutions like optimistic rollups, which provide a more secure environment for transactions and reduce the impact of frontrunning.

5. **Gas Price Limitations**: Users can set gas price limits to prevent their transactions from being replaced by higher-priced transactions.

Understanding and implementing these strategies can enhance the security of ERC20 token approvals and protect users from frontrunning attacks.

# 3. What opcode accomplishes address(this).balance?
The opcode that accomplishes `address(this).balance` in Solidity is:

```solidity
BALANCE
```
This opcode returns the balance of the current contract in Wei.

#### Note: In Solidity, the `address(this).balance` expression retrieves the balance of the current contract. It is equivalent to the `SELFBALANCE` opcode, which explicitly accesses the balance of the current contract instance. The `SELFBALANCE` opcode has a lower gas cost than the `BALANCE` opcode, which can be useful for performance-sensitive applications.

