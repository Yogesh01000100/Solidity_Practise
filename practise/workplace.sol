// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0

contract Employee {
    enum Department {
        Gardening,
        Clothing,
        Tools
    }

    string firstName;
    string lastName;
    uint hourlyPay;
    Department department;

    constructor(
        string memory _firstName,
        string memory _lastName,
        uint _hourlyPay,
        Department _department
    ) {
        firstName = _firstName;
        lastName = _lastName;
        hourlyPay = _hourlyPay;
        department = _department;
    }

    function getWeeklyPay(uint hoursWorked) public view returns (uint256) {
        if (hoursWorked <= 40) {
            return hourlyPay * hoursWorked;
        }
        uint overtimeHours = hoursWorked - 40;
        return 40 * hourlyPay + (overtimeHours * 2 * hourlyPay);
    }

    function getFirstName() public view returns (string memory) {
        return firstName;
    }
}

contract Manager is Employee{

    Employee[] subordinates;
    constructor(string memory _firstName, string memory _lastName,uint256 _hourlyPay, Department _department)
    Employee(_firstName, _lastName, _hourlyPay, _department)
    {} 

    function addSubordinate(
        string memory _firstName,
        string memory _lastName,
        uint256 _hourlyPay,
        Department _department
    ) public {
        Employee employee = new Employee(
            _firstName,
            _lastName,
            _hourlyPay,
            _department
        );
        subordinates.push(employee);
    }

    function getSubordinates() public view returns (string[] memory) {
        string[] memory names = new string[](subordinates.length);
        for (uint256 idx; idx < subordinates.length; idx++) {
            names[idx] = subordinates[idx].getFirstName();
        }
        return names;
    }

}