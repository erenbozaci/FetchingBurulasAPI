import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/durak_data.dart';
import 'package:flutter/material.dart';

class DurakClickNotifier extends ChangeNotifier {
  bool _isOpened = false;
  bool get isOpened => _isOpened;

  BusStop? _durak;
  BusStop? get durak => _durak;

  List<DurakData> _durakDatas = [];
  List<DurakData> get durakDatas => _durakDatas;

  void setIsOpened(bool isOpened) {
    _isOpened = isOpened;
    notifyListeners();
  }

  setDurakData(String durakId) async {
    _durakDatas = (await BurulasApi.getDurakData(durakId));
  }

  setDurak(BusStop durak){
    _durak = durak;
    setDurakData(durak.stopId.toString());
    notifyListeners();
  }

}