
enum SearchType {
  OTOBUS, DURAK
}

abstract class ISearchData {
  SearchType searchType;

  ISearchData({required this.searchType});
}