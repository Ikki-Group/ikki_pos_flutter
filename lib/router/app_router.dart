import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/features/auth/pages/auth_device_page.dart';
import 'package:ikki_pos_flutter/shared/providers/app_provider.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:ikki_pos_flutter/widgets/scaffold/home_scaffold.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum IkkiRouter {
  splash(path: "/splash"),
  authDevice(path: "/auth-device"),

  // Home
  home(path: "/home");

  const IkkiRouter({required this.path});
  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final listener = ValueNotifier<AppState>(AppState.loading());

  ref
    ..onDispose(listener.dispose)
    ..listen(appProvider.select((value) => value), (_, next) {
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
          print('state: $state');
          return const AuthDevicePage();
        },
        redirect: (context, state) async {
          final hasToken = await ref
              .read(appTokenProvider.future)
              .then((t) => t != null && t.isNotEmpty);

          return hasToken ? "/home" : null;
        },
      ),

      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return HomeScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) {
              return Scaffold(body: Center(child: Text("Hom")));
            },
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
