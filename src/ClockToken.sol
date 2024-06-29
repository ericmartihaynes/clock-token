// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ClockToken is ERC20 {
    mapping(address => int256) public hourOffset;
    mapping(address => int256) public minuteOffset;

    constructor() ERC20("Current Time", "CLOCK") {}

    function balanceOf(address account) public view override returns (uint256) {
        int256 offset = hourOffset[account] * int256(10 ** decimals()) + minuteOffset[account] * int256(10 ** (decimals() - 2));
        uint256 secondsToday = (block.timestamp % 1 days);
        uint256 time = secondsToday / 1 hours * 10 ** decimals() + (secondsToday % 1 hours) / 1 minutes * 10 ** (decimals() - 2);
        return  uint256(int256(time) + offset);
    }

    function offsetHours(int256 _hours) external {
        int256 newOffset = hourOffset[msg.sender] + _hours;
        require(newOffset >= -11 && newOffset <= 12, "Offset not allowed");
        hourOffset[msg.sender] = newOffset;
    }

    function offsetMinutes(int256 _minutes) external {
        int256 newOffset = minuteOffset[msg.sender] + _minutes;
        require(newOffset >= -29 && newOffset <= 30, "Offset not allowed");
        minuteOffset[msg.sender] = newOffset;
    }

    function resetOffsets() external {
        delete hourOffset[msg.sender];
        delete minuteOffset[msg.sender];
    }

    function totalSupply() public view override returns (uint256) {
        return type(uint256).max;
    }
}
