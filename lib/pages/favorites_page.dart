import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<StatefulWidget> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  final FavoritesDB favoritesDB = FavoritesDB();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favori Otobüsler"),
      ),
      body: FutureBuilder(
          future: favoritesDB.getFavoritesAllList(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const OtobusErrorWidget(
                  errorText: "Favorilere eklediğiniz otobüs yok. :(",
                  color: Colors.indigoAccent);
            } else {
              final favBuses = snapshot.data!;
              return ListView.separated(
                  shrinkWrap: true,
                  itemCount: favBuses.length,
                  itemBuilder: (context, i) {
                    final favBus = favBuses[i];
                    return ListTile(
                      title: Text(favBus["hatAdi"]),
                      subtitle: Text(favBus["guzergahBaslangic"] +
                          " - " +
                          favBus["guzergahBitis"]),
                      leading: const Icon(Icons.directions_bus_rounded),
                      trailing:
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            tooltip: "Menü",
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    favoritesDB.deleteFavorite(OtobusGuzergah.fromFavBus(favBus));
                                    setState(() {});
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text("Kaldır"), Icon(Icons.delete_forever_rounded)],
                                  ),
                                ),
                              ];
                            },
                          ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BusInfoPage(
                                  otobus: OtobusGuzergah.fromFavBus(favBus),
                                  isFavorite: true,
                                )));
                      },
                    );
                  }, separatorBuilder: (BuildContext context, int index) => const Divider(),);
            }
          }),
    );
  }
}
