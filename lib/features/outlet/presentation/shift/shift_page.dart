import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/extensions.dart';
import '../../../auth/provider/user_provider.dart';
import '../../model/outlet_extension.dart';
import '../../provider/outlet_provider.dart';
import 'shift_outlet_info.dart';
import 'shift_summary.dart';

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
        children: <Widget>[
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
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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

var closeMutation = Mutation<void>();

class _ActionsSection extends ConsumerWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletProvider);
    final closeMutationState = ref.watch(closeMutation);

    Future<void> onClose() async {
      await closeMutation.run(ref, (tsx) async {
        await ref
            .read(outletProvider.notifier)
            .closeOutlet(
              1000,
              ref.read(userProvider).selectedUser,
              'Terima kasir',
            );
      });
      if (!context.mounted) return;
      context.showTextSnackBar('Berhasil menutup toko');
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
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
          children: <Widget>[
            FilledButton(
              onPressed: closeMutationState is MutationPending || !outlet.isOpen ? null : onClose,
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
