import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/app_toast.dart';
import '../../../auth/provider/user_provider.dart';
import '../../../shift/model/shift_session_model.dart';
import '../../../shift/provider/shift_provider.dart';
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
    final shift = ref.watch(shiftProvider);
    final closeMutationState = ref.watch(closeMutation);
    final user = ref.watch(userProvider).selectedUser;

    Future<void> onClose() async {
      final outletId = ref.read(outletProvider).outlet.id;
      closeMutation.run(ref, (tsx) async {
        await ref
            .read(shiftProvider.notifier)
            .close(
              outletId,
              ShiftSessionInfo(
                by: user.id,
                at: DateTime.now().toIso8601String(),
                balance: 0,
                note: '',
              ),
            );
        if (!context.mounted) return;
        AppToast.show("Berhasil menutup toko");
      });
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
              onPressed: closeMutationState is MutationPending || shift.isOpen ? onClose : null,
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
