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

  Database db;

  Future<void> reinit() async {
    final f = getDatabaseFactorySqflite(sqflite.databaseFactory);
    db = await f.openDatabase('test.db');
  }

  Future<void> drop() async {
    await db.dropAll();
    // await db.reload();
  }
}

Future<Database> initSembastDb() async {
  final f = getDatabaseFactorySqflite(sqflite.databaseFactory);
  final db = await f.openDatabase('test.db');

  return db;
}

enum SembastKeys {
  carts,
}
