import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

import '../../core/db/sembast.dart';
import '../json.dart';
import 'cart_model.dart';

part 'cart_repo.g.dart';

@Riverpod(keepAlive: true)
CartRepo cartRepo(Ref ref) {
  return CartRepo(ss: ref.watch(sembastServiceProvider));
}

class CartRepo {
  CartRepo({required this.ss});
  final SembastService ss;

  final StoreRef store = StoreRef('carts');

  Future<List<Cart>> list() async {
    try {
      final records = await store.find(ss.db);
      print('records: $records');
      return records.map((e) => Cart.fromJson(e.value! as Json)).toList();
    } catch (e, stackTrace) {
      log('Error listing carts: $e');
      log('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> save(Cart cart) async {
    try {
      final json = cart.toJson();

      await store.record(cart.id).put(ss.db, json);
      log('Cart saved successfully to Sembast with ID: ${cart.id}');
    } catch (e, stackTrace) {
      log('Error saving cart: $e');
      log('Stack trace: $stackTrace');
      log('Cart data: $cart');
      rethrow;
    }
  }

  Future<Cart?> get(String id) async {
    try {
      final json = await store.record(id).get(ss.db);
      return json != null ? Cart.fromJson(json as Json) : null;
    } catch (e, stackTrace) {
      log('Error getting cart $id: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> delete(String id) async {
    try {
      await store.record(id).delete(ss.db);
      log('Cart $id deleted successfully');
    } catch (e, stackTrace) {
      log('Error deleting cart $id: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // ignore: unused_element
  Future<void> _unsafeClear() async {
    try {
      await store.delete(ss.db);
      log('Carts deleted successfully');
    } catch (e, stackTrace) {
      log('Error deleting carts: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
