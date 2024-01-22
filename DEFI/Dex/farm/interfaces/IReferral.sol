// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.12;

interface IReferral {
    function updateMasterChef(address _masterChef) external;

    function activate(address referrer) external;
    function activateBySign(address referee, address referrer, uint8 v, bytes32 r, bytes32 s) external;
    function isActivated(address _address) external view returns (bool);

    function updateReferralReward(address accountAddress, uint256 reward) external;

    function claimReward() external;
}