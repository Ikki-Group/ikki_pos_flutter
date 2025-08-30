import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../router/ikki_router.dart';
import '../providers/auth_device_provider.dart';

const _kCodeLen = 6;

class AuthDevicePage extends ConsumerStatefulWidget {
  const AuthDevicePage({super.key});

  @override
  ConsumerState<AuthDevicePage> createState() => _AuthDevicePageState();
}

class _AuthDevicePageState extends ConsumerState<AuthDevicePage> {
  late TextEditingController pinController;
  final focusNode = FocusNode();
  String code = '';

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    pinController.addListener(() {
      code = pinController.text.trim();
      setState(() {});
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    await ref.read(authDeviceProvider.notifier).authenticate(code.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = ref.watch(authDeviceProvider);

    final messenger = ScaffoldMessenger.of(context);

    ref.listen(authDeviceProvider, (_, next) {
      next.whenOrNull(
        data: (res) {
          if (res != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(res),
                backgroundColor: Colors.greenAccent,
              ),
            );
            context.goNamed(IkkiRouter.syncGlobal.name);
          }
        },
        error: (e, _) {
          messenger.showSnackBar(
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
          onTap: focusNode.unfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Device Authentication',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
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
                inputFormatters: [
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      return newValue.copyWith(text: newValue.text.toUpperCase());
                    },
                  ),
                ],
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(30, 60, 87, 1),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
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
                onPressed: provider.maybeWhen<VoidCallback?>(
                  loading: () => null,
                  orElse: () => code.length == _kCodeLen ? submit : null,
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
