// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyowner(){
        require(msg.sender == owner,"You are not allowd");
        _;
    }

    receive() external payable {}

    function withdraw(uint _amount) external onlyowner {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view onlyowner returns (uint) {
        return address(this).balance;
    }
}
