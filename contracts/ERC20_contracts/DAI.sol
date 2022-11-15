pragma solidity ^0.8.0;

import "./ERC20.sol";

contract Dai is ERC20("Dai token", "DAI") {
    address constant owner = 0xFfeEcd85edF58666AEb95Cc2EFA855DA62E6ea56;
    function mint(address account, uint256 amount) public {
        require(
            msg.sender == owner,
            "only owner can mint"
        );
        ERC20._mint(account, amount);
    }
}