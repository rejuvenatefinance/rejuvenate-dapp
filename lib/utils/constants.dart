import 'package:flutter/material.dart';

abstract class CStrings {
  static const String appName = "Rejuvenate";
  static const Map<String, String> donationsView = {
    "heading": "Donate \$BUSD",
    "body":
        "If you want to support the mission, but are not interested in participating in the Rejuvenate Ecosystem you can donate something directly to the Treasury.",
    "hint": "100.00",
    "label": "BUSD Amount",
    "button": "Donate",
  };
  static const Map<String, String> farmsView = {
    "heading": "Yield Farming",
    "body":
        "While we are in the process of building out our Infrastructur our Partner sBancc will handle our Yield Farming Needs. Participants will farm yield while providing Liquidity for the Protocol.",
    "button": "Farm",
  };
}

abstract class CColors {
  static const Color seed = Color(0xff61c989);
}

abstract class CRoutes {
  static const String donationsRoute = "/donate";
  static const String stakingRoute = "/staking";
  static const String farmsRoute = "/farms";
  static const String rugRecoveryRoute = "/rug-recovery";
  static const String partnersRoute = "/partners";
}

abstract class CTokens {
  static const Map<String, dynamic> rjv = {
    "address": "0x2B60Bd0D80495DD27CE3F8610B4980E94056b30c",
    "abi": "",
    "implementsERC20": true,
  };
  static const Map<String, dynamic> busd = {
    "address": "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56",
    "abi": null,
    "implementsERC20": true,
  };
}

abstract class CContracts {
  static const Map<String, dynamic> staking = {
    "address": "0xc11f01e5128B0CACdfe1A46879f3497460B9f30e",
    "abi":
        '''[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"wallet","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"staked","type":"uint256"}],"name":"Stake","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"wallet","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"staked","type":"uint256"}],"name":"Unstake","type":"event"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"calculateRewardPerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"rewardRate_","type":"uint256"}],"name":"changeRewardsPerBlock","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"claimRewards","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"wallet_","type":"address"}],"name":"earned","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"token_","type":"address"}],"name":"inCaseTokensGetStuck","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"start_","type":"uint256"}],"name":"retrieveData","outputs":[{"internalType":"uint256[30000]","name":"","type":"uint256[30000]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount_","type":"uint256"}],"name":"stake","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"token","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalStaked","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"unpause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount_","type":"uint256"}],"name":"unstake","outputs":[],"stateMutability":"payable","type":"function"}]''',
  };
}

abstract class CWallets {
  static const String treasury = "0xFb08de74D3DC381d2130e8885BdaD4e558b24145";
}
