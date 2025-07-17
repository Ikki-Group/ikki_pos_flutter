import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                  Icons.sentiment_very_satisfied,
                  color: Colors.red,
                  size: 100,
                )
                .animate()
                .fadeIn(duration: 100.milliseconds)
                .fadeOut(duration: 400.milliseconds)
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
