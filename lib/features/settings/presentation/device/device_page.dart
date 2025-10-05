import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/ikki_router.dart';
import '../../../../utils/extensions.dart';
import '../../../app/provider/app_provider.dart';

class DevicePage extends ConsumerStatefulWidget {
  const DevicePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DevicePageState();
}

class _DevicePageState extends ConsumerState<DevicePage> {
  Future<void> onLogout() async {
    await ref.read(appProvider.notifier).logout();
    if (!mounted) return;
    context
      ..goNamed(IkkiRouter.authDevice.name)
      ..showToast('Berhasil logout');
  }

  Future<void> onSync() async {
    await ref.read(appProvider.notifier).hardSync();
    if (!mounted) return;
    context.showToast('Berhasil menyinkronkan data');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),

                // Sync Section
                ListTile(
                  title: Text('Sinkronkan data perangkat ini', style: textTheme.titleMedium),
                  subtitle: Text('Data perangkat ini akan disinkronkan ke server', style: textTheme.bodySmall),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onSync,
                ),

                // Logout Tile
                ListTile(
                  title: Text('Keluar dari perangkat ini', style: textTheme.titleMedium),
                  subtitle: Text(
                    'Dengan mengklik logout, Anda akan keluar dari perangkat ini',
                    style: textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onLogout,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
