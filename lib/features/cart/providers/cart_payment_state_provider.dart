import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
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
  CartPaymentState build() => const CartPaymentState();

  void load() {
    final cart = ref.read(cartStateProvider);
    state = state.copyWith(
      total: cart.net,
      change: 0,
      tender: 0,
      remaining: 0,
      payments: [],
    );
  }

  void addPayment(PaymentModel payment, double amount) {}

  void removePayment() {}
}

extension CartPaymentX on CartPayment {
  String get formattedLabel {
    final idr = Formatter.toIdr.format(amount);
    if (type == PaymentType.cash) return 'Tunai: $idr';
    return '$label: $idr';
  }
}
