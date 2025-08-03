import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';

enum ButtonVariant {
  primary,
  secondary,
  destructive,
  primaryOutlined,
  secondaryOutlined,
  destructiveOutlined,
}

class PosButton extends StatelessWidget {
  const PosButton({
    required this.text,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    super.key,
    this.onPressed,
    this.icon,
  });

  const PosButton.cancel({
    this.isLoading = false,
    super.key,
    this.text = 'Batal',
    this.onPressed,
    this.variant = ButtonVariant.destructiveOutlined,
    this.icon,
  });

  const PosButton.process({
    this.isLoading = false,
    super.key,
    this.text = 'Proses',
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Widget? icon;
  final bool isLoading;

  static ButtonStyle? getStyle(ButtonVariant variant) {
    return switch (variant) {
      ButtonVariant.primary => null,
      ButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: POSTheme.secondaryOrange,
      ),
      ButtonVariant.destructive => FilledButton.styleFrom(
        backgroundColor: POSTheme.accentRed,
      ),
      ButtonVariant.primaryOutlined => null,
      ButtonVariant.secondaryOutlined => OutlinedButton.styleFrom(
        side: const BorderSide(color: POSTheme.secondaryOrange),
        foregroundColor: POSTheme.secondaryOrange,
      ),
      ButtonVariant.destructiveOutlined => OutlinedButton.styleFrom(
        side: const BorderSide(color: POSTheme.accentRed),
        foregroundColor: POSTheme.accentRed,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = getStyle(variant);

    final Widget labelWidget = Text(text);
    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.destructive:
        button = FilledButton(
          style: style,
          onPressed: onPressed,
          child: icon == null ? labelWidget : Row(children: [icon!, const SizedBox(width: 8), labelWidget]),
        );
      case ButtonVariant.primaryOutlined:
      case ButtonVariant.secondaryOutlined:
      case ButtonVariant.destructiveOutlined:
        button = OutlinedButton(
          style: style,
          onPressed: onPressed,
          child: icon == null ? labelWidget : Row(children: [icon!, const SizedBox(width: 8), labelWidget]),
        );
    }

    return button;
  }
}
