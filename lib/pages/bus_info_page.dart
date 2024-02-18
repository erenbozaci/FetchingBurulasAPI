import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:fetchingburulasapi/classes/time_group.dart';
import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/map_page.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';

typedef BusTimesOfWeek = Map<String, List<ScheduleByStop>>;

class NearestTime {
  String gun;
  String saat;

  NearestTime({required this.gun, required this.saat});
}

class BusInfoPage extends StatefulWidget {
  final OtobusGuzergah otobus;

  const BusInfoPage({super.key, required this.otobus});

  @override
  State<BusInfoPage> createState() => BusInfoPageState();
}

class BusInfoPageState extends State<BusInfoPage> with SingleTickerProviderStateMixin {
  late TimeGroup timeGroup;

  List<String> days = ["Pzt", "Sal", "Çrş", "Prş", "Cum", "Cmt", "Pzr"];
  BusTimesOfWeek times = {};
  List<String> directions = ["G", "D"];
  String direction = "G";

  @override
  void initState() {
    getDirection();
    super.initState();
  }

  void getDirection() async {
    try {
      final bus =
          await BurulasApi.fetchBusStops(widget.otobus.hatId.toString());
      bool isRing = bus.map((b) => b.routeDirection).contains("R");
      setDirection(!isRing ? direction : "R");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BusTimesOfWeek> seperateArrayToWeekdays(
      String direction, String hatId) async {
    try {
      BusTimesOfWeek tempTimes = {};
      final data = await fetchBusTimes(hatId);
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

  void setDirection(String d) {
    setState(() {
      direction = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.otobus.hatAdi),
        ),
        body: Column(children: [
          OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapPage(
                          title: widget.otobus.hatAdi,
                          searchData: SearchOtobus(
                              type: SearchType.OTOBUS,
                              kod: widget.otobus.hatAdi
                                  .replaceAll(RegExp(r"[\-/]+"), ""),
                              aciklama: widget.otobus.hatAdi
                                  .replaceAll(RegExp(r"[\-/]+"), ""),
                              hatId: widget.otobus.hatId))),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text("Harita")),
          drawHatDegistir(),
          Text("*Resmi tatil günleri, Pazar sefer saatleri ile aynıdır.", style: TextStyle(color: Theme.of(context).dividerColor),),
          drawPage()
        ]));
  }

  Widget drawPage() {
    return FutureBuilder<BusTimesOfWeek>(
      future:
          seperateArrayToWeekdays(direction, widget.otobus.hatId.toString()),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const OtobusErrorWidget(
              errorText: "Otobüs bilgisi bulunamadı.");
        } else {
          return Expanded(
              child: Container(
            padding: const EdgeInsets.all(5.0),
            child: drawArray(snapshot.data!),
          ));
        }
      }, //s
    );
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
    final tg = TimeGroup(times: times).groupTimesbyHour();

    List<Widget> hours = [];
    List<Widget> timesWidget = [];
    for (var weekDay in days) {
      hours = [];
      tg[weekDay]?.forEach((hour, timeItemList) {
        final timeItemListWidgets = timeItemList
            .map(
              (e) => Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: e.isNearest ? Colors.deepPurple : Colors.transparent,
                  ),
                  child: Text(e.stringifyMins(),
                      style: const TextStyle(color: Colors.white))),
            )
            .toList();

        final timeListWidget = Row(children: timeItemListWidgets);

        final hourRow = Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Text(hour >= 10 ? hour.toString() : "0$hour",
                    style: const TextStyle(fontSize: 20,)),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.all(2.5),
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          color: Colors.black,
                        ),
                        child: timeListWidget,
                      )
                  )
              )
            ],
        );

        hours.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: hourRow,
        ));
      });
      timesWidget.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
              border: Border.symmetric(vertical: BorderSide(width: 0.5, color: Theme.of(context).focusColor))
          ),
          child: ListView(children: hours))
      );
    }
    return timesWidget;
  }

  Widget drawHatDegistir() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Flexible(child: Text("KALKIŞ: ${(direction == "R" || direction == "G") ? widget.otobus.guzergahBaslangic : widget.otobus.guzergahBitis}")),
          IconButton(
              onPressed: () {
                const snackBar = SnackBar(
                  content: Text(
                      "Bu hat bir ring hattıdır. Bu nedenle değiştirme yapılamaz!"),
                );
                if (direction != "R" && direction == "G") {
                  setDirection("D");
                } else if (direction != "R" && direction == "D") {
                  setDirection("G");
                } else if (direction == "R") {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
              },
              icon: const Icon(Icons.change_circle_outlined)),
        ],
      ),
    );
  }

  Future<List<ScheduleByStop>> fetchBusTimes(String hatId) async {
    return BurulasApi.fetchBusTimes(direction, hatId);
  }
}
