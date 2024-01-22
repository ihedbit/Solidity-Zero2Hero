// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "../farm/interfaces/IMasterChef.sol";
import "../farm/interfaces/IMasterChefCallback.sol";
import "./interfaces/IShipBoosterConfig.sol";
import "./interfaces/IWingOwnerToken.sol";
import "./interfaces/IWingSwapNFT.sol";

contract WingNFT is
  IWingSwapNFT,
  ERC721PausableUpgradeable,
  OwnableUpgradeable,
  AccessControlUpgradeable,
  ReentrancyGuardUpgradeable,
  IMasterChefCallback
{
  using CountersUpgradeable for CountersUpgradeable.Counter;
  using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
  using SafeERC20Upgradeable for IERC20Upgradeable;

  bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE"); // role for setting up non-sensitive data
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE"); // role for minting stuff (owner + some delegated contract eg nft market)

  struct Category {
    string name;
    string categoryURI; // category URI, a super set of token's uri (it can be either uri or a path (if specify a base URI))
    uint256 timestamp;
  }

  // Used for generating the tokenId of new NFT minted
  CountersUpgradeable.Counter private _tokenIds;

  // Used for incrementing category id
  CountersUpgradeable.Counter private _categoryIds;

  // Map the wingName for a tokenId
  mapping(uint256 => string) public override wingNames;

  mapping(uint256 => Category) public override categoryInfo;

  mapping(uint256 => uint256) public override wingswapNFTToCategory;

  mapping(uint256 => EnumerableSetUpgradeable.UintSet) private _categoryToWingSwapNFTList;

  mapping(uint256 => string) private _tokenURIs;

  mapping(uint256 => IWingOwnerToken) public ogOwnerToken;

  IMasterChef public masterChef;
  IERC20Upgradeable public wing;
  mapping(uint256 => mapping(address => EnumerableSetUpgradeable.UintSet)) internal _userStakeTokenIds;

  event AddCategoryInfo(uint256 indexed id, string name, string uri);
  event UpdateCategoryInfo(uint256 indexed id, string prevName, string newName, string newURI);
  event SetWingName(uint256 indexed tokenId, string prevName, string newName);
  event SetTokenURI(uint256 indexed tokenId, string indexed prevURI, string indexed currentURI);
  event SetBaseURI(string indexed prevURI, string indexed currentURI);
  event SetTokenCategory(uint256 indexed tokenId, uint256 indexed categoryId);
  event Pause();
  event Unpause();
  event SetOgOwnerToken(uint256 indexed categoryId, address indexed ogOwnerToken);
  event Harvest(address indexed user, uint256 indexed categoryId, uint256 balance);
  event Stake(address indexed user, uint256 indexed categoryId, uint256 tokenId);
  event Unstake(address indexed user, uint256 indexed categoryId, uint256 tokenId);

  function initialize(
    string memory _baseURI,
    IERC20Upgradeable _wing,
    IMasterChef _masterChef
  ) external initializer {
    ERC721Upgradeable.__ERC721_init("OG NFT", "LOG");
    ERC721PausableUpgradeable.__ERC721Pausable_init();
    OwnableUpgradeable.__Ownable_init();
    AccessControlUpgradeable.__AccessControl_init();

    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(GOVERNANCE_ROLE, _msgSender());
    _setupRole(MINTER_ROLE, _msgSender());
    _setBaseURI(_baseURI);
    masterChef = _masterChef;
    wing = _wing;
  }

  /// @notice check whether this token's category id has an og owner token set
  modifier withOGOwnerToken(uint256 _tokenId) {
    require(
      address(ogOwnerToken[wingswapNFTToCategory[_tokenId]]) != address(0),
      "WingNFT::withOGOwnerToken:: og owner token not set"
    );
    _;
  }

  /// @dev only the one having a GOVERNANCE_ROLE can continue an execution
  modifier onlyGovernance() {
    require(hasRole(GOVERNANCE_ROLE, _msgSender()), "WingNFT::onlyGovernance::only GOVERNANCE role");
    _;
  }

  /// @dev only the one having a MINTER_ROLE can continue an execution
  modifier onlyMinter() {
    require(hasRole(MINTER_ROLE, _msgSender()), "WingNFT::onlyMinter::only MINTER role");
    _;
  }

  modifier onlyExistingCategoryId(uint256 _categoryId) {
    require(_categoryIds.current() >= _categoryId, "WingNFT::onlyExistingCategoryId::categoryId not existed");
    _;
  }

  function userStakeTokenIds(uint256 _categoryId, address _user) external view returns (uint256[] memory) {
    bytes32[] storage _values = _userStakeTokenIds[_categoryId][_user]._inner._values;
    uint256[] memory _tokenIds = new uint256[](_values.length);
    for (uint256 i = 0; i < _values.length; i++) {
      _tokenIds[i] = uint256(_values[i]);
    }
    return _tokenIds;
  }

  /// @notice getter function for getting a token id list with respect to category Id
  /// @param _categoryId category id
  /// @return return alist of nft tokenId
  function categoryToWingSwapNFTList(uint256 _categoryId)
    external
    view
    override
    onlyExistingCategoryId(_categoryId)
    returns (uint256[] memory)
  {
    uint256[] memory tokenIds = new uint256[](_categoryToWingSwapNFTList[_categoryId].length());
    for (uint256 i = 0; i < _categoryToWingSwapNFTList[_categoryId].length(); i++) {
      tokenIds[i] = _categoryToWingSwapNFTList[_categoryId].at(i);
    }
    return tokenIds;
  }

  /// @notice return latest token id
  /// @return uint256 of the current token id
  function currentTokenId() public view override returns (uint256) {
    return _tokenIds.current();
  }

  /// @notice return latest category id
  /// @return uint256 of the current category id
  function currentCategoryId() public view override returns (uint256) {
    return _categoryIds.current();
  }

  /// @notice add category (group of tokens)
  /// @param _name a name of a category
  /// @param _uri category URI, a super set of token's uri (it can be either uri or a path (if specify a base URI))
  function addCategoryInfo(string memory _name, string memory _uri) external onlyGovernance {
    uint256 newId = _categoryIds.current();
    _categoryIds.increment();
    categoryInfo[newId] = Category({ name: _name, timestamp: block.timestamp, categoryURI: _uri });

    emit AddCategoryInfo(newId, _name, _uri);
  }

  /// @notice view function for category URI
  /// @param _categoryId category id
  function categoryURI(uint256 _categoryId)
    external
    view
    override
    onlyExistingCategoryId(_categoryId)
    returns (string memory)
  {
    string memory _categoryURI = categoryInfo[_categoryId].categoryURI;
    string memory base = baseURI();

    // If there is no base URI, return the category URI.
    if (bytes(base).length == 0) {
      return _categoryURI;
    }
    // If both are set, concatenate the baseURI and categoryURI (via abi.encodePacked).
    if (bytes(_categoryURI).length > 0) {
      return string(abi.encodePacked(base, _categoryURI));
    }
    // If there is a baseURI but no categoryURI, concatenate the categoryId to the baseURI.
    return string(abi.encodePacked(base, _categoryId.toString()));
  }

  /**
   * @dev overrided tokenURI with a categoryURI replacement feature
   * @param _tokenId - token id
   */
  function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override(ERC721Upgradeable, IERC721MetadataUpgradeable)
    returns (string memory)
  {
    require(_exists(_tokenId), "WingNFT::tokenURI:: token not existed");

    string memory _tokenURI = _tokenURIs[_tokenId];
    string memory base = baseURI();

    // If there is no base URI, return the token URI.
    if (bytes(base).length == 0) {
      return _tokenURI;
    }
    // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
    if (bytes(_tokenURI).length > 0) {
      return string(abi.encodePacked(base, _tokenURI));
    }

    // If if category uri exists, use categoryURI as a tokenURI
    if (bytes(categoryInfo[wingswapNFTToCategory[_tokenId]].categoryURI).length > 0) {
      return string(abi.encodePacked(base, categoryInfo[wingswapNFTToCategory[_tokenId]].categoryURI));
    }

    // If there is a baseURI but neither have tokenURI nor categoryURI, concatenate the tokenID to the baseURI.
    return string(abi.encodePacked(base, _tokenId.toString()));
  }

  /// @notice update category (group of tokens)
  /// @param _categoryId a category id
  /// @param _newName a new updated name
  /// @param _newURI a new category URI
  function updateCategoryInfo(
    uint256 _categoryId,
    string memory _newName,
    string memory _newURI
  ) external onlyGovernance onlyExistingCategoryId(_categoryId) {
    Category storage category = categoryInfo[_categoryId];
    string memory prevName = category.name;
    category.name = _newName;
    category.categoryURI = _newURI;
    category.timestamp = block.timestamp;

    emit UpdateCategoryInfo(_categoryId, prevName, _newName, _newURI);
  }

  /// @notice update a token's categoryId
  /// @param _tokenId a token id to be updated
  /// @param _newCategoryId a new categoryId for the token
  function updateTokenCategory(uint256 _tokenId, uint256 _newCategoryId)
    external
    onlyGovernance
    onlyExistingCategoryId(_newCategoryId)
  {
    uint256 categoryIdToBeRemovedFrom = wingswapNFTToCategory[_tokenId];
    wingswapNFTToCategory[_tokenId] = _newCategoryId;
    require(
      _categoryToWingSwapNFTList[categoryIdToBeRemovedFrom].remove(_tokenId),
      "WingNFT::updateTokenCategory::tokenId not found"
    );
    require(_categoryToWingSwapNFTList[_newCategoryId].add(_tokenId), "WingNFT::updateTokenCategory::duplicated tokenId");

    emit SetTokenCategory(_tokenId, _newCategoryId);
  }

  /**
   * @dev Get the associated wingName for a unique tokenId.
   */
  function getWingNameOfTokenId(uint256 _tokenId) external view override returns (string memory) {
    return wingNames[_tokenId];
  }

  /**
   * @dev Mint NFT. Only the minter can call it.
   */
  function mint(
    address _to,
    uint256 _categoryId,
    string calldata _tokenURI
  ) public virtual override onlyMinter onlyExistingCategoryId(_categoryId) returns (uint256) {
    uint256 newId = _tokenIds.current();
    _tokenIds.increment();
    wingswapNFTToCategory[newId] = _categoryId;
    require(_categoryToWingSwapNFTList[_categoryId].add(newId), "WingNFT::mint::duplicated tokenId");
    _mint(address(this), newId);
    _setTokenURI(newId, _tokenURI);
    _stake(newId, _to);
    emit SetTokenCategory(newId, _categoryId);
    return newId;
  }

  function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal virtual override {
    require(_exists(_tokenId), "WingNFT::_setTokenURI::tokenId not found");
    string memory prevURI = _tokenURIs[_tokenId];
    _tokenURIs[_tokenId] = _tokenURI;

    emit SetTokenURI(_tokenId, prevURI, _tokenURI);
  }

  /**
   * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
   *
   * Requirements:
   *
   * - `tokenId` must exist.
   */
  function setTokenURI(uint256 _tokenId, string memory _tokenURI) external onlyGovernance {
    _setTokenURI(_tokenId, _tokenURI);
  }

  /**
   * @dev function to set the base URI for all token IDs. It is
   * automatically added as a prefix to the value returned in {tokenURI},
   * or to the token ID if {tokenURI} is empty.
   */
  function setBaseURI(string memory _baseURI) external onlyGovernance {
    string memory prevURI = baseURI();
    _setBaseURI(_baseURI);

    emit SetBaseURI(prevURI, _baseURI);
  }

  /**
   * @dev batch ming NFTs. Only the owner can call it.
   */
  function mintBatch(
    address _to,
    uint256 _categoryId,
    string calldata _tokenURI,
    uint256 _size
  ) external override onlyMinter onlyExistingCategoryId(_categoryId) returns (uint256[] memory tokenIds) {
    require(_size != 0, "WingNFT::mintBatch::size must be granter than zero");
    tokenIds = new uint256[](_size);
    for (uint256 i = 0; i < _size; ++i) {
      tokenIds[i] = mint(_to, _categoryId, _tokenURI);
    }
    return tokenIds;
  }

  /**
   * @dev Set a unique name for each tokenId. It is supposed to be called once.
   */
  function setWingName(uint256 _tokenId, string calldata _name) external onlyGovernance {
    string memory _prevName = wingNames[_tokenId];
    wingNames[_tokenId] = _name;

    emit SetWingName(_tokenId, _prevName, _name);
  }

  function pause() external onlyGovernance whenNotPaused {
    _pause();

    emit Pause();
  }

  function unpause() external onlyGovernance whenPaused {
    _unpause();

    emit Unpause();
  }

  /// @notice setCategoryOGOwnerToken for setting an ogOwnerToken with regard to a category id
  /// @param _categoryId - a category id
  /// @param _ogOwnerToken - BEP20 og token for staking at a master chef
  function setCategoryOGOwnerToken(uint256 _categoryId, address _ogOwnerToken) external onlyGovernance {
    ogOwnerToken[_categoryId] = IWingOwnerToken(_ogOwnerToken);

    emit SetOgOwnerToken(_categoryId, _ogOwnerToken);
  }

  /// @dev Internal function for withdrawing a boosted stake token and receive a reward from a master chef
  /// @param _categoryId specified category id
  /// @param _shares user's shares to be withdrawn
  function _withdrawFromMasterChef(uint256 _categoryId, uint256 _shares) internal {
    if (_shares == 0) return;
    masterChef.withdraw(_msgSender(), address(ogOwnerToken[_categoryId]), _shares);
  }

  /// @dev Internal function for harvest a reward from a master chef
  /// @param _user harvester
  /// @param _categoryId specified category Id
  function _harvestFromMasterChef(address _user, uint256 _categoryId) internal {
    address stakeToken = address(ogOwnerToken[_categoryId]);
    (uint256 userStakeAmount, , ) = masterChef.userInfo(stakeToken, _user);
    if (userStakeAmount == 0) {
      emit Harvest(_user, _categoryId, 0);
      return;
    }
    uint256 beforeReward = wing.balanceOf(_user);
    masterChef.harvest(_user, stakeToken);

    emit Harvest(_user, _categoryId, wing.balanceOf(_user).sub(beforeReward));
  }

  /// @notice for staking a stakeToken and receive some rewards
  /// @param _tokenId a tokenId
  function stake(uint256 _tokenId) external whenNotPaused nonReentrant withOGOwnerToken(_tokenId) {
    transferFrom(_msgSender(), address(this), _tokenId);
    _stake(_tokenId, _msgSender());
  }

  /// @dev internal function for stake
  function _stake(uint256 _tokenId, address _for) internal {
    uint256 categoryId = wingswapNFTToCategory[_tokenId];
    IWingOwnerToken stakeToken = ogOwnerToken[categoryId];
    _userStakeTokenIds[categoryId][_for].add(_tokenId);

    _harvestFromMasterChef(_for, categoryId);
    stakeToken.mint(address(this), 1 ether);
    IERC20Upgradeable(address(stakeToken)).safeApprove(address(masterChef), 1 ether);

    masterChef.deposit(_for, address(stakeToken), 1 ether);

    IERC20Upgradeable(address(stakeToken)).safeApprove(address(masterChef), 0);

    emit Stake(_for, categoryId, _tokenId);
  }

  /// @dev internal function for unstaking a stakeToken and receive some rewards
  /// @param _tokenId a tokenId
  function _unstake(uint256 _tokenId) internal {
    uint256 categoryId = wingswapNFTToCategory[_tokenId];
    require(
      _userStakeTokenIds[categoryId][_msgSender()].contains(_tokenId),
      "WingNFT::_unstake:: invalid token to be unstaked"
    );
    IWingOwnerToken stakeToken = ogOwnerToken[categoryId];
    _userStakeTokenIds[categoryId][_msgSender()].remove(_tokenId);

    _withdrawFromMasterChef(categoryId, 1 ether);
    stakeToken.burn(address(this), 1 ether);
    _transfer(address(this), _msgSender(), _tokenId);
    emit Unstake(_msgSender(), categoryId, _tokenId);
  }

  /// @dev function for unstaking a stakeToken and receive some rewards
  /// @param _tokenId a tokenId
  function unstake(uint256 _tokenId) external whenNotPaused withOGOwnerToken(_tokenId) nonReentrant {
    _unstake(_tokenId);
  }

  /// @notice function for harvesting the reward
  /// @param _categoryId a categoryId linked to an og owner token pool to be harvested
  function harvest(uint256 _categoryId) external whenNotPaused nonReentrant {
    require(address(ogOwnerToken[_categoryId]) != address(0), "WingNFT::harvest:: og owner token not set");
    _harvestFromMasterChef(_msgSender(), _categoryId);
  }

  /// @notice function for harvesting rewards in specified staking tokens
  /// @param _categoryIdParams a set of tokenId to be harvested
  function harvest(uint256[] calldata _categoryIdParams) external whenNotPaused nonReentrant {
    for (uint256 i = 0; i < _categoryIdParams.length; i++) {
      require(address(ogOwnerToken[_categoryIdParams[i]]) != address(0), "WingNFT::harvest:: og owner token not set");
      _harvestFromMasterChef(_msgSender(), _categoryIdParams[i]);
    }
  }

  /// @dev a notifier function for letting some observer call when some conditions met
  /// @dev currently, the caller will be a master chef calling before a wing lock
  function masterChefCall(
    address, /*stakeToken*/
    address, /*userAddr*/
    uint256 /*reward*/
  ) external override {
    return;
  }
}
