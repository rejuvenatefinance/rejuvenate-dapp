import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';

abstract class StakingContractProvider extends ChangeNotifier {
  StakingContractProvider(String address, String abi, Signer? signer)
      : _contract = signer != null ? Contract(address, abi, signer) : null;

  final Contract? _contract;
  Contract? get contract => _contract;

  bool get isValid => _contract != null;

  int get blocksPerDay => 28000;

  Future<bool> stake(BigInt amount);

  Future<bool> unstake(BigInt amount);

  Future<bool> claimRewards();

  Future<bool> approve(BigInt amount);

  Future<BigInt> approved(String address);

  Future<BigInt> earned(String address);

  Future<BigInt> balance(String address);

  Future<BigInt> totalStaked();

  Future<double> apy();

  List<Point> queryData({Duration duration = const Duration(days: 7)});
}
