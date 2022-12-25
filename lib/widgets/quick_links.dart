import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/extensions.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: () {
              launchUrlString(
                  "https://github.com/rejuvenatefinance/rejuvenate-assets/tree/master/raw/docs");
            },
            icon: Icon(
              LineIcons.alternateExternalLink,
              color: context.theme().onPrimary,
            ),
            label: Text(
              "Documentation",
              style: TextStyle(
                color: context.theme().onPrimary,
              ),
            ),
          ),
        ),
        Divider(color: context.theme().onPrimary),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const [
              _QuickLinksItem(
                icon: LineIcons.telegram,
                url: 'https://t.me/+LxJTReW_wDRmMmYx',
              ),
              _QuickLinksItem(
                icon: LineIcons.twitter,
                url: 'https://twitter.com/rejuvenatefin',
              ),
              _QuickLinksItem(
                icon: LineIcons.discord,
                url: 'https://discord.gg/Cf2VUn4e2R',
              ),
              _QuickLinksItem(
                icon: LineIcons.github,
                url: 'https://github.com/rejuvenatefinance',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickLinksItem extends StatelessWidget {
  const _QuickLinksItem({
    Key? key,
    required this.icon,
    required this.url,
  }) : super(key: key);

  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => launchUrlString(url),
      iconSize: 32.0,
      icon: Icon(
        icon,
        color: context.theme().onPrimary,
      ),
      hoverColor: Colors.transparent,
    );
  }
}
