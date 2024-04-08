import 'package:fetchingburulasapi/storage/favorites_db.dart';

class OtobusCode {
  String code;
  OtobusCode({required this.code});
}

class OtobusGuzergah {
  final int hatId;
  final String hatAdi;
  final String guzergahBaslangic;
  final String guzergahBitis;
  final String guzergahBilgisi;

  OtobusGuzergah ({
    required this.hatId,
    required this.hatAdi,
    required this.guzergahBaslangic,
    required this.guzergahBitis,
    required this.guzergahBilgisi
  });

  factory OtobusGuzergah.fromJson(Map<String, dynamic> json) {
    return OtobusGuzergah(
      hatId: int.parse(json['id']),
      hatAdi: json['HatAdi'] as String,
      guzergahBaslangic: json["GuzergahBaslangic"] as String,
      guzergahBitis: json["GuzergahBitis"] as String,
      guzergahBilgisi: json['GuzergahBilgisi'] as String,
    );
  }

  factory OtobusGuzergah.fromFavBus(FavoriteBus favBus) {
    return OtobusGuzergah(
      hatId: int.parse(favBus['hatId'].toString()),
      hatAdi: favBus['hatAdi'] as String,
      guzergahBaslangic: favBus["guzergahBaslangic"] as String,
      guzergahBitis: favBus["guzergahBitis"] as String,
      guzergahBilgisi: favBus['guzergahBilgisi'] as String,
    );
  }
}