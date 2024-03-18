import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/otobus_guzergah.dart';

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
  factory SearchOtobus.getBusFromOtobusGuzergah(OtobusGuzergah otobusGuzergah) {
    return SearchOtobus(
      type: SearchType.OTOBUS,
      kod: otobusGuzergah.hatAdi,
      aciklama: otobusGuzergah.hatAdi,
      hatId: otobusGuzergah.hatId,
    );
  }

}
