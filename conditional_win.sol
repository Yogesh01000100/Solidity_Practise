// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.17;

contract code {
    address winner;
    mapping(address=>bool) status;

    function get() external payable {
        require(status[msg.sender]==false,"Already Voted!");
        require(msg.value==1 ether,"1 Ether needs to be sent!");
        if(address(this).balance==7 ether)
        {
            winner=msg.sender;
        }
        status[msg.sender]=true;
    }

    function claim() public {
        require(status[msg.sender]==true,"Not Voted Yet!");
        require(msg.sender==winner,"You are not the winner!");
        (bool sent, )=payable(winner).call{value:7 ether}("");
        require(sent);
    }

    function getWinnner() public view returns(address) {
        return winner;
    }
}