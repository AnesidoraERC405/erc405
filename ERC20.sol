// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract ERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Mint(address indexed to, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _totalSupply = initialSupply * 10 ** _decimals;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            _balances[sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            _balances[sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        require(
            _allowances[sender][msg.sender] >= amount,
            "ERC20: transfer amount exceeds allowance"
        );

        _allowances[sender][msg.sender] -= amount;
        _transfer(sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function mint(address account, uint256 amount) internal {
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        emit Mint(account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
