import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../data/user/user_provider.dart';
import '../../../data/user/user_util.dart';
import '../../../shared/utils/formatter.dart';
import '../../payment/payment_enum.dart';
import '../../payment/payment_model.dart';

part 'cart_payment_state_provider.freezed.dart';
part 'cart_payment_state_provider.g.dart';

@freezed
abstract class CartPaymentState with _$CartPaymentState {
  const factory CartPaymentState({
    @Default(0) double total,
    @Default(0) double change,
    @Default(0) double tender,
    @Default(0) double remaining,
    @Default([]) List<CartPayment> payments,
  }) = _CartPaymentState;
}

@riverpod
class CartPaymentStateNotifier extends _$CartPaymentStateNotifier {
  @override
  CartPaymentState build() {
    final cart = ref.read(cartStateProvider);
    return CartPaymentState(
      total: cart.net,
      remaining: cart.net,
      payments: [],
    );
  }

  void addPayment(PaymentModel payment, double amount) {
    final payments = [
      ...state.payments,
      CartPayment(
        id: ObjectId().hexString,
        amount: amount,
        label: payment.label,
        type: payment.type,
        at: DateTime.now().toIso8601String(),
        by: ref.read(currentUserProvider).requireValue.id,
        isDraft: true,
      ),
    ];
    final newState = state.copyWith(payments: payments);
    state = newState.invalidate();
  }

  void removePayment(String id) {
    final payments = state.payments.where((p) => p.id != id).toList();
    final newState = state.copyWith(payments: payments);
    state = newState.invalidate();
  }
}

extension CartPaymentX on CartPayment {
  String get formattedLabel {
    final idr = Formatter.toIdr.format(amount);
    if (type == PaymentType.cash) return 'Tunai: $idr';
    return '$label: $idr';
  }
}

extension CartPaymentStateX on CartPaymentState {
  bool get allowToPay => change >= 0 && tender > 0 && remaining <= 0;

  CartPaymentState invalidate() {
    var payments = this.payments.toList();
    final tender = payments.fold<double>(0, (prev, curr) => prev + curr.amount);
    var change = tender - total;
    var remaining = total - tender;

    if (change < 0) change = 0;
    if (remaining < 0) remaining = 0;

    if (change > 0) {
      // Attch change to payment with type cash
      payments = payments.map((e) {
        return e.copyWith(
          change: e.type == PaymentType.cash ? change : null,
        );
      }).toList();
    }

    return copyWith(
      change: change,
      tender: tender,
      remaining: remaining,
      payments: payments,
    );
  }
}
