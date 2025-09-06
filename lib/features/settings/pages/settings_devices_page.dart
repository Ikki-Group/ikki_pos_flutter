import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../router/ikki_router.dart';
import '../../../utils/extensions.dart';
import '../../../widgets/ui/pos_button.dart';

class SettingsDevicesPage extends ConsumerStatefulWidget {
  const SettingsDevicesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsDevicesPageState();
}

class _SettingsDevicesPageState extends ConsumerState<SettingsDevicesPage> {
  Future<void> onLogout() async {
    await ref.read(authTokenProvider.notifier).logout();
    if (!mounted) return;
    context
      ..goNamed(IkkiRouter.authDevice.name)
      ..showTextSnackBar('Berhasil logout');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Perangkat', style: textTheme.titleMedium),
            const Spacer(),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                PosButton(
                  text: 'Keluar',
                  onPressed: onLogout,
                  variant: ButtonVariant.destructive,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
