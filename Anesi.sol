// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC405.sol";

contract XLayerScription is ERC405 {
    address private _feeAddress;
    uint256 private _mintFee;
    uint256 private _mintLimit;

    uint256 private constant _inscriptionTotalSupply= 21000000;
    uint256 private constant _conversionRate = 1000000;
    string private constant _name = "Anesi";
    string private constant _tick = "ANESI";

    error NOTEnoughFee();
    error WithdrawFailed();
    error ExceededLimit();

    event Inscription(bytes data);

    constructor(
        address initialFeeAddress,
        uint256 initialMintFee,
        uint256 initialLimit
    ) ERC405(_conversionRate, _name, _tick, _inscriptionTotalSupply, 18) {
        _feeAddress = initialFeeAddress;
        _mintFee = initialMintFee;
        _mintLimit = initialLimit;
    }

    function _setMintLimit(uint256 mintLimit) external onlyOwner {
        _mintLimit = mintLimit;
    }

    function mint(uint256 amount, bytes calldata _calldata) public payable {
        uint256 _fee = _mintFee * amount;

        if (msg.value < _fee) {
            revert NOTEnoughFee();
        }

        if (amount > _mintLimit) {
            revert ExceededLimit();
        }

        (bool success, ) = payable(_feeAddress).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert WithdrawFailed();
        }
        ERC405.safeMint(amount);
        emit Inscription(_calldata);
    }
}