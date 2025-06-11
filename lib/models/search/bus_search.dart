import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';

class BusSearch implements ISearchData {
  @override
  SearchType searchType;
  String kod;
  String aciklama;
  int hatId;
  BusStopList busStopList;

  BusSearch({
    required this.searchType,
    required this.kod,
    required this.aciklama,
    required this.hatId,
    this.busStopList = const [],
  });

  factory BusSearch.fromJSON(Map<String, dynamic> json) {
    print(json["routes"]);
    return BusSearch(
      searchType: SearchType.OTOBUS,
      kod: json["kod"],
      aciklama: json["aciklama"],
      hatId: json["hatNo"],
      busStopList: json["routes"] ?? [],
    );
  }

  factory BusSearch.getBusFromBusRoute(BusRoute busRoute) {
    return BusSearch(
      searchType: SearchType.OTOBUS,
      kod: busRoute.hatAdi,
      aciklama: busRoute.hatAdi,
      hatId: busRoute.hatId,
      busStopList: busRoute.busStopList,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "kod": kod,
      "aciklama": aciklama,
      "hatId": hatId,
      "routes": busStopList,
    };
  }
}
