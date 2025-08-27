import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/outlet/outlet_provider.dart';
import '../../../data/user/user_provider.dart';

part 'shift_page_provider.g.dart';

@riverpod
class CloseAction extends _$CloseAction {
  @override
  FutureOr<bool> build() => false;

  Future<void> execute() async {
    final user = ref.read(currentUserProvider)!;
    await ref.read(outletProvider.notifier).close(cash: 1000, user: user);
  }
}
