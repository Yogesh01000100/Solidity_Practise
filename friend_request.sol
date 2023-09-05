// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.19;

contract friend {
    struct Person {
        address[] friends;
        address[] requestSent;
        address[] requestReceived;
    }

    mapping(address => Person) user;

    modifier sendRequestStatus(address addr) {
        bool status = requestSentStatus(addr);
        bool friendRequestReceived = checkRequestReceived(addr);
        require(msg.sender!=addr,"Self request not allowed!");
        require(!status, "Already request sent!");
        require(!friendRequestReceived, "Already user request is pending!");
        _;
    }

    function requestSentStatus(address addr) internal view returns (bool) {
        for (uint i; i < user[msg.sender].requestSent.length; i++) {
            if (addr == user[msg.sender].requestSent[i]) {
                return true;
            }
        }
        return false;
    }

    function checkRequestReceived(address addr) internal view returns (bool) {
        for (uint i; i < user[msg.sender].requestReceived.length; i++) {
            if (addr == user[msg.sender].requestReceived[i]) {
                return true;
            }
        }
        return false;
    }

    function acceptRequestModify(address addr) internal returns (bool) {
        uint leng = user[msg.sender].requestReceived.length;
        bool friendNotFound;
        for (uint i; i < user[msg.sender].requestReceived.length; i++) {
            if (addr == user[msg.sender].requestReceived[i]) {
                address temp = user[msg.sender].requestReceived[leng - 1];
                user[msg.sender].requestReceived[leng - 1] = user[msg.sender]
                    .requestReceived[i];
                user[msg.sender].requestReceived[i] = temp;
                friendNotFound = false;
            } else {
                friendNotFound = true;
            }
        }
        user[msg.sender].requestReceived.pop();

        if (leng - user[msg.sender].requestReceived.length == 1) {
            return true;
        }
        return friendNotFound;
    }

    function sendRequest(
        address addr
    ) external sendRequestStatus(addr) returns (bool) {
        user[msg.sender].requestSent.push(addr);
        user[addr].requestReceived.push(msg.sender);
        return true;
    }

    function requestPending() external view returns (address[] memory) {
        return user[msg.sender].requestReceived;
    }

    function viewFriends() external view returns (address[] memory) {
        return user[msg.sender].friends;
    }

    function acceptFriendRequest(address addr) external {
        require(
            user[msg.sender].requestReceived.length != 0,
            "No pending requests!"
        );
        bool status = acceptRequestModify(addr);
        require(status == false, "Friend's address not found!");
        user[msg.sender].friends.push(addr);
    }
}
