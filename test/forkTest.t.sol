
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol"; 
import {TuNEO, MERC20} from "src/tokens/tuNEO.sol";
import {WtuNEO, ERC20} from "src/staking/wtuNEO.sol";
import {NativeMinterRedeem, ERC20MinterRedeem} from "src/minters/Minter.sol";


contract TestTokenFork is Test {
    TuNEO tuNEO = TuNEO(0xca2C8A261f6DbBcCBec155493b98d8fB478788A9);
    WtuNEO wtuNEO = WtuNEO(0x621933e2b3762Ea10Bd0d36E2C82d8d698A2A93C);

    NativeMinterRedeem nativeMinter = NativeMinterRedeem(0x2AF145228AA33aB3cc20b9aE866635390b439e74);
    ERC20MinterRedeem eRC20Minter = ERC20MinterRedeem(0x2Eef786557929BCe8cE5eF726f2d615fB73FbAC0);
    MERC20 erc20 = MERC20(0xE67a74cBf98Aa6B577Db1349D7607A95D7e3aE19);

    address user1 = address(0x02);
    function setUp() public {
        vm.createSelectFork("https://sepolia-rollup.arbitrum.io/rpc", 67955665);
    }

    function test_minter_deposit() public {

        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        vm.startPrank(deployer);
        erc20.transfer(user1, 2 ether);
        vm.stopPrank();
        vm.startPrank(user1);
        erc20.approve(address(eRC20Minter), type(uint).max);

        console.log("before deposit tuNeo bal is ", tuNEO.balanceOf(user1));
        eRC20Minter.deposit(1 ether, user1);
        console.log("after deposit tuNeo bal is ", tuNEO.balanceOf(user1));
        
    }

    function test_wtuneo_deposit() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        vm.startPrank(deployer);
        erc20.transfer(user1, 2 ether);
        vm.stopPrank();
        vm.startPrank(user1);
        erc20.approve(address(eRC20Minter), type(uint).max);

        console.log("before deposit tuNeo bal is ", tuNEO.balanceOf(user1));
        eRC20Minter.deposit(1 ether, user1);
        console.log("after deposit tuNeo bal is ", tuNEO.balanceOf(user1));
        tuNEO.approve(address(wtuNEO), type(uint).max);
        wtuNEO.deposit(1 ether, user1);
        console.log("user1 wtuNEO bal is ", wtuNEO.balanceOf(user1));

    }

    receive() external payable {}
}
