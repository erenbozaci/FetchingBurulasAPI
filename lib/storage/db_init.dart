import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBInit {

  final String FAV_BUS_DB_NAME = "FavoriteBuses";
  final String MAP_OPT_DB_NAME = "MapOptions";

  static Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'fetchingburulasapi.db');
    Database db = await openDatabase(path, onCreate: onCreate, version: 1);
    if((await db.query(MAP_OPT_DB_NAME, where: "optionId = ?", whereArgs: [1])).isEmpty) {
      await db.insert(
        MAP_OPT_DB_NAME,
        {
          "optionId": 1,
          "mainLat": "40.188215",
          "mainLong": "29.060828",
          "mapType": "DEFAULT"
        },
      );
    }
    return db;
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $FAV_BUS_DB_NAME (
        hatId INTEGER NOT NULL PRIMARY KEY,
        hatAdi TEXT NOT NULL,
        guzergahBaslangic TEXT NOT NULL,
        guzergahBitis TEXT NOT NULL,
        guzergahBilgisi TEXT NOT NULL,
        custom_order INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $MAP_OPT_DB_NAME (
        optionId INT PRIMARY KEY,
        mainLat TEXT NOT NULL,
        mainLong TEXT NOT NULL,
      )
      ''');
  }
}