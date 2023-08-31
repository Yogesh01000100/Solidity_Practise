// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <=0.8.17;

contract follows {
    mapping(address=>address[]) followdata;
    address owner;

    constructor() {
        owner=msg.sender;
    }
    event followed(address indexed follower);

    function follow(address addr) public
    {
        require(msg.sender!=owner,"Owner not allowed!");
        require(followdata[msg.sender].length<=3,"only 3 allowed!");

        bool alreadyFollowing = false;
        for (uint i = 0; i < followdata[msg.sender].length; i++) {
            if (followdata[msg.sender][i] == addr) {
                alreadyFollowing = true;
                break;
            }
        }

        require(!alreadyFollowing, "Address is already being followed!");
        followdata[msg.sender].push(addr);
        emit followed(addr);
    } 

    function getfollowers(address addr) public view returns(address[] memory){
        require(followdata[msg.sender].length>0, "Not yet followed anyone!");
        return followdata[addr];
    }
}