// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Variables {
    // State variables are stored on the blockchain. They are available based on their visibility
    // msg.sender & block.timestamp are global variables
    // owner & timestamp are State variables

    string public Hello = "Hello";
    uint public num = 123;
    address public owner = msg.sender;
    uint public timestamp = block.timestamp; 

    function DefineLocalVariable() view public {
        // Local variables are not saved to the blockchain + they are available just in their scope (between last { and next } ;) )
        uint test_local = 456;
    }
}
