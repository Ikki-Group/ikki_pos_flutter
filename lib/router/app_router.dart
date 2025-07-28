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
import '../features/showcase/pages/showcase_index_page.dart';
import '../features/splash/pages/splash_page.dart';
import '../features/sync/pages/sync_global_page.dart';
import '../features/user/pages/user_select_page.dart';
import '../shared/utils/talker.dart';
import '../widgets/scaffold/pos/pos_scaffold.dart';
import 'ikki_router.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: IkkiRouter.splash.path,
    // initialLocation: IkkiRouter.showcase.path,
    observers: [initTalkerRouteObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: IkkiRouter.splash.path,
        name: IkkiRouter.splash.name,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: IkkiRouter.authDevice.path,
        name: IkkiRouter.authDevice.name,
        builder: (context, state) => const AuthDevicePage(),
      ),

      GoRoute(
        path: IkkiRouter.syncGlobal.path,
        name: IkkiRouter.syncGlobal.name,
        builder: (context, state) => const SyncGlobalPage(),
      ),

      GoRoute(
        path: IkkiRouter.userSelect.path,
        name: IkkiRouter.userSelect.name,
        builder: (context, state) => const UserSelectPage(),
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          final ikkiRouter = GoRouter.of(context).currentRouteIkki;
          return PosScaffold(
            router: ikkiRouter,
            child: child,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.pos.path,
            name: IkkiRouter.pos.name,
            builder: (context, state) => const PosPage(),
          ),
          GoRoute(
            path: IkkiRouter.settings.path,
            name: IkkiRouter.settings.name,
            builder: (context, state) => const SettingIndexPage(),
          ),
        ],
      ),

      ShellRoute(
        pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
          return MaterialPage(child: Scaffold(body: child));
        },

        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.cart.path,
            name: IkkiRouter.cart.name,
            builder: (context, state) => const CartIndexPage(),
          ),
          GoRoute(
            path: IkkiRouter.cartPayment.path,
            name: IkkiRouter.cartPayment.name,
            builder: (context, state) => const CartPaymentPage(),
          ),
          GoRoute(
            path: IkkiRouter.cartRndTwo.path,
            name: IkkiRouter.cartRndTwo.name,
            builder: (context, state) => const CartPaymentRndTwo(
              orderItems: [],
              subtotal: 1000,
            ),
          ),
          GoRoute(
            path: IkkiRouter.cartPaymentSuccess.path,
            name: IkkiRouter.cartPaymentSuccess.name,
            builder: (context, state) => const CartPaymentSuccess(),
          ),
          GoRoute(
            path: IkkiRouter.cartRnd.path,
            name: IkkiRouter.cartRnd.name,
            builder: (context, state) => const CartRnd(),
          ),
        ],
      ),

      // Showcase
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Showcase'),
            ),
            body: child,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.showcase.path,
            name: IkkiRouter.showcase.name,
            builder: (context, state) => const ShowcaseIndexPage(),
          ),
        ],
      ),
    ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}
