// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Praise {
    // mapping of affiliate addresses to referral count
    mapping(address => uint) public referrals;
    // mapping of customer addresses to affiliate addresses
    mapping(address => address) public customerReferrals;
    // mapping of affiliate addresses to timestamp of last referral
    mapping(address => uint) public lastReferralTimestamp;

    // event to notify when a referral is recorded
    event Referral(address indexed affiliate, address indexed customer, uint timestamp);

    // function to record a referral
    function refer(address customer) public {
        // increment the referral count for the affiliate
        referrals[msg.sender]++;
        // record the customer's referral
        customerReferrals[customer] = msg.sender;
        // record the timestamp of the referral
        lastReferralTimestamp[msg.sender] = now;
        // emit the referral event
        emit Referral(msg.sender, customer, now);
    }

    // function to calculate and distribute commissions
    function distributeCommissions() public {
        // iterate through the customerReferrals mapping
        for(address customer in customerReferrals) {
            address affiliate = customerReferrals[customer];
            // check if the customer made a purchase
            if (customerMadePurchase(customer)) {
                // calculate the commission for the affiliate
                uint commission = calculateCommission(affiliate);
                // transfer the commission to the affiliate
                affiliate.transfer(commission);
                // reset the referral count for the affiliate
                referrals[affiliate] = 0;
            }
        }
    }

    // check if the customer made a purchase
    function customerMadePurchase(address customer) internal view returns (bool) {
        // this function should be implemented by the merchant
        // to check if the customer made a purchase
        // for example, by checking a database or calling an external API
        return true;
    }

    // calculate the commission for the affiliate
    function calculateCommission(address affiliate) internal view returns (uint) {
        uint referralCount = referrals[affiliate];
        uint commission = referralCount * 0.1 ether; // 10% commission
        return commission;
    }
}