// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../library/LinkList.sol";
import "./interfaces/IWING.sol";
import "./interfaces/IStake.sol";
import "./interfaces/IMasterChef.sol";
import "./interfaces/IMasterChefCallback.sol";
import "./interfaces/IReferral.sol";

// MasterChef is the master of WING. He can make WING and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once WING is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract MasterChef is IMasterChef, OwnableUpgradeable, ReentrancyGuardUpgradeable {
  using SafeMathUpgradeable for uint256;
  using SafeERC20Upgradeable for IERC20Upgradeable;
  using LinkList for LinkList.List;
  using AddressUpgradeable for address;

  // Info of each user.
  struct UserInfo {
    uint256 amount; // How many Staking tokens the user has provided.
    uint256 rewardDebt; // Reward debt. See explanation below.
    address fundedBy;
  }

  // Info of each pool.
  struct PoolInfo {
    uint256 allocPoint; // How many allocation points assigned to this pool.
    uint256 lastRewardBlock; // Last block number that WING distribution occurs.
    uint256 accWingPerShare; // Accumulated WING per share, times 1e12. See below.
  }

  // WING token.
  IWING public wing;
  // Stake address.
  IStake public stake;
  // Dev address.
  address public override devAddr;
  uint256 public devBps;
  // Refferal address.
  address public override refAddr;
  uint256 public refBps;
  // WING per block.
  uint256 public wingPerBlock;
  // Bonus muliplier for early users.
  uint256 public bonusMultiplier;
  // Lock-up in BPS
  uint256 public lockUpBps;

  // Pool link list.
  LinkList.List public pools;
  // Info of each pool.
  mapping(address => PoolInfo) public poolInfo;
  // Info of each user that stakes Staking tokens.
  mapping(address => mapping(address => UserInfo)) public override userInfo;
  // Total allocation poitns. Must be the sum of all allocation points in all pools.
  uint256 public totalAllocPoint;
  // The block number when WING mining starts.
  uint256 public startBlock;

  // Does the pool allows some contracts to fund for an account.
  mapping(address => bool) public stakeTokenCallerAllowancePool;

  // list of contracts that the pool allows to fund.
  mapping(address => LinkList.List) public stakeTokenCallerContracts;

  event Deposit(address indexed funder, address indexed fundee, address indexed stakeToken, uint256 amount);
  event Withdraw(address indexed funder, address indexed fundee, address indexed stakeToken, uint256 amount);
  event EmergencyWithdraw(address indexed user, address indexed stakeToken, uint256 amount);

  event SetStakeTokenCallerAllowancePool(address indexed stakeToken, bool isAllowed);
  event AddStakeTokenCallerContract(address indexed stakeToken, address indexed caller);
  event SetWingPerBlock(uint256 prevWingPerBlock, uint256 currentWingPerBlock);
  event RemoveStakeTokenCallerContract(address indexed stakeToken, address indexed caller);
  event SetRefAddress(address indexed refAddress);
  event SetDevAddress(address indexed devAddress);
  event SetDevBps(uint256 devBps);
  event SetRefBps(uint256 refBps);
  event SetLockUpBps(uint256 lockUpBps);
  event UpdateMultiplier(uint256 bonusMultiplier);

  function initialize(
    IWING _wing,
    IStake _stake,
    address _devAddr,
    address _refAddr,
    uint256 _wingPerBlock,
    uint256 _startBlock
  ) external initializer {
    require(
      _devAddr != address(0) && _devAddr != address(1),
      "initializer: _devAddr must not be address(0) or address(1)"
    );
    require(
      _refAddr != address(0) && _refAddr != address(1),
      "initializer: _refAddr must not be address(0) or address(1)"
    );
    OwnableUpgradeable.__Ownable_init();
    ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

    bonusMultiplier = 1;
    wing = _wing;
    stake = _stake;
    devAddr = _devAddr;
    refAddr = _refAddr;
    wingPerBlock = _wingPerBlock;
    lockUpBps = 0;
    startBlock = _startBlock;
    devBps = 0;
    refBps = 0;
    pools.init();

    // add WING pool
    pools.add(address(_wing));
    poolInfo[address(_wing)] = PoolInfo({ allocPoint: 0, lastRewardBlock: startBlock, accWingPerShare: 0 });
    totalAllocPoint = 0;
  }

  // Only permitted funder can continue the execution
  modifier onlyPermittedTokenFunder(address _beneficiary, address _stakeToken) {
    require(_isFunder(_beneficiary, _stakeToken), "onlyPermittedTokenFunder: caller is not permitted");
    _;
  }

  // Only stake token caller contract can continue the execution (stakeTokenCaller must be a funder contract)
  modifier onlyStakeTokenCallerContract(address _stakeToken) {
    require(stakeTokenCallerContracts[_stakeToken].has(_msgSender()), "onlyStakeTokenCallerContract: bad caller");
    _;
  }

  // Set funder allowance for a stake token pool
  function setStakeTokenCallerAllowancePool(address _stakeToken, bool _isAllowed) external onlyOwner {
    stakeTokenCallerAllowancePool[_stakeToken] = _isAllowed;
    emit SetStakeTokenCallerAllowancePool(_stakeToken, _isAllowed);
  }

  // Setter function for adding stake token contract caller
  function addStakeTokenCallerContract(address _stakeToken, address _caller) external onlyOwner {
    require(
      stakeTokenCallerAllowancePool[_stakeToken],
      "addStakeTokenCallerContract: the pool doesn't allow a contract caller"
    );
    LinkList.List storage list = stakeTokenCallerContracts[_stakeToken];
    if (list.getNextOf(LinkList.start) == LinkList.empty) {
      list.init();
    }
    list.add(_caller);
    emit AddStakeTokenCallerContract(_stakeToken, _caller);
  }

  // Setter function for removing stake token contract caller
  function removeStakeTokenCallerContract(address _stakeToken, address _caller) external onlyOwner {
    require(
      stakeTokenCallerAllowancePool[_stakeToken],
      "removeStakeTokenCallerContract: the pool doesn't allow a contract caller"
    );
    LinkList.List storage list = stakeTokenCallerContracts[_stakeToken];
    list.remove(_caller, list.getPreviousOf(_caller));
    emit RemoveStakeTokenCallerContract(_stakeToken, _caller);
  }

  function setDevAddress(address _devAddr) external onlyOwner {
    require(
      _devAddr != address(0) && _devAddr != address(1),
      "setDevAddress: _devAddr must not be address(0) or address(1)"
    );
    devAddr = _devAddr;
    emit SetDevAddress(_devAddr);
  }

  function setRefAddress(address _refAddr) external onlyOwner {
    require(
      _refAddr != address(0) && _refAddr != address(1),
      "setRefAddress: _refAddr must not be address(0) or address(1)"
    );
    refAddr = _refAddr;
    emit SetRefAddress(_refAddr);
  }

  // Set WING per block.
  function setWingPerBlock(uint256 _wingPerBlock) external onlyOwner {
    massUpdatePools();
    uint256 prevWingPerBlock = wingPerBlock;
    wingPerBlock = _wingPerBlock;
    emit SetWingPerBlock(prevWingPerBlock, wingPerBlock);
  }

  function setDevBps(uint256 _devBps) external onlyOwner {
    require(_devBps <= 1000, "setDevBps::bad devBps");
    massUpdatePools();
    devBps = _devBps;
    emit SetDevBps(_devBps);
  }

  function setRefBps(uint256 _refBps) external onlyOwner {
    require(_refBps <= 10000, "setRefBps::bad refBps");
    massUpdatePools();
    refBps = _refBps;
    emit SetRefBps(_refBps);
  }

  function setLockUpBps(uint256 _lockUpBps) external onlyOwner {
    require(_lockUpBps <= 10000, "setLockUpBps::bad lockUpBps");
    massUpdatePools();
    lockUpBps = _lockUpBps;
    emit SetLockUpBps(_lockUpBps);
  }

  // Add a pool. Can only be called by the owner.
  function addPool(address _stakeToken, uint256 _allocPoint) external override onlyOwner {
    require(
      _stakeToken != address(0) && _stakeToken != address(1),
      "addPool: _stakeToken must not be address(0) or address(1)"
    );
    require(!pools.has(_stakeToken), "addPool: _stakeToken duplicated");

    massUpdatePools();

    uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
    totalAllocPoint = totalAllocPoint.add(_allocPoint);
    pools.add(_stakeToken);
    poolInfo[_stakeToken] = PoolInfo({ allocPoint: _allocPoint, lastRewardBlock: lastRewardBlock, accWingPerShare: 0 });
  }

  // Update the given pool's WING allocation point. Can only be called by the owner.
  function setPool(address _stakeToken, uint256 _allocPoint) external override onlyOwner {
    require(
      _stakeToken != address(0) && _stakeToken != address(1),
      "setPool: _stakeToken must not be address(0) or address(1)"
    );
    require(pools.has(_stakeToken), "setPool: _stakeToken not in the list");

    massUpdatePools();

    totalAllocPoint = totalAllocPoint.sub(poolInfo[_stakeToken].allocPoint).add(_allocPoint);
    poolInfo[_stakeToken].allocPoint = _allocPoint;
  }

  // Remove pool. Can only be called by the owner.
  function removePool(address _stakeToken) external override onlyOwner {
    require(_stakeToken != address(wing), "removePool: can't remove WING pool");
    require(pools.has(_stakeToken), "removePool: pool not add yet");
    require(IERC20Upgradeable(_stakeToken).balanceOf(address(this)) == 0, "removePool: pool not empty");

    massUpdatePools();

    totalAllocPoint = totalAllocPoint.sub(poolInfo[_stakeToken].allocPoint);
    pools.remove(_stakeToken, pools.getPreviousOf(_stakeToken));
    poolInfo[_stakeToken].allocPoint = 0;
    poolInfo[_stakeToken].lastRewardBlock = 0;
    poolInfo[_stakeToken].accWingPerShare = 0;
  }

  // Return the length of poolInfo
  function poolLength() external view override returns (uint256) {
    return pools.length();
  }

  // Return reward multiplier over the given _from to _to block.
  function getMultiplier(uint256 _lastRewardBlock, uint256 _currentBlock) private view returns (uint256) {
    return _currentBlock.sub(_lastRewardBlock).mul(bonusMultiplier);
  }

  function updateMultiplier(uint256 _bonusMultiplier) public onlyOwner {
    bonusMultiplier = _bonusMultiplier;
    emit UpdateMultiplier(_bonusMultiplier);
  }

  // Validating if a msg sender is a funder
  function _isFunder(address _beneficiary, address _stakeToken) internal view returns (bool) {
    if (stakeTokenCallerAllowancePool[_stakeToken]) return stakeTokenCallerContracts[_stakeToken].has(_msgSender());
    return _beneficiary == _msgSender();
  }

  // View function to see pending WINGs on frontend.
  function pendingWing(address _stakeToken, address _user) external view override returns (uint256) {
    PoolInfo storage pool = poolInfo[_stakeToken];
    UserInfo storage user = userInfo[_stakeToken][_user];
    uint256 accWingPerShare = pool.accWingPerShare;
    uint256 totalStakeToken = IERC20Upgradeable(_stakeToken).balanceOf(address(this));
    if (block.number > pool.lastRewardBlock && totalStakeToken != 0) {
      uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
      uint256 wingReward = multiplier.mul(wingPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
      accWingPerShare = accWingPerShare.add(wingReward.mul(1e12).div(totalStakeToken));
    }
    return user.amount.mul(accWingPerShare).div(1e12).sub(user.rewardDebt);
  }

  // Update reward variables for all pools. Be careful of gas spending!
  function massUpdatePools() public {
    address current = pools.next[LinkList.start];
    while (current != LinkList.end) {
      updatePool(current);
      current = pools.getNextOf(current);
    }
  }

  // Update reward variables of the given pool to be up-to-date.
  function updatePool(address _stakeToken) public override {
    PoolInfo storage pool = poolInfo[_stakeToken];
    if (block.number <= pool.lastRewardBlock) {
      return;
    }
    uint256 totalStakeToken = IERC20Upgradeable(_stakeToken).balanceOf(address(this));
    if (totalStakeToken == 0) {
      pool.lastRewardBlock = block.number;
      return;
    }
    uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
    uint256 wingReward = multiplier.mul(wingPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
    wing.mint(devAddr, wingReward.mul(devBps).div(10000));
    wing.mint(address(stake), wingReward.mul(refBps).div(10000));
    wing.mint(address(stake), wingReward);
    pool.accWingPerShare = pool.accWingPerShare.add(wingReward.mul(1e12).div(totalStakeToken));
    pool.lastRewardBlock = block.number;
  }

  // Deposit token to MasterChef for WING allocation.
  function deposit(
    address _for,
    address _stakeToken,
    uint256 _amount
  ) external override onlyPermittedTokenFunder(_for, _stakeToken) nonReentrant {
    require(
      _stakeToken != address(0) && _stakeToken != address(1),
      "setPool: _stakeToken must not be address(0) or address(1)"
    );
    require(_stakeToken != address(wing), "deposit: use depositWing instead");
    require(pools.has(_stakeToken), "deposit: no pool");

    PoolInfo storage pool = poolInfo[_stakeToken];
    UserInfo storage user = userInfo[_stakeToken][_for];

    if (user.fundedBy != address(0)) require(user.fundedBy == _msgSender(), "deposit: only funder");

    updatePool(_stakeToken);

    if (user.amount > 0) _harvest(_for, _stakeToken);
    if (user.fundedBy == address(0)) user.fundedBy = _msgSender();
    if (_amount > 0) {
      IERC20Upgradeable(_stakeToken).safeTransferFrom(address(_msgSender()), address(this), _amount);
      user.amount = user.amount.add(_amount);
    }
    user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
    emit Deposit(_msgSender(), _for, _stakeToken, _amount);
  }

  // Withdraw token from MasterChef.
  function withdraw(
    address _for,
    address _stakeToken,
    uint256 _amount
  ) external override nonReentrant {
    require(
      _stakeToken != address(0) && _stakeToken != address(1),
      "setPool: _stakeToken must not be address(0) or address(1)"
    );
    require(_stakeToken != address(wing), "withdraw: use withdrawWing instead");
    require(pools.has(_stakeToken), "withdraw: no pool");

    PoolInfo storage pool = poolInfo[_stakeToken];
    UserInfo storage user = userInfo[_stakeToken][_for];

    require(user.fundedBy == _msgSender(), "withdraw: only funder");
    require(user.amount >= _amount, "withdraw: not good");

    updatePool(_stakeToken);
    _harvest(_for, _stakeToken);

    if (_amount > 0) {
      user.amount = user.amount.sub(_amount);
      IERC20Upgradeable(_stakeToken).safeTransfer(_msgSender(), _amount);
    }
    user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
    if (user.amount == 0) user.fundedBy = address(0);
    emit Withdraw(_msgSender(), _for, _stakeToken, user.amount);
  }

  // Deposit WING to MasterChef.
  function depositWing(address _for, uint256 _amount)
    external
    override
    onlyPermittedTokenFunder(_for, address(wing))
    nonReentrant
  {
    PoolInfo storage pool = poolInfo[address(wing)];
    UserInfo storage user = userInfo[address(wing)][_for];

    if (user.fundedBy != address(0)) require(user.fundedBy == _msgSender(), "depositWing: bad sof");

    updatePool(address(wing));

    if (user.amount > 0) _harvest(_for, address(wing));
    if (user.fundedBy == address(0)) user.fundedBy = _msgSender();
    if (_amount > 0) {
      IERC20Upgradeable(address(wing)).safeTransferFrom(address(_msgSender()), address(this), _amount);
      user.amount = user.amount.add(_amount);
    }
    user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
    emit Deposit(_msgSender(), _for, address(wing), _amount);
  }

  // Withdraw WING
  function withdrawWing(address _for, uint256 _amount) external override nonReentrant {
    PoolInfo storage pool = poolInfo[address(wing)];
    UserInfo storage user = userInfo[address(wing)][_for];

    require(user.fundedBy == _msgSender(), "withdrawWing: only funder");
    require(user.amount >= _amount, "withdrawWing: not good");

    updatePool(address(wing));
    _harvest(_for, address(wing));

    if (_amount > 0) {
      user.amount = user.amount.sub(_amount);
      IERC20Upgradeable(address(wing)).safeTransfer(address(_msgSender()), _amount);
    }
    user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
    if (user.amount == 0) user.fundedBy = address(0);
    emit Withdraw(_msgSender(), _for, address(wing), user.amount);
  }

  // Harvest WING earned from a specific pool.
  function harvest(address _for, address _stakeToken) external override nonReentrant {
    PoolInfo storage pool = poolInfo[_stakeToken];
    UserInfo storage user = userInfo[_stakeToken][_for];

    updatePool(_stakeToken);
    _harvest(_for, _stakeToken);

    user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
  }

  // Harvest WING earned from pools.
  function harvest(address _for, address[] calldata _stakeTokens) external override nonReentrant {
    for (uint256 i = 0; i < _stakeTokens.length; i++) {
      PoolInfo storage pool = poolInfo[_stakeTokens[i]];
      UserInfo storage user = userInfo[_stakeTokens[i]][_for];
      updatePool(_stakeTokens[i]);
      _harvest(_for, _stakeTokens[i]);
      user.rewardDebt = user.amount.mul(pool.accWingPerShare).div(1e12);
    }
  }

  // Internal function to harvest WING
  function _harvest(address _for, address _stakeToken) internal {
    PoolInfo memory pool = poolInfo[_stakeToken];
    UserInfo memory user = userInfo[_stakeToken][_for];
    require(user.fundedBy == _msgSender(), "_harvest: only funder");
    require(user.amount > 0, "_harvest: nothing to harvest");
    uint256 pending = user.amount.mul(pool.accWingPerShare).div(1e12).sub(user.rewardDebt);
    require(pending <= wing.balanceOf(address(stake)), "_harvest: wait what.. not enough WING");
    stake.safeWingTransfer(_for, pending);
    if (stakeTokenCallerContracts[_stakeToken].has(_msgSender())) {
      _masterChefCallee(_msgSender(), _stakeToken, _for, pending);
    }
    _referralCallee(_for, pending);
    wing.lock(_for, pending.mul(lockUpBps).div(10000));
  }

  function _referralCallee(address _for, uint256 _pending) internal {
    if (!refAddr.isContract()) {
      return;
    }
    stake.safeWingTransfer(_for, _pending.mul(refBps).div(10000));
    (bool success, ) = refAddr.call(
      abi.encodeWithSelector(IReferral.updateReferralReward.selector, _for, _pending.mul(refBps).div(10000))
    );
    require(success, "_referralCallee:  failed to execute updateReferralReward");
  }

  // Observer function for those contract implementing onBeforeLock, execute an onBeforelock statement
  function _masterChefCallee(
    address _caller,
    address _stakeToken,
    address _for,
    uint256 _pending
  ) internal {
    if (!_caller.isContract()) {
      return;
    }
    (bool success, ) = _caller.call(
      abi.encodeWithSelector(IMasterChefCallback.masterChefCall.selector, _stakeToken, _for, _pending)
    );
    require(success, "_masterChefCallee:  failed to execute masterChefCall");
  }

  // Withdraw without caring about rewards. EMERGENCY ONLY.
  function emergencyWithdraw(address _for, address _stakeToken) external override nonReentrant {
    UserInfo storage user = userInfo[_stakeToken][_for];
    require(user.fundedBy == _msgSender(), "emergencyWithdraw: only funder");
    IERC20Upgradeable(_stakeToken).safeTransfer(address(_for), user.amount);

    emit EmergencyWithdraw(_for, _stakeToken, user.amount);

    user.amount = 0;
    user.rewardDebt = 0;
    user.fundedBy = address(0);
  }

  // This is a function for mining an extra amount of wing, should be called only by stake token caller contract (boosting purposed)
  function mintExtraReward(
    address _stakeToken,
    address _to,
    uint256 _amount
  ) external override onlyStakeTokenCallerContract(_stakeToken) {
    wing.mint(_to, _amount);
    wing.lock(_to, _amount.mul(lockUpBps).div(10000));
  }
}
