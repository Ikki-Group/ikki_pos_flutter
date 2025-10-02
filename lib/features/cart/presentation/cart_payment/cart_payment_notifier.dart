import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../model/payment_model.dart';
import '../../../auth/provider/user_provider.dart';
import '../../data/cart_state.dart';
import '../../provider/cart_provider.dart';

part 'cart_payment_notifier.freezed.dart';
part 'cart_payment_notifier.g.dart';

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

@Riverpod(keepAlive: false, name: 'cartPaymentNotifier')
class PaymentNotifier extends _$PaymentNotifier {
  @override
  CartPaymentState build() {
    final cart = ref.watch(cartProvider);
    final paidAmount = cart.payments.fold<double>(0, (prev, curr) => prev + curr.amount);
    final totalAmount = cart.net;

    final needToPay = totalAmount - paidAmount;

    final state = CartPaymentState(
      total: needToPay,
      remaining: needToPay,
      payments: [],
    );

    return state;
  }

  void addPayment(PaymentModel payment, double amount) {
    final user = ref.read(userProvider).selectedUser;

    final payments = [
      ...state.payments,
      CartPayment(
        id: ObjectId().hexString,
        amount: amount,
        label: payment.label,
        type: payment.type,
        at: DateTime.now().toIso8601String(),
        by: user.id,
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
