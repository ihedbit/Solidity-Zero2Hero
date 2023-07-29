// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Loop {
    
    // For loop: A for loop is used for iterating over a sequence (Loops can execute a block of code a number of times)
    
    // While loop : The while Loop. With the while loop we can execute a set of statements as long as a condition is true.

    uint _while = 0;
    uint _while_increase = 3;
    uint _threshold = 35;

    function loop() public {
        // for loop
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                // Skip to next iteration with continue
                // do something
                continue;
            }
            if (i == 5) {
                // Exit loop with break
                // do something
                break;
            }
        }
        // while loop
        while (_while < _threshold) {
            _while += _while_increase;
        }
    }
}
