import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  // Font family
  static const lato = "Lato";
  static const inter = "Inter";
  static const montserrat = "Montserrat";

  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  // Secondary Colors
  static const Color secondaryOrange = Color(0xFFEA580C);
  static const Color secondaryOrangeLight = Color(0xFFF97316);
  static const Color secondaryOrangeDark = Color(0x00dc2626);

  // Accent Colors
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color.fromARGB(255, 24, 255, 182);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF06B6D4);

  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8FAFC);
  static const Color surfaceTertiary = Color(0xFFF1F5F9);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFF8FAFC);
  static const Color backgroundSecondary = Color(0xFFF4F7FD);
  static const Color backgroundAccent = Color(0xFFDEF7EC);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF374151);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);

  // Status Colors
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusInfo = Color(0xFF3B82F6);

  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x25000000);

  static const Color cardBorderFocus = Color.fromARGB(255, 106, 162, 253);
  static const Color cardBgFocus = Color.fromARGB(255, 237, 242, 252);

  static BorderRadius radius8 = BorderRadius.circular(8);

  static const TextStyle buttonText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const double buttonHeight = 48;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 16);

  static const Size appBarHeight = Size.fromHeight(72);

  // Main Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: lato,

      // Color Scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryBlue,
        onPrimary: textOnPrimary,
        secondary: secondaryOrange,
        onSecondary: textOnPrimary,
        error: statusError,
        onError: textOnPrimary,
        surface: surfacePrimary,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceSecondary,
        onSurfaceVariant: textSecondary,
        outline: borderMedium,
        outlineVariant: borderLight,
        shadow: shadowMedium,
        scrim: shadowDark,
        inverseSurface: textPrimary,
        onInverseSurface: textOnPrimary,
        inversePrimary: primaryBlueLight,
        primaryContainer: Color(0xFFEBF4FF),
        onPrimaryContainer: Color(0xFF001D3D),
        secondaryContainer: Color(0xFFFFEDD5),
        onSecondaryContainer: Color(0xFF2A1400),
        tertiary: accentGreen,
        onTertiary: textOnPrimary,
        tertiaryContainer: Color(0xFFD1FAE5),
        onTertiaryContainer: Color(0xFF064E3B),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        surfaceTint: primaryBlue,
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: backgroundPrimary,

      // AppBar Theme - Based on competitor's blue header
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: textOnPrimary,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textOnPrimary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: textOnPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        toolbarHeight: 68,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textOnPrimary,
          elevation: 2,
          shadowColor: Colors.black,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: radius8,
          ),
          textStyle: buttonText,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textOnPrimary,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: radius8,
          ),
          textStyle: buttonText,
          iconSize: 18,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: const WidgetStateBorderSide.fromMap({
            WidgetState.disabled: BorderSide(color: textTertiary),
            WidgetState.any: BorderSide(color: primaryBlue),
          }),
          padding: const WidgetStatePropertyAll(buttonPadding),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: radius8,
            ),
          ),
          textStyle: WidgetStateProperty.all(buttonText),
          iconSize: WidgetStateProperty.all(18),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: radius8,
          ),
          textStyle: buttonText,
          iconSize: 18,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primaryBlue,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(14),
          iconSize: 18,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: primaryBlue),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlueLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: statusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: statusError, width: 2),
        ),
        hintStyle: const TextStyle(
          color: textTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: const TextStyle(
          color: textTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Chip Theme - Category buttons
      chipTheme: ChipThemeData(
        backgroundColor: backgroundPrimary,
        selectedColor: primaryBlue,
        disabledColor: surfaceTertiary,
        checkmarkColor: textOnPrimary,
        iconTheme: const IconThemeData(color: primaryBlue, size: 14),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: WidgetStateColor.fromMap({
            WidgetState.selected: textOnPrimary,
            WidgetState.disabled: textTertiary,
            WidgetState.any: textOnSecondary,
          }),
        ),
        side: const BorderSide(color: borderMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 5,
        pressElevation: 0,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w400,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: borderMedium,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      primaryIconTheme: const IconThemeData(
        color: primaryBlue,
        size: 24,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontFamily: lato,
          letterSpacing: -.25,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: .25,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: .25,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: .25,
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: .25,
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: GoTransitions.fadeUpwards,
          TargetPlatform.iOS: GoTransitions.fade,
        },
      ),
    );
  }
}

// Custom Colors Extension for easy access
extension POSColors on BuildContext {
  Color get primaryBlue => AppTheme.primaryBlue;
  Color get secondaryOrange => AppTheme.secondaryOrange;
  Color get accentGreen => AppTheme.accentGreen;
  Color get accentRed => AppTheme.accentRed;
  Color get textPrimary => AppTheme.textPrimary;
  Color get textSecondary => AppTheme.textSecondary;
  Color get surfaceCard => AppTheme.surfaceCard;
  Color get borderLight => AppTheme.borderLight;
}

extension POSTextStylesX on BuildContext {
  TextStyle get textStyle => GoogleFonts.poppins(letterSpacing: .5);
}

extension TextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
