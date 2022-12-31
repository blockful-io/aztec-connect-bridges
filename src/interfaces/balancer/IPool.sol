// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;
pragma abicoder v2;

import {IVault} from "./IVault.sol";

interface IPool is IVault {
    /// @dev Returns the poolId for this pool
    /// @return The poolId for this pool
    function getPoolId() external view returns (bytes32);

    /// @dev Returns the vault that regards this pool
    /// @return The IVault instance
    function getVault() external view returns (IVault);
}
