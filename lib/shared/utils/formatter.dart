import 'package:intl/intl.dart';

abstract class Formatter {
  static NumberFormat toIdr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static NumberFormat toIdrNoSymbol = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  static DateFormat date = DateFormat(
    'EEEE, d MMMM yyyy HH:mm',
    'id_ID',
  );

  static DateFormat dateTime = DateFormat(
    'd MMMM yyyy HH:mm',
    'id_ID',
  );
}

extension DoubleX on double {
  String get toIdr => Formatter.toIdr.format(this);
  String get toIdrNoSymbol => Formatter.toIdrNoSymbol.format(this);
}

extension IntX on int {
  String get toIdr => Formatter.toIdr.format(this);
  String get toIdrNoSymbol => Formatter.toIdrNoSymbol.format(this);
}

extension NumX on num {
  String get toIdr => Formatter.toIdr.format(this);
  String get toIdrNoSymbol => Formatter.toIdrNoSymbol.format(this);
}
