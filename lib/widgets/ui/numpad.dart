import 'package:flutter/material.dart';

import '../../core/theme/pos_theme.dart';
import '../../shared/utils/formatter.dart';

typedef ListKeys = List<List<String>>;

const _defaultKeys = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['C', '0', 'DEL'],
];

class Numpad extends StatefulWidget {
  const Numpad({
    super.key,
    this.maxLength = 9,
    this.placeholder,
    this.initialValue,
    this.onInputChanged,
    this.customKeys = _defaultKeys,
  });
  final int maxLength;
  final int? initialValue;
  final String? placeholder;
  final ValueChanged<int?>? onInputChanged;
  final ListKeys customKeys;

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  String input = '';

  @override
  void initState() {
    super.initState();
    // Initialize input from initialValue prop
    input = widget.initialValue.toString();
  }

  String get currentInput {
    final valInt = int.tryParse(input) ?? 0;
    return Formatter.toIdr.format(valInt);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onSubmit() {
    Navigator.of(context).pop(int.tryParse(input));
  }

  void onTap(String code) {
    setState(() {
      switch (code) {
        case 'C':
          input = '';
        case 'DEL':
          if (input.isNotEmpty) {
            input = input.substring(0, input.length - 1);
          }
        default:
          if (input.isEmpty && code == '0') break;
          if (input.length < widget.maxLength) input += code;
      }
    });
    // Call the callback to notify parent of input change
    widget.onInputChanged?.call(int.tryParse(input));
  }

  @override
  Widget build(BuildContext context) {
    final isEmptyInput = input.isEmpty;
    final borderColor = isEmptyInput ? Colors.grey : POSTheme.primaryBlue;
    final textColor = isEmptyInput ? Colors.grey[500]! : Colors.black;
    final textFontWeight = isEmptyInput ? FontWeight.normal : FontWeight.bold;
    final textFontSize = isEmptyInput ? 20 : 24;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: borderColor, width: 2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isEmptyInput ? widget.placeholder ?? '' : currentInput,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: textFontSize.toDouble(),
                          color: textColor,
                          fontWeight: textFontWeight,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...widget.customKeys.map((rowKeys) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rowKeys.map((code) {
                        Widget buttonChild;
                        Color? buttonForegroundColor = Colors.black;

                        if (code == 'C') {
                          buttonChild = const Text('clr');
                        } else if (code == 'DEL') {
                          buttonChild = Icon(
                            Icons.backspace_rounded,
                            size: 28,
                            color: Colors.redAccent.shade400,
                          );
                          buttonForegroundColor = Colors.redAccent.shade400;
                        } else {
                          buttonChild = Text(code);
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: ElevatedButton(
                              onPressed: () => onTap(code),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size.fromHeight(56),
                                foregroundColor: buttonForegroundColor,
                                elevation: 0,
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: buttonChild,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16), // Space between buttons
                      Expanded(
                        child: FilledButton(
                          onPressed: int.tryParse(input) != null ? onSubmit : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 3,
                          ),
                          child: const Text('Proses'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
