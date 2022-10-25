import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class PartnersView extends StatelessWidget {
  const PartnersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.route()?.settings.name ?? "",
      ),
    );
  }
}
