import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/search_route_and_station.dart';
import 'package:flutter/foundation.dart';

class BusSearchNotifier extends ChangeNotifier {
  ISearchData? _searchData;
  ISearchData? get searchData => _searchData;


  SearchRouteAndStation? _searchRouteAndStation;
  SearchRouteAndStation? get searchRouteAndStation => _searchRouteAndStation;

  void setSearchRouteAndStation(SearchRouteAndStation searchRouteAndStation) {
    _searchRouteAndStation = searchRouteAndStation;
    notifyListeners();
  }

  void setSearch(ISearchData data) {
    _searchData = data;
    notifyListeners();
  }
}