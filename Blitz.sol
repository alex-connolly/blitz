pragma solidity 0.4.19;

import "./ERC20.sol";
import "./Ownable.sol";


contract Blitz is ERC20, Ownable {

    mapping (address => bool) public approvedPurchasers;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint private supply;

    function approveAddress(address _to) external onlyOwner {
        approvedPurchasers[_to] = true;
    }

    function name() public constant returns (string) {
        return "Blitz";
    }

    function symbol() public constant returns (string) {
        return "BLZ";
    }

    function totalSupply() public constant returns (uint) {
        return supply;
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _amount) public returns (bool success) {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        uint256 allow = allowed[_from][msg.sender];
        require(balances[_from] >= _amount && allow >= _amount);
        balances[_to] += _amount;
        balances[_from] -= _amount;
        if (allow < 2**256 - 1) {
            allowed[_from][msg.sender] -= _amount;
        }
        Transfer(_from, _to, _amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}
