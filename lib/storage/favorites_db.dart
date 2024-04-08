import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/storage/db_init.dart';

typedef FavoriteBus = Map<String, dynamic>;
typedef FavoritesList = List<FavoriteBus>;

class FavoritesDB extends DBInit {
  Future<FavoritesList> getFavoritesAllList() async {
    return (await db).query(FAV_BUS_DB_NAME);
  }

  Future<FavoritesList> getFavoritesLimited(int limit) async {
    return (await db).query(FAV_BUS_DB_NAME, limit: limit);
  }

  Future<void> addFavorite(OtobusGuzergah otobusGuzergah) async {
    (await db).insert(FAV_BUS_DB_NAME, {
      "hatId": otobusGuzergah.hatId ,
      "hatAdi": otobusGuzergah.hatAdi,
      "guzergahBaslangic": otobusGuzergah.guzergahBaslangic,
      "guzergahBitis": otobusGuzergah.guzergahBitis ,
      "guzergahBilgisi": otobusGuzergah.guzergahBilgisi,
    });
  }

  Future<void> deleteFavorite(OtobusGuzergah otobusGuzergah) async {
    (await db).delete("FavoriteBuses", where: 'hatId = ?', whereArgs: [otobusGuzergah.hatId ]);
  }

  Future<bool> isFavorite(OtobusGuzergah otobusGuzergah) async {
    return (await (await db).query("FavoriteBuses", where: 'hatId = ?', whereArgs: [otobusGuzergah.hatId])).isNotEmpty;
  }
}