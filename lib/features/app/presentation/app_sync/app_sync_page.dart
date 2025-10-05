import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncGlobalPage extends ConsumerWidget {
  const SyncGlobalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
