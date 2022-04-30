// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library MathContract{

    uint256 public constant MAX_VAL = 2454971259878909886679;
    uint256 public constant ONE = 0x10000000000000000;
    uint256 public constant LN2 = 0xb17217f7d1cf79ac;
    uint256 public constant LOG2_E = 0x171547652b82fe177;


    function sumArr(uint256[2] memory nums) external pure returns(uint256){
        uint256 _sum = 0;
        for(uint8 i; i < nums.length; i++){
            _sum += nums[i];
        }
        return _sum;
    }

    function exp(uint256 x) external pure returns (uint) {

        require(x <= MAX_VAL);

        x = x * uint(ONE) / uint(LN2);
        uint256 shift;
        uint256 z;
        shift = x / uint(ONE);
        z = uint(x % uint(ONE));

        uint256 zpow = z;
        uint256 result = ONE;

        result += 0xb17217f7d1cf79ab * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x3d7f7bff058b1d50 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xe35846b82505fc5 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x276556df749cee5 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x5761ff9e299cc4 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xa184897c363c3 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xffe5fe2c4586 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x162c0223a5c8 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1b5253d395e * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1e4cf5158b * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1e8cac735 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1c3bd650 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1816193 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x131496 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xe1b7 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x9c7 * zpow / ONE;

        return result << shift;
    }

    function one() external pure returns(uint256){
        return ONE;
    }
}