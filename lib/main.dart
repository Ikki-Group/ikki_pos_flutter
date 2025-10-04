// ignore_for_file: scoped_providers_should_specify_dependencies, missing_provider_scope
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/db/sembast.dart';
import 'core/db/shared_prefs.dart';
import 'router/app_router.dart';
import 'router/ikki_pos_app.dart';

//
// Devlopment device (iPad)
// flutter: ratio: 2.0
// flutter: size: Size(1180.0, 820.0)
// flutter: padding: EdgeInsets(0.0, 24.0, 0.0, 25.0)
//

const double widthOfDesign = 1180;

void main() async {
  // final binding = SentryWidgetsFlutterBinding.ensureInitialized();
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) => deviceSize.width / widthOfDesign,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      options.sendDefaultPii = true;
      options.enableLogs = true;
      options.tracesSampleRate = 0.5;
      options.profilesSampleRate = 0.5;
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
      options.navigatorKey = navigatorKey;
      options.beforeSend = (event, hint) async {
        final screenshot = await SentryFlutter.captureScreenshot();
        // Safely obtain context from NavigatorState
        final navState = navigatorKey.currentState;
        if (navState != null && navState.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final context = navState.context;
            SentryFeedbackWidget.show(
              context,
              associatedEventId: event.eventId,
              screenshot: screenshot,
            );
          });
        } else {
          print('[Sentry] No valid navigator context for feedback widget.');
        }
        return null;
      };
    },
    appRunner: () async {
      await setPreferredOrientations();
      await initializeDateFormatting('id_ID');

      final db = await initSembastDb();
      final sp = await SharedPreferences.getInstance();

      return runApp(
        SentryWidget(
          child: ProviderScope(
            // observers: const [TalkerStateLogger()],
            overrides: [
              sembastServiceProvider.overrideWithValue(SembastService(db: db)),
              sharedPrefsProvider.overrideWithValue(sp),
            ],
            child: const IkkiPosApp(),
          ),
        ),
      );
    },
  );
}
