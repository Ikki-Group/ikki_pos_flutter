import '../formatter.dart';

extension ExtDateTime on DateTime {
  String get dateTimeId {
    return Formatter.dateTime.format(this);
  }
}
