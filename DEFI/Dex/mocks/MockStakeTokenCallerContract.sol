// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../farm/interfaces/IMasterChefCallback.sol";
import "../farm/interfaces/IMasterChef.sol";

contract MockStakeTokenCallerContract is IMasterChefCallback {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  address public stakeToken;
  address public wing;
  IMasterChef public masterChef;

  event OnBeforeLock();

  constructor(
    address _wing,
    address _stakeToken,
    IMasterChef _masterChef
  ) public {
    wing = _wing;
    stakeToken = _stakeToken;
    masterChef = _masterChef;
  }

  function _withdrawFromMasterChef(IERC20 _stakeToken, uint256 _shares) internal returns (uint256 reward) {
    if (_shares == 0) return 0;
    uint256 stakeTokenBalance = _stakeToken.balanceOf(address(this));
    if (address(_stakeToken) == address(wing)) {
      masterChef.withdrawWing(msg.sender, _shares);
    } else {
      masterChef.withdraw(msg.sender, address(_stakeToken), _shares);
    }
    reward = address(wing) == address(_stakeToken)
      ? _stakeToken.balanceOf(address(this)).sub(stakeTokenBalance)
      : IERC20(wing).balanceOf(address(this));
    return reward;
  }

  function _harvestFromMasterChef(IERC20 _stakeToken) internal returns (uint256 reward) {
    uint256 stakeTokenBalance = _stakeToken.balanceOf(address(this));
    (uint256 userStakeAmount, , ) = masterChef.userInfo(address(address(_stakeToken)), msg.sender);

    if (userStakeAmount == 0) return 0;

    masterChef.harvest(msg.sender, address(_stakeToken));
    reward = address(wing) == address(_stakeToken)
      ? _stakeToken.balanceOf(address(this)).sub(stakeTokenBalance)
      : IERC20(wing).balanceOf(address(this));
    return reward;
  }

  function stake(IERC20 _stakeToken, uint256 _amount) external {
    _harvestFromMasterChef(_stakeToken);

    IERC20(_stakeToken).safeApprove(address(masterChef), uint256(-1));
    if (address(_stakeToken) == address(wing)) {
      masterChef.depositWing(msg.sender, _amount);
    } else {
      masterChef.deposit(msg.sender, address(_stakeToken), _amount);
    }
  }

  function _unstake(IERC20 _stakeToken, uint256 _amount) internal {
    _withdrawFromMasterChef(_stakeToken, _amount);
  }

  function unstake(address _stakeToken, uint256 _amount) external {
    _unstake(IERC20(_stakeToken), _amount);
  }

  function harvest(address _stakeToken) external {
    _harvest(_stakeToken);
  }

  function _harvest(address _stakeToken) internal {
    _harvestFromMasterChef(IERC20(_stakeToken));
  }

  function masterChefCall(
    address, /*stakeToken*/
    address, /*userAddr*/
    uint256 /*reward*/
  ) external override {
    emit OnBeforeLock();
  }
}
