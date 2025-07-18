import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_constants.dart';
import '../core/config/pos_theme.dart';
import 'app_router.dart';

class IkkiPosApp extends ConsumerWidget {
  const IkkiPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: POSTheme.lightTheme,
      // theme: AppThemeFlex.light,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> setPreferredOrientations() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black));
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
