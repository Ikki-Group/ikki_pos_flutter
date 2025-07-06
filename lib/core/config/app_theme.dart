import 'package:flutter/material.dart';

// Primary Colors
const Color primaryColor = Color(0xFF2563EB); // Blue-600
const Color primaryVariant = Color(0xFF1E40AF); // Blue-700
const Color secondary = Color(0xFF10B981); // Emerald-500
const Color secondaryVariant = Color(0xFF059669); // Emerald-600

// Surface Colors
const Color surface = Color(0xFFF8FAFC); // Slate-50
const Color background = Color(0xFFFFFFFF);
const Color cardColor = Color(0xFFF1F5F9); // Slate-100

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: background,
    cardColor: cardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Elevated buttons for actions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // pageTransitionsTheme: const PageTransitionsTheme(
    //   builders: {
    //     TargetPlatform.android: GoTransitions.fadeUpwards,
    //     TargetPlatform.iOS: GoTransitions.fade,
    //   },
    // ),
  );

  static const TextStyle textLabel = TextStyle(fontSize: 16);
  static const TextStyle textLabelValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static ButtonStyle btnPrimaryFilled = FilledButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle btnSecondary = OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
  );
}
