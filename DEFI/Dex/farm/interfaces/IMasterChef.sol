// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

interface IMasterChef {
  /// @dev functions return information. no states changed.
  function poolLength() external view returns (uint256);

  function pendingWing(address _stakeToken, address _user) external view returns (uint256);

  function userInfo(address _stakeToken, address _user)
    external
    view
    returns (
      uint256,
      uint256,
      address
    );

  function devAddr() external view returns (address);
  function refAddr() external view returns (address);

  /// @dev configuration functions
  function addPool(address _stakeToken, uint256 _allocPoint) external;

  function setPool(address _stakeToken, uint256 _allocPoint) external;

  function updatePool(address _stakeToken) external;

  function removePool(address _stakeToken) external;

  /// @dev user interaction functions
  function deposit(
    address _for,
    address _stakeToken,
    uint256 _amount
  ) external;

  function withdraw(
    address _for,
    address _stakeToken,
    uint256 _amount
  ) external;

  function depositWing(address _for, uint256 _amount) external;

  function withdrawWing(address _for, uint256 _amount) external;

  function harvest(address _for, address _stakeToken) external;

  function harvest(address _for, address[] calldata _stakeToken) external;

  function emergencyWithdraw(address _for, address _stakeToken) external;

  function mintExtraReward(
    address _stakeToken,
    address _to,
    uint256 _amount
  ) external;
}
