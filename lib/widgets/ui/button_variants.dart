import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  destructive,
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
  // Base colors (define these in your theme)
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color secondaryColor = Color(0xFF6B7280);
  static const Color destructiveColor = Color(0xFFEF4444);
  static const Color surfaceColor = Color(0xFFF9FAFB);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color textPrimaryColor = Color(0xFF111827);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color textOnPrimaryColor = Color(0xFFFFFFFF);

  static ButtonStyle getVariant(ButtonVariant variant, {ButtonSize size = ButtonSize.medium}) {
    switch (variant) {
      case ButtonVariant.primary:
        return _primaryButton(size);
      case ButtonVariant.secondary:
        return _secondaryButton(size);
      case ButtonVariant.destructive:
        return _destructiveButton(size);
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
      disabledBackgroundColor: Color(0xFFE5E7EB),
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
          return Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return Color(0xFF2563EB); // Darker blue on hover
        }
        if (states.contains(WidgetState.pressed)) {
          return Color(0xFF1D4ED8); // Even darker on press
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
      disabledBackgroundColor: Color(0xFFE5E7EB),
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
          return Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return Color(0xFF4B5563);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color(0xFF374151);
        }
        return secondaryColor;
      }),
    );
  }

  static ButtonStyle _destructiveButton(ButtonSize size) {
    return ElevatedButton.styleFrom(
      backgroundColor: destructiveColor,
      foregroundColor: textOnPrimaryColor,
      disabledBackgroundColor: Color(0xFFE5E7EB),
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
          return Color(0xFFE5E7EB);
        }
        if (states.contains(WidgetState.hovered)) {
          return Color(0xFFDC2626);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color(0xFFB91C1C);
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
      side: BorderSide(color: borderColor, width: 1),
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
          return Color(0xFFF9FAFB);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color(0xFFF3F4F6);
        }
        return Colors.transparent;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: Color(0xFFE5E7EB), width: 1);
        }
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(color: primaryColor, width: 1);
        }
        return BorderSide(color: borderColor, width: 1);
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
          return Color(0xFFF9FAFB);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color(0xFFF3F4F6);
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
          return Color(0xFF2563EB);
        }
        return primaryColor;
      }),
    );
  }
}

// Custom Button Widget
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final double? width;

  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  const ThemedButton.cancel({
    super.key,
    this.text = "Batal",
    this.onPressed,
    this.variant = ButtonVariant.destructive,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  const ThemedButton.process({
    super.key,
    this.text = "Proses",
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

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
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        );
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return TextButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        );
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        );
    }
  }

  Widget _buildIconButton(ButtonStyle style) {
    switch (variant) {
      case ButtonVariant.outline:
        return OutlinedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon!,
          label: Text(text),
        );
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return TextButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon!,
          label: Text(text),
        );
      default:
        return ElevatedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon!,
          label: Text(text),
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
              SizedBox(width: 8),
              Text(text),
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ButtonVariants.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(text),
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ButtonVariants.textOnPrimaryColor,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(text),
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
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Small',
              size: ButtonSize.small,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Medium',
              size: ButtonSize.medium,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Large',
              size: ButtonSize.large,
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Secondary Buttons
        Text('Secondary Buttons', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Secondary',
              variant: ButtonVariant.secondary,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'With Icon',
              variant: ButtonVariant.secondary,
              icon: Icon(Icons.star),
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Destructive Buttons
        Text('Destructive Buttons', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Delete',
              variant: ButtonVariant.destructive,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Remove Item',
              variant: ButtonVariant.destructive,
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Outline Buttons
        Text('Outline Buttons', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Outline',
              variant: ButtonVariant.outline,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Cancel',
              variant: ButtonVariant.outline,
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Ghost Buttons
        Text('Ghost Buttons', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Ghost',
              variant: ButtonVariant.ghost,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Link Style',
              variant: ButtonVariant.link,
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Loading States
        Text('Loading States', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ThemedButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
            ThemedButton(
              text: 'Processing',
              variant: ButtonVariant.secondary,
              isLoading: true,
              onPressed: () {},
            ),
          ],
        ),

        SizedBox(height: 16),

        // Full Width
        Text('Full Width', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 8),
        ThemedButton(
          text: 'Full Width Button',
          width: double.infinity,
          onPressed: () {},
        ),
      ],
    );
  }
}
