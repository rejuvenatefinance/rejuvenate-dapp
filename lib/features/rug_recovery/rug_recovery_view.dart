import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class RugRecoveryView extends StatelessWidget {
  const RugRecoveryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.route()?.settings.name ?? "",
      ),
    );
  }
}
