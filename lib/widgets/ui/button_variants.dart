// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';

import '../../core/config/pos_theme.dart';

enum ButtonVariant {
  primary,
  secondary,
  destructive,
  outlinedDestructive,
  outline,
  ghost,
  link,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class ButtonVariants {
  static const Color primaryColor = POSTheme.primaryBlue;
  static const Color secondaryColor = POSTheme.secondaryOrange;
  static const Color destructiveColor = POSTheme.accentRed;
  static const Color surfaceColor = Color(0xFFF9FAFB);
  static const Color borderColor = POSTheme.borderLight;
  static const Color textPrimaryColor = POSTheme.textPrimary;
  static const Color textSecondaryColor = POSTheme.textSecondary;
  static const Color textOnPrimaryColor = POSTheme.textOnPrimary;

  static ButtonStyle getVariant(ButtonVariant variant, {ButtonSize size = ButtonSize.medium}) {
    switch (variant) {
      case ButtonVariant.primary:
        return _primaryButton(size);
      case ButtonVariant.secondary:
        return _secondaryButton(size);
      case ButtonVariant.destructive:
        return _destructiveButton(size);
      case ButtonVariant.outlinedDestructive:
        return _outlinedDestructiveButton(size);
      case ButtonVariant.outline:
        return _outlineButton(size);
      case ButtonVariant.ghost:
        return _ghostButton(size);
      case ButtonVariant.link:
        return _linkButton(size);
    }
  }

  static EdgeInsetsGeometry _getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  static double _getFontSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  static double _getMinHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }

  static ButtonStyle _primaryButton(ButtonSize size) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textOnPrimaryColor,
      disabledBackgroundColor: const Color(0xFFE5E7EB),
      disabledForegroundColor: textSecondaryColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF2563EB); // Darker blue on hover
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF1D4ED8); // Even darker on press
        }
        return primaryColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor;
        }
        return textOnPrimaryColor;
      }),
    );
  }

  static ButtonStyle _secondaryButton(ButtonSize size) {
    return ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: textOnPrimaryColor,
      disabledBackgroundColor: const Color(0xFFE5E7EB),
      disabledForegroundColor: textSecondaryColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF4B5563);
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF374151);
        }
        return secondaryColor;
      }),
    );
  }

  static ButtonStyle _destructiveButton(ButtonSize size) {
    return ElevatedButton.styleFrom(
      backgroundColor: destructiveColor,
      foregroundColor: textOnPrimaryColor,
      disabledBackgroundColor: const Color(0xFFE5E7EB),
      disabledForegroundColor: textSecondaryColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFDC2626);
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFB91C1C);
        }
        return destructiveColor;
      }),
    );
  }

  static ButtonStyle _outlinedDestructiveButton(ButtonSize size) {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: destructiveColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: textSecondaryColor,
      side: const BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFF9FAFB);
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFF3F4F6);
        }
        return Colors.transparent;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: Color(0xFFE5E7EB));
        }
        if (states.contains(WidgetState.hovered)) {
          return const BorderSide(color: Color(0xFFDC2626));
        }
        return const BorderSide(color: destructiveColor);
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return destructiveColor;
        }
        return destructiveColor;
      }),
    );
  }

  static ButtonStyle _outlineButton(ButtonSize size) {
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimaryColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: textSecondaryColor,
      side: const BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFF9FAFB);
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFF3F4F6);
        }
        return Colors.transparent;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: Color(0xFFE5E7EB));
        }
        if (states.contains(WidgetState.hovered)) {
          return const BorderSide(color: primaryColor);
        }
        return const BorderSide(color: borderColor);
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return primaryColor;
        }
        return textPrimaryColor;
      }),
    );
  }

  static ButtonStyle _ghostButton(ButtonSize size) {
    return TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimaryColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: textSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFF9FAFB);
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFF3F4F6);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return primaryColor;
        }
        return textPrimaryColor;
      }),
    );
  }

  static ButtonStyle _linkButton(ButtonSize size) {
    return TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: primaryColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: textSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: _getPadding(size),
      minimumSize: Size(0, _getMinHeight(size)),
      textStyle: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF2563EB);
        }
        return primaryColor;
      }),
    );
  }
}

