// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AllAboutCalldata {

    function manipulateMemory(string memory input) public pure returns (string memory) {
        // You CAN modify arguments passed with data location 'memory'

        // You can add data to the string
        input = string.concat(input, " - All About Solidity");

        // You can change the whole string
        input = "Changed to -> All About Memory!";
        return input;
    }

    function manipulateCalldata(string calldata input) external pure returns (string calldata) {
        // You CANNOT modify arguments passed with data location 'calldata'

        // Attempting to add or edit data in the string will result in a compiler error.
        // TypeError: Type string memory is not implicitly convertible to expected type string calldata.
        // input = string.concat(input, " - All About Solidity");

        // Attempting to change the whole string will result in a compiler error.
        // Type literal_string "..." is not implicitly convertible to expected type string calldata.
        // input = "Cannot change to -> All About Calldata!";
        return input;
    }
}