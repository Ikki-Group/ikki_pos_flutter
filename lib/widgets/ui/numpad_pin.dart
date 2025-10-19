import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

// --- NumpadKey Enum for type-safe key values ---
enum NumpadKey {
  digit0('0'),
  digit1('1'),
  digit2('2'),
  digit3('3'),
  digit4('4'),
  digit5('5'),
  digit6('6'),
  digit7('7'),
  digit8('8'),
  digit9('9'),
  decimal('.'),
  backspace('backspace'),
  empty('');

  const NumpadKey(this.value);
  final String value;
}

const List<List<NumpadKey>> _numpadLayout = [
  [NumpadKey.digit1, NumpadKey.digit2, NumpadKey.digit3],
  [NumpadKey.digit4, NumpadKey.digit5, NumpadKey.digit6],
  [NumpadKey.digit7, NumpadKey.digit8, NumpadKey.digit9],
  [NumpadKey.empty, NumpadKey.digit0, NumpadKey.backspace],
];

// ----------------------------------------------------------------------
// Numpad Widget Definition
// ----------------------------------------------------------------------

/// A callback function type for when a Numpad key is pressed.
typedef NumpadKeyPressed = void Function(NumpadKey key);

class NumpadPin extends StatelessWidget {
  const NumpadPin({
    super.key,
    this.onKeyPressed,
    this.buttonStyle,
    this.textStyle,
    this.spacing = 8.0,
    this.aspectRatio = 1.5,
    this.enableHapticFeedback = true,
  });

  /// Callback function triggered when a numpad key is pressed
  final NumpadKeyPressed? onKeyPressed;

  /// Custom button styling
  final ButtonStyle? buttonStyle;

  /// Custom text style for buttons
  final TextStyle? textStyle;

  /// Spacing between buttons
  final double spacing;

  /// Button aspect ratio
  final double aspectRatio;

  /// Whether to show haptic feedback on button press
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: _numpadLayout.expand((row) {
        return row.map((key) {
          return _NumpadButton(
            keyType: key,
            onTap: () => onKeyPressed?.call(key),
            buttonStyle: buttonStyle,
            textStyle: textStyle,
            enableHapticFeedback: enableHapticFeedback,
          );
        });
      }).toList(),
    );
  }
}

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({
    required this.keyType,
    required this.onTap,
    this.buttonStyle,
    this.textStyle,
    this.enableHapticFeedback = true,
  });

  final NumpadKey keyType;
  final VoidCallback onTap;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    // Handle empty key - return invisible container
    if (keyType == NumpadKey.empty) {
      return const SizedBox.shrink();
    }

    Widget buttonChild;

    // Handle backspace key with icon
    if (keyType == NumpadKey.backspace) {
      buttonChild = const Icon(
        Icons.backspace_outlined,
        size: 22,
        color: AppTheme.accentRed,
      );
    } else {
      // Handle digit and decimal keys
      buttonChild = Text(
        keyType.value,
        style:
            textStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
    }

    return OutlinedButton(
      style:
          buttonStyle ??
          OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: AppTheme.borderDark,
            backgroundColor: AppTheme.surfacePrimary,
            side: const BorderSide(color: AppTheme.borderMedium),
            fixedSize: const Size.fromHeight(AppTheme.buttonHeight),
          ),
      onPressed: () {
        // Add haptic feedback for better UX
        if (enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
      child: buttonChild,
    );
  }
}

// ----------------------------------------------------------------------
// PIN Indicator Widget
// ----------------------------------------------------------------------

class PinIndicator extends StatelessWidget {
  const PinIndicator({
    required this.pinLength,
    required this.maxLength,
    super.key,
    this.boxSize = 50.0,
    this.filledColor = Colors.black,
    this.emptyColor = Colors.transparent,
    this.borderColor = Colors.grey,
  });

  final int pinLength;
  final int maxLength;
  final double boxSize;
  final Color filledColor;
  final Color emptyColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < pinLength;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(14),
            color: emptyColor,
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isFilled ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isFilled ? 1.0 : 0.0,
                curve: Curves.elasticOut,
                child: Container(
                  width: 8,
                  height: 16,
                  decoration: BoxDecoration(
                    color: filledColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
