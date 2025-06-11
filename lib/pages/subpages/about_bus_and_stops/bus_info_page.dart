import 'dart:async';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_bloc.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_event.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_state.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_bloc.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_event.dart';
import 'package:fetchingburulasapi/bloc/fav_bloc/fav_state.dart';
import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:fetchingburulasapi/models/search/bus_search.dart';
import 'package:fetchingburulasapi/pages/components/errors/otobus_error_component.dart';
import 'package:fetchingburulasapi/pages/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_map_page.dart';
import 'package:fetchingburulasapi/storage/favorites_db.dart';
import 'package:fetchingburulasapi/utils/cache_manager.dart';
import 'package:fetchingburulasapi/utils/time_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BusTimesOfWeek = Map<String, List<ScheduleByStop>>;

class NearestTime {
  String gun;
  String saat;

  NearestTime({required this.gun, required this.saat});
}

class BusInfoPage extends StatefulWidget {
  final BusRoute otobus;

  const BusInfoPage({super.key, required this.otobus});

  @override
  State<BusInfoPage> createState() => BusInfoPageState();
}

class BusInfoPageState extends State<BusInfoPage> with SingleTickerProviderStateMixin {
  late TimeGroup timeGroup;

  List<String> days = TimeGroup.days;
  BusTimesOfWeek times = {};
  List<String> directions = ["G", "D"];

  Future<BusTimesOfWeek> seperateArrayToWeekdays(
      String direction, String hatId) async {
    try {
      BusTimesOfWeek tempTimes = {};
      final data = await fetchBusTimes(direction, hatId);
      for (final timeData in data) {
        tempTimes[days[timeData.routeDay - 1]] =
            tempTimes[days[timeData.routeDay - 1]] ?? [];
        tempTimes[days[timeData.routeDay - 1]]?.add(timeData);
      }
      return tempTimes;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final otobusS = widget.otobus;
    var busStops = otobusS.busStopList;
    bool isRing = busStops.map((b) => b.routeDirection).contains("R");
    context.read<BusDirectionBloc>().add(BusDirectionFetch(busId: widget.otobus.hatId.toString(), direction: isRing ? "R" : "G"));

    return Scaffold(
      appBar: AppBar(
        title: Text(otobusS.hatAdi),
        actions: [
          StreamBuilder(
              stream: Stream.fromFuture(FavoritesDB.instance.isFavorite(otobusS.hatId)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else if (snapshot.hasData) {
                  return BlocBuilder<FavBloc, FavState>(builder: (context, state) {
                    bool isFav = state.favList.isNotEmpty ? state.favList.any((e) => e["hatId"] == otobusS.hatId) : snapshot.data!;
                    return IconButton(
                        onPressed: () {
                          context.read<FavBloc>().add(isFav
                              ? FavRemove(favBus: otobusS.toJSON())
                              : FavAdd(favBus: otobusS.toJSON()));
                        },
                        icon: isFav
                            ? const Icon(Icons.star_rounded)
                            : const Icon(Icons.star_outline_rounded));

                  });
                } else {
                  return const SizedBox();
                }
              }
          )
        ],
      ),
      body: Column(children: [
        drawPrices(otobusS.hatAdi),
        BlocBuilder<BusDirectionBloc, BusDirectionState>(
            builder: (context, state) {
          if (state.status == "error") {
            return OtobusErrorComponent(errorText: "Error: ${state.status}");
          } else if (state.status == "success" || state.status == "loading") {
            final direction = state.direction;
            return Expanded(
                child: Column(children: [
                  drawRouteChange(direction, state),
                  drawTimes(direction, otobusS.hatId.toString()),
                ])
            );
          } else {
            return const OtobusErrorComponent(
                errorText: "Otobüs bilgisi bulunamadı.");
          }
        })
      ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.map),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusMapPage(
                    otobus: otobusS,
                  ),
                ));
          }),
    );
  }

  Widget drawRouteChange(String direction, BusDirectionState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawHatDegistir(direction, state),
          Text(
            "*Resmi tatil günleri, Pazar sefer saatleri ile aynıdır.",
            style: TextStyle(color: Theme.of(context).dividerColor),
          )
        ],
      ),
    );
  }

  Widget drawPrices(String hatAdi) {
    return FutureBuilderExtended(
        future: BurulasApi.getRoutePrices(hatAdi),
        errors: FutureBuilderErrors(
            hasDataError: "Ücret Bilgisi Bulunamadı.",
            isEmptyError: "Ücret Bilgisi Bulunamadı."),
        outputFunc: (data) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data!
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.black),
                        child: Column(children: [
                          Text(e.cardType),
                          Text("${e.price.toStringAsFixed(2)}₺")
                        ]),
                      ))
                  .toList(),
            ),
          );
        });
  }

  Widget drawTimes(String direction, String hatId) {
    return FutureBuilderExtended(
        future: seperateArrayToWeekdays(direction, hatId),
        errors: FutureBuilderErrors(
            hasDataError: "Otobüs Zaman Bilgisi Bulunamadı."),
        outputFunc: (data) {
          return Expanded(
              child: Container(
            padding: const EdgeInsets.all(5.0),
            child: drawArray(data!),
          ));
        });
  }

  Widget drawArray(BusTimesOfWeek times) {
    final dt = DateTime.timestamp().add(const Duration(hours: 3));
    return ContainedTabBarView(
      initialIndex: (dt.weekday - 1),
      tabs: days.map((e) => Tab(text: e)).toList(),
      views: drawTabBarView(times),
    );
  }

  List<Widget> drawTabBarView(BusTimesOfWeek times) {
    final borderColor = const Color.fromARGB(255, 90, 92, 106); // Medium Gray
    final hourBgColor = const Color.fromARGB(255, 52, 54, 65); // Darker Gray
    final minutesBgColor =
        const Color.fromARGB(255, 35, 36, 42); // Very Dark Gray

    final tg = TimeGroup(times: times).groupTimesbyHour();

    return days.map((weekDay) {
      final hours = tg[weekDay]?.entries.map((entry) {
            final hour = entry.key;
            final timeItemList = entry.value;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: minutesBgColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHourContainer(hour, borderColor, hourBgColor),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: timeItemList
                              .map((e) => _buildTimeItem(e))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [];

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListView(shrinkWrap: true, children: hours),
      );
    }).toList();
  }

  Widget _buildHourContainer(int hour, Color borderColor, Color hourBgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: hourBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.shadow),
        ],
      ),
      child: Text(
        hour >= 10 ? hour.toString() : "0$hour",
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildTimeItem(TimeItem e) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: e.isNearest ? Colors.deepPurple : Colors.transparent,
      ),
      child: Text(
        e.stringifyMins(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget drawHatDegistir(String direction, BusDirectionState state) {
    const snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        "Bu hat bir ring hattıdır. Bu nedenle değiştirme yapılamaz!",
        style: TextStyle(color: Colors.white),
      ),
    );
    return Row(
      children: [
        Flexible(
            child: Text("KALKIŞ: ${state.kalkisDurak}")),
        IconButton(
            onPressed: () {
              if (direction != "R") {
                context.read<BusDirectionBloc>().add(BusDirectionFetch(
                    busId: widget.otobus.hatId.toString(),
                    direction: direction == "G" ? "D" : "G")
                );
              } else if (direction == "R") {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(Icons.change_circle_outlined)),
      ],
    );
  }

  Future<List<ScheduleByStop>> fetchBusTimes(
      String direction, String hatId) async {
    return BurulasApi.getBusTimes(direction, hatId);
  }
}
