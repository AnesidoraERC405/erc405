// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";
import { IERC405 } from './IERC405.sol';
import "./ERC20.sol";
import "./ERC1155.sol";

abstract contract ERC405 is ERC20, ERC1155 {
    uint256 private _conversionRate;
    uint256 private _erc20TotalSupply;
    uint256 private _inscriptionTotalSupply;
    uint256 private _inscriptionTotalMinted;
    uint256 private _inscriptionId = 405;

    mapping(address => uint256) private _whitelist;

    error TotalSupplyExceeded();

    event Burn(address from, uint256 amount, uint256 when);
    event TransferData(bytes data);

    constructor(
        uint256 initialConversionRate,
        string memory name,
        string memory symbol,
        uint256 inscriptionSupply,
        uint256 initialDecimals
    )
        ERC20(
            name,
            symbol,
            initialDecimals,
            initialConversionRate * inscriptionSupply
        )
    {
        _conversionRate = initialConversionRate;
        _inscriptionTotalSupply = inscriptionSupply;

    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) external pure returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) external pure returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function totalMinted() public view returns (uint256) {
        return _inscriptionTotalMinted;
    }

    function _getFullDecimals() internal view returns (uint256) {
        return 10 ** ERC20.decimals;
    }

    function safeMint(uint256 amount) internal virtual {
        if (totalMinted() + amount > _inscriptionTotalSupply) {
            revert TotalSupplyExceeded();
        }
        _inscriptionTotalMinted += amount;
        ERC1155.mint(msg.sender, _inscriptionId, amount);
        ERC20.mint(msg.sender, amount * _conversionRate * _getFullDecimals());
    }

    function setWhiteList(
        address whiteAddress,
        uint256 status
    ) external onlyOwner {
        _whitelist[whiteAddress] = status;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public returns (bool) {
        if (ERC20.balanceOf(msg.sender) < amount) {
            revert InsufficientBalance();
        }
        ERC20._transfer(msg.sender, recipient, amount);
        _checkAndTransferNFT(msg.sender, recipient);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        ERC20._transferFrom(sender, recipient, amount);
        _checkAndTransferNFT(sender, recipient);
        return true;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) public {
        ERC1155._safeTransferFrom(from, to, id, value);
        ERC20._transfer(
            from,
            to,
            value * _conversionRate * _getFullDecimals()
        );
        emit TransferData(data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) public {
        if (ids.length > 1 || ids[0] != _inscriptionId) {
            revert InsufficientBalance();
        }
        ERC1155._safeBatchTransferFrom(from, to, ids, values);
        ERC20._transfer(
            from,
            to,
            values[0] * _conversionRate * _getFullDecimals()
        );
        emit TransferData(data);
    }

    function _checkAndTransferNFT(
        address sender,
        address receiver
    ) internal returns (bool) {
        uint256 _nftSenderBalance = ERC1155.balanceOf(sender, _inscriptionId);
        uint256 _erc20TokenSenderBalance = ERC20.balanceOf(sender);

        uint256 _nftReceiverBalance = ERC1155.balanceOf(receiver, _inscriptionId);
        uint256 _erc20TokenReceiverBalance = ERC20.balanceOf(receiver);

        uint256 _expectedSenderNFT = _erc20TokenSenderBalance /
            _conversionRate /
            _getFullDecimals();
        uint256 _expectedReceiverNFT = _erc20TokenReceiverBalance /
            _conversionRate /
            _getFullDecimals();

        if (
            _whitelist[sender] == 0 && (_expectedSenderNFT < _nftSenderBalance)
        ) {
            uint256 _senderMinusNFT = _nftSenderBalance - _expectedSenderNFT;
            ERC1155._transferFrom(
                sender,
                address(this),
                _inscriptionId,
                _senderMinusNFT
            );
        }
        if (
            _whitelist[receiver] == 0 &&
            (_expectedReceiverNFT > _nftReceiverBalance)
        ) {
            uint256 _nftThisBalance = ERC1155.balanceOf(address(this), _inscriptionId);
            uint256 _receiverAddNFT = _expectedReceiverNFT -
                _nftReceiverBalance;
            if (_nftThisBalance != 0) {
                if (_nftThisBalance >= _receiverAddNFT) {
                    ERC1155._transferFrom(
                        address(this),
                        receiver,
                        _inscriptionId,
                        _receiverAddNFT
                    );
                } else {
                    ERC1155._transferFrom(
                        address(this),
                        receiver,
                        _inscriptionId,
                        _nftThisBalance
                    );
                    ERC1155.mint(
                        receiver,
                        _inscriptionId,
                        _receiverAddNFT - _nftThisBalance
                    );
                }
            } else {
                ERC1155.mint(receiver, _inscriptionId, _receiverAddNFT);
            }
        }
        return true;
    }

    function _burn(uint256 amount) internal virtual {
        if (ERC20.balanceOf(msg.sender) < amount) {
            revert InsufficientBalance();
        }
        ERC20._transfer(msg.sender, address(0), amount);

        uint256 _nftSenderBalance = ERC1155.balanceOf(msg.sender, _inscriptionId);
        uint256 _erc20TokenSenderBalance = ERC20.balanceOf(msg.sender);

        uint256 _expectedSenderNFT = _erc20TokenSenderBalance /
            _conversionRate /
            _getFullDecimals();

        if (_expectedSenderNFT < _nftSenderBalance) {
            ERC1155._transferFrom(
                msg.sender,
                address(this),
                _inscriptionId,
                _nftSenderBalance - _expectedSenderNFT
            );
        }

        emit Burn(msg.sender, amount, block.timestamp);
    }

    function supportsInterface(
      bytes4 interfaceId
    ) public view virtual returns (bool) {
      return
        interfaceId == type(IERC405).interfaceId ||
        interfaceId == type(IERC165).interfaceId;
    }
}
