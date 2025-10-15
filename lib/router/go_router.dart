import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/logger/talker_logger.dart';
import '../features/app/presentation/app_splash_page.dart';
import '../features/auth/presentation/auth_device/auth_device_page.dart';
import '../features/auth/presentation/select_user/select_user_page.dart';
import '../features/cart/presentation/cart_order/cart_order_page.dart';
import '../features/cart/presentation/cart_payment/cart_payment_page.dart';
import '../features/cart/presentation/cart_payment_success/cart_payment_success_page.dart';
import '../features/outlet/presentation/shift/shift_page.dart';
import '../features/pos/presentation/pos_home/pos_home_page.dart';
import '../features/sales/presentation/sales/sales_page.dart';
import '../features/settings/presentation/layouts/settings_layout.dart';
import '../widgets/layout/shell/shell_layout.dart';
import 'app_router.dart';

part 'go_router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRouter.splash.path,
    observers: [initTalkerRouteObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: AppRouter.splash.path,
        name: AppRouter.splash.name,
        builder: (context, state) => const AppSplashPage(),
      ),
      GoRoute(
        path: AppRouter.authDevice.path,
        name: AppRouter.authDevice.name,
        builder: (context, state) => const AuthDevicePage(),
      ),
      GoRoute(
        path: AppRouter.userSelect.path,
        name: AppRouter.userSelect.name,
        builder: (context, state) => const SelectUserPage(),
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          final routeName = GoRouter.of(context).currentRouteName;
          final appRouter = AppRouter.fromName(routeName);
          return ShellLayout(router: appRouter, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRouter.pos.path,
            name: AppRouter.pos.name,
            builder: (context, state) => const PosHomePage(),
          ),
          GoRoute(
            path: AppRouter.sales.path,
            name: AppRouter.sales.name,
            builder: (context, state) => const SalesPage(),
          ),
          GoRoute(
            path: AppRouter.shift.path,
            name: AppRouter.shift.name,
            builder: (context, state) => const ShiftPage(),
          ),
          GoRoute(
            path: AppRouter.settings.path,
            name: AppRouter.settings.name,
            builder: (context, state) => const SettingsLayout(),
          ),
        ],
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            body: child,
            resizeToAvoidBottomInset: false,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRouter.cart.path,
            name: AppRouter.cart.name,
            builder: (context, state) => const CartOrderPage(),
          ),
          GoRoute(
            path: AppRouter.cartPayment.path,
            name: AppRouter.cartPayment.name,
            builder: (context, state) => const CartPaymentPage(),
          ),
          GoRoute(
            path: AppRouter.cartPaymentSuccess.path,
            name: AppRouter.cartPaymentSuccess.name,
            builder: (context, state) => const CartPaymentSuccessPage(),
          ),
        ],
      ),
    ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}
