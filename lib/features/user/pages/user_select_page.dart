import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/user/user_model.dart';
import 'package:ikki_pos_flutter/data/user/user_notifier.dart';
import 'package:ikki_pos_flutter/features/user/widgets/user_select_dialog.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';
import 'package:ikki_pos_flutter/widgets/ui/numpad_pin.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> with TickerProviderStateMixin {
  final int maxPinLength = User.kPinLength;
  User? selectedUser;
  String _displayValue = "";

  _openDialog() async {
    final user = await showDialog<User?>(
      context: context,
      builder: (context) => UserSelectDialog(
        initialValue: selectedUser,
      ),
    );

    if (user == null) return;

    setState(() {
      selectedUser = user;
    });
  }

  void _handleKeyPress(NumpadKey key) {
    if (selectedUser == null) {
      _openDialog();
      return;
    }
    setState(() {
      switch (key) {
        case NumpadKey.backspace:
          if (_displayValue.isNotEmpty) {
            _displayValue = _displayValue.substring(0, _displayValue.length - 1);
          }
          break;
        case NumpadKey.empty:
          // Do nothing for empty keys
          break;
        default:
          // Add the digit only if we haven't reached max length
          if (_displayValue.length < maxPinLength) {
            _displayValue += key.value;
          }

          if (_displayValue.length == maxPinLength) {
            final isValid = selectedUser!.comparePin(_displayValue);
            if (isValid) {
              ref.read(userNotifierProvider.notifier).setUser(selectedUser!);
              context.go(IkkiRouter.home.path);
              return;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "PIN tidak valid",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              _displayValue = "";
              return;
            }
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider).outlet!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '-- ${outlet.name} --',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(280),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                _openDialog();
              },
              child: Row(
                children: [
                  const Icon(Icons.person, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedUser?.name ?? 'Pilih Karyawan',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            PinIndicator(
              pinLength: _displayValue.length,
              maxLength: maxPinLength,
              boxSize: 45,
            ),
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  NumpadPin(
                    onKeyPressed: _handleKeyPress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(height: 100, child: Center(child: Text(text))),
    );
  }
}
