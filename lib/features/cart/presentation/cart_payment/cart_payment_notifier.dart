import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/provider/user_provider.dart';
import '../../../sales/domain/payment_model.dart';
import '../../../sales/domain/sales_model.dart';
import '../../../sales/domain/sales_model_ext.dart';
import '../../domain/cart_state_ext.dart';
import '../../provider/cart_provider.dart';

part 'cart_payment_notifier.freezed.dart';
part 'cart_payment_notifier.g.dart';

@freezed
abstract class CartPaymentState with _$CartPaymentState {
  const factory CartPaymentState({
    @Default(0) double total,
    @Default('') String note,
    @Default([]) List<SalesPayment> payments,
  }) = _CartPaymentState;
}

extension CartPaymentStateX on CartPaymentState {
  double get tender => payments.fold<double>(0, (prev, curr) => prev + curr.amount);
  double get tenderCash => payments.where((e) => e.isCash).fold<double>(0, (prev, curr) => prev + curr.amount);
  double get tenderNonCash => payments.where((e) => !e.isCash).fold<double>(0, (prev, curr) => prev + curr.amount);

  double get cashChange {
    final change = tenderCash - total;
    return change >= 0 ? change : 0;
  }

  double get remaining {
    final remain = total - tender;
    return remain >= 0 ? remain : 0;
  }

  bool get allowToPay => payments.isNotEmpty && remaining <= 0;
}

@Riverpod(keepAlive: false, name: 'cartPaymentNotifier')
class PaymentNotifier extends _$PaymentNotifier {
  @override
  CartPaymentState build() {
    final cart = ref.watch(cartProvider);
    final needToPay = cart.net - cart.paidAmount;

    if (needToPay <= 0) return CartPaymentState();
    return CartPaymentState(
      total: needToPay,
      note: cart.note,
      payments: [],
    );
  }

  void addPayment(PaymentModel payment, double amount) {
    final user = ref.read(userProvider).selectedUser;

    final payments = [
      ...state.payments,
      SalesPayment(
        id: ObjectId().hexString,
        amount: amount,
        label: payment.label,
        type: payment.type,
        at: DateTime.now().toIso8601String(),
        by: user.id,
      ),
    ];
    state = state.copyWith(payments: payments);
  }

  void removePayment(String id) {
    final payments = state.payments.where((p) => p.id != id).toList();
    state = state.copyWith(payments: payments);
  }

  void updateNote(String note) {
    state = state.copyWith(note: note);
  }
}
