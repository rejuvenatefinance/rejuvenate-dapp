import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//Build Context extensions
extension ContextExtension on BuildContext {
  double width() => MediaQuery.of(this).size.width;
  double height() => MediaQuery.of(this).size.height;
  ColorScheme theme() => Theme.of(this).colorScheme;
  TextTheme textTheme() => Theme.of(this).textTheme;
  NavigatorState navigator() => Navigator.of(this);
  ModalRoute<Object?>? route() => ModalRoute.of(this);
}

extension ThemeExtension on ColorScheme {
  ButtonStyle primaryButton() => ElevatedButton.styleFrom(
        foregroundColor: onPrimary,
        backgroundColor: primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      );
  ButtonStyle onPrimaryButton() => ElevatedButton.styleFrom(
        foregroundColor: onBackground,
        backgroundColor: background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      );
}

extension StringExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  String alphanumeric() =>
      replaceAll(RegExp("[^A-Za-z0-9]"), " ").trimLeft().trimRight();
  bool isInt() => int.tryParse(this) != null;
  bool isIntOrEmpty() => isInt() || isEmpty;
  bool isPositiveInt() => isInt() && int.parse(this) >= 0;
  bool isPositiveIntOrEmpty() => isPositiveInt() || isEmpty;
  bool isDouble() => double.tryParse(this) != null;
  bool isDoubleOrEmpty() => isDouble() || isEmpty;
  bool isPositiveDouble() => isDouble() && double.parse(this) >= 0;
  bool isPositiveDoubleOrEmpty() => isPositiveDouble() || isEmpty;
  BigInt toWei() =>
      isPositiveDouble() ? double.parse(this).toWei() : BigInt.zero;
}

extension UrlExtension on String {
  String asAssetUrl() =>
      "https://raw.githubusercontent.com/rejuvenate-finance/assets/master/development/frontend/$this";
}

extension DoubleExtension on double {
  BigInt toWei() => BigInt.from(this * 1e18);
}

extension BigIntExtension on BigInt {
  double toEth() => this / BigInt.from(1e18);
}

extension ColorExtension on Color {
  // ranges from 0.0 to 1.0

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  charts.Color toChartColor() =>
      charts.Color(r: red, g: green, b: blue, a: alpha);
}
