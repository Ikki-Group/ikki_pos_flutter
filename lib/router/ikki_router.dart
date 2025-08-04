import 'package:go_router/go_router.dart';

enum IkkiRouter {
  widgetsbook,

  splash,
  authDevice,
  syncGlobal,

  userSelect,

  // Pos
  pos,

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
    for (final element in IkkiRouter.values) {
      if (element.name == name) {
        return element;
      }
    }
    return null;
  }
}

extension RouterX on GoRouter {
  String? get currentRouteName => routerDelegate.currentConfiguration.last.route.name;
  IkkiRouter? get currentRouteIkki => IkkiRouter.fromName(currentRouteName);
}
