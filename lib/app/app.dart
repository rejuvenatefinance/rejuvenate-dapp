import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';
import 'navigation.dart';

class RejuvenateApp extends StatelessWidget {
  const RejuvenateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CColors.seed,
          primary: CColors.seed,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(
            brightness: Brightness.dark,
          ).textTheme,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: onGenerateRoute,
      initialRoute: CRoutes.stakingRoute,
    );
  }
}
