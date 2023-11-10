import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';

class BusStop extends RouteData {
  final int stopId;
  final String stopName;
  final String routeDirection;
  final int sequence;

  BusStop(
      {required this.stopId, required this.stopName, required this.sequence, required this.routeDirection, required super.latitude, required super.longitude});

  factory BusStop.fromJSON(Map<String, dynamic> json) {
    return BusStop(
        stopId: json["stopId"],
        stopName: json["stopName"],
        sequence: json["sequence"],
        routeDirection: json["direction"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"])
    );
  }

  factory BusStop.fromSearchDurak(SearchDurak durak) {
    return BusStop(
        stopId: durak.stationId,
        stopName: durak.stationName,
        sequence: 0,
        routeDirection: 'R',
        latitude: durak.latitude,
        longitude: durak.latitude);
  }
}