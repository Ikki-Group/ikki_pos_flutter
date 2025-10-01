import 'dart:convert';

import '../../features-old/payment/payment_enum.dart';
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
    // const encoder = JsonEncoder.withIndent('  ');
    // final stateStr = encoder.convert(state);
    final stateStr = jsonEncode(state);

    final msg =
        '''
[$date][$this][${user.id}-${user.name}][$message]
$stateStr
''';

    talker.info(msg);
    return msg;
  }
}

extension CartX on Cart {
  double get receivableCash {
    final cash = payments.toList().where((p) => p.type == PaymentType.cash);
    var amount = 0.0;
    for (final p in cash) {
      amount += p.amount;
    }
    return amount;
  }
}
