import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final router = GoRouter(
    initialLocation: IkkiRouter.splash.path,
    routes: [
      GoRoute(
        path: IkkiRouter.splash.path,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: IkkiRouter.authDevice.path,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );

  return router;
}
