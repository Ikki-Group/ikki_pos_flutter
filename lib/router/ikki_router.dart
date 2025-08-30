import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

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

extension RouterX on GoRouter {
  String? get currentRouteName => routerDelegate.currentConfiguration.last.route.name;
  IkkiRouter? get currentRouteIkki => IkkiRouter.fromName(currentRouteName);
}
