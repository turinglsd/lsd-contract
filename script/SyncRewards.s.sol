// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";

interface IToken {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IWtuNEO {
    function syncRewards() external;
}

contract SyncRewardsScript is Script {
    address constant tuNEO = 0xE2E9fB0f2A42ceECa5d3c6C798dd115B616a9581;
    address constant wtuNEO = 0xfeFcA9C2FC70b0Ca71acdbA1920d8CD5485547f8;

    function run() public {
        // Load private key
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting to chain
        vm.startBroadcast(deployerPrivateKey);

        // Record gas before first transfer
        uint256 gasBeforeFirstTransfer = gasleft();

        // Transfer 12 ether worth of tuNEO to wtuNEO (12 * 10^18)
        bool success1 = IToken(tuNEO).transfer(wtuNEO, 12 ether);
        require(success1, "First transfer of 12 ether worth of tuNEO failed");

        // Log gas consumption for the first transfer
        uint256 gasAfterFirstTransfer = gasleft();
        console.log("Gas used for first transfer:", gasBeforeFirstTransfer - gasAfterFirstTransfer);

        // Check balance of wtuNEO after the transfer
        uint256 balanceAfterFirstTransfer = IToken(tuNEO).balanceOf(wtuNEO);
        console.log("wtuNEO balance after first transfer:", balanceAfterFirstTransfer);

        // Advance time by 1 second
        vm.warp(block.timestamp + 1);

        // Record gas before first syncRewards
        uint256 gasBeforeFirstSync = gasleft();

        // Sync rewards on wtuNEO
        try IWtuNEO(wtuNEO).syncRewards() {
            console.log("First syncRewards() successful");
        } catch {
            revert("First syncRewards() failed");
        }

        // Log gas consumption for first syncRewards
        uint256 gasAfterFirstSync = gasleft();
        console.log("Gas used for first syncRewards:", gasBeforeFirstSync - gasAfterFirstSync);

        // Record gas before second transfer
        uint256 gasBeforeSecondTransfer = gasleft();

        // Transfer another 12 tuNEO (12 * 10^18)
        bool success2 = IToken(tuNEO).transfer(wtuNEO, 12 ether);
        require(success2, "Second transfer of 12 tuNEO failed");

        // Log gas consumption for the second transfer
        uint256 gasAfterSecondTransfer = gasleft();
        console.log("Gas used for second transfer:", gasBeforeSecondTransfer - gasAfterSecondTransfer);

        // Check balance of wtuNEO after the second transfer
        uint256 balanceAfterSecondTransfer = IToken(tuNEO).balanceOf(wtuNEO);
        console.log("wtuNEO balance after second transfer:", balanceAfterSecondTransfer);

        // Advance time by 1 more second
        vm.warp(block.timestamp + 2);

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
