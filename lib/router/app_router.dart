import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/user/user_notifier.dart';
import 'package:ikki_pos_flutter/features/auth/pages/auth_device_page.dart';
import 'package:ikki_pos_flutter/features/home/pages/home_page.dart';
import 'package:ikki_pos_flutter/features/user/pages/user_select_page.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';
import 'package:ikki_pos_flutter/shared/providers/app_provider.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:ikki_pos_flutter/widgets/scaffold/home/home_scaffold.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final listener = ValueNotifier<AppState>(AppState.loading());

  ref
    ..onDispose(listener.dispose)
    ..listen(appProvider, (_, next) {
      print('authProvider.select next: $next');
      listener.value = next;
    });

  final router = GoRouter(
    initialLocation: IkkiRouter.splash.path,
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
    routes: [
      GoRoute(
        path: IkkiRouter.splash.path,
        builder: (context, state) {
          return const Scaffold(body: Center(child: Text("Loading...")));
        },
      ),

      GoRoute(
        path: IkkiRouter.authDevice.path,
        builder: (context, state) {
          return const AuthDevicePage();
        },
        redirect: (context, state) async {
          final hasToken = await ref.read(appTokenProvider.future).then((t) => t != null && t.isNotEmpty);

          return hasToken ? "/home" : null;
        },
      ),

      GoRoute(
        path: IkkiRouter.userSelect.path,
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
            throw Exception("outlet is null");
          }

          final hasUser = ref.read(userNotifierProvider) != null;
          if (!hasUser) {
            return IkkiRouter.userSelect.path;
          }

          return null;
        },
        routes: [
          GoRoute(
            path: IkkiRouter.home.path,
            builder: (context, state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: IkkiRouter.history.path,
            builder: (context, state) {
              return const Center(child: Text("History"));
            },
          ),
        ],
      ),

      // Exception Handler
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
