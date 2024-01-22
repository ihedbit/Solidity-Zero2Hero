// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import "./interfaces/IShipBoosterConfig.sol";
import "../nft/interfaces/IWingSwapNFT.sol";

contract ShipBoosterConfig is IShipBoosterConfig, OwnableUpgradeable, ReentrancyGuardUpgradeable {
  using SafeERC20Upgradeable for IERC20Upgradeable;
  using SafeMathUpgradeable for uint256;

  struct ShipBoosterNFTInfo {
    address nftAddress;
    uint256 tokenId;
  }

  struct ShipBoosterEnergyInfo {
    uint256 maxEnergy;
    uint256 currentEnergy;
    uint256 boostBps;
    uint256 updatedAt;
  }

  struct CategoryEnergyInfo {
    uint256 maxEnergy;
    uint256 boostBps;
    uint256 updatedAt;
  }

  struct ShipBoosterNFTParams {
    address nftAddress;
    uint256 nftTokenId;
    uint256 maxEnergy;
    uint256 boostBps;
  }

  struct CategoryNFTParams {
    address nftAddress;
    uint256 nftCategoryId;
    uint256 maxEnergy;
    uint256 boostBps;
  }

  struct ShipBoosterAllowance {
    address nftAddress;
    uint256 nftTokenId;
    bool allowance;
  }

  struct ShipBoosterAllowanceParams {
    address stakingToken;
    ShipBoosterAllowance[] allowance;
  }

  struct CategoryAllowance {
    address nftAddress;
    uint256 nftCategoryId;
    bool allowance;
  }

  struct CategoryAllowanceParams {
    address stakingToken;
    CategoryAllowance[] allowance;
  }

  mapping(address => mapping(uint256 => ShipBoosterEnergyInfo)) public shipboosterEnergyInfo;
  mapping(address => mapping(uint256 => CategoryEnergyInfo)) public categoryEnergyInfo;

  mapping(address => mapping(address => mapping(uint256 => bool))) public shipboosterNftAllowanceConfig;
  mapping(address => mapping(address => mapping(uint256 => bool))) public categoryNftAllowanceConfig;

  mapping(address => bool) public override stakeTokenAllowance;

  mapping(address => bool) public override callerAllowance;

  event UpdateCurrentEnergy(
    address indexed nftAddress,
    uint256 indexed nftTokenId,
    uint256 indexed updatedCurrentEnergy
  );
  event SetStakeTokenAllowance(address indexed stakingToken, bool isAllowed);
  event SetShipBoosterNFTEnergyInfo(
    address indexed nftAddress,
    uint256 indexed nftTokenId,
    uint256 maxEnergy,
    uint256 currentEnergy,
    uint256 boostBps
  );
  event SetCallerAllowance(address indexed caller, bool isAllowed);
  event SetShipBoosterNFTAllowance(
    address indexed stakeToken,
    address indexed nftAddress,
    uint256 indexed nftTokenId,
    bool isAllowed
  );
  event SetCategoryNFTEnergyInfo(
    address indexed nftAddress,
    uint256 indexed nftCategoryId,
    uint256 maxEnergy,
    uint256 boostBps
  );
  event SetCategoryNFTAllowance(
    address indexed stakeToken,
    address indexed nftAddress,
    uint256 indexed nftCategoryId,
    bool isAllowed
  );

  /// @notice only eligible caller can continue the execution
  modifier onlyCaller() {
    require(callerAllowance[msg.sender], "ShipBoosterConfig::onlyCaller::only eligible caller");
    _;
  }

  function initialize() external initializer {
    OwnableUpgradeable.__Ownable_init();
    ReentrancyGuardUpgradeable.__ReentrancyGuard_init();
  }

  /// @notice getter function for energy info
  /// @dev check if the shipbooster energy existed,
  /// if not, it should be non-preminted version, so use categoryEnergyInfo to get a current, maxEnergy instead
  function energyInfo(address _nftAddress, uint256 _nftTokenId)
    public
    view
    override
    returns (
      uint256 maxEnergy,
      uint256 currentEnergy,
      uint256 boostBps
    )
  {
    ShipBoosterEnergyInfo memory shipboosterInfo = shipboosterEnergyInfo[_nftAddress][_nftTokenId];
    // if there is no preset shipbooster energy info, use preset in category info
    // presume that it's not a preminted nft
    if (shipboosterInfo.updatedAt == 0) {
      uint256 categoryId = IWingSwapNFT(_nftAddress).wingswapNFTToCategory(_nftTokenId);
      CategoryEnergyInfo memory categoryInfo = categoryEnergyInfo[_nftAddress][categoryId];
      return (categoryInfo.maxEnergy, categoryInfo.maxEnergy, categoryInfo.boostBps);
    }
    // if there is an updatedAt, it's a preminted nft
    return (shipboosterInfo.maxEnergy, shipboosterInfo.currentEnergy, shipboosterInfo.boostBps);
  }

  /// @notice function for updating a curreny energy of the specified nft
  /// @dev Only eligible caller can freely update an energy
  /// @param _nftAddress a composite key for nft
  /// @param _nftTokenId a composite key for nft
  /// @param _energyToBeConsumed an energy to be consumed
  function consumeEnergy(
    address _nftAddress,
    uint256 _nftTokenId,
    uint256 _energyToBeConsumed
  ) external override onlyCaller {
    require(_nftAddress != address(0), "ShipBoosterConfig::consumeEnergy::_nftAddress must not be address(0)");
    ShipBoosterEnergyInfo storage energy = shipboosterEnergyInfo[_nftAddress][_nftTokenId];

    if (energy.updatedAt == 0) {
      uint256 categoryId = IWingSwapNFT(_nftAddress).wingswapNFTToCategory(_nftTokenId);
      CategoryEnergyInfo memory categoryEnergy = categoryEnergyInfo[_nftAddress][categoryId];
      require(categoryEnergy.updatedAt != 0, "ShipBoosterConfig::consumeEnergy:: invalid nft to be updated");
      energy.maxEnergy = categoryEnergy.maxEnergy;
      energy.boostBps = categoryEnergy.boostBps;
      energy.currentEnergy = categoryEnergy.maxEnergy;
    }

    energy.currentEnergy = energy.currentEnergy.sub(_energyToBeConsumed);
    energy.updatedAt = block.timestamp;

    emit UpdateCurrentEnergy(_nftAddress, _nftTokenId, energy.currentEnergy);
  }

  /// @notice set stake token allowance
  /// @dev only owner can call this function
  /// @param _stakeToken a specified token
  /// @param _isAllowed a flag indicating the allowance of a specified token
  function setStakeTokenAllowance(address _stakeToken, bool _isAllowed) external onlyOwner {
    require(_stakeToken != address(0), "ShipBoosterConfig::setStakeTokenAllowance::_stakeToken must not be address(0)");
    stakeTokenAllowance[_stakeToken] = _isAllowed;

    emit SetStakeTokenAllowance(_stakeToken, _isAllowed);
  }

  /// @notice set caller allowance - only eligible caller can call a function
  /// @dev only eligible callers can call this function
  /// @param _caller a specified caller
  /// @param _isAllowed a flag indicating the allowance of a specified token
  function setCallerAllowance(address _caller, bool _isAllowed) external onlyOwner {
    require(_caller != address(0), "ShipBoosterConfig::setCallerAllowance::_caller must not be address(0)");
    callerAllowance[_caller] = _isAllowed;

    emit SetCallerAllowance(_caller, _isAllowed);
  }

  /// @notice A function for setting shipbooster NFT energy info as a batch
  /// @param _params a list of ShipBoosterNFTParams [{nftAddress, nftTokenId, maxEnergy, boostBps}]
  function setBatchShipBoosterNFTEnergyInfo(ShipBoosterNFTParams[] calldata _params) external onlyOwner {
    for (uint256 i = 0; i < _params.length; ++i) {
      _setShipBoosterNFTEnergyInfo(_params[i]);
    }
  }

  /// @notice A function for setting shipbooster NFT energy info
  /// @param _param a ShipBoosterNFTParams {nftAddress, nftTokenId, maxEnergy, boostBps}
  function setShipBoosterNFTEnergyInfo(ShipBoosterNFTParams calldata _param) external onlyOwner {
    _setShipBoosterNFTEnergyInfo(_param);
  }

  /// @dev An internal function for setting shipbooster NFT energy info
  /// @param _param a ShipBoosterNFTParams {nftAddress, nftTokenId, maxEnergy, boostBps}
  function _setShipBoosterNFTEnergyInfo(ShipBoosterNFTParams calldata _param) internal {
    shipboosterEnergyInfo[_param.nftAddress][_param.nftTokenId] = ShipBoosterEnergyInfo({
      maxEnergy: _param.maxEnergy,
      currentEnergy: _param.maxEnergy,
      boostBps: _param.boostBps,
      updatedAt: block.timestamp
    });

    emit SetShipBoosterNFTEnergyInfo(
      _param.nftAddress,
      _param.nftTokenId,
      _param.maxEnergy,
      _param.maxEnergy,
      _param.boostBps
    );
  }

  /// @notice A function for setting category NFT energy info as a batch, used for nft with non-preminted
  /// @param _params a list of CategoryNFTParams [{nftAddress, nftTokenId, maxEnergy, boostBps}]
  function setBatchCategoryNFTEnergyInfo(CategoryNFTParams[] calldata _params) external onlyOwner {
    for (uint256 i = 0; i < _params.length; ++i) {
      _setCategoryNFTEnergyInfo(_params[i]);
    }
  }

  /// @notice A function for setting category NFT energy info, used for nft with non-preminted
  /// @param _param a CategoryNFTParams {nftAddress, nftTokenId, maxEnergy, boostBps}
  function setCategoryNFTEnergyInfo(CategoryNFTParams calldata _param) external onlyOwner {
    _setCategoryNFTEnergyInfo(_param);
  }

  /// @dev An internal function for setting category NFT energy info, used for nft with non-preminted
  /// @param _param a CategoryNFTParams {nftAddress, nftCategoryId, maxEnergy, boostBps}
  function _setCategoryNFTEnergyInfo(CategoryNFTParams calldata _param) internal {
    categoryEnergyInfo[_param.nftAddress][_param.nftCategoryId] = CategoryEnergyInfo({
      maxEnergy: _param.maxEnergy,
      boostBps: _param.boostBps,
      updatedAt: block.timestamp
    });

    emit SetCategoryNFTEnergyInfo(_param.nftAddress, _param.nftCategoryId, _param.maxEnergy, _param.boostBps);
  }

  /// @dev A function setting if a particular stake token should allow a specified nft category to be boosted (used with non-preminted nft)
  /// @param _param a CategoryAllowanceParams {stakingToken, [{nftAddress, nftCategoryId, allowance;}]}
  function setStakingTokenCategoryAllowance(CategoryAllowanceParams calldata _param) external onlyOwner {
    for (uint256 i = 0; i < _param.allowance.length; ++i) {
      require(
        stakeTokenAllowance[_param.stakingToken],
        "ShipBoosterConfig::setStakingTokenCategoryAllowance:: bad staking token"
      );
      categoryNftAllowanceConfig[_param.stakingToken][_param.allowance[i].nftAddress][
        _param.allowance[i].nftCategoryId
      ] = _param.allowance[i].allowance;

      emit SetCategoryNFTAllowance(
        _param.stakingToken,
        _param.allowance[i].nftAddress,
        _param.allowance[i].nftCategoryId,
        _param.allowance[i].allowance
      );
    }
  }

  /// @dev A function setting if a particular stake token should allow a specified nft to be boosted
  /// @param _param a ShipBoosterAllowanceParams {stakingToken, [{nftAddress, nftTokenId,allowance;}]}
  function setStakingTokenShipBoosterAllowance(ShipBoosterAllowanceParams calldata _param) external onlyOwner {
    for (uint256 i = 0; i < _param.allowance.length; ++i) {
      require(
        stakeTokenAllowance[_param.stakingToken],
        "ShipBoosterConfig::setStakingTokenShipBoosterAllowance:: bad staking token"
      );
      shipboosterNftAllowanceConfig[_param.stakingToken][_param.allowance[i].nftAddress][
        _param.allowance[i].nftTokenId
      ] = _param.allowance[i].allowance;

      emit SetShipBoosterNFTAllowance(
        _param.stakingToken,
        _param.allowance[i].nftAddress,
        _param.allowance[i].nftTokenId,
        _param.allowance[i].allowance
      );
    }
  }

  /// @notice use for checking whether or not this nft supports an input stakeToken
  /// @dev if not support when checking with token, need to try checking with category level (categoryNftAllowanceConfig) as well since there should not be shipboosterNftAllowanceConfig in non-preminted nft
  function shipboosterNftAllowance(
    address _stakeToken,
    address _nftAddress,
    uint256 _nftTokenId
  ) external view override returns (bool) {
    if (!shipboosterNftAllowanceConfig[_stakeToken][_nftAddress][_nftTokenId]) {
      uint256 categoryId = IWingSwapNFT(_nftAddress).wingswapNFTToCategory(_nftTokenId);
      return categoryNftAllowanceConfig[_stakeToken][_nftAddress][categoryId];
    }
    return true;
  }
}
