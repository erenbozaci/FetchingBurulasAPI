

import 'package:fetchingburulasapi/models/abstracts/route_data.dart';

class BusLocation extends RouteData{
  int state;
  String plaka;
  String renk;
  int hiz;
  int mesafe;
  String surucu;
  int gunlukYolcu;
  int seferYolcu;
  int durakYolcu;
  int maxHiz;
  int yon;
  DateTime editDate;
  int klimaVarMi;
  int engelliUygunMu;
  String hatkodu;
  int validatorNo;
  String istikamet;

  BusLocation({
    required super.latitude,
    required super.longitude,
    required this.state,
    required this.plaka,
    required this.renk,
    required this.hiz,
    required this.mesafe,
    required this.surucu,
    required this.gunlukYolcu,
    required this.seferYolcu,
    required this.durakYolcu,
    required this.maxHiz,
    required this.yon,
    required this.editDate,
    required this.klimaVarMi,
    required this.engelliUygunMu,
    required this.hatkodu,
    required this.validatorNo,
    required this.istikamet,
  });

  factory BusLocation.fromJSON(Map<String, dynamic> json) {
    return BusLocation(
      latitude: json['enlem'] as double,
      longitude: json['boylam'] as double,
      state: json['state'] as int,
      plaka: json['plaka'] as String,
      renk: json['renk'] as String,
      hiz: json['hiz'] as int,
      mesafe: json['mesafe'] as int,
      surucu: json['surucu'] as String,
      gunlukYolcu: json['gunlukYolcu'] as int,
      seferYolcu: json['seferYolcu'] as int,
      durakYolcu: json['durakYolcu'] as int,
      maxHiz: json['maxHiz'] as int,
      yon: json['yon'] as int,
      editDate: DateTime.parse(json['editDate'] as String),
      klimaVarMi: json['klimaVarMi'] as int,
      engelliUygunMu: json['engelliUygunMu'] as int,
      hatkodu: json['hatkodu'] as String,
      validatorNo: json['validatorNo'] as int,
      istikamet: json['istikamet'] as String,
    );
  }


}