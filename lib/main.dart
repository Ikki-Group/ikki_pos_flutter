import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/router/ikki_pos_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      // observers: [TalkerStateLogger()],
      overrides: [
        // sembastServiceProvider.overrideWithValue(SembastService(db: db)),
      ],
      child: const IkkiPosApp(),
    ),
  );
}
