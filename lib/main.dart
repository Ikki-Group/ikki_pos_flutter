import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/db/sembast.dart';
import 'core/db/shared_prefs.dart';
import 'router/ikki_pos_app.dart';
import 'shared/utils/talker.dart';

//
// Devlopment device (iPad)
// flutter: ratio: 2.0
// flutter: size: Size(1180.0, 820.0)
// flutter: padding: EdgeInsets(0.0, 24.0, 0.0, 25.0)
//

void main() async {
  // var appToken = '';
  // if (Platform.isIOS) {
  //   appToken = 'AAf4e0b2a3b17f3a07f6b173e6434adf60487742e4-NRMA';
  // } else if (Platform.isAndroid) {
  //   appToken = 'AA5f6b439c5b03b3edb50d5b1bb2f780b8580e3fa7-NRMA';
  // }

  // final config = Config(
  //   accessToken: appToken,
  //   newEventSystemEnabled: true,
  // );

  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 1180;
      // const double widthOfDesign = 460;
      return deviceSize.width / widthOfDesign;
    },
  );

  await setPreferredOrientations();

  final db = await initSembastDb();
  final sp = await SharedPreferences.getInstance();

  // await NewrelicMobile.instance.start(config, () {});
  // await NewrelicMobile.instance.setMaxEventPoolSize(3000);
  // await NewrelicMobile.instance.setMaxEventBufferTime(200);
  // await NewrelicMobile.instance.setMaxOfflineStorageSize(200);

  await initializeDateFormatting(
    'id_ID',
  ).then((_) {
    runApp(
      ProviderScope(
        observers: const [TalkerStateLogger()],
        overrides: [
          sembastServiceProvider.overrideWithValue(SembastService(db: db)),
          sharedPrefsProvider.overrideWithValue(sp),
        ],
        child: const IkkiPosApp(),
      ),
    );
  });
}
