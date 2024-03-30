import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/subpages/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/subpages/durak_info_page.dart';
import 'package:flutter/material.dart';

import 'components/errors/otobus_error_widget.dart';

class BusSearchComponent extends SearchDelegate {
  BusSearchComponent();

  @override
  String? get searchFieldLabel => "Ara";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Bişeyler Araman Lazım"));
    }

    return FutureBuilder<List<SearchApiMap>>(
      future: fetchData(query),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const OtobusErrorWidget(errorText: "Otobüs veya Durak bulunamadı.");
        } else {
          final suggestions = snapshot.data ?? [];


          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              if(suggestion["type"] == "R") {
                SearchOtobus data = SearchOtobus.fromJSON(suggestion);

                return ListTile(
                  title: Text(data.kod),
                  onTap: () async {
                    final busStops = (await BurulasApi.fetchBusStops(data.hatId.toString())).where((e) =>(e.routeDirection == "G" || e.routeDirection == "R")).toList();

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BusInfoPage(
                            otobus: OtobusGuzergah(
                                hatId: data.hatId,
                                hatAdi: data.kod,
                                guzergahBaslangic: busStops[0].stopName,
                                guzergahBitis: busStops[busStops.length - 1].stopName,
                                guzergahBilgisi: busStops.map((e) => e.stopName).join(" - ")
                            )
                        ))
                    );
                  },
                  leading: const Icon(Icons.directions_bus_rounded),
                );
              } else if (suggestion["type"] == "S") {
                SearchDurak data = SearchDurak.fromJSON(suggestion);

                return ListTile(
                  title: Text(data.stationName),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DurakInfoPage(durak: data)));
                  },
                  leading: const Icon(Icons.signpost_outlined),
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }

  Future<List<SearchApiMap>> fetchData(String query) async {
    return BurulasApi.fetchSearch(query);
  }
}
