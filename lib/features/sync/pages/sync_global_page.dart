import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/ikki_router.dart';
import '../providers/sync_provider.dart';

class SyncGlobalPage extends ConsumerWidget {
  const SyncGlobalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messenger = ScaffoldMessenger.of(context);
    ref.listen(
      syncGlobalProvider,
      (_, _) {
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Ikki Smart POS is syncing your data'),
              backgroundColor: Colors.greenAccent,
            ),
          );
        context.goNamed(IkkiRouter.userSelect.name);
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('IKKI Smart POS', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Dont worry, we will sync your data'),
          ],
        ),
      ),
    );
  }
}
