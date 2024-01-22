// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/IStake.sol";
import "./interfaces/IWING.sol";

contract Stake is IStake, Ownable {

  /// @notice wing token
  IWING public wing;

  constructor(
    IWING _wing
  ) public {
    wing = _wing;
  }

  /// @notice Safe WING transfer function, just in case if rounding error causes pool to not have enough WINGs.
  /// @param _to The address to transfer WING to
  /// @param _amount The amount to transfer to
  function safeWingTransfer(address _to, uint256 _amount) external override onlyOwner {
    uint256 wingBal = wing.balanceOf(address(this));
    if (_amount > wingBal) {
      wing.transfer(_to, wingBal);
    } else {
      wing.transfer(_to, _amount);
    }
  }
}