// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract maktabwallet {
    address payable public owner;
    
    constructor(){
        owner = payable (msg.sender);
    }

    receive() external payable { }

    modifier onlyowner(){
        require(payable (msg.sender) == owner,"There is no permission");
        _;
    }

    modifier checkamount(uint amount){
        require(amount <= address(this).balance ,"There is not enough money");
        _;
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }

    function withdraw(address to,uint amount) external onlyowner checkamount(amount) {
        payable (to).transfer(amount);
    }

    function multi_send(address[] calldata recepients, uint256[] calldata amounts) external onlyowner {
        require(recepients.length == amounts.length,"Index out of range");

        for(uint256 i = 0; i < recepients.length ; i++){
            require(recepients[i] != address(0),"it's burining address");
            require(amounts[i] != 0,"Not valid value");
            require(amounts[i] <= address(this).balance,"Not enough money");

            payable (recepients[i]).transfer(amounts[i]);
        }
    }
}