// ignore_for_file: scoped_providers_should_specify_dependencies, missing_provider_scope
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app_config.dart';
import 'core/db/sembast.dart';
import 'core/db/shared_prefs.dart';
import 'router/pos_app.dart';

//
// Devlopment device (iPad)
// flutter: ratio: 2.0
// flutter: size: Size(1180.0, 820.0)
// flutter: padding: EdgeInsets(0.0, 24.0, 0.0, 25.0)
//

const double widthOfDesign = 1180;

void main() async {
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) => deviceSize.width / widthOfDesign,
  );

  await setPreferredOrientations();
  await initializeDateFormatting('id_ID');

  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = AppConfig.sentryDsn
          ..sendDefaultPii = true
          ..enableLogs = true
          ..tracesSampleRate = 0.5
          ..profilesSampleRate = 0.5
          ..replay.sessionSampleRate = 0.1
          ..replay.onErrorSampleRate = 1.0;
      },
      appRunner: bootstrap,
    );
  } else {
    await bootstrap();
  }
}

Future<void> bootstrap() async {
  Intl.defaultLocale = "id-ID";

  final db = await initSembastDb();
  final sp = await SharedPreferences.getInstance();

  runApp(
    ToastificationWrapper(
      config: ToastificationConfig(
        alignment: Alignment.topCenter,
      ),
      child: SentryWidget(
        child: ProviderScope(
          // observers: const [TalkerStateLogger()],
          overrides: <Override>[
            sembastServiceProvider.overrideWithValue(SembastService(db: db)),
            sharedPrefsProvider.overrideWithValue(sp),
          ],
          child: const PosApp(),
        ),
      ),
    ),
  );
}
