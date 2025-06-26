import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'sembast.g.dart';

@Riverpod(keepAlive: true)
SembastService sembastService(Ref ref) {
  throw UnimplementedError();
}

class SembastService {
  SembastService({required this.db});

  final Database db;
}

Future<Database> initSembastDb() async {
  final f = getDatabaseFactorySqflite(sqflite.databaseFactory);
  final db = await f.openDatabase('test.db');
  return db;
}
