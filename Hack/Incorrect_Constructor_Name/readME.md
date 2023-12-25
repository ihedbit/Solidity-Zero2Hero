# Constructors with Care

Constructors are special functions which often perform critical, privileged tasks when initialising contracts. Before solidity v0.4.22 constructors were defined as functions that had the same name as the contract that contained them. Thus, when a contract name gets changed in development, if the constructor name isn't changed, it becomes a normal, callable function. As you can imagine, this can (and has) lead to some interesting contract hacks.

## The Vulnerability

If the contract name gets modified, or there is a typo in the constructor's name such that it no longer matches the name of the contract, the constructor will behave like a normal function. This can lead to dire consequences, especially if the constructor is performing privileged operations. Consider the following contract

see code [here](Code.sol)

This contract collects ether and only allows the owner to withdraw all the ether by calling the withdraw() function. The issue arises due to the fact that the constructor is not exactly named after the contract. Specifically, ownerWallet is not the same as OwnerWallet. Thus, any user can call the ownerWallet() function, set themselves as the owner and then take all the ether in the contract by calling withdraw().

## Preventative Techniques

This issue has been primarily addressed in the Solidity compiler in version 0.4.22. This version introduced a constructor keyword which specifies the constructor, rather than requiring the name of the function to match the contract name. Using this keyword to specify constructors is recommended to prevent naming issues as highlighted above.