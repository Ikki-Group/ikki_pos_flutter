import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../core/theme/app_theme.dart';
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
    final user = await SelectUserDialog.show(
      context,
      users: users,
      initialValue: selectedUser,
    );

    if (user != null) {
      if (user.id != selectedUser?.id) {
        inputPin = '';
      }
      selectedUser = user;
      setState(() {});
    }
  }

  void handleKeyPress(NumpadKey key) {
    if (selectedUser == null) {
      openDialog();
      return;
    }

    switch (key) {
      case NumpadKey.backspace:
        if (inputPin.isNotEmpty) {
          inputPin = inputPin.substring(0, inputPin.length - 1);
        }
        break;
      case NumpadKey.empty:
        break;
      default:
        if (inputPin.length < AppConstants.pinLength) {
          inputPin += key.value;
        }
        break;
    }

    AppToast.dismiss();
    setState(() {});

    if (selectedUser != null && inputPin.length == AppConstants.pinLength) {
      final isValid = selectedUser!.pin == inputPin;

      if (isValid) {
        ref.read(userProvider.notifier).setUser(selectedUser!);
        context.goNamed(AppRouter.pos.name);
      } else {
        AppToast.show("PIN Salah", type: ToastificationType.error);
        Future.delayed(const Duration(milliseconds: 200), () {
          inputPin = '';
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider).outlet;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 26),
                Text('Selamat Datang', style: textTheme.displayLarge, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('-- ${outlet.name} --', style: textTheme.displaySmall, textAlign: TextAlign.center),
                const SizedBox(height: 36),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size.fromHeight(AppTheme.buttonHeight),
                    backgroundColor: AppTheme.surfacePrimary,
                  ),
                  onPressed: openDialog,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.person, size: 20),
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
                const SizedBox(height: 26),
                PinIndicator(
                  pinLength: inputPin.length,
                  maxLength: AppConstants.pinLength,
                  boxSize: 44,
                ),
                NumpadPin(onKeyPressed: handleKeyPress),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
