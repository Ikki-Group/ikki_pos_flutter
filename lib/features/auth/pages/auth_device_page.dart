import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../router/ikki_router.dart';
import '../../../utils/extensions.dart';
import '../providers/auth_device_provider.dart';

const _kCodeLen = 6;

class AuthDevicePage extends ConsumerStatefulWidget {
  const AuthDevicePage({super.key});

  @override
  ConsumerState<AuthDevicePage> createState() => _AuthDevicePageState();
}

class _AuthDevicePageState extends ConsumerState<AuthDevicePage> {
  late TextEditingController pinController;
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
    super.dispose();
  }

  Future<void> submit() async {
    final result = await ref.read(authenticateProvider.notifier).call(code.toUpperCase());
    if (!mounted) return;
    if (result) {
      ref.invalidate(authTokenProvider);
      context
        ..showTextSnackBar('Autentikasi Berhasil')
        ..goNamed(IkkiRouter.syncGlobal.name);
    } else {
      context.showTextSnackBar('Autentikasi Gagal', severity: SnackBarSeverity.error);
      pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authenticate = ref.watch(authenticateProvider);

    final isValidInput = code.length == _kCodeLen;

    return Scaffold(
      body: Center(
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
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              textCapitalization: TextCapitalization.characters,
              onTapOutside: (_) => context.unfocus(),
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(text: newValue.text.toUpperCase()),
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
              onPressed: authenticate.maybeWhen<VoidCallback?>(
                loading: () => null,
                orElse: () => isValidInput ? submit : null,
              ),
              child: const Text('Authenticate Device'),
            ),
          ],
        ),
      ),
    );
  }
}
