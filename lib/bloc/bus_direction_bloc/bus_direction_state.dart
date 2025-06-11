import 'package:equatable/equatable.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/route_coordinates.dart';

class BusDirectionState extends Equatable {
   final List<BusStop> busStops;
   final List<RouteCoordinates> routeCoordinates;
   final String direction;
   final String kalkisDurak;
   final String status;

  const BusDirectionState({
    this.busStops = const [],
    this.routeCoordinates = const [],
    this.direction = "G",
    this.kalkisDurak = "",
    this.status = "waiting",
  });

  BusDirectionState copyWith({
    List<BusStop>? busStops,
    List<RouteCoordinates>? routeCoordinates,
    String? kalkisDurak,
    String? direction,
    String? status,
  }) {
    return BusDirectionState(
      busStops: busStops ?? this.busStops,
      direction: direction ?? this.direction,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      status: status ?? this.status,
      kalkisDurak: kalkisDurak ?? this.kalkisDurak,
    );
  }

  @override
  List<Object> get props => [busStops, direction, status];
}