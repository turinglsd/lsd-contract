// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";

interface IToken {
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IWtuNEO {
    function syncRewards() external;
}

contract SyncRewardsScript is Script {
    address constant tuNEO = 0x02502acd5fbdeed132748b76993149685af4ea2a;
    address constant wtuNEO = 0x968f6ac64a274b2f04506d22e0b2bc8552011258;

    function run() public {
        // Load private key
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting to chain
        vm.startBroadcast(deployerPrivateKey);

        // Transfer 12 ether worth of tuNEO to wtuNEO
        IToken(tuNEO).transfer(wtuNEO, 12 ether);

        // Advance time by 1 second
        vm.warp(block.timestamp + 1);

        // Sync rewards on wtuNEO
        IWtuNEO(wtuNEO).syncRewards();

        // Transfer another 12 tuNEO (no ether this time)
        IToken(tuNEO).transfer(wtuNEO, 12);

        // Advance time by 1 more second
        vm.warp(block.timestamp + 2);

        // Sync rewards again
        IWtuNEO(wtuNEO).syncRewards();

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
