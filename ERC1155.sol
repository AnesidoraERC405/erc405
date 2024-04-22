// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";

abstract contract ERC1155 is Ownable {
    string private _uri;

    mapping(address => mapping(uint256 => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    error NotApproved();
    error InsufficientBalance();
    error IncorrectAccountsOrIds();

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    constructor() {}

    function mint(address account, uint256 id, uint256 amount) internal {
        _balances[account][id] += amount;
        emit TransferSingle(msg.sender, address(0), account, id, amount);
    }

    function balanceOf(
        address account,
        uint256 id
    ) public view returns (uint256) {
        return _balances[account][id];
    }

    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(
        address account,
        address operator
    ) public view returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount
    ) internal {
        if (!(from == msg.sender || isApprovedForAll(from, msg.sender))) {
            revert NotApproved();
        }

        _transferFrom(from, to, id, amount);
    }

    function _transferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount
    ) internal {
        if (_balances[from][id] < amount) {
            revert InsufficientBalance();
        }

        _balances[from][id] -= amount;
        _balances[to][id] += amount;
        emit TransferSingle(msg.sender, from, to, id, amount);
    }

    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal {
        if (!(from == msg.sender || isApprovedForAll(from, msg.sender))) {
            revert NotApproved();
        }

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            if (_balances[from][id] < amount) {
                revert InsufficientBalance();
            }

            _balances[from][id] -= amount;
            _balances[to][id] += amount;

            emit TransferSingle(msg.sender, from, to, id, amount);
        }
    }

    function setURI(string memory nextUri) external onlyOwner {
        _uri = nextUri;
    }

    function uri(uint256 id) public view returns (string memory) {
        return _uri;
    }

}
