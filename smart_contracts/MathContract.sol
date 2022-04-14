// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MathContract{


    function sumArr(uint256[2] memory nums) external pure returns(uint256){
        uint256 _sum = 0;
        for(uint8 i; i < nums.length; i++){
            _sum += nums[i];
        }
        return _sum;
    }

    function expABC(
        uint256 _a,
        uint256 _b,
        uint256 _c,
        uint8 seriesLength
    ) external pure returns(uint256){

        uint256 _result;
        uint256 _factorial = 1;

        for(uint8 i = 0; i <= seriesLength; i++){
            if(i == 0){
                _result += _a;
            } else {
                _result += ((_a * _b ** i) / (_c ** i * _factorial));
                _factorial *= (i + 1);
            }
        }
        return _result;
    }
}