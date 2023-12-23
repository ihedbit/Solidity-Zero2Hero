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