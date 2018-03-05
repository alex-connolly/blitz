pragma solidity 0.4.19;


contract BlitzPurchaser {

    BlitzVault public vault;

    function BlitzPurchaser(BlitzVault _vault) public {
        require(_vault.isVault());
        vault = _vault;
    }

    function purchase() public payable returns (uint256 amount) {
        // deposit ETH in the reserve
        etherToken.deposit.value(msg.value)(); 
        // need to reset the allowance to 0 before setting a new one
        assert(etherToken.approve(tokenChanger, 0));
        // approve the changer to use the ETH amount for the purchase
        assert(etherToken.approve(tokenChanger, msg.value));

        ISmartToken smartToken = tokenChanger.token();
        uint256 returnAmount = tokenChanger.change(etherToken, smartToken, msg.value, 1); // do the actual change using the current price
        assert(smartToken.transfer(msg.sender, returnAmount)); // transfer the tokens to the sender
        return returnAmount;
    }

    function() payable {
        purchase();
    }

}
