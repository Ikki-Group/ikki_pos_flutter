import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/core/config/pos_theme.dart';
import 'package:ikki_pos_flutter/shared/utils/formatter.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';
import 'package:ikki_pos_flutter/widgets/ui/ikki_dialog.dart';
import 'package:ikki_pos_flutter/widgets/ui/numpad_pin.dart';

class CurrencyNumpadDialog extends ConsumerStatefulWidget {
  const CurrencyNumpadDialog({super.key, this.initialValue});
  final int? initialValue;

  static Future<int> show(BuildContext context, {int? initialValue}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CurrencyNumpadDialog(
          initialValue: initialValue ?? 0,
        );
      },
    );

    return 1;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrencyNumpadDialogState();
}

class _CurrencyNumpadDialogState extends ConsumerState<CurrencyNumpadDialog> {
  int? _input;

  @override
  void initState() {
    super.initState();
    _input = widget.initialValue;
  }

  void onInputChanged(int? value) {
    setState(() {
      _input = value;
    });
  }

  void onSubmit() {
    Navigator.of(context).pop(_input);
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = "Masukkan Kas Awal";

    String? value;
    if (_input == null || _input == 0) {
      value = placeholder;
    } else {
      value = Formatter.toIdr.format(_input!);
    }

    return IkkiDialog(
      padding: const EdgeInsets.all(8),
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
                    bottom: BorderSide(color: POSTheme.primaryBlue, width: 1),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(value, style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            NumpadPin(
              aspectRatio: 4 / 2,
              onKeyPressed: (key) {
                if (key == NumpadKey.empty) {
                  return;
                }
                onInputChanged((int.tryParse(_input?.toString() ?? "") ?? 0) + int.parse(key.value));
              },
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: ThemedButton.cancel(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: ThemedButton.process(
                    text: "Simpan",
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
