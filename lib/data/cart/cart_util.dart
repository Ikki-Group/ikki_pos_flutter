import 'dart:convert';

import '../../shared/utils/talker.dart';
import '../user/user_model.dart';
import 'cart_model.dart';

enum CartLogAction {
  create,
  pay
  //
  ;

  @override
  String toString() {
    return name.split('.').last.toUpperCase();
  }

  String toLog(Cart state, UserModel user, String message) {
    final date = DateTime.now().toIso8601String();
    const encoder = JsonEncoder.withIndent('  ');
    final stateStr = encoder.convert(state);
    final msg =
        '''
[$date][$this][${user.id}-${user.name}][$message]
$stateStr
''';

    talker.info(msg);
    return msg;
  }
}
