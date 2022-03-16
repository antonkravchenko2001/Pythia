// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract MathContract{

    function ln(uint256 num) internal pure returns(uint256){
        return log2(num) * 693 / 1000;
    }

    function log2(uint256 num) internal pure returns(uint256){
        return intPart(num);
    }


    function intPart(uint256 x) internal pure returns(uint256){
        uint256 int_part = 0;
        if (x >= 2**128) {
            x >>= 128;
            int_part += 128;
        }
        if (x >= 2**64) {
            x >>= 64;
            int_part += 64;
        }
        if (x >= 2**32) {
            x >>= 32;
            int_part += 32;
        }
        if (x >= 2**16) {
            x >>= 16;
            int_part += 16;
        }
        if (x >= 2**8) {
            x >>= 8;
            int_part += 8;
        }
        if (x >= 2**4) {
            x >>= 4;
            int_part += 4;
        }
        if (x >= 2**2) {
            x >>= 2;
            int_part += 2;
        }
        if (x >= 2**1) {
            int_part += 1;
        }

        return int_part;
    }
}
