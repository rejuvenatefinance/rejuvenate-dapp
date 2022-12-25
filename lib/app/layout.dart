import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metaballs/metaballs.dart';
import 'package:rejuvenate/providers/wallet_connection_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/side_navigation_menu.dart';

// ignore: must_be_immutable
class Layout extends ConsumerWidget {
  Layout({Key? key, required this.child, required this.title})
      : super(key: key);

  final String title;
  Widget child;
  Widget? loadingWidget;

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      backgroundColor: context.theme().primary,
      foregroundColor: context.theme().onPrimary,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kToolbarHeight / 6),
          child: ElevatedButton.icon(
            onPressed: () =>
                launchUrlString("https://swap.rejuvenatefinance.com"),
            label: const Text(
              "Buy RJV",
            ),
            icon: const Icon(
              Icons.monetization_on_outlined,
            ),
            style: context.theme().onPrimaryButton(),
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kToolbarHeight / 6),
          child: ElevatedButton.icon(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 200.0,
                          maxWidth: 300.0,
                          minWidth: min(context.width(), 300.0),
                        ),
                        child: _MigrationDialog()),
                    title: const Text("Migration"),
                  );
                },
              );
            },
            label: const Text(
              "Migrate",
            ),
            icon: const Icon(
              Icons.swap_horizontal_circle_outlined,
            ),
            style: context.theme().onPrimaryButton(),
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        IconButton(
          icon: const Icon(
            Icons.info,
          ),
          color: context.theme().background,
          onPressed: () => _showContractInfoDialog(context),
        ),
        const SizedBox(
          width: 16.0,
        ),
      ],
    );
  }

  Widget _background(BuildContext context, {required Widget child}) {
    return Metaballs(
      color: context.theme().background.lighten(0.01),
      metaballs: 40,
      animationDuration: const Duration(milliseconds: 200),
      speedMultiplier: 0.5,
      bounceStiffness: 3,
      minBallRadius: 15,
      maxBallRadius: 40,
      glowRadius: 0.7,
      glowIntensity: 0.2,
      child: child,
    );
  }

  Scaffold _mobileScaffold(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: const SideNavigationMenu(),
      body: loadingWidget ?? child,
    );
  }

  Scaffold _desktopScaffold(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SideNavigationMenu(),
          Expanded(
            child: _background(
              context,
              child: Center(
                child: loadingWidget ?? child,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CachedNetworkImage(
        imageUrl: "logo.png".asAssetUrl(),
        placeholder: (context, url) => const Center(),
        errorWidget: (context, url, error) => const Center(),
        height: 64.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletProvider = ref.watch(walletConnectionProvider);
    loadingWidget = walletProvider.isConnected
        ? null
        : Column(
            children: [
              Container(
                height: 50.0,
                width: context.width(),
                color: context.theme().errorContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "No Wallet Connected!",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.halfTriangleDot(
                        color: context.theme().onBackground,
                        size: 50.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text("Loading..."),
                    ],
                  ),
                ),
              ),
            ],
          );
    if (context.width() >= 900) {
      return _desktopScaffold(context);
    }
    return _mobileScaffold(context);
  }

  _showContractInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Important Addresses'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  '\$RJV Token:',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const SelectableText(
                  '0x2B60Bd0D80495DD27CE3F8610B4980E94056b30c',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                const Text(
                  'MultiSig Treasury:',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const SelectableText(
                  '0xFb08de74D3DC381d2130e8885BdaD4e558b24145',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    launchUrlString(
                        "https://debank.com/profile/0xfb08de74d3dc381d2130e8885bdad4e558b24145");
                  },
                  child: Text(
                    "Show on DeBank",
                    style: TextStyle(
                      color: context.theme().primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  color: context.theme().primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _MigrationDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletConnect = ref.watch(walletConnectionProvider);
    if (!walletConnect.isConnected) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "The process of Migration will walk you through 2 Transactions, one to approve the migration contract and one to actually migrate the tokens.",
        ),
        const SizedBox(
          height: 32.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kToolbarHeight / 6),
          child: ElevatedButton.icon(
            onPressed: () async {
              final rjvContract =
                  ContractERC20(CTokens.rjv["address"], walletConnect.signer);
              await rjvContract.approve(CContracts.migration["address"],
                  BigInt.from(1000000 * pow(10, 18)));
              final amount = await rjvContract
                  .balanceOf(await walletConnect.signer?.getAddress() ?? "");
              while (await rjvContract.allowance(
                      await walletConnect.signer?.getAddress() ?? "",
                      CContracts.migration["address"]) <
                  amount) {
                sleep(const Duration(milliseconds: 500));
              }
              final migration = Contract(
                CContracts.migration["address"],
                CContracts.migration["abi"],
                walletConnect.signer,
              );
              await migration.call(
                "migrate",
                [amount],
              );
              // ignore: use_build_context_synchronously
              context.navigator().pop();
            },
            label: const Text(
              "Migrate",
            ),
            icon: const Icon(
              Icons.swap_horizontal_circle_outlined,
            ),
            style: context.theme().primaryButton(),
          ),
        ),
      ],
    );
  }
}
