import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'user_model.dart';

part 'user_repo.g.dart';

@riverpod
UserRepo userRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  final dio = ref.watch(dioClientProvider);
  return UserRepoImpl(dio: dio, sp: sp);
}

abstract class UserRepo {
  Future<List<UserModel>> fetch();
  Future<List<UserModel>> getLocal();
  Future<bool> saveLocal(List<UserModel> users);
}

class UserRepoImpl implements UserRepo {
  UserRepoImpl({required this.dio, required this.sp});

  final Dio dio;
  final SharedPreferences sp;

  @override
  Future<List<UserModel>> getLocal() async {
    final raw = sp.getStringList(SharedPrefsKeys.users.key);
    if (raw != null) {
      final jsonList = posJsonDecodeList(raw);
      return jsonList.map(UserModel.fromJson).toList();
    } else {
      return fetch();
    }
  }

  @override
  Future<bool> saveLocal(List<UserModel> users) async {
    final encoded = users.map(jsonEncode).toList();
    return sp.setStringList(SharedPrefsKeys.users.key, encoded);
  }

  @override
  Future<List<UserModel>> fetch() async {
    final users = _kMock;
    await saveLocal(users);
    return users;
  }
}

List<UserModel> _kMock = List.generate(10, (index) {
  return UserModel(
    id: '$index',
    name: 'Rizqy Nugroho $index',
    email: 'rizqy.nugroho$index@ikki.id',
    pin: '1111',
  );
});
