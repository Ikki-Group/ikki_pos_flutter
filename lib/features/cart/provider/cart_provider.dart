import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_constant.dart';
import '../../../model/product_model.dart';
import '../../../model/user_model.dart';
import '../../outlet/data/outlet_state.dart';
import "../data/cart_state.dart";

part 'cart_provider.g.dart';

abstract class CartProvider {
  Future<void> createNew({
    required int pax,
    required SaleMode saleMode,
    required UserModel user,
    required OutletState outletState,
  });

  Future<void> addProductDirectly(ProductModel product);
}

@Riverpod(keepAlive: true)
class Cart extends _$Cart implements CartProvider {
  @override
  CartState build() {
    throw UnimplementedError();
  }

  @override
  Future<void> createNew({
    required int pax,
    required SaleMode saleMode,
    required UserModel user,
    required OutletState outletState,
  }) async {
    final session = outletState.sessionRequired;
    final now = DateTime.now().toIso8601String();

    final newCart = CartState(
      id: ObjectId().hexString,
      rc: outletState.receiptCode,
      saleMode: saleMode,
      pax: pax,
      outletId: outletState.outlet.id,
      sessionId: session.id,
      batches: [
        CartBatch(
          id: 1,
          at: now,
          by: user.id,
        ),
      ],
      createdAt: now,
      createdBy: user.id,
      updatedAt: now,
      updatedBy: user.id,
    );

    state = newCart;
  }

  @override
  Future<void> addProductDirectly(ProductModel product) {
    throw UnimplementedError();
  }
}
