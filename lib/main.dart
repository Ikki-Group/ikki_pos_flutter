import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/core/db/sembast.dart';
import 'package:ikki_pos_flutter/core/db/shared_prefs.dart';
import 'package:ikki_pos_flutter/router/ikki_pos_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await initSembastDb();
  await setPreferredOrientations();

  final sp = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // observers: [TalkerStateLogger()],
      overrides: [
        sembastServiceProvider.overrideWithValue(SembastService(db: db)),
        sharedPrefsProvider.overrideWithValue(sp),
      ],
      child: const IkkiPosApp(),
    ),
  );
}
