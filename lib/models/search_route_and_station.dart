import 'package:fetchingburulasapi/models/durak_data.dart';

class SearchRouteAndStation {
  String type;
  String kod;
  String aciklama;
  int hatId;

  SearchRouteAndStation(
      {required this.type,
      required this.kod,
      required this.aciklama,
      required this.hatId});

  factory SearchRouteAndStation.fromJSON(Map<String, dynamic> json) {
    return SearchRouteAndStation(
        type: json["type"] as String,
        kod: json["kod"] ?? "",
        aciklama: json["aciklama"] ?? "",
        hatId: json["hatNo"] ?? 0
    );
  }

  factory SearchRouteAndStation.getBusFromDurakData(DurakData durakData) {
    return SearchRouteAndStation(
      type: 'R',
      kod: durakData.routeCode,
      aciklama: durakData.routeCode,
      hatId: durakData.routeId,
    );
  }


}
