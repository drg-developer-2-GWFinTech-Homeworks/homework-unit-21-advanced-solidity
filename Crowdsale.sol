pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, 
    MintedCrowdsale,
    CappedCrowdsale,
    TimedCrowdsale,
    RefundablePostDeliveryCrowdsale {

    constructor(
        uint initial_supply,
        uint256 rate,
        address payable wallet,
        PupperCoin token,
        uint256 cap,
        uint256 openingTime,
        uint256 closingTime,
        uint256 goal
    )
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
    public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint256 goal)
        public
    {
        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token


        uint256 rate = 1;
        uint256 openingTime = now;
        uint256 closingTime = now + 7 minutes;
        uint256 cap = 300;


        PupperCoinSale pupper_sale = new PupperCoinSale(
            0,
            rate,
            wallet,
            token,
            cap,
            openingTime,
            closingTime,
            goal
        );
        token_sale_address = address(pupper_sale);

        // make the ArcadeTokenSale contract a minter, then have the PupperCoinSale renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
