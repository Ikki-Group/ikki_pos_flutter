import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/app/presentation/app_splash_page.dart';
import '../features/auth/presentation/auth_device/auth_device_page.dart';
import '../features/auth/presentation/select_user/select_user_page.dart';
import '../shared/utils/talker.dart';
import '../widgets/layout/shell/shell_layout.dart';
import 'ikki_router.dart';

part 'app_router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: IkkiRouter.splash.path,
    observers: [initTalkerRouteObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: IkkiRouter.splash.path,
        name: IkkiRouter.splash.name,
        builder: (context, state) => const AppSplashPage(),
      ),
      GoRoute(
        path: IkkiRouter.authDevice.path,
        name: IkkiRouter.authDevice.name,
        builder: (context, state) => const AuthDevicePage(),
      ),
      GoRoute(
        path: IkkiRouter.userSelect.path,
        name: IkkiRouter.userSelect.name,
        builder: (context, state) => const SelectUserPage(),
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          final ikkiRouter = GoRouter.of(context).currentRouteIkki;
          return ShellLayout(router: ikkiRouter, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.pos.path,
            name: IkkiRouter.pos.name,
            builder: (context, state) => const Placeholder(),
          ),
          // GoRoute(
          //   path: IkkiRouter.sales.path,
          //   name: IkkiRouter.sales.name,
          //   builder: (context, state) => const SalesPage(),
          // ),
        ],
      ),
    ],
    // routes: <RouteBase>[

    //   GoRoute(
    //     path: IkkiRouter.syncGlobal.path,
    //     name: IkkiRouter.syncGlobal.name,
    //     builder: (context, state) => const SyncGlobalPage(),
    //   ),

    //   ShellRoute(
    //     builder: (BuildContext context, GoRouterState state, Widget child) {
    //       final ikkiRouter = GoRouter.of(context).currentRouteIkki;
    //       return PosScaffold(
    //         router: ikkiRouter,
    //         child: child,
    //       );
    //     },
    //     routes: <RouteBase>[
    //       GoRoute(
    //         path: IkkiRouter.pos.path,
    //         name: IkkiRouter.pos.name,
    //         builder: (context, state) => const PosPage(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.sales.path,
    //         name: IkkiRouter.sales.name,
    //         builder: (context, state) => const SalesPage(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.shift.path,
    //         name: IkkiRouter.shift.name,
    //         builder: (context, state) => const ShiftPage(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.settings.path,
    //         name: IkkiRouter.settings.name,
    //         builder: (context, state) => const SettingIndexPage(),
    //       ),
    //     ],
    //   ),

    //   ShellRoute(
    //     pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
    //       return MaterialPage(
    //         child: Scaffold(
    //           body: child,
    //           resizeToAvoidBottomInset: false,
    //         ),
    //       );
    //     },

    //     routes: <RouteBase>[
    //       GoRoute(
    //         path: IkkiRouter.cart.path,
    //         name: IkkiRouter.cart.name,
    //         builder: (context, state) => const CartIndexPage(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.cartPayment.path,
    //         name: IkkiRouter.cartPayment.name,
    //         builder: (context, state) => const CartPaymentPage(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.cartPaymentSuccess.path,
    //         name: IkkiRouter.cartPaymentSuccess.name,
    //         builder: (context, state) => const CartPaymentSuccess(),
    //       ),
    //       GoRoute(
    //         path: IkkiRouter.cartRnd.path,
    //         name: IkkiRouter.cartRnd.name,
    //         builder: (context, state) => const CartRnd(),
    //       ),
    //     ],
    //   ),

    //   // Showcase
    //   ShellRoute(
    //     builder: (BuildContext context, GoRouterState state, Widget child) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: const Text('Showcase'),
    //         ),
    //         body: child,
    //       );
    //     },
    //     routes: <RouteBase>[
    //       GoRoute(
    //         path: IkkiRouter.showcase.path,
    //         name: IkkiRouter.showcase.name,
    //         builder: (context, state) => const ShowcaseIndexPage(),
    //       ),
    //     ],
    //   ),
    // ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}

extension RouterX on GoRouter {
  String? get currentRouteName => routerDelegate.currentConfiguration.last.route.name;
  IkkiRouter? get currentRouteIkki => IkkiRouter.fromName(currentRouteName);
}
