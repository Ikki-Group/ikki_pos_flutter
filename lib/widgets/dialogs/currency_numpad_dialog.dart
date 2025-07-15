import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/shared/utils/formatter.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';
import 'package:ikki_pos_flutter/widgets/ui/ikki_dialog.dart';
import 'package:ikki_pos_flutter/widgets/ui/numpad_pin.dart';

class CurrencyNumpadDialog extends ConsumerStatefulWidget {
  const CurrencyNumpadDialog({super.key, this.initialValue});
  final int? initialValue;

  static Future<int?> show(BuildContext context, {int? initialValue}) async {
    return showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CurrencyNumpadDialog(
          initialValue: initialValue ?? 0,
        );
      },
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrencyNumpadDialogState();
}

class _CurrencyNumpadDialogState extends ConsumerState<CurrencyNumpadDialog> {
  final _maxInputLength = 9;
  int? _input;

  @override
  void initState() {
    super.initState();
    _input = widget.initialValue;
  }

  void onInputChanged(String? value) {
    setState(() {
      _input = int.tryParse(value ?? "") ?? 0;
    });
  }

  void onSubmit() {
    Navigator.of(context).pop(_input);
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = "Masukkan Kas Awal";

    bool isEmptyInput = _input == null || _input == 0;
    String? value = isEmptyInput ? null : Formatter.toIdr.format(_input!);

    return IkkiDialog(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: BoxBorder.fromLTRB(
                    bottom: BorderSide(
                      color: isEmptyInput ? Colors.grey[500]! : Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value ?? placeholder,
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
              aspectRatio: 4 / 2,
              onKeyPressed: (key) {
                final inputStr = _input?.toString() ?? "";
                switch (key) {
                  case NumpadKey.backspace:
                    if (inputStr.isNotEmpty) {
                      onInputChanged(inputStr.substring(0, inputStr.length - 1));
                    }
                    break;
                  case NumpadKey.empty:
                  case NumpadKey.decimal:
                    break;
                  default:
                    if (inputStr.length < _maxInputLength) {
                      onInputChanged(inputStr + key.value);
                    }
                }
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ThemedButton.cancel(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ThemedButton.process(
                    text: Text("Simpan"),
                    onPressed: isEmptyInput ? null : onSubmit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
