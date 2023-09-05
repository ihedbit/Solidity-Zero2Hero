// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {
    string public name = "Contract A";

    function getName() public view returns (string memory) {
        return name;
    }
}


contract C is A {
    // This is the correct way to override inherited state variables.
    constructor() {
        name = "Contract C";
    }

    // C.getName returns "Contract C"
}
