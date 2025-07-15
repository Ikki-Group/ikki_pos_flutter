import 'package:ikki_pos_flutter/core/db/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'receipt_code_repo.g.dart';

@riverpod
ReceiptCodeRepo receiptCodeRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return ReceiptCodeRepo(sp: sp);
}

class ReceiptCodeRepo {
  final SharedPreferences sp;

  ReceiptCodeRepo({required this.sp});

  Future<String> getCode(String sessionId) async {
    final queue = getLocalQueue();
    return "$sessionId/$queue";
  }

  Future<bool> commit(String code) async {
    final [_, queue] = code.split("/");
    final queueInt = int.parse(queue);
    return setLocalQueue(queueInt + 1);
  }

  int getLocalQueue() {
    final queue = sp.getInt(SharedPrefsKeys.receiptCode.key);
    return queue ?? 1;
  }

  Future<bool> setLocalQueue(int queue) {
    return sp.setInt(SharedPrefsKeys.receiptCode.key, queue);
  }
}
