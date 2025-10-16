import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

enum AppRouter {
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

  static AppRouter? fromName(String? name) {
    if (name == null || name.isEmpty) return null;
    return AppRouter.values.firstWhereOrNull((e) => e.name == name);
  }
}

extension RouterX on GoRouter {
  String? get currentRouteName => routerDelegate.currentConfiguration.last.route.name;
}
