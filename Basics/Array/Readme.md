# Solidity Array Contract

This Solidity smart contract provides examples and functions related to arrays. It covers dynamic arrays, fixed-size arrays, and various array operations.

## Initialization

The contract demonstrates different ways to initialize arrays:

- Dynamic array without initialization: `uint[] public arr;`
- Dynamic array with initialization: `uint[] public arr2 = [1, 2, 3];`
- Fixed-sized array with all elements initialized to 0: `uint[10] public myFixedSizeArr;`

## Functions

### 1. Get Element at Index

```solidity
function get(uint i) public view returns (uint)
```

This function returns the value at a specific index in the dynamic array.

### 2. Get Entire Dynamic Array

```solidity
function getArr() public view returns (uint[] memory)
```

This function returns the entire dynamic array. Note: Avoid using this for arrays that can grow indefinitely.

### 3. Push Element to Dynamic Array

```solidity
function push(uint i) public
```

This function appends a new element to the end of the dynamic array.

### 4. Pop Element from Dynamic Array

```solidity
function pop() public
```

This function removes the last element from the dynamic array.

### 5. Get Dynamic Array Length

```solidity
function getLength() public view returns (uint)
```

This function returns the current length of the dynamic array.

### 6. Remove Element at Index

```solidity
function remove(uint index) public
```

This function removes an element at a specific index from the dynamic array using the `delete` keyword.

### 7. Create Fixed-Size Array in Memory

```solidity
function examples() pure external returns(uint[] memory)
```

This function demonstrates creating a fixed-size array in memory.
