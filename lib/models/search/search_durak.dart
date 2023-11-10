import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';

class SearchDurak extends RouteData implements ISearchData {
  SearchType type;
  int stationId;
  String stationName;

  SearchDurak(
      {required this.type,
      required this.stationId,
      required this.stationName,
      required super.latitude,
      required super.longitude});

  factory SearchDurak.fromJSON(Map<String, dynamic> json) {
    return SearchDurak(
        type: SearchType.DURAK,
        stationId: json["stationId"] as int,
        stationName: json["stationName"],
        latitude: json["latitude"],
        longitude: json["longitude"]);
  }
}
