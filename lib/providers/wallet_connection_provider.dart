import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletConnectionProvider =
    ChangeNotifierProvider<WalletConnectionProvider>(
  (ref) => WalletConnectionProvider(),
);

class WalletConnectionProvider extends ChangeNotifier {
  final _isConnected = ValueNotifier<bool>(false);
  bool get isConnected => _isConnected.value;

  final _currentAddress = ValueNotifier<String>("");
  String get currentAddress => _currentAddress.value;

  final _signer = ValueNotifier<Signer?>(null);
  Signer? get signer => _signer.value;

  WalletConnectionProvider() {
    _isConnected.addListener(() {
      notifyListeners();
    });
    _currentAddress.addListener(() {
      notifyListeners();
    });
    _signer.addListener(() {
      notifyListeners();
    });
  }

  Future<void> connect() async {
    if (ethereum == null) {
      return;
    }
    final currentChain = await ethereum!.getChainId();
    if (currentChain != 56) {
      await ethereum!.walletSwitchChain(56);
    }
    ethereum!.onConnect((info) async {
      final accounts = await ethereum!.getAccounts();
      _currentAddress.value = accounts.first;
      _isConnected.value = true;
      _signer.value = provider?.getSigner();
    });
    ethereum!.onAccountsChanged((chainId) async {
      final accounts = await ethereum!.getAccounts();
      _currentAddress.value = accounts.first;
      _isConnected.value = true;
      _signer.value = provider?.getSigner();
    });
    ethereum!.onDisconnect((_) {
      _currentAddress.value = "";
      _isConnected.value = false;
      _signer.value = null;
    });
    final accounts = await ethereum!.requestAccount();
    if (accounts.isNotEmpty) {
      _currentAddress.value = accounts.first;
      _isConnected.value = true;
      _signer.value = provider?.getSigner();
    }
  }

  Future<String>? call({
    String? to,
    String? from,
    BigInt? value,
    BigInt? gasLimit,
    BigInt? gasPrice,
    int? nounce,
    String? data,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
  }) {
    if (!isConnected) {
      return null;
    }

    return signer?.call(TransactionRequest(
      to: to,
      from: from,
      value: value,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
      nounce: nounce,
      data: data,
      maxFeePerGas: maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
    ));
  }

  ContractInterface? contract(String address, String abi) {
    if (!isConnected) {
      return null;
    }

    final contract = Contract(address, abi, signer);
    return ContractInterface._fromContract(contract);
  }

  ContractInterfaceERC20? contractERC20(String address) {
    if (!isConnected) {
      return null;
    }

    final contract = ContractERC20(address, signer);
    return ContractInterfaceERC20._fromContract(contract);
  }
}

class ContractInterface {
  // ignore: unused_element
  const ContractInterface._() : _contract = null; //default constructor override
  const ContractInterface._fromContract(Contract contract)
      : _contract = contract;

  final Contract? _contract;

  bool get isValid => _contract != null;
  String? get address => _contract?.address;
  String? get abi => _contract?.interface.formatJson();

  Future<T>? call<T>(String method, [List<dynamic> args = const []]) async {
    if (!isValid) {
      return Future.value(null);
    }
    return _contract!.call<T>(method, [args]);
  }
}

class ContractInterfaceERC20 {
  // ignore: unused_element
  const ContractInterfaceERC20._()
      : _contract = null; //default constructor override
  const ContractInterfaceERC20._fromContract(ContractERC20 contract)
      : _contract = contract;

  final ContractERC20? _contract;

  bool get isValid => _contract != null;
  Future<String?> get name async => _contract?.name ?? Future.value(null);
  Future<String?> get symbol async => _contract?.symbol ?? Future.value(null);

  Future<String?> transfer(String to, BigInt amount) async {
    final response = await _contract?.transfer(to, amount);
    return response?.raw;
  }
}
