// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <=0.8.17;

interface layout {
    function start() external;
    function stop() external;
    function addFuel(uint litres) external returns(uint);
}

abstract contract test is layout{

    uint currentFuel;
    bool started;
    uint chasis;

    constructor(uint _chasis)
    {
        chasis=_chasis;
    }
    
    modifier checkFuel(uint litres)
    {
        require(currentFuel+litres<=getFuelCapacity(),"Overflow!");
        _;
    }

    function start() override external{
        started=true;
    }
    function stop() override external{
        started=false;
    }

    function addFuel(uint litres) override checkFuel(litres) external returns(uint){
        currentFuel+=litres;
        return currentFuel;
    }

    function getFuelCapacity() public virtual returns(uint);

}

contract newTest is test{

    uint256 fuelTankSize;
    constructor(uint256 _fuelTankSize,uint _chasis) test(_chasis) {
        fuelTankSize = _fuelTankSize;
    }

    function getFuelCapacity() public view override returns (uint256) {
        return fuelTankSize;
    }

}