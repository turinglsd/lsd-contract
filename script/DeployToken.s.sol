// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TuNEO, MERC20} from "src/tokens/tuNEO.sol";
import {TuGAS} from "src/tokens/tuGAS.sol";
import {TuBNEO} from "src/tokens/tuBNEO.sol";
import {WtuNEO} from "src/staking/wtuNEO.sol";
import {WtuGAS} from "src/staking/wtuGAS.sol";
import {WtuBNEO} from "src/staking/wtuBNEO.sol";
import {ERC20} from "src/ERC20.sol";
import {NativeMinterRedeem, ERC20MinterRedeem, ERC20MinterWithdrawal, NativeMinterWithdrawal} from "src/minters/tuNEOMinter.sol";

contract DeployScript is Script {

    TuNEO tuNEO;
    WtuNEO wtuNEO;
    TuGAS tuGAS;
    WtuGAS wtuGAS;
    TuBNEO tuBNEO;
    WtuBNEO wtuBNEO;
    // NativeMinterRedeem nativeMinter;
    // ERC20MinterRedeem eRC20Minter;
    ERC20MinterWithdrawal erc20Withdraw;
    NativeMinterWithdrawal nativeWithdraw;

    function setUp() public {}

    function run() public {
        deploy_tuBNEO();
    }

    function deploy_gas() public {
        uint8 decimals = 18;
        uint privateKey = vm.envUint("PRIVATE_KEY");
        // address deployer = vm.addr(privateKey);
        uint32 rewardsCycleLength = 1; // 6s in seconds
        vm.startBroadcast(privateKey);
        tuGAS = new TuGAS("tuGAS", "tuGAS", decimals);
        wtuGAS = new WtuGAS(ERC20(address(tuGAS)), rewardsCycleLength);
        tuGAS.mint(address(wtuGAS), 1);
        nativeWithdraw = new NativeMinterWithdrawal(address(tuGAS), "wd", "wd");
        tuGAS.transferOwnership(address(nativeWithdraw));
        vm.stopBroadcast();
    }

    function deploy_tuBNEO() public {
        uint8 decimals = 18;
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        uint32 rewardsCycleLength = 1; // 6s in seconds
        vm.startBroadcast(privateKey);
        tuBNEO = new TuBNEO("tuBNEO", "tuBNEO", decimals);
        wtuBNEO = new WtuBNEO(ERC20(address(tuBNEO)), rewardsCycleLength);
        tuBNEO.mint(address(wtuBNEO), 1);
        MERC20 erc20 = new MERC20("MockBNEO", "MockBNEO", decimals);
        erc20.mint(address(deployer), 1000000 * 10 ** 18);
        erc20Withdraw = new ERC20MinterWithdrawal(address(erc20), address(tuBNEO), "wd", "wd");
        tuBNEO.transferOwnership(address(erc20Withdraw));
        vm.stopBroadcast();
    }




    function deploy_tuNEO() public {
        uint8 decimals = 18;
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        uint32 rewardsCycleLength = 1; // 6s in seconds
        vm.startBroadcast(privateKey);
        tuNEO = new TuNEO("tuNEO", "tuNEO", decimals);
        wtuNEO = new WtuNEO(ERC20(address(tuNEO)), rewardsCycleLength);
        tuNEO.mint(address(wtuNEO), 1);
        // nativeMinter = new NativeMinterRedeem(address(tuNEO));
        MERC20 erc20 = new MERC20("Mock", "Mock", decimals);
        erc20.mint(address(deployer), 1000 * 10 ** 18);
        // eRC20Minter = new ERC20MinterRedeem(address(erc20), address(tuNEO));
        erc20Withdraw = new ERC20MinterWithdrawal(address(erc20), address(tuNEO), "wd", "wd");
        nativeWithdraw = new NativeMinterWithdrawal(address(tuNEO), "wd", "wd");
        tuNEO.transferOwnership(address(erc20Withdraw));
        vm.stopBroadcast();
    }


}


