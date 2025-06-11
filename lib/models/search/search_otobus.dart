import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';

class SearchOtobus implements ISearchData {
  SearchType type;
  String kod;
  String aciklama;
  int hatId;

  SearchOtobus({
    required this.type,
      required this.kod,
      required this.aciklama,
      required this.hatId});

  factory SearchOtobus.fromJSON(Map<String, dynamic> json) {
    return SearchOtobus(
        type: SearchType.OTOBUS,
        kod: json["kod"],
        aciklama: json["aciklama"],
        hatId: json["hatNo"]
    );
  }
  factory SearchOtobus.getBusFromBusRoute(BusRoute busRoute) {
    return SearchOtobus(
      type: SearchType.OTOBUS,
      kod: busRoute.hatAdi,
      aciklama: busRoute.hatAdi,
      hatId: busRoute.hatId,
    );
  }

}
