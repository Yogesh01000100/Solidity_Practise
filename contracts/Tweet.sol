// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./token.sol";
contract TweetHandler {
    address private owner;
    MyToken public tokenContract;
    uint256 public tweetCost = 10;

    struct User {
        string name;
        uint256 age;
        string[] tweets;
        uint256 createdAt;
    }
    mapping(address => User) users;

    constructor(MyToken _tokenContract) {
        owner = msg.sender;
        tokenContract = _tokenContract;
    }

    modifier onlyUser() {
        require(msg.sender != owner, "Owner can't add a tweet!");
        _;
    }

    modifier tweetLength() {
        require(
            users[msg.sender].tweets.length <= 3,
            "Only 3 tweets allowed per user!"
        );
        _;
    }

    function addTweet(string memory _tweet) external onlyUser tweetLength {
        require(
            tokenContract.balanceOf(msg.sender) >= tweetCost,
            "Not enough balance!"
        );
        tokenContract.transferFrom(msg.sender, owner, tweetCost);
        if (users[msg.sender].createdAt == 0) {
            users[msg.sender].createdAt = block.timestamp;
        }
        users[msg.sender].tweets.push(_tweet);
    }

    function getAllTweets() external view onlyUser returns (string[] memory) {
        require(
            block.timestamp >= (users[msg.sender].createdAt + 1 * 60),
            "Only old accounts can access this!"
        );
        return users[msg.sender].tweets;
    }

    function updateTweet(string memory _tweet, uint256 _i) external onlyUser {
        users[msg.sender].tweets[_i] = _tweet;
    }
}
