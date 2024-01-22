# Dutch Auction Contract README

This repository contains a Solidity contract named `DutchAuction` that implements a Dutch auction for selling non-fungible tokens (NFTs). The auction starts with a specified price and decreases over time until it expires or a buyer purchases the NFT.

## DutchAuction Contract

### Overview

The `DutchAuction` contract is designed to auction an NFT with a decreasing price over a specified duration. It includes the following key features:

- The auction starts with a specified starting price.
- The price decreases over time based on a discount rate.
- Buyers can purchase the NFT at the current price.
- The auction expires after a fixed duration.
- The seller receives the proceeds from the sale.

### Constructor Parameters

- `startingPrice`: The initial price of the NFT.
- `discountRate`: The rate at which the price decreases per second.
- `nft`: The address of the ERC-721 NFT contract.
- `nftId`: The ID of the NFT to be auctioned.

### Functions

#### `getPrice()`

Returns the current price of the NFT based on the elapsed time and discount rate.

#### `buy()`

Allows buyers to purchase the NFT by sending ETH. Checks if the auction has not expired and the sent ETH is equal to or greater than the current price. Transfers the NFT to the buyer and refunds any excess ETH. Finally, self-destructs the contract and sends the proceeds to the seller.

### Usage

1. Deploy the `DutchAuction` contract, specifying the required parameters in the constructor.
2. Buyers can call the `buy` function to purchase the NFT by sending the required ETH.

### Example

```solidity
// Deploying the DutchAuction Contract
DutchAuction dutchAuction = new DutchAuction(100 ether, 1 ether, address(nftContract), nftId);

// Buying the NFT
dutchAuction.buy{value: 90 ether}();
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
git