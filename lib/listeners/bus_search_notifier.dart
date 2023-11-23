import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:flutter/foundation.dart';

class BusSearchNotifier extends ChangeNotifier {
  ISearchData? _searchData;
  ISearchData? get searchData => _searchData;

  void setSearch(ISearchData data) {
    _searchData = data;
    notifyListeners();
  }
}