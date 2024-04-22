//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";

interface IERC405 is IERC165 {
    error TotalSupplyExceeded();
    event Burn(address from, uint256 amount, uint256 when);
    event TransferData(bytes data);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner_) external view returns (uint256);

    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);

    function isApprovedForAll(
        address owner_,
        address operator_
    ) external view returns (bool);

    function allowance(
        address owner_,
        address spender_
    ) external view returns (uint256);

    function uri(uint256 id) external view returns (string memory);

    function setApprovalForAll(address operator_, bool approved_) external;

    function transferFrom(
        address from_,
        address to_,
        uint256 valueOrId_
    ) external returns (bool);

    function transfer(address to_, uint256 amount_) external returns (bool);

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;

    function totalMinted() external view returns (uint256);

    function safeMint(uint256 amount) external;
}
