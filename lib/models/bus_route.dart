import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';

class BusCode {
  String code;
  BusCode({required this.code});
}

class BusRoute {
  final int hatId;
  final String hatAdi;
  final String guzergahBaslangic;
  final String guzergahBitis;
  final String guzergahBilgisi;
  final BusStopList busStopList;

  BusRoute ({
    required this.hatId,
    required this.hatAdi,
    required this.guzergahBaslangic,
    required this.guzergahBitis,
    required this.guzergahBilgisi,
    this.busStopList = const [],
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      hatId: int.parse(json['id']),
      hatAdi: json['HatAdi'] as String,
      guzergahBaslangic: json["GuzergahBaslangic"] as String,
      guzergahBitis: json["GuzergahBitis"] as String,
      guzergahBilgisi: json['GuzergahBilgisi'] as String,
    );
  }

  factory BusRoute.fromFavBus(FavoriteBus favBus) {
    return BusRoute(
      hatId: int.parse(favBus['hatId'].toString()),
      hatAdi: favBus['hatAdi'] as String,
      guzergahBaslangic: favBus["guzergahBaslangic"] as String,
      guzergahBitis: favBus["guzergahBitis"] as String,
      guzergahBilgisi: favBus['guzergahBilgisi'] as String,
    );
  }

  FavoriteBus toJSON() {
    return {
      "hatId": hatId ,
      "hatAdi": hatAdi,
      "guzergahBaslangic": guzergahBaslangic,
      "guzergahBitis": guzergahBitis ,
      "guzergahBilgisi": guzergahBilgisi,
    };
  }
}