// Custom Button Widget
class ThemedButton extends StatelessWidget {
  const ThemedButton({
    required this.text,
    super.key,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  const ThemedButton.cancel({
    super.key,
    this.text = const Text('Batal'),
    this.onPressed,
    this.variant = ButtonVariant.outlinedDestructive,
    this.size = ButtonSize.large,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  const ThemedButton.process({
    super.key,
    this.text = const Text('Proses'),
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.large,
    this.icon,
    this.isLoading = false,
    this.width,
  });
  final Widget text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    Widget button;
    final style = ButtonVariants.getVariant(variant, size: size);

    if (isLoading) {
      button = _buildLoadingButton(style);
    } else if (icon != null) {
      button = _buildIconButton(style);
    } else {
      button = _buildRegularButton(style);
    }

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }

  Widget _buildRegularButton(ButtonStyle style) {
    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.outlinedDestructive:
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: text,
        );
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return TextButton(
          onPressed: onPressed,
          style: style,
          child: text,
        );
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: text,
        );
    }
  }

  Widget _buildIconButton(ButtonStyle style) {
    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.outlinedDestructive:
        return OutlinedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: text,
        );
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return TextButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: text,
        );
      default:
        return ElevatedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: text,
        );
    }
  }

  Widget _buildLoadingButton(ButtonStyle style) {
    final loadingSize = size == ButtonSize.small
        ? 16.0
        : size == ButtonSize.medium
        ? 18.0
        : 20.0;

    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.outlinedDestructive:
        return OutlinedButton(
          onPressed: null,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: loadingSize,
                height: loadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    variant == ButtonVariant.outline ? ButtonVariants.primaryColor : ButtonVariants.textOnPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              text,
            ],
          ),
        );
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return TextButton(
          onPressed: null,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: loadingSize,
                height: loadingSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ButtonVariants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              text,
            ],
          ),
        );
      default:
        return ElevatedButton(
          onPressed: null,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: loadingSize,
                height: loadingSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ButtonVariants.textOnPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              text,
            ],
          ),
        );
    }
  }
}

// Usage Examples
class ButtonExamples extends StatefulWidget {
  const ButtonExamples({super.key});

  @override
  _ButtonExamplesState createState() => _ButtonExamplesState();
}

class _ButtonExamplesState extends State<ButtonExamples> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Buttons
        Text('Primary Buttons', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Small',
        //         size: ButtonSize.small,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Medium',
        //         size: ButtonSize.medium,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Large',
        //         size: ButtonSize.large,
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Secondary Buttons
        //   Text('Secondary Buttons', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Secondary',
        //         variant: ButtonVariant.secondary,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'With Icon',
        //         variant: ButtonVariant.secondary,
        //         icon: Icon(Icons.star),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Destructive Buttons
        //   Text('Destructive Buttons', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Delete',
        //         variant: ButtonVariant.destructive,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Remove Item',
        //         variant: ButtonVariant.destructive,
        //         icon: Icon(Icons.delete),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Outline Buttons
        //   Text('Outline Buttons', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Outline',
        //         variant: ButtonVariant.outline,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Cancel',
        //         variant: ButtonVariant.outline,
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Ghost Buttons
        //   Text('Ghost Buttons', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Ghost',
        //         variant: ButtonVariant.ghost,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Link Style',
        //         variant: ButtonVariant.link,
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Loading States
        //   Text('Loading States', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: [
        //       ThemedButton(
        //         text: 'Loading',
        //         isLoading: true,
        //         onPressed: () {},
        //       ),
        //       ThemedButton(
        //         text: 'Processing',
        //         variant: ButtonVariant.secondary,
        //         isLoading: true,
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),

        //   SizedBox(height: 16),

        //   // Full Width
        //   Text('Full Width', style: Theme.of(context).textTheme.headlineSmall),
        //   SizedBox(height: 8),
        //   ThemedButton(
        //     text: 'Full Width Button',
        //     width: double.infinity,
        //     onPressed: () {},
        //   ),
      ],
    );
  }
}
