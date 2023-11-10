import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/listeners/bus_search_notifier.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/models/search_route_and_station.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/errors/otobus_error_widget.dart';

class BusSearchComponent extends SearchDelegate {

  BusSearchComponent();

  List<SearchRouteAndStation> searchTerms = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
            searchTerms = [];
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
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

    return FutureBuilder<List<SearchApi>>(
      future: fetchData(query),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
                  onTap: () {
                    Provider.of<BusSearchNotifier>(context, listen: false).setSearch(data);
                    close(context, suggestion);
                  },
                  leading: const Icon(Icons.directions_bus_rounded),
                );
              } else if (suggestion["type"] == "S") {
                SearchDurak data = SearchDurak.fromJSON(suggestion);

                return ListTile(
                  title: Text(data.stationName),
                  onTap: () {
                    Provider.of<BusSearchNotifier>(context, listen: false).setSearch(data);
                    close(context, suggestion);
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

  Widget _buildTile(SearchRouteAndStation suggestion) {
    if(suggestion.type == "R") {
      return const Icon(Icons.directions_bus_rounded);
    } else if (suggestion.type == "S") {
      return const Icon(Icons.signpost_outlined);
    } else {
      return Container();
    }
  }

  Future<List<SearchApi>> fetchData(String query) async {
    return BurulasApi.fetchSearch(query);
  }
}
