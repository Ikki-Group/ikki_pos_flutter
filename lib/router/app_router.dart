import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/outlet/outlet_notifier.dart';
import '../data/user/user_notifier.dart';
import '../features/auth/pages/auth_device_page.dart';
import '../features/cart/pages/cart_selection_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/user/pages/user_select_page.dart';
import '../features/widgetsbook/pages/pos_theme_showcase_page.dart';
import '../shared/providers/app_provider.dart';
import '../shared/providers/app_token.dart';
import '../widgets/scaffold/home/home_scaffold.dart';
import 'ikki_router.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final listener = ValueNotifier<AppState>(const AppState.loading());

  ref
    ..onDispose(listener.dispose)
    ..listen(appProvider, (_, next) {
      print('authProvider.select next: $next');
      listener.value = next;
    });

  final router = GoRouter(
    initialLocation: initialLocation,
    refreshListenable: listener,
    redirect: (context, state) {
      final isReady = switch (listener.value) {
        Loading() => false,
        Ready() => true,
      };
      if (!isReady) return null;

      final isSplash = state.matchedLocation == IkkiRouter.splash.path;
      if (isSplash) {
        return IkkiRouter.authDevice.path;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: IkkiRouter.splash.path,
        name: IkkiRouter.splash.name,
        builder: (context, state) {
          return const Scaffold(body: Center(child: Text('Loading...')));
        },
      ),

      GoRoute(
        path: IkkiRouter.authDevice.path,
        name: IkkiRouter.authDevice.name,
        builder: (context, state) {
          return const AuthDevicePage();
        },
        redirect: (context, state) async {
          final hasToken = await ref.read(appTokenProvider.future).then((t) => t != null && t.isNotEmpty);
          return hasToken ? IkkiRouter.home.path : null;
        },
      ),

      GoRoute(
        path: IkkiRouter.userSelect.path,
        name: IkkiRouter.userSelect.name,
        builder: (context, state) {
          return const UserSelectPage();
        },
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return HomeScaffold(child: child);
        },
        redirect: (context, state) {
          final hasOutlet = ref.read(outletNotifierProvider).outlet != null;
          if (!hasOutlet) {
            throw Exception('outlet is null');
          }

          final hasUser = ref.read(userNotifierProvider) != null;
          if (!hasUser) {
            return IkkiRouter.userSelect.path;
          }

          return null;
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.home.path,
            name: IkkiRouter.home.name,
            builder: (context, state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: IkkiRouter.history.path,
            name: IkkiRouter.history.name,
            builder: (context, state) {
              return const Center(child: Text('History'));
            },
          ),
        ],
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return KeyboardAutoDismiss(
            scaffold: Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: child,
              ),
            ),
          );
        },
        redirect: (context, state) {
          final hasOutlet = ref.read(outletNotifierProvider).outlet != null;
          if (!hasOutlet) {
            throw Exception('outlet is null');
          }

          final hasUser = ref.read(userNotifierProvider) != null;
          if (!hasUser) {
            return IkkiRouter.userSelect.path;
          }

          return null;
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.cartSelection.path,
            name: IkkiRouter.cartSelection.name,
            builder: (context, state) {
              return const CartSelectionPage();
            },
          ),
        ],
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: child,
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: IkkiRouter.widgetsbook.path,
            name: IkkiRouter.widgetsbook.name,
            builder: (context, state) {
              return const POSThemeShowcasePage();
            },
          ),
        ],
      ),
    ],
  );

  // Its a good practice to dispose the router when the widget is disposed.
  ref.onDispose(router.dispose);
  return router;
}
