// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.19;
contract vote {

    mapping(uint=>uint) votes;
    mapping(address=>bool) votestatus;

    uint currentWinnerVotes=0;
    uint winnerNumber=1;
    function getVotes(uint number) public view returns(uint)
    {
        require(number>0 && number<=5, "Number not in range of 1-5");
        return votes[number];
    }
    function voter(uint num) external{
        bool status=votestatus[msg.sender];
        require(status==false, "Already voted!");
        require(num>0 && num<=5, "Number not in range of 1-5");
        votestatus[msg.sender]=true;
        if(votes[num]>=currentWinnerVotes){
            currentWinnerVotes=votes[num];
            winnerNumber=num;
        }
        votes[num]+=1;
    }

    function winner() public view returns (uint){
        return winnerNumber;
    }
}