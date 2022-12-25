import 'package:flutter/material.dart';
import '../utils/extensions.dart';
import 'layout.dart';
import '../features/not_found/not_found_view.dart';
import '../utils/constants.dart';

import '../features/farms/farms_view.dart';
import '../features/rug_recovery/rug_recovery_view.dart';
import '../features/staking/staking_view.dart';

Route<dynamic>? onGenerateRoute(RouteSettings? settings) {
  Widget child = const NotFoundView();

  if (settings?.name == "" || settings?.name == "/") {
    settings = settings?.copyWith(
      name: CRoutes.stakingRoute,
    );
  }

  switch (settings?.name) {
    case CRoutes.farmsRoute:
      child = const FarmsView();
      break;
    case CRoutes.stakingRoute:
      child = const StakingView();
      break;
    case CRoutes.rugRecoveryRoute:
      child = const RugRecoveryView();
      break;
  }
  return _generateRoute(child, settings);
}

_generateRoute(Widget child, RouteSettings? settings) {
  return MaterialPageRoute(
    builder: (context) => Layout(
      title: settings?.name!.alphanumeric().capitalize() ?? "Rejuvenate",
      child: child,
    ),
    settings: settings,
  );
}
