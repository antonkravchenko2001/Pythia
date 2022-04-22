// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract PriceFeeder is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address constant linkTokenAddress;
    IERC20 linkToken;

    uint256 public price;
    string assetName;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor(string memory _assetName) {

        linkToken = IERC20(linkTokenAddress);
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        assetName = _assetName;
        fee = 0.1 * 10 ** 18;
        fund(fee);
    }

    function requestVolumeData() public returns (bytes32 requestId)
    {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        request.add("get", getUrl());

        request.add("path", assetName);

        request.add("path", "usd");

        int timesAmount = 10**18;
        request.addInt("times", timesAmount);

        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _price) public
    {
       price = _price;
    }

    function getUrl() internal view returns (string memory) {
        string memory startUrl = "https://api.coingecko.com/api/v3/simple/price?ids=";
        string memory endUrl = "&vs_currencies=usd";
        return string(abi.encodePacked(startUrl, assetName, endUrl));
    }

    function fund(uint256 fee) internal {
        require(linkToken.balanceOf(msg.sender) >= fee);
        linkToken.transferFrom(
            msg.sender,
            address(_priceFeeder),
             _priceFeeder.fee
        );
    }
}
