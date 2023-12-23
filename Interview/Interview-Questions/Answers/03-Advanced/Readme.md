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