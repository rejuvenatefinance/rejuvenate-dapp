import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/extensions.dart';
import '../widgets/side_navigation_menu.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key, required this.child, required this.title})
      : super(key: key);

  final String title;
  final Widget child;

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
      body: child,
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600.0,
                  ),
                  child: child,
                ),
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
  Widget build(BuildContext context) {
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
