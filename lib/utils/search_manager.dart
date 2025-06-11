import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/search/bus_search.dart';
import 'package:fetchingburulasapi/models/search/bus_stop_search.dart';

class SearchManager {
  Future<List<ISearchData>> search(String query) async {
    SearchApiList searchList = await BurulasApi.getSearch(query);
    List<ISearchData> searchResults = [];
    for (var item in searchList) {
      if (item["type"] == "R") {
        BusStopList busStops = await BurulasApi.getBusStopsFromBus(item["hatNo"].toString());
        searchResults.add(BusSearch(
          searchType: SearchType.OTOBUS,
          kod: item["kod"],
          aciklama: item["aciklama"],
          hatId: item["hatNo"],
          busStopList: busStops
        ));
      } else if (item["type"] == "S") {
        searchResults.add(BusStopSearch.fromJSON(item));
      }
    }
    return searchResults;
  }
}