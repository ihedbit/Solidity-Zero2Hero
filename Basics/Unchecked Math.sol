// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract UncheckedMath {
    function add(uint x,uint y) external pure returns (uint) {
        // If you use return you use 22291 gas
        // return x + y;

        // If you use unchecked you use 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint){
        // If you use return you use 22329 gas
        // return x - y;

        // If you use unchecked you use 22147 gas
        unchecked {
            return x- y;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint){
        // Wrap complex math logic inside unchecked
        unchecked {
            uint x3 = x*x*x;

            uint y3 = y*y*y;

            return x3 + y3;
        }
    }
}