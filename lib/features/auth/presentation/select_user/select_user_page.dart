import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../router/app_router.dart';
import '../../../../utils/app_toast.dart';
import '../../../../widgets/ui/numpad_pin.dart';
import '../../../outlet/provider/outlet_provider.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import 'select_user_dialog.dart';

class SelectUserPage extends ConsumerStatefulWidget {
  const SelectUserPage({super.key});

  @override
  ConsumerState<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends ConsumerState<SelectUserPage> {
  UserModel? selectedUser;
  String inputPin = '';

  Future<void> openDialog() async {
    final users = ref.read(userProvider).users;
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

    final value = switch (key) {
      NumpadKey.backspace when inputPin.isNotEmpty => inputPin.substring(0, inputPin.length - 1),
      _ when inputPin.length < AppConstants.pinLength => inputPin + key.value,
      _ => inputPin,
    };

    inputPin = value;
    setState(() {});

    if (selectedUser != null && value.length == AppConstants.pinLength) {
      final isValid = selectedUser!.pin == value;

      if (isValid) {
        ref.read(userProvider.notifier).setUser(selectedUser!);
        context.goNamed(AppRouter.pos.name);
      } else {
        AppToast.show("PIN Salah", type: ToastificationType.error);
        inputPin = '';
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider).outlet;

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
                maxLength: AppConstants.pinLength,
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
