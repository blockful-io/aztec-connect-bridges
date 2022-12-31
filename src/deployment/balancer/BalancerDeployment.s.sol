// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec.
pragma solidity >=0.8.4;

import {BaseDeployment} from "../base/BaseDeployment.s.sol";
import {BalancerBridge} from "../../bridges/balancer/BalancerBridge.sol";

contract BalancerDeployment is BaseDeployment {
    address public constant BBAUSD = 0xA13a9247ea42D743238089903570127DdA72fE44;

    function deploy() public returns (address) {
        emit log("Deploying balancer bridge");

        vm.broadcast();
        BalancerBridge bridge = new BalancerBridge(address(ROLLUP_PROCESSOR), BBAUSD);

        emit log_named_address("balancer bridge deployed to", address(bridge));

        return address(bridge);
    }

    function deployAndList() public {
        address bridge = deploy();
        uint256 addressId = listBridge(bridge, 250000);
        emit log_named_uint("balancer bridge address id", addressId);
    }
}
