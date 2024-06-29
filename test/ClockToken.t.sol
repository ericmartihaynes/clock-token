// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {ClockToken} from "../src/ClockToken.sol";

contract ClockTokenTest is Test {
    ClockToken clockToken;

    function setUp() public {
        clockToken = new ClockToken();
    }

    function testBalance() public {
        vm.warp(1719615204);
        //console.log(clockToken.balanceOf(address(0)));
        assertEq(clockToken.balanceOf(address(0)), 22530000000000000000);
    }

    function testBalance(address _address) public {
        vm.warp(1719615204);
        assertEq(clockToken.balanceOf(address(_address)), 22530000000000000000);
    }

    function testOffset() public {
        vm.warp(1719615204);
        address user = address(0x25);
        vm.startPrank(user);
        assertEq(clockToken.balanceOf(user), 22530000000000000000);
        assertEq(clockToken.hourOffset(user), 0);
        assertEq(clockToken.minuteOffset(user), 0);

        clockToken.offsetHours(-1);
        assertEq(clockToken.balanceOf(user), 21530000000000000000);
        assertEq(clockToken.hourOffset(user), -1);
        assertEq(clockToken.minuteOffset(user), 0);

        clockToken.offsetHours(2);
        assertEq(clockToken.balanceOf(user), 23530000000000000000);
        assertEq(clockToken.balanceOf(address(0)), 22530000000000000000);
        assertEq(clockToken.hourOffset(user), 1);
        assertEq(clockToken.minuteOffset(user), 0);

        clockToken.offsetMinutes(-23);
        assertEq(clockToken.balanceOf(user), 23300000000000000000);
        assertEq(clockToken.hourOffset(user), 1);
        assertEq(clockToken.minuteOffset(user), -23);

        clockToken.offsetMinutes(15);
        assertEq(clockToken.balanceOf(user), 23450000000000000000);
        assertEq(clockToken.balanceOf(address(0)), 22530000000000000000);
        assertEq(clockToken.hourOffset(user), 1);
        assertEq(clockToken.minuteOffset(user), -8);

        clockToken.resetOffsets();
        assertEq(clockToken.balanceOf(user), clockToken.balanceOf(address(0)));
        assertEq(clockToken.hourOffset(user), 0);
        assertEq(clockToken.minuteOffset(user), 0);
        vm.stopPrank();
    }

    function testOffsetFails() public {
        vm.warp(1719615204);
        address user = address(0x25);
        vm.startPrank(user);
        assertEq(clockToken.balanceOf(user), 22530000000000000000);

        vm.expectRevert("Offset not allowed");
        clockToken.offsetHours(-12);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetHours(13);
        clockToken.offsetHours(6);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetHours(8);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetHours(-18);

        vm.expectRevert("Offset not allowed");
        clockToken.offsetMinutes(-30);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetMinutes(31);
        clockToken.offsetMinutes(20);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetMinutes(11);
        vm.expectRevert("Offset not allowed");
        clockToken.offsetMinutes(-50);
        
        vm.stopPrank();
    }

    function testSupply() public {
        assertEq(clockToken.totalSupply(), type(uint256).max);
    }

    function testTransfersFail() public {
        vm.warp(1719615204);
        address user = address(0x25);
        address user2 = address(0x26);
        vm.startPrank(user);
        assertEq(clockToken.balanceOf(user), 22530000000000000000);

        vm.expectRevert();
        clockToken.transfer(user2, 22530000000000000000);

        vm.expectRevert();
        clockToken.transfer(user2, 1);

        //transfering 0 does not revert
        clockToken.transfer(user2, 0);

        clockToken.approve(user2, 22530000000000000000);
        vm.stopPrank();
        vm.startPrank(user2);
        vm.expectRevert();
        clockToken.transferFrom(user, user2, 22530000000000000000);

        vm.expectRevert();
        clockToken.transferFrom(user, user2, 1);

        //transfering 0 does not revert
        clockToken.transferFrom(user, user2, 0);
        vm.stopPrank();
    }
}
