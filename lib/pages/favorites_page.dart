import 'package:fetchingburulasapi/bloc/fav_bloc/fav_bloc.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_event.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_state.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/pages/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ChangedList = Map<String, dynamic>;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<StatefulWidget> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  final FavoritesDB favoritesDB = FavoritesDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favori Otobüsler"),
        ),
        body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(flex: 1, child: drawFavoritesList()),
              const Center(
                  child: Text(
                "Favorilerinizin sırasını basılı tutup sürükleyerek değiştirebilirsiniz.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ))
            ],
          ),
        ));
  }

  Widget drawFavoritesList() {
    return BlocBuilder<FavBloc, FavState>(builder: (context, state) {
      final favBuses = state.favList ?? [];
      if (favBuses.isNotEmpty) {
        return drawReordableList(favBuses);
      } else {
        return Column(
          children: [
            FutureBuilderExtended(
              future: favoritesDB.getFavoritesAllList(),
              outputFunc: (data) {
                return drawReordableList(data!);
              },
              errors: FutureBuilderErrors(
                  hasDataError: "Favori otobüs bilgisi bulunamadı.",
                  isEmptyError: "Favorilerinizde Hiç Otobüs Yok. :/"),
            ),
          ],
        );
      }
    });
  }

  Widget drawReordableList(List? favBuses) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.secondary.withValues(alpha: 0.05);
    final Color evenItemColor = colorScheme.secondary.withValues(alpha: 0.15);

    List orderList = favBuses?.toList() ?? [];
    return ReorderableListView.builder(
        shrinkWrap: true,
        itemCount: orderList.length,
        itemBuilder: (context, i) {
          final favBus = orderList[i];
          return ListTile(
            key: Key(favBus["custom_order"].toString()),
            title: Text("${i + 1}. ${favBus["hatAdi"]}"),
            tileColor: (i % 2 == 0) ? evenItemColor : oddItemColor,
            subtitle: Text(
                "${favBus["guzergahBaslangic"]} -  ${favBus["guzergahBitis"]}"),
            leading: const Icon(Icons.directions_bus_rounded),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded),
              tooltip: "Menü",
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      context.read<FavBloc>().add(FavRemove(favBus: favBus));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Kaldır"),
                        Icon(Icons.delete_forever_rounded)
                      ],
                    ),
                  ),
                ];
              },
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      BusInfoPage(otobus: BusRoute.fromFavBus(favBus))));
            },
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = orderList.removeAt(oldIndex);
          orderList.insert(newIndex, item);

          context.read<FavBloc>().add(FavChangeOrder(
              orderList: orderList.map((e) => e["hatId"]).toList()));
        });
  }
}
