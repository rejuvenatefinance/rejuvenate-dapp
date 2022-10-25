import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/wallet_connection_provider.dart';
import '../../utils/constants.dart';
import '../../utils/extensions.dart';
import '../../widgets/amount_text_field.dart';

class DonationsView extends HookConsumerWidget {
  const DonationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final walletConnect = ref.watch(walletConnectionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              CStrings.donationsView["heading"] ?? "",
              style: context.textTheme().headline2,
              textAlign: TextAlign.left,
            ),
          ),
          Text(
            CStrings.donationsView["body"] ?? "",
            style: context.textTheme().bodyLarge,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 32.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AmountTextField(
              controller: controller,
              hint: CStrings.donationsView["hint"] ?? "",
              label: CStrings.donationsView["label"] ?? "",
              formatFunction: (old, update) {
                if (update.text.isPositiveDoubleOrEmpty()) {
                  return update;
                }
                return old;
              },
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            onPressed: walletConnect.isConnected
                ? () async {
                    final amount = controller.text.toWei();
                    final contract = walletConnect.contractERC20(
                      CTokens.busd["address"],
                    );
                    if (contract!.isValid) {
                      contract.transfer(
                        CWallets.treasury,
                        amount,
                      );
                    }
                  }
                : null,
            style: context.theme().primaryButton(),
            child: Text(CStrings.donationsView["button"] ?? ""),
          ),
        ],
      ),
    );
  }
}
