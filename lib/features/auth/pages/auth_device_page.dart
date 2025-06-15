import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:pinput/pinput.dart";

import '../manager/auth_device_manager.dart';

const _kCodeLen = 6;

class AuthDevicePage extends ConsumerStatefulWidget {
  const AuthDevicePage({super.key});

  @override
  ConsumerState<AuthDevicePage> createState() => _AuthDevicePageState();
}

class _AuthDevicePageState extends ConsumerState<AuthDevicePage> {
  late TextEditingController pinController;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    final code = pinController.text;
    // if (code.length != _kCodeLen) {
    //   return;
    // }

    await ref.read(authDeviceManagerProvider.notifier).authenticate(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mnger = ref.watch(authDeviceManagerProvider);

    ref.listen(authDeviceManagerProvider, (_, next) {
      next.whenOrNull(
        data: (res) {
          if (res != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(res), backgroundColor: Colors.greenAccent),
            );
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: Center(
        child: GestureDetector(
          // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          onTap: () => focusNode.unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Device Authentication',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Please copy the code from backoffice',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 35),
              Pinput(
                length: _kCodeLen,
                controller: pinController,
                focusNode: focusNode,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: mnger.maybeWhen<VoidCallback?>(
                  loading: () => null,
                  orElse: () => _authenticate,
                ),
                child: const Text('Authenticate Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
