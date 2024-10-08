import 'dart:math';

class BusStopData {
  final int routeId;
  final String routeCode;
  final String routeTitle;
  final String passTime;
  final String realTime;

  BusStopData({
    required this.routeId,
    required this.routeCode,
    required this.routeTitle,
    required this.passTime,
    required this.realTime
  });

  factory BusStopData.fromJSON(Map<String, dynamic> json) {
    return BusStopData(
      routeId: json['routeId'] as int,
      routeCode: json['routeCode'] as String,
      routeTitle: json['routeTitle'] as String,
      passTime: json['passTime'] as String,
      realTime: json['realTime'] as String
    );
  }
  
  factory BusStopData.random() {
    return BusStopData(routeId: Random().nextInt(1000) + 1000, routeCode: "25", routeTitle: "25", passTime: Duration(minutes: Random().nextInt(10)).toString(), realTime: Duration(minutes: Random().nextInt(10)).toString());
  }
}