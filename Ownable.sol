// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev This contract provides a basic access control mechanism, where there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 */
abstract contract Ownable {
    address private _owner;

    error NotTheOwner();
    error UnsuitableOwner();

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        if (_owner != msg.sender) {
            revert NotTheOwner();
        }
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == address(0)) {
            revert UnsuitableOwner();
        }
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
