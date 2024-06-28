// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ClockToken is ERC20 {
    constructor() ERC20("Clock Token", "HOUR") {}

    function balanceOf(address account) public view override returns (uint256) {
        return block.timestamp;
    }
}
