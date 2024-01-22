# MerkleProof Contract

This contract provides a simple implementation of a Merkle tree and a function to verify a Merkle proof.

## MerkleProof.sol

### `verify` function

```solidity
function verify(
    bytes32[] memory proof,
    bytes32 root,
    bytes32 leaf,
    uint index
) public pure returns (bool)
```

Verifies a Merkle proof given the proof elements, Merkle root, leaf, and leaf index.

### Usage

1. **proof**: An array of proof elements.
2. **root**: The Merkle root to verify against.
3. **leaf**: The leaf node for which the proof is generated.
4. **index**: The index of the leaf in the Merkle tree.

Returns `true` if the proof is valid, `false` otherwise.

---

## TestMerkleProof.sol

This contract is an extension of the `MerkleProof` contract, providing additional functionalities for testing purposes.

### `getRoot` function

```solidity
function getRoot() public view returns (bytes32)
```

Returns the current Merkle root.

### Test Example

1. **Constructor**: Initializes the Merkle tree with sample transactions.

```solidity
string[4] memory transactions = [
    "alice -> bob",
    "bob -> dave",
    "carol -> alice",
    "dave -> bob"
];
```

2. **Get Root Example**:

```solidity
function getRoot() public view returns (bytes32) {
    return hashes[hashes.length - 1];
}
```

This returns the Merkle root of the current tree.

3. **Verification Example**:

```solidity
function verifyMerkleProofExample() external view returns (bool) {
    bytes32 leaf = 0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b;
    bytes32 root = 0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7;
    uint index = 2;
    bytes32[] memory proof = [
        0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950,
        0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
    ];

    return verify(proof, root, leaf, index);
}
```

This demonstrates how to use the `verify` function to verify a Merkle proof.

