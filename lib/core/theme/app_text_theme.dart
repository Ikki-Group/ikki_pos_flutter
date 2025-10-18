import 'package:flutter/material.dart';

abstract class AppTextTheme {
  static const lato = "Lato";
  static const inter = "Inter";
  static const montserrat = "Montserrat";

  static TextStyle titleLarge = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.w600,
    fontFamily: inter,
    letterSpacing: -0.25,
  );
}
