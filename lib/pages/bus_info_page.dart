import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/otobus_guzergah.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:flutter/material.dart';

typedef BusTimesOfWeek = Map<String, List<ScheduleByStop>>;

class BusInfoPage extends StatefulWidget {
  final OtobusGuzergah otobus;

  const BusInfoPage({super.key, required this.otobus});

  @override
  State<BusInfoPage> createState() => BusInfoPageState();
}

class BusInfoPageState extends State<BusInfoPage> {
  List<String> days = ["Pzt", "Sal", "Çrş", "Prş", "Cum", "Cmt", "Pzr"];
  BusTimesOfWeek times = {};
  List<String> directions = ["G", "D"];
  String direction = "G";

  @override
  void initState() {
    setDirection();
    super.initState();
  }

  void setDirection() async {
    final bus = await BurulasApi.fetchBusStops(widget.otobus.hatId.toString());
    bool isRing = bus.map((b) => b.routeDirection).contains("R");
    setState(() {
      direction = isRing ? "R" : direction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otobus.hatAdi),
      ),
      body: drawTable(),
    );
  }

  Widget drawTable() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder<BusTimesOfWeek>(
          future: seperateArrayToWeekdays(
              direction, widget.otobus.hatId.toString()),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const OtobusErrorWidget(
                  errorText: "Otobüs bilgisi bulunamadı.");
            } else {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                          "Kalkış: ${(direction == "R" || direction == "G") ? widget.otobus.guzergahBitis : widget.otobus.guzergahBaslangic}"),
                      IconButton(
                          onPressed: () {
                            const snackBar = SnackBar(
                              content: Text(
                                  "Bu hat bir ring hattıdır. Bu nedenle değiştirme yapılamaz!"),
                            );

                            if (direction != "R" && direction == "G") {
                              setState(() {
                                direction = "D";
                              });
                            } else if (direction != "R" && direction == "D") {
                              setState(() {
                                direction = "G";
                              });
                            } else if (direction == "R") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                          },
                          icon: const Icon(Icons.change_circle_outlined))
                    ],
                  ),
                  drawArray(snapshot.data!)
                ],
              ));
            }
          },
        ));
  }

  List<String?> findNearTimeKey(BusTimesOfWeek times) {
    DateTime dt = DateTime.timestamp();
    String day = days[dt.weekday - 1];
    final a = times[day]?.firstWhere((e) {
      final dur = parseDuration(e.stopTime);
      return dur.inHours >= dt.hour && (dur.inMinutes % 60) >= dt.minute;
    });
    return [day, a?.stopTime ?? "00:00:00"];
  }

  Widget drawArray(BusTimesOfWeek times) {
    List<Column> tableColumn = [];

    final nearestTime = findNearTimeKey(times);

    for (var weekDay in days) {
      final temp = [...?times[weekDay]];
      tableColumn.add(Column(children: [
        paddingText(
            text: weekDay,
            padding: const EdgeInsets.all(5.0),
            textStyle: const TextStyle(color: Colors.orange)),
        ...temp.map((e) {
          bool isNearestTime =
              (nearestTime[0] == weekDay && nearestTime[1] == e.stopTime);
          return Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              decoration: BoxDecoration(
                  color: isNearestTime ? Colors.redAccent : Colors.transparent,
                  border: Border.all(color: Colors.blueGrey)),
              child: paddingText(
                  text: stringifyDuration(parseDuration(e.stopTime)),
                  padding: const EdgeInsets.all(1.0),
                  textStyle: const TextStyle(fontSize: 10)));
        })
      ]));
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start, children: tableColumn);
  }

  Future<BusTimesOfWeek> seperateArrayToWeekdays(
      String direction, String hatId) async {
    try {
      BusTimesOfWeek tempTimes = {};
      final data = await fetchBusTimes(hatId);
      for (var timeData in data) {
        tempTimes[days[timeData.routeDay - 1]] =
            tempTimes[days[timeData.routeDay - 1]] ?? [];
        tempTimes[days[timeData.routeDay - 1]]?.add(timeData);
      }
      return tempTimes;
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget paddingText(
      {required String text,
      required EdgeInsetsGeometry padding,
      TextStyle? textStyle}) {
    return Padding(
      padding: padding,
      child: Text(text, style: textStyle),
    );
  }

  Future<List<ScheduleByStop>> fetchBusTimes(String hatId) async {
    return BurulasApi.fetchBusTimes(direction, hatId);
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  String stringifyDuration(Duration duration) {
    final hour = duration.inMinutes ~/ 60;
    final minutes = duration.inMinutes % 60;
    String hr = hour >= 10 ? hour.toString() : "0$hour";
    String mins = minutes >= 10 ? minutes.toString() : "0$minutes";
    return "$hr:$mins";
  }
}
