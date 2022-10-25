import 'dart:math';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:rejuvenate/utils/constants.dart';

import 'staking_contract_provider.dart';
import 'wallet_connection_provider.dart';

class StakingContractFlexibleProvider extends StakingContractProvider {
  StakingContractFlexibleProvider(
      WalletConnectionProvider walletConnectionProvider)
      : super(_address, _abi, walletConnectionProvider.signer) {
    Stream<void>.periodic(
      const Duration(minutes: 1),
      (int _) => notifyListeners(),
    );
  }

  @override
  Future<bool> claimRewards() async {
    if (!isValid) {
      return Future.value(false);
    }

    final transaction = await contract?.send(
      "claimRewards",
      [],
    );
    final receipt = await transaction?.wait();
    notifyListeners();
    return receipt?.status ?? false;
  }

  @override
  Future<BigInt> earned(String address) async {
    if (!isValid) {
      return Future.value(BigInt.zero);
    }

    return await contract?.call<BigInt>("earned", [address]) ?? BigInt.zero;
  }

  @override
  Future<BigInt> balance(String address) async {
    if (!isValid) {
      return Future.value(BigInt.zero);
    }

    return await contract?.call<BigInt>("balances", [address]) ?? BigInt.zero;
  }

  @override
  List<Point<num>> queryData({Duration duration = const Duration(days: 7)}) {
    return [];
  }

  @override
  Future<bool> stake(BigInt amount) async {
    if (!isValid) {
      return false;
    }

    final transaction = await contract?.send(
      "stake",
      [amount],
      TransactionOverride(
        value: BigInt.from(0.01 * 1e18),
      ),
    );
    final receipt = await transaction?.wait();
    notifyListeners();
    return receipt?.status ?? false;
  }

  @override
  Future<bool> unstake(BigInt amount) async {
    if (!isValid) {
      return false;
    }

    final transaction = await contract?.send(
      "unstake",
      [amount],
      TransactionOverride(
        value: BigInt.from(0.01 * 1e18),
      ),
    );
    final receipt = await transaction?.wait();
    notifyListeners();
    return receipt?.status ?? false;
  }

  @override
  Future<double> apy() async {
    final blocksPerYear = BigInt.from(365 * blocksPerDay);
    final stakedTokens = await totalStaked();
    final rewardsPerBlock =
        await contract?.call<BigInt>("rewardRate") ?? BigInt.zero;

    if (stakedTokens.compareTo(BigInt.zero) == 0 ||
        rewardsPerBlock.compareTo(BigInt.zero) == 0) {
      return double.infinity;
    }

    return (blocksPerYear * rewardsPerBlock * BigInt.from(100) / stakedTokens);
  }

  @override
  Future<BigInt> totalStaked() async {
    if (!isValid) {
      return Future.value(BigInt.zero);
    }

    return await contract?.call<BigInt>("totalStaked") ?? BigInt.zero;
  }

  @override
  Future<BigInt> approved(String address) async {
    if (!isValid) {
      return BigInt.zero;
    }
    final rjvContract = ContractERC20(CTokens.rjv["address"], contract?.signer);
    final user = await contract?.signer?.getAddress();
    if (user == null) {
      return BigInt.zero;
    }
    return await rjvContract.allowance(user, contract!.address);
  }

  @override
  Future<bool> approve(BigInt amount) async {
    final rjvContract = ContractERC20(CTokens.rjv["address"], contract?.signer);
    await rjvContract.approve(contract?.address ?? "", amount);
    return true;
  }

  static const String _address = "0x22C5D8713614088420E62277309C0FdbB17eA0db";
  static const String _abi = '''
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"wallet","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"staked","type":"uint256"}],"name":"Stake","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"wallet","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"staked","type":"uint256"}],"name":"Unstake","type":"event"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"calculateRewardPerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"rewardRate_","type":"uint256"}],"name":"changeRewardsPerBlock","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"claimRewards","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"wallet_","type":"address"}],"name":"earned","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"token_","type":"address"}],"name":"inCaseTokensGetStuck","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"block_","type":"uint256"}],"name":"retrieveData","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount_","type":"uint256"}],"name":"stake","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"token","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalStaked","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount_","type":"uint256"}],"name":"unstake","outputs":[],"stateMutability":"payable","type":"function"}]
''';
}
