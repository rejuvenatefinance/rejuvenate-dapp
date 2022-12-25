import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/constants.dart';
import '../utils/extensions.dart';
import 'connect_button.dart';
import 'quick_links.dart';

class SideNavigationMenu extends StatelessWidget {
  const SideNavigationMenu({Key? key}) : super(key: key);

  Widget _drawer({required Widget child, required BuildContext context}) {
    return Drawer(
      backgroundColor: context.theme().primary,
      child: child,
    );
  }

  Widget _drawerContent(
      {required Widget child, Widget? bottomBar, Widget? header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (header != null) header,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: child,
        ),
        const Expanded(
          child: SizedBox(),
        ),
        if (bottomBar != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: bottomBar,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _drawer(
      context: context,
      child: _drawerContent(
        child: _SideNavigationMenuContent(),
        bottomBar: const QuickLinks(),
        header: _SideNavigationMenuHeader(),
      ),
    );
  }
}

class _SideNavigationMenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 15.0,
      ),
      child: Center(
        child: ConnectButton(
          style: context.theme().onPrimaryButton(),
        ),
      ),
    );
  }
}

class _SideNavigationMenuContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        const _SideNavigationMenuItem(
          route: CRoutes.stakingRoute,
          icon: Icons.layers_outlined,
        ),
        const _SideNavigationMenuItem(
          route: CRoutes.insuranceRoute,
          icon: Icons.shield_outlined,
        ),
        const _SideNavigationMenuItem(
          route: CRoutes.farmsRoute,
          icon: Icons.agriculture_outlined,
        ),
        Divider(
          color: context.theme().onPrimary,
        ),
        const _SideNavigationMenuItem(
          route: "Swap",
          icon: Icons.swap_horiz_outlined,
          url: "https://swap.rejuvenatefinance.com",
        ),
        const _SideNavigationMenuItem(
          route: "Bridge",
          icon: Icons.switch_access_shortcut,
          url: "https://bridge.rejuvenatefinance.com",
        ),
      ],
    );
  }
}

class _SideNavigationMenuItem extends StatelessWidget {
  const _SideNavigationMenuItem({
    Key? key,
    required this.route,
    required this.icon,
    this.url,
  }) : super(key: key);

  final IconData icon;
  final String route;
  final String? url;

  bool isSelected(BuildContext context) =>
      ModalRoute.of(context)!.settings.name == route;

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: isSelected(context)
            ? context.theme().onPrimary
            : Colors.transparent,
        width: 3.0,
      ),
      borderRadius: BorderRadius.circular(5.0),
      color: isSelected(context)
          ? context.theme().onPrimary.withOpacity(0.24)
          : Colors.transparent,
    );
  }

  ListTile _listTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.theme().onPrimary,
      ),
      title: Text(
        route.alphanumeric().capitalize(),
        style: TextStyle(
          color: context.theme().onPrimary,
        ),
      ),
      onTap: () {
        if (url == null) {
          context.navigator().pushNamed(route);
        } else {
          launchUrlString(url!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decoration(context),
      child: _listTile(context),
    );
  }
}
