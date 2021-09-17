import 'dart:io';
import 'package:app_persitencia_flutter/src/models/basic_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static Database? _database;
  static final DBProvider db = DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  static Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'BasicModel.db');

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE BasicModel(
              id INTEGER PRIMARY KEY,
              paramText TEXT,
              paramNum INTEGER,
              paramBool INTEGER,
              paramDate TEXT
            )
        ''');
      },
    );
  }

  Future<int> newRegister(BasicModel data) async {
    final db = await database;
    final response = await db!.insert('BasicModel', data.toJson());
    return response;
  }

  Future<List<BasicModel>?> getAllRegisters() async {
    final db = await database;
    final res = await db!.query('BasicModel');

    return res.isNotEmpty
        ? res
            .map((e) => BasicModel(
                id: int.parse(e['id'].toString()),
                paramText: e['paramText'].toString(),
                paramNum: double.parse(e['paramNum'].toString()),
                paramBool: true,
                paramDate: e['paramText'].toString()))
            .toList()
        : null;
  }

  Future<int> updateModel(BasicModel model) async {
    final db = await database;
    final res = await db!.update('BasicModel', model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
    return res;
  }

  Future<int> deleteModel(BasicModel model) async {
    final db = await database;
    final res =
        await db!.delete('BasicModel', where: 'id = ?', whereArgs: [model.id]);
    return res;
  }
}
