import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/storage/db_init.dart';

typedef FavoriteBus = Map<String, dynamic>;
typedef FavoritesList = List<FavoriteBus>;

class FavoritesDB extends DBInit {
  static final FavoritesDB instance = FavoritesDB();

  static void init() async {}

  Future<FavoritesList> getFavoritesAllList() async {
    try {
      return (await db).query(FAV_BUS_DB_NAME, orderBy: 'custom_order ASC');
    } catch (e) {
      throw Exception("GetFavoritesAll Error: $e");
    }
  }

  Future<FavoritesList> getFavoritesLimited(int limit) async {
    try {
      return (await db).query(FAV_BUS_DB_NAME, limit: limit, orderBy: 'custom_order ASC');
    } catch (e) {
      throw Exception("GetFavoritesLimit Error: $e");
    }
  }

  Future<void> addFavorite(BusRoute busRoute) async {
    try {
      final maxOrder = await (await db).rawQuery('SELECT MAX(custom_order) as max_order FROM $FAV_BUS_DB_NAME');
      (await db).insert(FAV_BUS_DB_NAME, {
        ...busRoute.toJSON(),
        'custom_order': (int.tryParse((maxOrder.first['max_order'].toString())) ?? 0) + 1
      });
    } catch (e) {
      throw Exception("AddFavorite Error: $e");
    }
  }

  Future<void> deleteFavorite(BusRoute busRoute) async {
    try {
      (await db).delete(FAV_BUS_DB_NAME, where: 'hatId = ?', whereArgs: [busRoute.hatId]);
    } catch (e) {
      throw Exception("RemoveFavorite Error: $e");
    }
  }

  Future<bool> isFavorite(BusRoute busRoute) async {
    try {
      return (await (await db).query(FAV_BUS_DB_NAME, where: 'hatId = ?', whereArgs: [busRoute.hatId])).isNotEmpty;
    } catch (e) {
      throw Exception("IsFavorite Error: $e");
    }
  }

  Future<void> updateOrders(List orderList) async {
    try {
      for (int i = 0; i < orderList.length; i++) {
        (await db).update(FAV_BUS_DB_NAME, { 'custom_order' : (i+1) }, where: 'hatId = ?', whereArgs: [orderList[i]]);
      }
    } catch (e) {
      throw Exception("ChangeOrder Error: $e");
    }
  }
}