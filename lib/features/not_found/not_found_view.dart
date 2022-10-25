import 'package:flutter/material.dart';
import '../../utils/extensions.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Route Not Found",
            style: TextStyle(
              color: context.theme().primary,
              fontSize: 32.0,
            ),
          ),
          Text(
            context.route()?.settings.name ?? "",
          ),
        ],
      ),
    );
  }
}
