import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/pages/auth_device_page.dart';
import '../features/pos/pages/pos_page.dart';
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
        ],
      ),

      // ShellRoute(
      //   builder: (BuildContext context, GoRouterState state, Widget child) {
      //     return HomeScaffold(child: child);
      //   },
      //   redirect: (context, state) {
      //     final hasOutlet = ref.read(outletNotifierProvider).outlet != null;
      //     if (!hasOutlet) {
      //       throw Exception('outlet is null');
      //     }

      //     final hasUser = ref.read(userNotifierProvider) != null;
      //     if (!hasUser) {
      //       return IkkiRouter.userSelect.path;
      //     }

      //     return null;
      //   },
      //   routes: <RouteBase>[
      //     GoRoute(
      //       path: IkkiRouter.home.path,
      //       name: IkkiRouter.home.name,
      //       builder: (context, state) {
      //         return const HomePage();
      //       },
      //     ),
      //     GoRoute(
      //       path: IkkiRouter.history.path,
      //       name: IkkiRouter.history.name,
      //       builder: (context, state) {
      //         return const Center(child: Text('History'));
      //       },
      //     ),
      //   ],
      // ),

      // ShellRoute(
      //   builder: (BuildContext context, GoRouterState state, Widget child) {
      //     return KeyboardAutoDismiss(
      //       scaffold: Scaffold(
      //         body: AnnotatedRegion<SystemUiOverlayStyle>(
      //           value: SystemUiOverlayStyle.dark,
      //           child: child,
      //         ),
      //       ),
      //     );
      //   },
      //   redirect: (context, state) {
      //     final hasOutlet = ref.read(outletNotifierProvider).outlet != null;
      //     if (!hasOutlet) {
      //       throw Exception('outlet is null');
      //     }

      //     final hasUser = ref.read(userNotifierProvider) != null;
      //     if (!hasUser) {
      //       return IkkiRouter.userSelect.path;
      //     }

      //     return null;
      //   },
      //   routes: <RouteBase>[
      //     GoRoute(
      //       path: IkkiRouter.cartSelection.path,
      //       name: IkkiRouter.cartSelection.name,
      //       builder: (context, state) {
      //         return const CartSelectionPage();
      //       },
      //     ),
      //   ],
      // ),

      // ShellRoute(
      //   builder: (BuildContext context, GoRouterState state, Widget child) {
      //     return Scaffold(
      //       body: AnnotatedRegion<SystemUiOverlayStyle>(
      //         value: SystemUiOverlayStyle.dark,
      //         child: child,
      //       ),
      //     );
      //   },
      //   routes: <RouteBase>[
      //     GoRoute(
      //       path: IkkiRouter.widgetsbook.path,
      //       name: IkkiRouter.widgetsbook.name,
      //       builder: (context, state) {
      //         return const POSThemeShowcasePage();
      //       },
      //     ),
      //   ],
      // ),
    ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}
