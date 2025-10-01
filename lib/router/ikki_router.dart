import 'package:collection/collection.dart';

enum IkkiRouter {
  widgetsbook,
  splash,
  authDevice,
  syncGlobal,
  userSelect,
  pos,
  sales,
  shift,
  report,
  home,
  history,
  cart,
  cartRnd,
  cartPayment,
  cartPaymentSuccess,
  settings,
  showcase
  //
  ;

  String get path => '/$name';

  static IkkiRouter? fromName(String? name) {
    if (name == null) return null;
    return IkkiRouter.values.firstWhereOrNull((e) => e.name == name);
  }
}
