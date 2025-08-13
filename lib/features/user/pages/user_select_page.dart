import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/user/user_model.dart';
import '../../../data/user/user_provider.dart';
import '../../../router/ikki_router.dart';
import '../../../widgets/dialogs/select_user_dialog.dart';
import '../../../widgets/ui/numpad_pin.dart';

class UserSelectPage extends ConsumerStatefulWidget {
  const UserSelectPage({super.key});

  @override
  ConsumerState<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends ConsumerState<UserSelectPage> {
  UserModel? selectedUser;
  String inputPin = '';

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
    final messenger = ScaffoldMessenger.of(context);

    if (selectedUser == null) {
      openDialog();
      return;
    }

    final value = switch (key) {
      NumpadKey.backspace when inputPin.isNotEmpty => inputPin.substring(0, inputPin.length - 1),
      _ when inputPin.length < UserModel.kPinLength => inputPin + key.value,
      _ => inputPin,
    };

    if (value.length == UserModel.kPinLength) {
      final isValid = selectedUser!.comparePin(value);

      if (isValid) {
        ref.read(currentUserProvider.notifier).setUser(selectedUser!);
        context.goNamed(IkkiRouter.pos.name);
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('PIN tidak valid', style: TextStyle(color: POSTheme.textOnPrimary)),
            backgroundColor: POSTheme.accentRed,
          ),
        );
        inputPin = '';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider).requireValue;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selamat Datang', style: textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('-- ${outlet.name} --', style: textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: openDialog,
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedUser?.name ?? 'Pilih Karyawan',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PinIndicator(
                pinLength: inputPin.length,
                maxLength: UserModel.kPinLength,
                boxSize: 48,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: NumpadPin(onKeyPressed: handleKeyPress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
