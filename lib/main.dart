// ignore: avoid_web_libraries_in_flutter
import "dart:html";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/app.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: RejuvenateApp(),
    ),
  );
}
