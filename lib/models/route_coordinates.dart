import 'package:fetchingburulasapi/models/abstracts/route_data.dart';

class RouteCoordinates extends RouteData {
  final String route;
  final String routeDirection;
  final int sequence;

  RouteCoordinates({required super.latitude, required super.longitude, required this.route, required this.routeDirection, required this.sequence});

  factory RouteCoordinates.fromJSON(Map <String, dynamic> json) {
    return RouteCoordinates(
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["logitude"]),
        route: json["route"],
        routeDirection: json["routeDirection"],
        sequence: json["sequence"]
    );
  }

}