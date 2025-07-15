import 'package:bson/bson.dart';
import 'package:ikki_pos_flutter/data/cart/cart_model.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/product/product_model.dart';
import 'package:ikki_pos_flutter/data/receipt_code/receipt_code_repo.dart';
import 'package:ikki_pos_flutter/data/sale/sale_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  Cart build() {
    return Cart();
  }

  void setCart(Cart cart) {
    state = cart;
  }

  Future<void> newCart(
    int pax,
    SaleMode saleMode,
  ) async {
    final session = ref.read(outletNotifierProvider).requiredSession;
    final rc = await ref.read(receiptCodeRepoProvider).getCode(session.id);

    state = Cart(
      id: ObjectId().toString(),
      rc: rc,
      saleMode: saleMode,
      pax: pax,
    );
  }

  void addProduct(Product product) {
    final index = state.items.indexWhere((i) => i.product.id == product.id);
    late CartItem item;
  }
}
