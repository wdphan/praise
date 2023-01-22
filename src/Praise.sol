// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Praise {
    // mapping of affiliate addresses to referral count
    mapping(address => uint) public referrals;
    // mapping of customer addresses to affiliate addresses
    mapping(address => address) public customerReferrals;
    // mapping of customer addresses to purchase status
    mapping(address => bool) public customerPurchases;

    // event to notify when a referral is recorded
    event Referral(address indexed affiliate, address indexed customer);
    // event to notify when a purchase is recorded
    event Purchase(address indexed customer);

    // function to record a referral
    function refer(address customer) public {
        // increment the referral count for the affiliate
        referrals[msg.sender]++;
        // record the customer's referral
        customerReferrals[customer] = msg.sender;
        // emit the referral event
        emit Referral(msg.sender, customer);
    }

    // function to record a purchase
    function recordPurchase(address customer) public {
        // record the customer's purchase
        customerPurchases[customer] = true;
        // emit the purchase event
        emit Purchase(customer);
    }//

    // function to calculate and distribute commissions
    function distributeCommissions() public {
        // iterate through the customerReferrals mapping
        for(address customer in customerReferrals) {
            address affiliate = customerReferrals[customer];
            // check if the customer made a purchase
            if (customerPurchases[customer]) {
                // calculate the commission for the affiliate
                uint commission = calculateCommission(affiliate);
                // transfer the commission to the affiliate
                affiliate.transfer(commission);
                // reset the referral count for the affiliate
                referrals[affiliate] = 0;
                // reset the purchase status for the customer
                customerPurchases[customer] = false;
            }
        }
    }

    // calculate the commission for the affiliate
    function calculateCommission(address affiliate) internal view returns (uint) {
        uint referralCount = referrals[affiliate];
        uint commission = referralCount * 0.1 ether; // 10% commission
        return commission;
    }
}
