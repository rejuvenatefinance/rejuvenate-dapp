import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class FarmsView extends StatelessWidget {
  const FarmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.route()?.settings.name ?? "",
      ),
    );
  }
}
