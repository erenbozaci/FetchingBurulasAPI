import 'db_init.dart';

typedef AyarlarMap = Map<String, dynamic>;

typedef AyarlarJSON = Map<String, dynamic>;

abstract class IOptions extends DBInit {
  Future<AyarlarJSON> getOptions();
  Future<void> updateOptions(AyarlarJSON json);
}

class HaritaAyarlar extends IOptions {
  static AyarlarJSON? haritaAyarlari;

  static void init() async {
    haritaAyarlari = await HaritaAyarlar().getOptions();
  }

  @override
  Future<AyarlarJSON> getOptions() async {
    final res = (await (await db).query(MAP_OPT_DB_NAME));

    return Map<String, dynamic>.from(res[0]);
  }

  @override
  Future<void> updateOptions(AyarlarJSON json) async {
    (await (await db).update(MAP_OPT_DB_NAME, {
      "mainLat": json["mainLat"].toString(),
      "mainLong": json["mainLong"].toString(),
    }, where: "optionId = ?", whereArgs: [1]));
  }
}