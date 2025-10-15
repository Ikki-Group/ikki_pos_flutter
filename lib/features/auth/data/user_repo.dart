import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/shared_prefs.dart';
import '../../../core/logger/talker_logger.dart';
import '../../../utils/json.dart';
import '../model/user_model.dart';

part 'user_repo.g.dart';

@Riverpod(keepAlive: true)
UserRepo userRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return UserRepoImpl(sp: sp);
}

abstract class UserRepo {
  Future<List<UserModel>> getData();

  Future<List<UserModel>?> getLocal();
  Future<bool> saveLocal(List<UserModel> users);

  Future<bool> syncLocal(List<UserModel> users);
}

class UserRepoImpl implements UserRepo {
  UserRepoImpl({required this.sp});

  final SharedPreferences sp;

  @override
  Future<List<UserModel>> getData() async {
    final users = await getLocal();
    if (users == null) {
      throw Exception('Users not found');
    }
    return users;
  }

  @override
  Future<List<UserModel>?> getLocal() async {
    final raw = sp.getStringList(SharedPrefsKeys.users.key);
    if (raw == null) {
      logger.info('Data not persisted, need to sync');
      return null;
    }
    final jsonList = posJsonDecodeList(raw);
    return jsonList.map(UserModel.fromJson).toList();
  }

  @override
  Future<bool> saveLocal(List<UserModel> users) async {
    final encoded = users.map(jsonEncode).toList();
    return sp.setStringList(SharedPrefsKeys.users.key, encoded);
  }

  @override
  Future<bool> syncLocal(List<UserModel> users) async {
    final result = await saveLocal(users);
    return result;
  }
}
