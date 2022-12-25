import 'package:flutter/material.dart';

abstract class CStrings {
  static const String appName = "Rejuvenate";
}

abstract class CColors {
  static const Color seed = Color(0xff61c989);
}

abstract class CRoutes {
  static const String stakingRoute = "/staking";
  static const String farmsRoute = "/farms";
  static const String insuranceRoute = "/insurance";
}

abstract class CTokens {
  static const Map<String, dynamic> rjvf = {
    "address": "0xe41736AFF31FCcbCf619CB06Dbb3Ae33f3493C53",
    "abi": "",
    "implementsERC20": true,
  };
}

abstract class CWallets {
  static const String treasury = "0xFb08de74D3DC381d2130e8885BdaD4e558b24145";
}
