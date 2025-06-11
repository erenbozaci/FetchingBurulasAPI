import 'package:fetchingburulasapi/fetch/burulas_api.dart';
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
    final type = HaritaAyarlar.haritaAyarlari!["mapType"];
    String mapURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
    switch (type) {
      case "DEFAULT":
        break;
      case "DARK":
        break;
    }
    if (type == "DARK") {
      return ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            -1, 0, 0, 0, 255,
            0, -1, 0, 0, 255,
            0, 0, -1, 0, 255,
            0, 0, 0, 1, 0,
          ]),
          child: TileLayer(urlTemplate: mapURL, retinaMode: true));
    }

    return TileLayer(
      urlTemplate: mapURL,
      retinaMode: true,
    );
  }
}