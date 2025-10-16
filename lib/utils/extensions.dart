import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

extension BuildContextX on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();
}

enum SnackBarSeverity {
  success(AppTheme.accentGreen, Colors.white),
  info(AppTheme.primaryBlueLight, Colors.white),
  warning(AppTheme.statusWarning, Colors.white),
  error(AppTheme.accentRed, Colors.white);

  const SnackBarSeverity(this.bg, this.text);
  final Color bg;
  final Color text;
}
