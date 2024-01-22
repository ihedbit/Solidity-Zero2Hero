# Proxy Contracts README

This repository contains two proxy contracts implemented in Solidity:

1. **Minimal Proxy Contract**
2. **Upgradeable Proxy Contract**

## Minimal Proxy Contract

### Overview

The Minimal Proxy Contract is a simple implementation of a contract proxy. It allows for the creation of lightweight proxies that delegate calls to a target contract. This proxy design is minimal in functionality and serves as a foundation for more advanced proxy patterns.

### Usage

To use the Minimal Proxy Contract:

1. Deploy the proxy contract, specifying the target contract address during deployment.
2. The proxy contract will delegate all calls to the specified target contract.
3. The storage and state of the target contract are maintained.

## Upgradeable Proxy Contract

### Overview

The Upgradeable Proxy Contract is designed for upgradability, enabling seamless updates to the logic of the underlying contract. It uses an implementation contract where the main logic resides, and the proxy forwards calls to this implementation contract. This pattern allows for contract upgrades without changing the proxy itself.

### Usage

To use the Upgradeable Proxy Contract:

1. Deploy the implementation contract with the desired logic.
2. Deploy the proxy contract, specifying the address of the implementation contract during deployment.
3. The proxy contract forwards all calls to the implementation contract, allowing for easy upgrades.
4. To upgrade, deploy a new version of the implementation contract and update the proxy's implementation address.

## Deployment Examples

### Minimal Proxy Contract

```solidity
// Deploying the Minimal Proxy Contract
MinimalProxy minimalProxy = new MinimalProxy(targetContractAddress);
```

### Upgradeable Proxy Contract

```solidity
// Deploying the Implementation Contract
CounterV1 initialImplementation = new CounterV1();

// Deploying the Upgradeable Proxy Contract
UpgradeableProxy upgradeableProxy = new UpgradeableProxy(initialImplementation);

// Upgrading the Proxy Contract
CounterV2 newImplementation = new CounterV2();
upgradeableProxy.upgradeTo(newImplementation);
```

## Proxy Admin

### ProxyAdmin Contract

The `ProxyAdmin` contract is used to manage the administrative aspects of the proxy contracts. It provides functionality to change the proxy admin and upgrade the proxy to a new implementation.

### Usage

```solidity
// Deploying the ProxyAdmin Contract
ProxyAdmin proxyAdmin = new ProxyAdmin();

// Changing the Proxy Admin
proxyAdmin.changeProxyAdmin(proxyAddress, newAdminAddress);

// Upgrading the Proxy to a New Implementation
proxyAdmin.upgrade(proxyAddress, newImplementationAddress);
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
