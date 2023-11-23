class ScheduleByStop {
  final int routeId;
  final String routeCode;
  final int routeDay;
  final String stopTime;

  ScheduleByStop({
    required this.routeId,
    required this.routeCode,
    required this.routeDay,
    required this.stopTime,
  });

  factory ScheduleByStop.fromJSON(Map<String, dynamic> json) =>
      ScheduleByStop(
        routeId: json["routeId"],
        routeCode: json["routeCode"],
        routeDay: json["routeDay"],
        stopTime: json["stopTime"],
      );
}