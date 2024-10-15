// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface Driveable {
    function startEngine() external;

    function stopEngine() external;

    function fuelUp(uint256 litres) external;

    function drive(uint256 kilometers) external;

    function kilometersRemaining() external view returns (uint256);
}

abstract contract GasVehicle is Driveable {
    uint256 litresRemaining;
    bool started;

    modifier sufficientTankSize(uint256 litres) {
        require(litresRemaining + litres <= getFuelCapacity());
        _;
    }

    modifier sufficientKilometersRemaining(uint256 kilometers) {
        require(kilometersRemaining() >= litresRemaining);
        _;
    }

    modifier notStarted() {
        require(!started);
        _;
    }

    modifier isStarted() {
        require(started);
        _;
    }

    function startEngine() override external notStarted {
        started = true;
    }

    function stopEngine() override external isStarted {
        started = false;
    }

    function fuelUp(uint256 litres)
        override external
        sufficientTankSize(litres)
        notStarted
    {
        litresRemaining += litres;
    }

    function drive(uint256 kilometers)
         override external
        isStarted
        sufficientKilometersRemaining(kilometers)
    {
        litresRemaining -= kilometers / getKilometersPerLitre();
    }

    function kilometersRemaining() override public view returns (uint256) {
        return litresRemaining * getKilometersPerLitre();
    }

    function getKilometersPerLitre() public view virtual returns (uint256);

    function getFuelCapacity() public view virtual returns (uint256);
}

contract Car is GasVehicle {
    uint256 fuelTankSize;
    uint256 kilometersPerLitre;

    constructor(uint256 _fuelTankSize, uint256 _kilometersPerLitre) {
        fuelTankSize = _fuelTankSize;
        kilometersPerLitre = _kilometersPerLitre;
    }
    
    function getKilometersPerLitre() public view override returns (uint256) {
        return kilometersPerLitre;
    }

    function getFuelCapacity() public view override returns (uint256) {
        return fuelTankSize;
    }
}
