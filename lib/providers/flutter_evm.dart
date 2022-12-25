import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_evm/flutter_evm.dart';

final _flutterEVM = FlutterEVM(
  bridge: "https://bridge.walletconnect.org",
  name: "Rejuvenate",
  description: "Rejuvenate Finance DApp",
  url: "https://app.rejuvenatefinance.com",
  iconUrl:
      "https://raw.githubusercontent.com/rejuvenatefinance/rejuvenate-assets/master/development/frontend/logo.png",
);

final flutterEVMProvider = ChangeNotifierProvider((_) => _flutterEVM);
