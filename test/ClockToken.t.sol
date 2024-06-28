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
        //counter.increment();
        //assertEq(counter.number(), 1);
    }
}
