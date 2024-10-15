// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0

contract fancyShirt {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    enum Size {
        Small,
        Medium,
        Large
    }

    enum Color {
        Red,
        Green,
        Blue
    }

    struct userChoice {
        Size _size;
        Color _color;
    }
    mapping(address => userChoice) closet;

    modifier correctAmount(Size size, Color color) {
        require(
            getShirtPrice(size, color) == msg.value,
            "Incorrect Amount sent!"
        );
        _;
    }

    function getShirtPrice(Size size, Color color) public pure returns (uint) {
        uint price;
        if (size == Size.Small) {
            price += 10;
        } else if (size == Size.Medium) {
            price += 15;
        } else {
            price += 20;
        }

        if (color != Color.Red) {
            price += 5;
        }
        return price;
    }

    function buyShirt(
        Size size,
        Color color
    ) public payable correctAmount(size, color) {
        closet[msg.sender]._size = size;
        closet[msg.sender]._color = color;
    }

    function getCloset(address addr) public view returns (userChoice memory) {
        return closet[addr];
    }
}
