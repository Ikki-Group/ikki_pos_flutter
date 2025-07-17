// import 'package:bson/bson.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../outlet/outlet_notifier.dart';
// import '../product/product.model.dart';
// import '../receipt_code/receipt_code_repo.dart';
// import '../sale/sale_model.dart';
// import 'cart_model.dart';

// part 'cart_notifier.g.dart';

// @Riverpod(keepAlive: true)
// class CartNotifier extends _$CartNotifier {
//   @override
//   Cart build() {
//     return const Cart();
//   }

//   void setCart(Cart cart) {
//     state = cart;
//   }

//   Future<void> newCart(
//     int pax,
//     SaleMode saleMode,
//   ) async {
//     final session = ref.read(outletNotifierProvider).requiredSession;
//     final rc = await ref.read(receiptCodeRepoProvider).getCode(session.id);

//     state = Cart(
//       id: ObjectId().toString(),
//       rc: rc,
//       saleMode: saleMode,
//       pax: pax,
//     );
//   }

//   void addProduct(Product product) {
//     final cartItems = state.items;
//     final existingItemIndex = cartItems.indexWhere(
//       (item) => item.product.id == product.id && item.note.isEmpty,
//     );

//     if (existingItemIndex != -1 && cartItems[existingItemIndex].note.isEmpty) {
//       // Update quantity if item exists and has no note
//       final updatedItem = cartItems[existingItemIndex].copyWith(
//         qty: cartItems[existingItemIndex].qty + 1,
//         gross: cartItems[existingItemIndex].gross,
//         net: cartItems[existingItemIndex].net,
//       );

//       state = state.copyWith(
//         items: [
//           ...cartItems.sublist(0, existingItemIndex),
//           updatedItem,
//           ...cartItems.sublist(existingItemIndex + 1),
//         ],
//         gross: state.gross,
//         net: state.net,
//       );
//     } else {
//       // Add new item to cart
//       final newItem = CartItem(
//         id: ObjectId().toString(),
//         batch: 1,
//         product: CartItemProduct(
//           id: product.id,
//           name: product.name,
//           price: product.price,
//         ),
//         qty: 1,
//         price: product.price,
//         gross: product.price,
//         net: product.price,
//       );

//       state = state.copyWith(
//         items: [...cartItems, newItem],
//         gross: state.gross + (product.price),
//         net: state.net + (product.price),
//       );
//     }
//   }
// }
