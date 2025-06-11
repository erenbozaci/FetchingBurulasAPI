import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/models/search/bus_search.dart';
import 'package:fetchingburulasapi/models/search/bus_stop_search.dart';
import 'package:fetchingburulasapi/pages/components/errors/otobus_error_component.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_stop_info_page.dart';
import 'package:fetchingburulasapi/utils/cache_manager.dart';
import 'package:fetchingburulasapi/utils/search_manager.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = "";

  void _onSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchManager searchManager = SearchManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Otobüs ve Durak Ara"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Otobüs veya Durak Ara",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchQuery.isEmpty
                  ? const Center(child: Text("Arama yapmak için bir şeyler yazın ve Gönder tuşuna basın"))
                  : FutureBuilder(
                future: searchManager.search(_searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Hata: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(children: [
                      OtobusErrorComponent(errorText: "Otobüs veya Durak bulunamadı.")
                    ]);
                  } else {
                    final results = snapshot.data!;

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result = results[index];
                        final isBus = result is BusSearch;

                        final busStopNameList = isBus ? result.busStopList.where((e) => (e.routeDirection == "G" || e.routeDirection == "R")).map((e) => e.stopName).toList() : [];
                        return ListTile(
                          leading: Icon(isBus ? Icons.directions_bus : Icons.location_on),
                          title: Text(isBus ? (result).kod : (result as BusStopSearch).stationName),
                          subtitle: isBus && result.busStopList.isNotEmpty
                              ? Text("${busStopNameList.first} - ${busStopNameList.last}") : null,
                          onTap: () {
                            if (isBus) {
                              CacheManager.setHatId(result.hatId.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusInfoPage(
                                    otobus: BusRoute(
                                        hatId: result.hatId,
                                        hatAdi: result.kod,
                                        guzergahBaslangic: busStopNameList.first,
                                        guzergahBitis: busStopNameList.last,
                                        guzergahBilgisi: busStopNameList.join(" - "),
                                        busStopList: result.busStopList
                                    )
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusStopInfoPage(
                                    durak: result as BusStopSearch,
                                  ),
                                ),
                              );
                            }
                          }
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}