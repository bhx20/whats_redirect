import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const dbVersion = 1;
  static Database? _database;

/*----------> For avoid the multiple class instance and this lines of
            code gives you a single private instance for global use <---------*/

  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

/*-----------------------> For check the database availability <--------------*/

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDataBase();
    return _database;
  }

/*----> For database is not available then get db path and create table <-----*/

  initDataBase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "whatsDB");
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

/*----------------------> SQL Create Table Function <-------------------------*/

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE USER_NUMBER (
      dbId INTEGER PRIMARY KEY AUTOINCREMENT,
      CreatedAt TEXT,
      Number TEXT
      )
      ''');
  }

  Future<int?> insert(String tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(
      tableName,
      row,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> queryAll(String tableName) async {
    Database? db = await instance.database;
    return await db?.query(
      tableName,
    );
  }

  Future<int?> deleteQuery(
    String tableName,
    int id,
    String columnName,
  ) async {
    Database? db = await instance.database;
    try {
      var res = await db?.delete(
        tableName,
        where: "$columnName = ?",
        whereArgs: [id],
      );
      return res;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<int?> update(
      String tableName, int id, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.update(
      tableName,
      row,
      where: 'dbId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>?> queryAllWithOrderBy(
    String tableName,
    String columnName,
  ) async {
    Database? db = await instance.database;
    return await db?.query(tableName, orderBy: " $columnName DESC");
  }

  Future<List<Map<String, dynamic>>?> querySpecific(
    String tableName,
    dynamic id, {
    String? columnName,
  }) async {
    try {
      Database? db = await instance.database;
      var res =
          await db?.query(tableName, where: "$columnName = ?", whereArgs: [id]);
      return res;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
