import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/core/config/app_constants.dart';
import 'package:ikki_pos_flutter/core/config/pos_theme.dart';
import 'package:ikki_pos_flutter/router/app_router.dart';

class IkkiPosApp extends ConsumerWidget {
  const IkkiPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: POSTheme.lightTheme,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> setPreferredOrientations() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
