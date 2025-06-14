import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/core/config/app_constants.dart';
import 'package:ikki_pos_flutter/core/config/app_theme.dart';
import 'package:ikki_pos_flutter/router/app_router.dart';

class IkkiPosApp extends ConsumerWidget {
  const IkkiPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
