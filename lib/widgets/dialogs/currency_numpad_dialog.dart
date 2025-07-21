import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/utils/formatter.dart';
import '../ui/numpad_pin.dart';
import 'ikki_dialog.dart';

class CurrencyNumpadDialog extends ConsumerStatefulWidget {
  const CurrencyNumpadDialog({
    super.key,
    this.initialValue = 0,
    this.placeholder = 'Masukkan Tunai',
    this.maxDigits = 9,
  });

  final int initialValue;
  final String placeholder;
  final int maxDigits;

  static Future<int?> show(BuildContext context, {int? initialValue, String? placeholder, int? maxDigits}) async {
    return showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CurrencyNumpadDialog(
          initialValue: initialValue ?? 0,
          placeholder: placeholder ?? 'Masukkan Kas Awal',
          maxDigits: maxDigits ?? 9,
        );
      },
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrencyNumpadDialogState();
}

class _CurrencyNumpadDialogState extends ConsumerState<CurrencyNumpadDialog> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void _onInputChanged(String? inputValue) {
    value = int.tryParse(inputValue ?? '') ?? 0;
    setState(() {});
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final isEmptyInput = value == 0;
    final displayValue = isEmptyInput ? widget.placeholder : Formatter.toIdr.format(value);

    return IkkiDialog(
      mainAxisSize: MainAxisSize.min,
      constraints: const BoxConstraints(maxWidth: 350),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isEmptyInput ? null : _onConfirm,
              child: const Text('Proses'),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(
                  bottom: BorderSide(
                    color: isEmptyInput ? Colors.grey[500]! : Colors.black,
                  ),
                ),
              ),
              child: Align(
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isEmptyInput ? Colors.grey[500]! : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          NumpadPin(
            aspectRatio: 19 / 12,
            onKeyPressed: (key) {
              final inputStr = value.toString();
              switch (key) {
                case NumpadKey.backspace:
                  if (inputStr.isNotEmpty) {
                    _onInputChanged(inputStr.substring(0, inputStr.length - 1));
                  }
                case NumpadKey.empty:
                case NumpadKey.decimal:
                  break;
                // ignore: no_default_cases
                default:
                  if (inputStr.length < widget.maxDigits) {
                    _onInputChanged(inputStr + key.value);
                  }
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
