import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/favorites_page.dart';
import 'package:fetchingburulasapi/pages/widgets/bus_search_widget.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';

class BurulasAPIPage extends StatefulWidget {
  const BurulasAPIPage({super.key});

  @override
  State<StatefulWidget> createState() => BurulasAPIPageState();

}

class BurulasAPIPageState extends State<BurulasAPIPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 0,
          child: Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                onTap: () {
                  showSearch(context: context, delegate: BusSearchComponent());
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded),
                      SizedBox(width: 15.0),
                      Text("Arama yapmak için tıklayın...",
                          style: TextStyle(
                            fontSize: 18.0,
                          ))
                    ],
                  ),
                ),
              )),
        ),
        Row(
          children: [
            Flexible(child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // if you need this
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Favoriler",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(onPressed: () {
                          setState(() {});
                        }, icon: const Icon(Icons.refresh_rounded))
                      ],
                    ),
                  ),
                  Container(
                    child: drawFavBusses(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesPage()));
                    },
                    child: const ListTile(
                      title: Center(child: Text("Hepsini Gör...", style: TextStyle(fontSize: 12),)),
                    ),
                  )
                ],
              ),
            )
            ),
          ],
        )
      ],
    );
  }

  Widget drawFavBusses() {
    return FutureBuilder(
        future: FavoritesDB().getFavoritesLimited(3),
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
            return ListView.builder(
                shrinkWrap: true,
                itemCount: favBuses.length,
                itemBuilder: (context, i) {
                  final favBus = favBuses[i];
                  return ListTile(
                    title: Text(favBus["hatAdi"], style: const TextStyle(fontSize: 14)),
                    subtitle: Text(favBus["guzergahBaslangic"] + " - " + favBus["guzergahBitis"], style: const TextStyle(fontSize: 10),),
                    leading: const Icon(Icons.directions_bus_rounded),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BusInfoPage(
                            otobus: OtobusGuzergah(
                                hatId: favBus["hatId"],
                                hatAdi: favBus["hatAdi"],
                                guzergahBaslangic: favBus["guzergahBaslangic"],
                                guzergahBitis: favBus["guzergahBitis"],
                                guzergahBilgisi: favBus["guzergahBilgisi"]),
                            isFavorite: true,
                          )));
                    },
                  );
                });
          }
        });
  }
}
