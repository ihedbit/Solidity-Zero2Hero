# Solidity Zero2Hero: A Roadmap for Mastering Smart Contract Development + Solidity

![Logo](https://github.com/itsDMind/Solidity-Zero2Hero/blob/main/images/Solidity.png)

Welcome to Solidity Zero2Hero, your comprehensive guide to becoming a Solidity expert! Whether you're a beginner or an experienced developer looking to dive into the world of decentralized applications (DApps), this repository is your roadmap to mastering Solidity, the programming language for Ethereum smart contracts.

## Intriduction to different Parts of this repo : 

  - <b>Abstract Docs</b> : Welcome to the Abstract Docs section of Solidity Zero2Hero! In this segment, we delve into the   conceptual foundations of smart contract development. Expect to explore high-level overviews, theoretical frameworks, and key principles that will shape your understanding of Solidity and its applications.
    
  - <b>Basics</b> : Embark on your journey with Solidity by immersing yourself in the Basics section. Here, we break down the fundamental elements of smart contract development. Whether you're a novice or a seasoned developer, this section serves as a comprehensive resource to reinforce your understanding of Solidity's core concepts.
    
  - <b>Applications</b> : Discover the real-world impact of Solidity in the Applications section. From decentralized finance to supply chain management, we explore diverse use cases to showcase the versatility and potential of smart contracts. Gain insights into how Solidity can revolutionize industries and pave the way for innovative solutions.
    
  - <b>Hack</b> : Dive into the Hack section for an interactive and hands-on experience with Solidity. Unleash your creativity and problem-solving skills by engaging in practical challenges, coding exercises, and innovative projects. Elevate your proficiency in smart contract development through a series of stimulating activities.
    
  - <b>Tests & Audit tools</b> : Ensuring the security and reliability of smart contracts is paramount. In the Tests & Audit Tools section, discover a toolkit designed to fortify your projects. Explore testing methodologies, debugging techniques, and robust audit tools to enhance the quality of your smart contracts and contribute to a safer blockchain ecosystem.
    
  - <b>Common EIPs</b> : Stay abreast of the latest developments in the Ethereum ecosystem with our exploration of Common EIPs (Ethereum Improvement Proposals). This section provides an in-depth analysis of essential proposals shaping the future of Ethereum. Stay informed and contribute to the ongoing evolution of the blockchain.
    
  - <b>DeFi</b> : Delve into the world of decentralized finance (DeFi) with our specialized section. Uncover the intricacies of financial protocols, liquidity pools, and decentralized exchanges powered by Solidity. Whether you're a DeFi enthusiast or aspiring developer, this segment provides a comprehensive guide to navigating the decentralized financial landscape.
    
  - <b>Audit</b> : In the Audit section, prioritize the security and reliability of your smart contracts. Gain insights into best practices for auditing Solidity code and explore methodologies to identify vulnerabilities. Elevate your projects to the highest standards of security with the knowledge and tools provided in this crucial segment.

## Roadmap

### Abstract Docs
  - Introduction to Smart Contracts
  - Solidity by Example
  - Installing the Solidity Compiler
  - Layout of a Solidity Source File
  - Structure of a Contract
  - Types
  - Units and Globally Available Variables
  - Expressions and Control Structures
  - Contracts
  - Inline Assembly
  - Cheatsheet
  - Language Grammar
  - Using the Compiler
  - Analysing the Compiler Output
  - Solidity IR-based Codegen Changes
  - Layout of State Variables in Storage
  - Layout in Memory
  - Layout of Call Data
  - Cleaning Up Variables
  - Source Mappings
  - The Optimizer
  - Contract Metadata
  - Contract ABI Specification
  - Security Considerations
    
### Basics
  - Hello World
  - First App
  - Primitive Data Types
  - Variables
  - Constants
  - Immutable
  - Reading and Writing to a State Variable
  - Ether and Wei
  - Gas and Gas Price
  - If / Else
  - For and While Loop
  - Mapping
  - Array
  - Enum
  - Structs
  - Data Locations - Storage, Memory and Calldata
  - Function
  - View and Pure Functions
  - Error
  - Function Modifier
  - Events
  - Constructor
  - Inheritance
  - Shadowing Inherited State Variables
  - Calling Parent Contracts
  - Visibility
  - Interface
  - Payable
  - Sending Ether (transfer, send, call)
  - Fallback
  - Call
  - Delegatecall
  - Function Selector
  - Calling Other Contract
  - Contract that Creates other Contracts
  - Try Catch
  - Import
  - Library
  - ABI Encode
  - ABI Decode
  - Hashing with Keccak256
  - Verifying Signature
  - Gas Saving Techniques
  - Bitwise Operators
  - Unchecked Math
  - Assembly Variable
  - Assembly Conditional Statements
  - Assembly Loop
  - Assembly Error
  - Assembly Math

### Applications
  - Ether Wallet
  - Multi Sig Wallet
  - Merkle Tree
  - Iterable Mapping
  - ERC20
  - ERC721
  - ERC1155
  - Gasless Token Transfer
  - Simple Bytecode Contract
  - Precompute Contract Address with Create2
  - Minimal Proxy Contract
  - Upgradeable Proxy
  - Deploy Any Contract
  - Write to Any Slot
  - Uni-Directional Payment Channel
  - Bi-Directional Payment Channel
  - English Auction
  - Dutch Auction
  - Crowd Fund
  - Multi Call
  - Multi Delegatecall
  - Time Lock
  - Assembly Binary Exponentiation

### Hack
  - Insufficient Gas Griefing
  - Reentrancy
  - Integer Overflow and Underflow
  - Timestamp Dependence
  - Authorization Through tx.origin
  - Floating Pragma
  - Outdated Compiler Version
  - Unsafe Low-Level Call
  - Uninitialized Storage Pointer
  - Assert Violation
  - Use of Deprecated Functions
  - Delegatecall to Untrusted Callee
  - Signature Malleability
  - Incorrect Constructor Name
  - Shadowing State Variables
  - Weak Sources of Randomness from Chain Attributes
  - Missing Protection against Signature Replay Attacks
  - Requirement Validation
  - Write to Arbitrary Storage Location
  - Incorrect Inheritance Order
  - Presence of Unused Variables
  - Unencrypted Private Data On-Chain
  - Inadherence to Standards
  - Asserting Contract from Code Size
  - Transaction-Ordering Dependence
  - DoS with Block Gas Limit
  - DoS with (Unexpected) revert
  - Unexpected ecrecover null address
  - Default Visibility
  - Insufficient Access Control
  - Off-By-One
  - Lack of Precision
  - Access Control Checks on Critical Function
  - Account Existence Check for low level calls
  - Arithmetic Over/Under Flows
  - Assert Violation
  - Authorization through tx.origin
  - Bad Source of Randomness
  - Block Timestamp manipulation
  - Bypass Contract Size Check
  - Code With No Effects
  - Delegatecall
  - Delegatecall to Untrusted Callee
  - DoS with (Unexpected) revert
  - DoS with Block Gas Limit
  - Logical Issues
  - Entropy Illusion
  - Function Selector Abuse
  - Floating Point and Numerical Precision
  - Floating Pragma
  - Forcibly Sending Ether to a Contract
  - Function Default Visibility
  - Hash Collisions With Multiple Variable Length Arguments
  - Improper Array Deletion
  - Incorrect interface
  - Insufficient gas griefing
  - Unsafe Ownership Transfer
  - Loop through long arrays
  - Message call with hardcoded gas amount
  - Outdated Compiler Version
  - Precision Loss in Calculations
  - Price Manipulation
  - Hiding Malicious Code with External Contract
  - Public burn() function
  - Race Conditions / Front Running
  - Re-entrancy
  - Requirement Violation
  - Right-To-Left-Override control character (U+202E)
  - Shadowing State Variables
  - Short Address/Parameter Attack
  - Signature Malleability
  - Signature Replay Attacks
  - State Variable Default Visibility
  - Transaction Order Dependence
  - Typographical Error
  - Unchecked Call Return Value
  - Unencrypted Private Data On-Chain
  - Unexpected Ether balance
  - Uninitialized Storage Pointer
  - Unprotected Ether Withdrawal
  - Unprotected SELFDESTRUCT Instruction
  - Unprotected Upgrades
  - Unused Variable
  - Use of Deprecated Solidity Functions
  - Write to Arbitrary Storage Location
  - Wrong inheritance
  - DeFi : Flash Loan Attack
  - DeFi : Price Oracle Manipulation
  - DeFi : Front-Running
  - DeFi : Exit Scams
  - DeFi : Sandwich attacks
  - DeFi : Unlimited Token Allowance


### Tests & Audit tools
  - Audit : Slither
  - Audit : Mythril
  - Audit : Mythx
  - Audit : Echidna
  - Audit : Foundry FUZZ
  - Audit : Manticore
  - Audit : Surya
  - Tests : Hardhat
  - Tests : Brownie
  - Tests : Foundry
  - Tests : Tenderly

### Common EIPs
  - ERC 20
  - ERC 721 (NFT)
  - ERC 777
  - ERC 1155
  - ERC 4626
  - ERC 2981

### DeFi
  - Uniswap V2 Swap
  - Uniswap V2 Add Remove Liquidity
  - Uniswap V2 Optimal One Sided Supply
  - Uniswap V2 Flash Swap
  - Uniswap V3 Swap Examples
  - Uniswap V3 Liquidity Examples
  - Uniswap V3 Flash Loan
  - Uniswap V3 Flash Swap Arbitrage
  - Chainlink Price Oracle
  - Staking Rewards
  - Discrete Staking Rewards
  - Vault
  - Constant Sum AMM
  - Constant Product AMM
  - Stable Swap AMM

### Audit
  - Behavioral Patterns
    - Guard Check
    - State Machine
    - Oracle
    - Randomness
      
  - Security Patterns
    - Access Restriction
    - Checks Effects Interactions
    - Secure Ether Transfer
    - Pull over Push
    - Emergency Stop
      
  - Upgradeability Patterns
    - Proxy Delegate
    - Eternal Storage
      
  - Economic Patterns
    - String Equality Comparison
    - Tight Variable Packing
    - Memory Array Building
      
  - Smart Contract Security Verification Standard
    - Architecture, Design and Threat Modelling
    - Access Control
    - Blockchain Data
    - Communications
    - Arithmetic
    - Malicious Input Handling
    - Gas Usage & Limitations
    - Business Logic
    - Denial of Service
    - Token
    - Code Clarity
    - Test Coverage
    - Known Attacks
    - Decentralized Finance

## Key Features:

<b>Structured Learning Path</b>: This repository is carefully organized to take you from the fundamentals of Solidity to advanced smart contract development. Follow a step-by-step guide that ensures a smooth learning curve.

<b>Hands-on Examples</b>: Learn by doing! Dive into real-world examples and practical exercises that reinforce your understanding of Solidity concepts. From basic data types to complex contract interactions, we've got you covered.

<b>Best Practices</b>: Explore industry best practices for writing secure, efficient, and maintainable smart contracts. Understand common pitfalls and how to avoid them, ensuring your code is robust and ready for deployment on the Ethereum blockchain.

<b>Community Support</b>: Join our growing community of Solidity enthusiasts. Exchange ideas, seek help, and collaborate with fellow learners. Engage in discussions, share your projects, and stay updated on the latest developments in the Ethereum ecosystem.

<b>Persian Language Support</b>: Solidity Zero2Hero is designed with Persian speakers in mind. All content, explanations, and discussions are available in Persian, making it easier for Farsi-speaking developers to grasp complex concepts.

## Who is this for ?


<b>Beginners</b>: If you're new to blockchain development and Solidity, this roadmap provides a structured approach to help you build a strong foundation.

<b>Intermediate Developers</b>: If you have some experience with Solidity but want to deepen your knowledge and refine your skills, this repository offers advanced topics and challenges.

<b>Experienced Developers</b>: Even if you're already well-versed in smart contract development, Solidity Zero2Hero serves as a handy reference and a source for staying updated on the latest best practices and advancements.

Embark on your journey from Solidity Zero to Hero today! Let's build the decentralized future together.

Happy coding!

## Colabration Terms

  - contact  [@Hooman (DMind) Dehghani](https://www.github.com/itsDMind) to get access.

      - [communication](https://www.itsdmind.github.io)

  - Select one of the categories.
  
  - Start & Explore & Move on. 

## Authors
- [@Hooman (DMind) Dehghani](https://www.github.com/itsDMind)

## Feedback
If you have any feedback, please reach out to us at dmind.me@proton.me

## License

[MIT](https://choosealicense.com/licenses/mit/)
