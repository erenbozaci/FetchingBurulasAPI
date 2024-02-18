import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/widgets/components/map_component.dart';
import 'package:flutter/material.dart';

class BusMapPage extends StatefulWidget {
  final SearchOtobus otobus;
  const BusMapPage({super.key, required this.otobus});

  @override
  State<StatefulWidget> createState() => BusMapPageState();
}

class BusMapPageState extends State<BusMapPage> {

  @override
  Widget build(BuildContext context) {
    return MapComponent(searchData: widget.otobus);
  }
}
