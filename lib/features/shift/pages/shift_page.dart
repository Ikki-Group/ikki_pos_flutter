import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet_provider.dart';
import '../provider/shift_page_provider.dart';
import '../widgets/shift_outlet_info.dart';
import '../widgets/shift_summary.dart';

class ShiftPage extends ConsumerStatefulWidget {
  const ShiftPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShiftPageState();
}

class _ShiftPageState extends ConsumerState<ShiftPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: 300,
            child: _ActionsSection(),
          ),
          const SizedBox(width: 8),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    ShiftSummary(),
                    SizedBox(height: 16),
                    ShiftOutletInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends ConsumerWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeAction = ref.watch(closeActionProvider);
    final _ = ref.watch(outletProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: switch (closeAction) {
                // AsyncData() when outlet.isOpen => ref.read(closeActionProvider.notifier).execute,
                _ => ref.read(closeActionProvider.notifier).execute,
                // _ => null,
              },
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 64),
              ),
              child: const Text('Tutup Toko'),
            ),
          ],
        ),
      ),
    );
  }
}
