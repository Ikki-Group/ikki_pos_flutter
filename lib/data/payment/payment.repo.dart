import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'payment.enum.dart';
import 'payment.model.dart';

part 'payment.repo.g.dart';

@Riverpod(keepAlive: true)
PaymentRepo paymentRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return PaymentRepo(dio, sp);
}

class PaymentRepo {
  const PaymentRepo(this.dio, this.sp);

  final Dio dio;
  final SharedPreferences sp;

  Future<List<PaymentOption>> fetch() async {
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 1));
    final res = await getMock();
    await save(res);
    return res;
  }

  Future<List<PaymentOption>> getLocal() async {
    final paymentsJson = sp.getString(SharedPrefsKeys.paymentOptions.name);
    if (paymentsJson != null) {
      final json = jsonDecode(paymentsJson) as JsonList;
      return json.map(PaymentOption.fromJson).toList();
    } else {
      return fetch();
    }
  }

  Future<bool> save(List<PaymentOption> payments) async {
    final paymentsJson = jsonEncode(payments);
    return sp.setString(SharedPrefsKeys.paymentOptions.name, paymentsJson);
  }

  Future<List<PaymentOption>> getMock() async {
    return [
      const PaymentOption(
        id: '1',
        name: 'Cash',
        mode: PaymentMode.cash,
      ),
      const PaymentOption(
        id: '2',
        name: 'QRIS',
        mode: PaymentMode.cashless,
      ),
    ];
  }
}
