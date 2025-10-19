import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

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
    this.disabled = false,
  });

  const PosButton.cancel({
    this.isLoading = false,
    super.key,
    this.text = 'Batal',
    this.onPressed,
    this.variant = ButtonVariant.destructiveOutlined,
    this.icon,
    this.disabled = false,
  });

  const PosButton.process({
    this.isLoading = false,
    super.key,
    this.text = 'Proses',
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;

  static ButtonStyle? getStyle(ButtonVariant variant) {
    return switch (variant) {
      ButtonVariant.primary => null,
      ButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: AppTheme.secondaryOrange,
        fixedSize: Size.fromHeight(AppTheme.buttonHeight),
      ),
      ButtonVariant.destructive => FilledButton.styleFrom(
        backgroundColor: AppTheme.accentRed,
        fixedSize: Size.fromHeight(AppTheme.buttonHeight),
      ),
      ButtonVariant.primaryOutlined => null,
      ButtonVariant.secondaryOutlined => OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.secondaryOrange),
        foregroundColor: AppTheme.secondaryOrange,
        fixedSize: Size.fromHeight(AppTheme.buttonHeight),
      ),
      ButtonVariant.destructiveOutlined => OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.accentRed),
        foregroundColor: AppTheme.accentRed,
        fixedSize: Size.fromHeight(AppTheme.buttonHeight),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = getStyle(variant);
    final isDisabled = disabled || isLoading;

    final Widget labelWidget = Text(text);

    Widget button;
    Widget buttonChild;

    if (isLoading) {
      buttonChild = const CircularProgressIndicator.adaptive();
    } else {
      buttonChild = icon == null
          ? labelWidget
          : Row(
              children: [
                icon!,
                const SizedBox(width: 8),
                labelWidget,
              ],
            );
    }

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.destructive:
        button = FilledButton(
          style: style,
          onPressed: isDisabled ? null : onPressed,
          child: buttonChild,
        );
      case ButtonVariant.primaryOutlined:
      case ButtonVariant.secondaryOutlined:
      case ButtonVariant.destructiveOutlined:
        button = OutlinedButton(
          style: style,
          onPressed: isDisabled ? null : onPressed,
          child: buttonChild,
        );
    }

    return button;
  }
}
