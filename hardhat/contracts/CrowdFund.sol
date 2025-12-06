// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint256 public totalFunds;
    uint256 public goalAmount;
    uint256 public deadline;
    bool public goalReached;

    mapping(address => uint256) public contributions;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);
    event RefundIssued(address indexed contributor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier campaignActive() {
        require(block.timestamp < deadline, "Campaign has ended");
        _;
    }

    constructor(uint256 _goalAmount, uint256 _duration) {
        owner = msg.sender;
        goalAmount = _goalAmount;
        deadline = block.timestamp + _duration;
    }

    function contribute() public payable campaignActive {
        require(msg.value > 0, "Must send ETH");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        if (totalFunds >= goalAmount) {
            goalReached = true;
        }

        emit ContributionReceived(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        require(goalReached, "Goal not reached");
        uint256 amount = address(this).balance;
        payable(owner).transfer(amount);
        emit Withdraw(owner, amount);
    }

    function refund() public {
        require(block.timestamp >= deadline, "Campaign still active");
        require(!goalReached, "Goal was reached; no refunds");

        uint256 contributed = contributions[msg.sender];
        require(contributed > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributed);
        emit RefundIssued(msg.sender, contributed);
    }
}
