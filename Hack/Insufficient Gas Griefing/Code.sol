// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsufficientGasGriefing {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        // Increase the balance of the sender
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        // Ensure the sender has sufficient balance
        require(amount <= balances[msg.sender], "Insufficient balance");

        // Vulnerability: Lack of gas stipend in the loop
        for (uint i = 0; i < amount; i++) {
            // Simulate some computation or state change
            // This could be a complex operation or a loop that consumes gas
            // but doesn't actually persist any meaningful state change

            // In reality, this should be a meaningful operation that consumes gas
            // For simplicity, we are just doing a no-op here
            assembly {
                // This is just an example and doesn't do anything meaningful
            }
        }

        // Update the balance by subtracting the withdrawn amount
        balances[msg.sender] -= amount;

        // Vulnerability: Lack of gas stipend in selfdestruct
        // Self-destruct the contract to return remaining gas to the attacker
        selfdestruct(payable(msg.sender));
    }
}
