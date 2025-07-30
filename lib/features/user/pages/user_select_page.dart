import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet.provider.dart';
import '../../../data/user/user.model.dart';
import '../../../data/user/user.provider.dart';
import '../../../router/ikki_router.dart';
import '../../../widgets/dialogs/select_user_dialog.dart';
import '../../../widgets/ui/numpad_pin.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> with TickerProviderStateMixin {
  UserModel? selectedUser;
  String displayValue = '';

  Future<void> openDialog() async {
    final users = await ref.read(userListProvider.future);
    if (!mounted) return;

    final user = await SelectUserDialog.show(context, users: users, initialValue: selectedUser);
    if (user != null) {
      selectedUser = user;
      setState(() {});
    }
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
        if (displayValue.length < UserModel.kPinLength) {
          displayValue += key.value;
        }

        if (displayValue.length == UserModel.kPinLength) {
          final isValid = selectedUser!.comparePin(displayValue);
          if (isValid) {
            ref.read(currentUserProvider.notifier).setUser(selectedUser!);
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang',
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '-- ${outlet.name} --',
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  side: const BorderSide(color: POSTheme.borderDark),
                ),
                onPressed: openDialog,
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedUser?.name ?? 'Pilih Karyawan',
                        // style: POSTextStyles.buttonText.copyWith(
                        //   overflow: TextOverflow.ellipsis,
                        //   fontWeight: FontWeight.w600,
                        // ),
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
      ),
    );
  }
}
