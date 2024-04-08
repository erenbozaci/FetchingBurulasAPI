import 'dart:core';

import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/bus_info_page.dart';
import 'package:collection/collection.dart';

typedef HourGroupedTimeItems = Map<String, Map<int, List<TimeItem>>>;

class TimeItem {
  int hour;
  int minutes;
  bool isNearest = false;

  TimeItem({required this.hour, required this.minutes, this.isNearest = false});

  void setIsNearest(bool isNearest) {
    this.isNearest = isNearest;
  }

  String stringify() {
    String hr = hour >= 10 ? hour.toString() : "0$hour";
    String mins = minutes >= 10 ? minutes.toString() : "0$minutes";
    return "$hr:$mins";
  }

  String stringifyMins() {
    return minutes >= 10 ? minutes.toString() : "0$minutes";
  }

  String stringifyHour() {
    return hour >= 10 ? hour.toString() : "0$hour";
  }
}

class TimeGroup {

  final BusTimesOfWeek times;
  List<String> days = ["Pzt", "Sal", "Çrş", "Prş", "Cum", "Cmt", "Pzr"];

  TimeGroup({required this.times});

  HourGroupedTimeItems groupTimesbyHour() {
    HourGroupedTimeItems t = {};
    DateTime dt = DateTime.timestamp().add(const Duration(hours: 3));

    bool gived = false;

    for(final day in days){
      final timeItems = times[day]?.map((e) {
        final ti = toTimeItem(e.stopTime);
        if((dt.weekday - 1) == days.indexOf(day) && !gived) {
          if (ti.hour > dt.hour) {
            ti.setIsNearest(true);
            gived = true;
          } else if (ti.hour == dt.hour) {
            if (ti.minutes >= dt.minute) {
              ti.setIsNearest(true);
              gived = true;
            }
          }
        }

        return ti;
      }) ?? [];
      final s = groupBy(timeItems, (timeItem) => timeItem.hour);
      t[day] = s;
    }
    return t;
  }
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

TimeItem toTimeItem(String s) {
  int hours = 0;
  int minutes = 0;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  return TimeItem(hour: hours, minutes: minutes);
}