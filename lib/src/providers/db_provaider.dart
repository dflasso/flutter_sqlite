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

  Future<List<BasicModel>> getAllRegisters() async {
    final db = await database;
    final res = await db!.query('BasicModel');

    List<BasicModel> data = [];
    if (res.isNotEmpty) {
      for (var element in res) {
        data.add(BasicModel(
            paramText: element['paramText'].toString(),
            paramNum: double.parse(element['paramNum'].toString()),
            paramBool: true,
            paramDate: element['paramDate'].toString()));
      }
    }

    return data;
  }
}
