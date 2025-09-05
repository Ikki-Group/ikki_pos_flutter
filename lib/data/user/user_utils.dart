import 'user_model.dart';

extension UserNullX on UserModel? {
  bool get isNull => this == null;

  UserModel get requireValue {
    if (isNull) throw Exception('User is null');
    return this!;
  }
}
