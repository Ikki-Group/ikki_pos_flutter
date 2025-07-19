import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/pages/auth_device_page.dart';
import '../features/cart/pages/cart_index_page.dart';
import '../features/cart/pages/cart_payment_page.dart';
import '../features/cart/pages/cart_payment_rnd_two.dart';
import '../features/cart/pages/cart_payment_success.dart';
import '../features/cart/pages/cart_rnd.dart';
import '../features/pos/pages/pos_page.dart';
import '../features/settings/pages/setting_index_page.dart';
import '../features/splash/pages/splash_page.dart';
import '../features/sync/pages/sync_global_page.dart';
import '../features/user/pages/user_select_page.dart';
import '../widgets/scaffold/pos/pos_scaffold.dart';
import 'ikki_router.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: IkkiRouter.splash.name,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: '/auth-device',
        name: IkkiRouter.authDevice.name,
        builder: (context, state) => const AuthDevicePage(),
      ),

      GoRoute(
        path: '/sync-global',
        name: IkkiRouter.syncGlobal.name,
        builder: (context, state) => const SyncGlobalPage(),
      ),

      GoRoute(
        path: '/user-select',
        name: IkkiRouter.userSelect.name,
        builder: (context, state) => const UserSelectPage(),
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return PosScaffold(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/pos',
            name: IkkiRouter.pos.name,
            builder: (context, state) => const PosPage(),
          ),
          GoRoute(
            path: '/settings',
            name: IkkiRouter.settings.name,
            builder: (context, state) => const SettingIndexPage(),
          ),
        ],
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(body: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/cart',
            name: IkkiRouter.cart.name,
            builder: (context, state) => const CartIndexPage(),
          ),
          GoRoute(
            path: '/cart-payment',
            name: IkkiRouter.cartPayment.name,
            builder: (context, state) => const CartPaymentPage(),
          ),
          GoRoute(
            path: '/cart-payment-rnd-two',
            name: IkkiRouter.cartRndTwo.name,
            builder: (context, state) => const CartPaymentRndTwo(
              orderItems: [],
              subtotal: 1000,
            ),
          ),
          GoRoute(
            path: '/cart-payment-success',
            name: IkkiRouter.cartPaymentSuccess.name,
            builder: (context, state) => const CartPaymentSuccess(),
          ),
          GoRoute(
            path: '/cart_rnd',
            name: IkkiRouter.cartRnd.name,
            builder: (context, state) => const CartRnd(),
          ),
        ],
      ),
    ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}
