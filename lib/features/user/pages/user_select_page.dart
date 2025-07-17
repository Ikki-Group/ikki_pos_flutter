import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet.provider.dart';
import '../../../data/user/user.model.dart';
import '../../../data/user/user.provider.dart';
import '../../../data/user/user.repo.dart';
import '../../../router/ikki_router.dart';
import '../../../widgets/ui/numpad_pin.dart';
import '../widgets/user_select_dialog.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> with TickerProviderStateMixin {
  final int maxPinLength = UserModel.kPinLength;
  UserModel? selectedUser;
  String displayValue = '';

  Future<void> openDialog() async {
    final users = await ref.watch(userRepoProvider).fetch();

    if (!mounted) return;
    final user = await showDialog<UserModel?>(
      context: context,
      builder: (context) => UserSelectDialog(
        initialValue: selectedUser,
        users: users,
      ),
    );

    if (user != null) selectedUser = user;
    setState(() {});
  }

  void handleKeyPress(NumpadKey key) {
    if (selectedUser == null) {
      openDialog();
      return;
    }

    setState(() {
      if (key case NumpadKey.backspace) {
        if (displayValue.isNotEmpty) {
          displayValue = displayValue.substring(0, displayValue.length - 1);
        }
      } else if (key case NumpadKey.empty) {
      } else {
        if (displayValue.length < maxPinLength) {
          displayValue += key.value;
        }

        if (displayValue.length == maxPinLength) {
          final isValid = selectedUser!.comparePin(displayValue);
          if (isValid) {
            ref.read(currentUserProvider.notifier).setUser(selectedUser!);
            print('Pos');
            context.goNamed(IkkiRouter.pos.name);
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'PIN tidak valid',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
            displayValue = '';
            return;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider).requireValue;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang',
              style: POSTextStyles.headerTitle.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '-- ${outlet.name} --',
              style: POSTextStyles.headerTitle.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(320),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
              onPressed: openDialog,
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
              pinLength: displayValue.length,
              maxLength: UserModel.kPinLength,
              boxSize: 52,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  NumpadPin(
                    onKeyPressed: handleKeyPress,
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
