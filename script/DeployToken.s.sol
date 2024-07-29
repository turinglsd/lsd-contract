// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TuNEO} from "src/tuNEO.sol";
import {WtuNEO, ERC20} from "src/wtuNEO.sol";
import {NativeMinter, ERC20Minter} from "src/Minter.sol";

contract DeployScript is Script {

    TuNEO tuNEO;
    WtuNEO wtuNEO;
    NativeMinter nativeMinter;
    ERC20Minter eRC20Minter;
    address usdc = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;

    function setUp() public {}

    function run() public {
        uint8 decimals = 18;
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        uint32 rewardsCycleLength = 604800; // 1 week in seconds
        vm.startBroadcast(privateKey);
        tuNEO = new TuNEO("tuNEO", "tuNEO", decimals);
        tuNEO.mint(address(wtuNEO), 1);
        wtuNEO = new WtuNEO(ERC20(address(tuNEO)), rewardsCycleLength);
        nativeMinter = new NativeMinter(address(tuNEO));
        eRC20Minter = new ERC20Minter(usdc, address(tuNEO));
        vm.stopBroadcast();
    }
}


