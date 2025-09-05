import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';

part 'receipt_code_repo.g.dart';

@Riverpod(keepAlive: true)
ReceiptCodeRepo receiptCodeRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return ReceiptCodeRepoImpl(sp: sp);
}

abstract class ReceiptCodeRepo {
  Future<String> getCode(String sessionId);
  Future<bool> commit(String code);
}

class ReceiptCodeRepoImpl implements ReceiptCodeRepo {
  ReceiptCodeRepoImpl({required this.sp});
  final SharedPreferences sp;

  @override
  Future<String> getCode(String sessionId) async {
    final queue = getLocalQueue();
    final date = DateTime.now().toString().substring(0, 10);
    final queuePad = queue.toString().padLeft(4, '0');
    return 'PT/$date/$queuePad';
  }

  @override
  Future<bool> commit(String code) async {
    final queue = getLocalQueue();
    // final [_, _, queue] = code.split('/');
    // print(queue);
    // final queueInt = int.parse(queue);
    return setLocalQueue(queue + 1);
  }

  int getLocalQueue() {
    final queue = sp.getInt(SharedPrefsKeys.receiptCode.key);
    return queue ?? 1;
  }

  Future<bool> setLocalQueue(int queue) {
    return sp.setInt(SharedPrefsKeys.receiptCode.key, queue);
  }
}
