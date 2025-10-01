import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../providers/splash_provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splash = ref.watch(splashProvider);

    return Scaffold(
      body: Center(
        child: switch (splash) {
          AsyncData(:final value) =>
            const Icon(
                  Icons.point_of_sale,
                  color: POSTheme.primaryBlue,
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
