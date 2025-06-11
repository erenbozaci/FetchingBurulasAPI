import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/storage/ayarlar_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapComponents {
  static init() {
    HaritaAyarlar.init();
  }

  static MapOptions getMapOptions() {
    return MapOptions(
      initialCenter: BurulasApi.toLatLngM(
          HaritaAyarlar.haritaAyarlari!["mainLat"],
          HaritaAyarlar.haritaAyarlari!["mainLong"]),
      initialZoom: 12.0,
      maxZoom: 18.0,
    );
  }

  static Widget getTileLayer() {
    String mapURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

    return TileLayer(
      urlTemplate: mapURL,
      userAgentPackageName: "com.erenbozaci.fetchingburulasapi",
    );
  }
}