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
  return UserRepo(dio: dio, sp: sp);
}

class UserRepo {
  UserRepo({required this.dio, required this.sp});

  final Dio dio;
  final SharedPreferences sp;

  // Local
  Future<List<UserModel>> getLocal() async {
    final raw = sp.getString(SharedPrefsKeys.users.key);
    if (raw != null) {
      return UserModel.fromJsonList(jsonDecode(raw) as JsonList);
    } else {
      return fetch();
    }
  }

  Future<bool> saveLocal(List<UserModel> users) async {
    return sp.setString(SharedPrefsKeys.users.key, jsonEncode(users));
  }

  // Remote
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
