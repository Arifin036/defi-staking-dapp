// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Staking {

    mapping(address => uint256) public balances;
    mapping(address => uint256) public stakingTime;

    uint256 public rewardRate = 1 ether; // reward per second (example only)

    function stake() external payable {
        require(msg.value > 0, "Must stake more than 0");

        balances[msg.sender] += msg.value;
        stakingTime[msg.sender] = block.timestamp;
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 timeStaked = block.timestamp - stakingTime[user];
        return (timeStaked * rewardRate) / 1 days;
    }

    function withdraw() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No staked balance");

        uint256 reward = calculateReward(msg.sender);

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance + reward);
    }
}
