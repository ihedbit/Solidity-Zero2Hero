# Solidity Advanced Questions Answers

# 1. What addresses do the Ethereum precompiles live at?
The Ethereum precompiled contracts are specialized contracts that perform specific cryptographic operations. In Solidity, these contracts are identified by their addresses. The addresses of the Ethereum precompiles are as follows:

1. **ECDSA Recovery (1):**
   - **Address:** `0x0000000000000000000000000000000000000001`

2. **SHA-256 (2):**
   - **Address:** `0x0000000000000000000000000000000000000002`

3. **RIPEMD-160 (3):**
   - **Address:** `0x0000000000000000000000000000000000000003`

4. **Identity (4):**
   - **Address:** `0x0000000000000000000000000000000000000004`

5. **Modular Exponentiation (5):**
   - **Address:** `0x0000000000000000000000000000000000000005`

6. **BN256 Pairing Check (6):**
   - **Address:** `0x0000000000000000000000000000000000000006`

These addresses are constants defined on the Ethereum network and represent the locations of the corresponding precompiled contracts. Developers can interact with these contracts to perform cryptographic operations as part of their smart contract logic.

# 2. How does Solidity manage the function selectors when there are more than 4 functions?

In Solidity, function selectors are used to uniquely identify functions within a contract. When there are more than 4 functions, Solidity employs a process called function overloading or function name mangling to distinguish between them. The function selector is essentially a hash of the function signature.

## Solidity Function Selectors for More Than 4 Functions

In Solidity, each function is identified by a unique function selector, which is a hash of the function signature. This mechanism allows the Ethereum Virtual Machine (EVM) to correctly call the intended function when a transaction is sent to a contract.

### Function Selectors and Function Signatures

A function selector is a 4-byte identifier derived from the first four bytes of the Keccak-256 hash of the canonical function signature. The canonical function signature includes the function name and parameter types, but not the parameter names or return types.

### Handling More Than 4 Functions

When there are more than 4 functions in a contract, Solidity employs function overloading, and each function is assigned a unique function selector based on its signature. The overloading is possible because the function selectors are derived from the entire function signature, including the parameter types.

### Example

Consider a contract with the following functions:

```solidity
function foo(uint256 a) external returns (uint256);
function foo(string memory b) external returns (string memory);
function bar() external;
function baz(address c) external;
function qux(bool d) external;
```

Each of these functions will have a unique function selector based on its complete signature. Solidity will use these selectors to correctly route incoming transactions to the corresponding functions.

In summary, Solidity utilizes function selectors, generated from the function signatures, to manage the identification of functions, even when there are more than 4 functions in a contract. The entire signature, including parameter types, ensures unique function selectors and proper function dispatching within the EVM.