import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fetchingburulasapi/models/ayarlar.dart';
import 'package:path_provider/path_provider.dart';

typedef AyarlarMap = Map<String, dynamic>;

class AyarlarStorage {

  static AyarlarMap defaultConfig = {
    "mainLat": 40.188215,
    "mainLong": 29.060828,
  };

  static late Ayarlar ayarlar;

  static Future<void> init() async {
    ayarlar = await getAyarlar();
  }
  static Future<String> get _localPath async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ayarlar.json').create(recursive: true);
  }


  static Future<Ayarlar> getAyarlar() async {
    try {
      final file = await _localFile, contents = await file.readAsString();
      AyarlarMap s = jsonDecode(contents.isEmpty ? jsonEncode(defaultConfig).toString() : contents);
      return Ayarlar.fromJSON(s);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<File> writeAyarlar(Ayarlar ayarlar) async {
    final jsonString = jsonEncode(ayarlar.toJSON());
    final file = await _localFile;
    return await file.writeAsString(jsonString);
  }
}