import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_repo.dart';

class SettingDevPage extends ConsumerStatefulWidget {
  const SettingDevPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingDevPageState();
}

class _SettingDevPageState extends ConsumerState<SettingDevPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Pengembang', style: context.textTheme.titleLarge),
            const Spacer(),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FilledButton(
                  onPressed: () async {
                    await ref.read(cartRepoProvider).unsafeClear();
                  },
                  child: const Text('Clear cart'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
