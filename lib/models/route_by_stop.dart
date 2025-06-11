
class RouteByStop {
  final int routeNo;
  final String routeCode;
  final String routeName;

  RouteByStop({
    required this.routeNo,
    required this.routeCode,
    required this.routeName,
  });

  factory RouteByStop.fromJSON(Map<String, dynamic> json) =>
      RouteByStop(
        routeNo: json["routeNo"],
        routeCode: json["routeCode"],
        routeName: json["routeName"],
      );
}