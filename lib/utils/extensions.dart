import 'package:flutter/material.dart';

import '../core/config/pos_theme.dart';

extension BuildContextX on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showTextSnackBar(
    String text, {
    SnackBarSeverity severity = SnackBarSeverity.success,
  }) => ScaffoldMessenger.of(this).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text, style: TextStyle(color: severity.text)),
      backgroundColor: severity.bg,
    ),
  );

  void unfocus() => FocusScope.of(this).unfocus();
}

enum SnackBarSeverity {
  success(POSTheme.accentGreen, Colors.white),
  info(POSTheme.primaryBlueLight, Colors.white),
  warning(POSTheme.statusWarning, Colors.white),
  error(POSTheme.accentRed, Colors.white);

  const SnackBarSeverity(this.bg, this.text);
  final Color bg;
  final Color text;
}
