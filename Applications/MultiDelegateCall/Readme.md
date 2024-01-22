# MultiDelegatecall Contract

This contract allows for multiple delegate calls in a single transaction, providing a convenient way to execute multiple functions atomically.

## MultiDelegatecall.sol

### `multiDelegatecall` function

```solidity
function multiDelegatecall(bytes[] memory data)
    external
    payable
    returns (bytes[] memory results)
```

Executes multiple delegate calls in a single transaction.

1. **data**: An array of bytes containing the calldata for each delegate call.
2. **results**: An array of bytes containing the results of each delegate call.

### Example Usage

```solidity
bytes[] memory data = new bytes[](3);
data[0] = Helper.getFunc1Data(10, 20);
data[1] = Helper.getFunc2Data();
data[2] = Helper.getMintData();

bytes[] memory results = multiDelegatecall(data);
```

---

## TestMultiDelegatecall.sol

This contract extends the MultiDelegatecall contract and provides example functions for testing purposes.

### `func1` function

```solidity
function func1(uint x, uint y) external
```

An example function that emits a log statement with the caller's address, function name, and the sum of `x` and `y`.

### `func2` function

```solidity
function func2() external returns (uint)
```

An example function that emits a log statement with the caller's address, function name, and returns the value `111`.

### `mint` function

```solidity
function mint() external payable
```

An example function that increments the balance of the caller by the amount sent in the transaction. **Warning**: This function can be unsafe if used in combination with multi-delegatecall.

### Example Usage

```solidity
TestMultiDelegatecall testContract = new TestMultiDelegatecall();
testContract.multiDelegatecall([Helper.getFunc1Data(10, 20), Helper.getMintData()]);
```

---

## Helper.sol

This contract provides helper functions to generate calldata for functions in the `TestMultiDelegatecall` contract.

### `getFunc1Data` function

```solidity
function getFunc1Data(uint x, uint y) external pure returns (bytes memory)
```

Generates calldata for the `func1` function.

### `getFunc2Data` function

```solidity
function getFunc2Data() external pure returns (bytes memory)
```

Generates calldata for the `func2` function.

### `getMintData` function

```solidity
function getMintData() external pure returns (bytes memory)
```

Generates calldata for the `mint` function.
