// ignore: avoid_web_libraries_in_flutter
import "dart:html";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/app.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final UrlSearchParams params = UrlSearchParams()
    ..append(
      "isWidget",
      "true",
    )
    ..append("widgetId", "24")
    ..append("fromChain", "56")
    ..append("toChain", "56")
    ..append("fromToken", "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56")
    ..append("toToken", "0x2B60Bd0D80495DD27CE3F8610B4980E94056b30c")
    ..append("ctaColor", "#61c989")
    ..append("textColor", "#ffffff")
    ..append("backgroundColor", "0");

  // ignore error: it works on web
  ui.platformViewRegistry.registerViewFactory(
    "swapIFrame",
    (int viewId) => IFrameElement()
      ..src = "https://app.thevoyager.io/swap?${params.toString()}"
      ..style.border = "none"
      ..style.height = "100%"
      ..style.width = "100%",
  );

  runApp(
    const ProviderScope(
      child: RejuvenateApp(),
    ),
  );
}
