import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';

class BusStopSearch extends RouteData implements ISearchData {
  @override
  SearchType searchType;
  int stationId;
  String stationName;

  BusStopSearch({
    required this.searchType,
    required this.stationId,
    required this.stationName,
    required super.latitude,
    required super.longitude
  });

  factory BusStopSearch.fromJSON(Map<String, dynamic> json) {
    return BusStopSearch(
        searchType: SearchType.DURAK,
        stationId: json["stationId"] as int,
        stationName: json["stationName"],
        latitude: json["latitude"],
        longitude: json["longitude"]);
  }
}
