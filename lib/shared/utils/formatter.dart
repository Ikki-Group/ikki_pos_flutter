import 'package:intl/intl.dart';

class Formatter {
  static NumberFormat toIdr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
}
