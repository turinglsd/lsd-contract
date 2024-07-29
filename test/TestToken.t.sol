// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol"; 
import {TuNEO} from "src/tuNEO.sol";
import {WtuNEO, ERC20} from "src/wtuNEO.sol";

contract TokenTest is Test {
    address owner = address(0x01);
    address user1 = address(0x02);
    address user2 = address(0x03);
    uint256 start = 1721475062;

    TuNEO tuNEO;
    WtuNEO wtuNEO;

    function setUp() public {
        vm.startPrank(owner);

        vm.warp(1721475062);
        tuNEO = new TuNEO("tuNEO", "tuNEO", 18);
        wtuNEO = new WtuNEO(ERC20(address(tuNEO)), 120);
        tuNEO.mint(user1, 10 ether);
        tuNEO.mint(user2, 10 ether);
        tuNEO.mint(address(this), 100 ether);
    
        vm.stopPrank();
    }

    function test_restake() public {
        tuNEO.transfer(address(wtuNEO), 1);

        vm.startPrank(user1);
        tuNEO.approve(address(wtuNEO), 4 ether);
        wtuNEO.deposit(4 ether, user1);
        vm.stopPrank();

        vm.startPrank(user2);
        tuNEO.approve(address(wtuNEO), 4 ether);
        wtuNEO.deposit(2 ether, user2);
        vm.stopPrank();
        console.log("\n before rewards release: ================================== user token balance \n");

        console.log("user1 tuNEO balance: ", tuNEO.balanceOf(user1));
        console.log("user1 wtuNEO balance: ", wtuNEO.balanceOf(user1));
        console.log("user2 tuNEO balance: ", tuNEO.balanceOf(user2));
        console.log("user2 wtuNEO balance: ", wtuNEO.balanceOf(user2));
   

      
        tuNEO.transfer(address(wtuNEO), 12 ether);
        vm.warp(start + 120);
        wtuNEO.syncRewards();
        tuNEO.transfer(address(wtuNEO), 1);
        vm.warp(start + 240);
        wtuNEO.syncRewards();

        console.log("\n after rewards released: ================================== user token balance \n");

        vm.startPrank(user1);
        wtuNEO.redeem(wtuNEO.balanceOf(user1), user1, user1);
        console.log("user1 tuNEO balance: ", tuNEO.balanceOf(user1));
        console.log("user1 wtuNEO balance: ", wtuNEO.balanceOf(user1));
        vm.stopPrank();


        vm.startPrank(user2);
        wtuNEO.redeem(wtuNEO.balanceOf(user2), user2, user2);
        console.log("user2 tuNEO balance: ", tuNEO.balanceOf(user2));
        console.log("user2 wtuNEO balance: ", wtuNEO.balanceOf(user2));
        vm.stopPrank();


    }
}
