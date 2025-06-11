import 'package:fetchingburulasapi/bloc/fav_bloc/fav_bloc.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_state.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/pages/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/pages/favorites_page.dart';
import 'package:fetchingburulasapi/pages/subpages/about_search/search_page.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.topCenter,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const SearchPage()));
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
            )
        ),
        Row(
          children: [
            Flexible(
                child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // if you need this
                side: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          "Favoriler",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const FavoritesPage()));
                      }, icon: Icon(Icons.arrow_forward_rounded), tooltip: "Hepsini Gör")
                    ],
                  ),
                  BlocBuilder<FavBloc, FavState>(
                    buildWhen: (previous, current) => current.status.isSuccess,
                    builder: (BuildContext context, FavState state) {
                      return drawFavBusses(state);
                    },
                  ),
                ],
              ),
            )),
          ],
        )
      ],
    );
  }

  Widget drawFavBusses(FavState state) {
    return FutureBuilderExtended(
        future: FavoritesDB().getFavoritesLimited(3),
        errors: FutureBuilderErrors(
          hasDataError: "Favorilerinizde Hiç Otobüs Yok. :(",
          isEmptyError: "Favorilerinizde Hiç Otobüs Yok. :("
        ),
        outputFunc: (data) {
          final favBuses = data!;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: favBuses.length,
              itemBuilder: (context, i) {
                final favBus = favBuses[i];
                return ListTile(
                  title: Text(favBus["hatAdi"],
                      style: const TextStyle(fontSize: 14)),
                  subtitle: Text(
                    '${favBus["guzergahBaslangic"]} - ${favBus["guzergahBitis"]}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  leading: const Icon(Icons.directions_bus_rounded),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BusInfoPage(
                              otobus: BusRoute.fromFavBus(favBus),
                            )
                    ));
                  },
                );
              });
        });
  }
}
