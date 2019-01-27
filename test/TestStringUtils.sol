pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "../libraries/StringUtils.sol";

contract TestStringUtils {
    function testCompareFunction() public {
        int result1 = StringUtils.compare("Potluck", "Potluck2");
        int expected1 = -1;

        Assert.equal(result1, expected1, "detects difference in string where string1 is lexicographically smaller");

        int result2 = StringUtils.compare("Zero", "Zero");
        int expected2 = 0;

        Assert.equal(result2, expected2, "detects strings that are the same");

        int result3 = StringUtils.compare("Yellow", "Pear");
        int expected3 = 1;

        Assert.equal(result3, expected3, "detects difference in string where string1 is lexicographically bigger");
    }

    function testEqualFunction() public {
        bool result1 = StringUtils.equal("Potluck", "Potluck2");
        bool expected1 = false;

        Assert.equal(result1, expected1, "returns false when strings are different");

        bool result2 = StringUtils.equal("Two", "Two");
        bool expected2 = true;

        Assert.equal(result2, expected2, "returns true when strings are the same");
    }
}
