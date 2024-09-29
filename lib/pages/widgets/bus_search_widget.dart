import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_stop_info_page.dart';
import 'package:fetchingburulasapi/pages/widgets/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';

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
      return const Center(child: Text("Bir şeyler Araman Lazım"));
    }

    return FutureBuilderExtended<SearchApiList>(
        future: fetchData(query),
        errors:
            FutureBuilderErrors(hasDataError: "Otobüs veya Durak bulunamadı.", isEmptyError: "Otobüs veya Durak bulunamadı."),
        outputFunc: (data) {
          final suggestions = data ?? [];

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              if (suggestion["type"] == "R") {
                SearchOtobus data = SearchOtobus.fromJSON(suggestion);

                return ListTile(
                  title: Text(data.kod),
                  onTap: () async {
                    final busStops =
                        (await BurulasApi.fetchBusStops(data.hatId.toString()))
                            .where((e) => (e.routeDirection == "G" ||
                                e.routeDirection == "R"))
                            .toList();
                    final busRoute = BusRoute(
                        hatId: data.hatId,
                        hatAdi: data.kod,
                        guzergahBaslangic: busStops[0].stopName,
                        guzergahBitis: busStops[busStops.length - 1].stopName,
                        guzergahBilgisi:
                            busStops.map((e) => e.stopName).join(" - "));

                    final isFavorite =
                        await FavoritesDB().isFavorite(busRoute);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BusInfoPage(
                              otobus: busRoute,
                          isFavorite: isFavorite,
                            )));
                  },
                  leading: const Icon(Icons.directions_bus_rounded),
                );
              } else if (suggestion["type"] == "S") {
                SearchDurak data = SearchDurak.fromJSON(suggestion);

                return ListTile(
                  title: Text(data.stationName),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BusStopInfoPage(durak: data)));
                  },
                  leading: const Icon(Icons.signpost_outlined),
                );
              } else {
                return Container();
              }
            },
          );
        });
  }

  Future<List<SearchApiMap>> fetchData(String query) async {
    return BurulasApi.fetchSearch(query);
  }
}
