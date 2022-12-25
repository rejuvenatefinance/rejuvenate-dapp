import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import 'staking_chart.dart';
import '../../providers/staking_contract_flexible_provider.dart';
import '../../providers/staking_contract_provider.dart';
import '../../providers/wallet_connection_provider.dart';
import '../../widgets/amount_text_field.dart';
import '../../utils/extensions.dart';

class StakingView extends ConsumerWidget {
  const StakingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletConnect = ref.watch(walletConnectionProvider);
    final stakingContractProvider = ChangeNotifierProvider(
        (ref) => StakingContractFlexibleProvider(walletConnect));

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600.0,
              maxHeight: min(context.height() * 0.4, 400.0),
            ),
            child: Stack(
              children: <Widget>[
                const StakingChart(),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8.0,
                      sigmaY: 8.0,
                    ),
                    child: Center(
                      child: Text(
                        "The chart is not working yet!",
                        style: context.textTheme().headline5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: walletConnect.isConnected
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _StakingOption(
                        name: "Flexible Staking",
                        contractProvider: stakingContractProvider,
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        )
      ],
    ));
  }
}

class _StakingOption extends HookConsumerWidget {
  const _StakingOption({
    Key? key,
    required this.name,
    required this.contractProvider,
  }) : super(key: key);

  final String name;
  final ChangeNotifierProvider<StakingContractProvider>? contractProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stakingTextController = useTextEditingController();
    final unstakingTextController = useTextEditingController();
    final walletConnect = ref.watch(walletConnectionProvider);
    final contract = ref.watch(contractProvider!);

    final apy = useFuture(contract.apy());
    final totalStaked = useFuture(contract.totalStaked());
    final balance = useFuture(contract.balance(walletConnect.currentAddress));
    final rewards = useFuture(contract.earned(walletConnect.currentAddress));
    final allowance =
        useFuture(contract.approved(walletConnect.currentAddress));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 10.0,
        child: Container(
          color: context.theme().background.lighten(0.1),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: context.textTheme().headline4,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Staked RJV:",
                    style: context.textTheme().headline6,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    NumberFormat.compact()
                        .format((totalStaked.data ?? BigInt.zero).toEth()),
                    style: context.textTheme().headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "APY:",
                    style: context.textTheme().headline6,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "${NumberFormat.compact().format(apy.data ?? 0.0)}%",
                    style: context.textTheme().headline6?.copyWith(
                          color: context.theme().primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "You Staked:",
                    style: context.textTheme().headline6,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    NumberFormat.compact()
                        .format((balance.data ?? BigInt.zero).toEth()),
                    style: context.textTheme().headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Expanded(child: SizedBox()),
                  if ((allowance.data ?? BigInt.zero).toEth() <=
                      stakingTextController.text.toWei().toEth())
                    ElevatedButton.icon(
                      label: const Text("Approve"),
                      icon: const Icon(
                        Icons.check,
                      ),
                      style: context.theme().primaryButton(),
                      onPressed: walletConnect.isConnected
                          ? () => contract.approve("1000000".toWei())
                          : null,
                    ),
                ],
              ),
              const Divider(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 150.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: AmountTextField(
                                controller: stakingTextController,
                                hint: "100.0",
                                label: "Stake RJV",
                                formatFunction: (TextEditingValue old,
                                    TextEditingValue update) {
                                  if (update.text.isPositiveDoubleOrEmpty()) {
                                    return update;
                                  }
                                  return old;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            ElevatedButton.icon(
                              label: const Text("Stake"),
                              icon: const Icon(
                                Icons.arrow_downward,
                              ),
                              style: context.theme().onPrimaryButton(),
                              onPressed: allowance.hasData
                                  ? (allowance.data! >
                                          stakingTextController.text.toWei()
                                      ? (walletConnect.isConnected
                                          ? () => contract.stake(
                                                stakingTextController.text
                                                    .toWei(),
                                              )
                                          : null)
                                      : null)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: AmountTextField(
                                controller: unstakingTextController,
                                hint: "100.0",
                                label: "Unstake RJV",
                                formatFunction: (TextEditingValue old,
                                    TextEditingValue update) {
                                  if (update.text.isPositiveDouble()) {
                                    return update;
                                  }
                                  return old;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            ElevatedButton.icon(
                              label: const Text("Unstake"),
                              icon: const Icon(
                                Icons.arrow_upward,
                              ),
                              style: context.theme().onPrimaryButton(),
                              onPressed: walletConnect.isConnected
                                  ? () => contract.unstake(
                                        unstakingTextController.text.toWei(),
                                      )
                                  : null,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            ElevatedButton.icon(
                              label: const Text("Unstake All"),
                              icon: const Icon(
                                Icons.arrow_upward,
                              ),
                              style: context.theme().onPrimaryButton(),
                              onPressed: walletConnect.isConnected
                                  ? () async {
                                      final rjvContract = ContractERC20(
                                          CTokens.rjv["address"],
                                          walletConnect.signer);
                                      final amount = await rjvContract
                                          .balanceOf(await walletConnect.signer
                                                  ?.getAddress() ??
                                              "");
                                      contract.unstake(
                                        amount,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Rewards:",
                            style: context.textTheme().headline6,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            NumberFormat.compact()
                                .format((rewards.data ?? BigInt.zero).toEth()),
                            style: context.textTheme().headline6?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      ElevatedButton.icon(
                        label: const Text("Claim"),
                        icon: const Icon(
                          Icons.monetization_on_outlined,
                        ),
                        style: context.theme().onPrimaryButton(),
                        onPressed: walletConnect.isConnected
                            ? () => contract.claimRewards()
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
