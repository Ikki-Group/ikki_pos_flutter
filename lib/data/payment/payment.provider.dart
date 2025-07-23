import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'payment.model.dart';
import 'payment.repo.dart';

part 'payment.provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<PaymentOption>> paymentOptions(Ref ref) {
  return ref.watch(paymentRepoProvider).getLocal();
}
