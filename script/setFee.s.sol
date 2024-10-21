// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TuNEO, MERC20} from "src/tokens/tuNEO.sol";
import {WtuNEO, ERC20} from "src/staking/wtuNEO.sol";
import {NativeMinterWithdrawal, ERC20MinterWithdrawal} from "src/minters/tuNEOMinter.sol";

contract SetFeeScript is Script {

    NativeMinterWithdrawal withdrawMinter;
    ERC20MinterWithdrawal erc20withdraw_bneo;
    ERC20MinterWithdrawal erc20withdraw_gas;


    function setUp() public {}

    function run() public {
        // set_ownership();
        set_fee();
    
    }

    function set_ownership() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        // set ownership
        address withdrawMinterAddr  = 0xf9C1aa3d3d2200EA2C2eEea99ed77173bF2164e1;
        TuNEO tuneo = TuNEO(0xE2E9fB0f2A42ceECa5d3c6C798dd115B616a9581);
        tuneo.transferOwnership(withdrawMinterAddr);
        vm.stopBroadcast();
    }


    function set_fee() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        // address deployer = vm.addr(privateKey);
        vm.startBroadcast(privateKey);
        // updateWithdrawalFee
        // withdrawMinter = NativeMinterWithdrawal(0xC6962a4ffeaf4c7fDF46C02ca99C29A4CC366f2e);
        erc20withdraw_bneo = ERC20MinterWithdrawal(0xC55215ae37fB289350F26973225f9b1028D5690d);
        erc20withdraw_gas = ERC20MinterWithdrawal(0xC6962a4ffeaf4c7fDF46C02ca99C29A4CC366f2e);

        // withdrawMinter.updateWithdrawalFee(50);
        erc20withdraw_bneo.updateWithdrawalFee(50);
        erc20withdraw_gas.updateWithdrawalFee(50);
        // uint fee = withdrawMinter.withdrawalFee();
        // require(fee == 50, "fee is not 50");
        vm.stopBroadcast();

    }
}


