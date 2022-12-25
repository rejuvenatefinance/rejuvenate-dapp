import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rejuvenate/providers/flutter_evm.dart';

class ConnectButton extends ConsumerWidget {
  const ConnectButton({Key? key, required this.style}) : super(key: key);

  final ButtonStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletConnect = ref.watch(flutterEVMProvider);

    return ElevatedButton(
      style: style,
      onPressed: walletConnect.isConnected
          ? null
          : () async {
              walletConnect.connect(
                context,
                rpcUrl: "https://bsc-dataseed.binance.org/",
                chainId: 56,
              );
            },
      child: SizedBox(
        width: 275.0,
        height: 50.0,
        child: Center(
          child: Text(
            walletConnect.isConnected
                ? walletConnect.credentials?.address.hex ?? "Loading..."
                : "Connect Wallet",
            style: const TextStyle(
              fontSize: 18.0,
            ),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
