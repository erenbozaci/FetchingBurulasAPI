import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/pages/widgets/components/map_component.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  final String title;
  final ISearchData searchData;
  const MapPage({super.key,required this.title, required this.searchData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MapComponent(searchData: searchData),
    );
  }
}
