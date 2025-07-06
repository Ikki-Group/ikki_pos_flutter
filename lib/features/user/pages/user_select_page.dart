import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/core/config/pos_theme.dart';
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

  Future<void> _openDialog() async {
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
              style: POSTextStyles.headerTitle.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              '-- ${outlet.name} --',
              style: POSTextStyles.headerTitle.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(320),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                      style: POSTextStyles.buttonText.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 42),
            PinIndicator(
              pinLength: _displayValue.length,
              maxLength: maxPinLength,
              boxSize: 52,
            ),
            const SizedBox(height: 24),
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
