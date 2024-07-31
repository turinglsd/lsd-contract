// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TuNEO, MERC20} from "src/tuNEO.sol";
import {WtuNEO, ERC20} from "src/wtuNEO.sol";
import {NativeMinterRedeem, ERC20MinterRedeem} from "src/Minter.sol";

contract DeployScript is Script {

    TuNEO tuNEO;
    WtuNEO wtuNEO;
    NativeMinterRedeem nativeMinter;
    ERC20MinterRedeem eRC20Minter;

    function setUp() public {}

    function run() public {
        uint8 decimals = 18;
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        uint32 rewardsCycleLength = 604800; // 1 week in seconds
        vm.startBroadcast(privateKey);
        tuNEO = new TuNEO("tuNEO", "tuNEO", decimals);
        wtuNEO = new WtuNEO(ERC20(address(tuNEO)), rewardsCycleLength);
        tuNEO.mint(address(wtuNEO), 1);
        nativeMinter = new NativeMinterRedeem(address(tuNEO));
        MERC20 erc20 = new MERC20("Mock", "Mock", decimals);
        erc20.mint(address(deployer), 1000 * 10 ** 18);
        eRC20Minter = new ERC20MinterRedeem(address(erc20), address(tuNEO));
        tuNEO.transferOwnership(address(eRC20Minter));
        vm.stopBroadcast();
    }
}


