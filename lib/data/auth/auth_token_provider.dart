import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repo.dart';

part 'auth_token_provider.g.dart';

@riverpod
FutureOr<String?> authToken(Ref ref) async {
  final token = await ref.read(authRepoProvider).getToken();
  return token;
}
