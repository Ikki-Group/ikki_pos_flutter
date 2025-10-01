import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import 'app_splash_controller.dart';

class AppSplashPage extends ConsumerWidget {
  const AppSplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splash = ref.watch(splashProvider);

    return Scaffold(
      body: Center(
        child: switch (splash) {
          AsyncData(:final value) =>
            const Icon(
                  Icons.point_of_sale,
                  color: AppTheme.primaryBlue,
                  size: 100,
                )
                .animate()
                .fadeIn(duration: 100.ms)
                .fadeOut(duration: 400.ms)
                .then()
                .callback(
                  callback: (_) => context.goNamed(value.name),
                ),
          AsyncError(:final error) => Text(error.toString()),
          _ => const CircularProgressIndicator(),
        },
      ),
    );
  }
}
