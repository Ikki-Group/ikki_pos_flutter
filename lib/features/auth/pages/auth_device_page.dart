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
  String code = "";

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    pinController.addListener(() {
      setState(() {
        code = pinController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    await ref.read(authDeviceManagerProvider.notifier).authenticate(code.toUpperCase());
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
          pinController.clear();
        },
      );
    });

    return Scaffold(
      body: Center(
        child: GestureDetector(
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
                textCapitalization: TextCapitalization.characters,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(30, 60, 87, 1),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
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
                  orElse: () => code.length == _kCodeLen ? _authenticate : null,
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
