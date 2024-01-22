// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

interface IStake {
  // Stake specific functions
  function safeWingTransfer(address _account, uint256 _amount) external;
}