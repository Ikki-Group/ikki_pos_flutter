import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

enum IkkiRouter {
  widgetsbook,

  splash,
  authDevice,
  syncGlobal,

  userSelect,

  // Pos
  pos,

  // Sales
  sales,

  // Shift
  shift,

  // Report
  report,

  // Home
  home,
  history,

  // Cart
  cart,
  cartRnd,
  cartPayment,
  cartPaymentSuccess,

  // Settings
  settings,

  // Showcase
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
