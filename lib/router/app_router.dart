import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/features/auth/pages/auth_device_page.dart';
import 'package:ikki_pos_flutter/shared/providers/app_ready.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum IkkiRouter {
  splash(path: "/splash"),
  authDevice(path: "/auth-device");

  const IkkiRouter({required this.path});
  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final listener = ValueNotifier<AsyncValue>(const AsyncLoading());

  ref
    ..onDispose(listener.dispose)
    ..listen(appReadyProvider.select((value) => value), (_, next) {
      print('authProvider.select next: $next');
      listener.value = next;
    });

  final router = GoRouter(
    initialLocation: IkkiRouter.splash.path,
    refreshListenable: listener,
    redirect: (context, state) {
      final isReady = switch (listener.value) {
        AsyncLoading() => null,
        AsyncError() => null,
        AsyncValue() => true,
      };

      if (isReady == null) return null;

      final isSplash = state.matchedLocation == IkkiRouter.splash.path;

      print('isReady: $isReady');
      if (isSplash) {
        return IkkiRouter.authDevice.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: IkkiRouter.splash.path,
        builder: (context, state) =>
            Scaffold(body: Center(child: Text("Loading..."))),
      ),
      GoRoute(
        path: IkkiRouter.authDevice.path,
        builder: (context, state) => const AuthDevicePage(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
