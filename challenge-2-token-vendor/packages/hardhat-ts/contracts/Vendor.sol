pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import './YourToken.sol';

contract Vendor is Ownable {
  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfETH = msg.value;
    uint256 amountOfTokens = amountOfETH * tokensPerEth;
    _safeTransfer(yourToken, msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, amountOfETH, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw(uint256 amount) public payable {
    require(msg.sender == owner(), "must be owner to withdraw");
    _safeTransfer(yourToken, msg.sender, amount);
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amountOfTokens) public payable {
    uint256 amountOfETH = amountOfTokens / tokensPerEth;
    _safeTransferFrom(yourToken, msg.sender, address(this), amountOfTokens);
    (bool sent,) = msg.sender.call{value: amountOfETH}("");
    require(sent, "Failed to send Ether");
    emit SellTokens(msg.sender, amountOfETH, amountOfTokens);
  }


  function _safeTransfer(
        IERC20 token,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transfer(recipient, amount);
        require(sent, "Token transfer failed");
    }

  function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
