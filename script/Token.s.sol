// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.33;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Token} from "../src/Token.sol";

contract TokenScript is Script {
    Token public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new Token("MyToken", "MTK", 18, 1000000);

        vm.stopBroadcast();
    }
}
