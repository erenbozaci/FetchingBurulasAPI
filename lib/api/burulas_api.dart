import 'dart:async';

import 'package:fetchingburulasapi/api/fetch_burulas_data.dart';
import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/bus_location.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/bus_stop_data.dart';
import 'package:fetchingburulasapi/models/route_by_stop.dart';
import 'package:fetchingburulasapi/models/route_coordinates.dart';
import 'package:fetchingburulasapi/models/route_price.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:latlong2/latlong.dart';

typedef SearchApiMap = Map<String, dynamic>;
typedef SearchApiList = List<SearchApiMap>;
typedef BusLocationList = List<BusLocation>;
typedef RouteCoordinatesList = List<RouteCoordinates>;
typedef BusStopList = List<BusStop>;
typedef BusStopDataList = List<BusStopData>;
typedef ScheduleByStopList = List<ScheduleByStop>;
typedef RoutePriceList = List<RoutePrice>;
typedef RouteByStopList = List<RouteByStop>;

class BurulasApi {
  static Future<SearchApiList> getSearch(String search) async {
      return fetchBurulasData<SearchApiMap>("api/static/routeandstation", {"keyword": search}, (data) => SearchApiMap.from(data));
  }

  static Future<BusLocationList> getBusMapData(String routeName) async {
      return fetchBurulasData<BusLocation>("api/static/realtimedata", {"keyword": routeName}, (data) => BusLocation.fromJSON(data));
  }

  static Future<RouteCoordinatesList> getBusRouteCoordinates(String routeID) async {
      return fetchBurulasData<RouteCoordinates>("api/static/routecoordinate", {"keyword": routeID}, (data) => RouteCoordinates.fromJSON(data));
  }

  static Future<BusStopList> getBusStopsFromBus(String routeID) async {
    return fetchBurulasData<BusStop>("api/static/routestat", {"routeCode": int.parse(routeID)}, (data) => BusStop.fromJSON(data));
  }

  static Future<BusStopDataList> getBusStopData(String stopId) async {
      return fetchBurulasData<BusStopData>("api/static/stationremainingtime", {"keyword": int.parse(stopId)}, (data) => BusStopData.fromJSON(data));
  }

  static Future<ScheduleByStopList> getBusTimes(String direction, String hatId) {
      return fetchBurulasData<ScheduleByStop>("api/static/schedulebystop",
          {
            "direction": direction,
            "routeId": int.parse(hatId),
            "stopSequenceNo": 0,
            "weekday": 0
          }, (data) => ScheduleByStop.fromJSON(data));
  }

  static Future<RoutePriceList> getRoutePrices(String routeName) async {
      return fetchBurulasData<RoutePrice>("api/static/routeprice", {"keyword": routeName}, (data) => RoutePrice.fromJSON(data));
  }

  static Future<RouteByStopList> getBusesPassingByTheStop(String stopID) {
    return fetchBurulasData<RouteByStop>("api/static/RouteByStop",
          {"keyword": int.parse(stopID)}, (data) => RouteByStop.fromJSON(data));
  }

  static List<LatLng> toLatLng(List<RouteData> list) {
    return list.map((data) => data.toLatLng()).toList();
  }

  static LatLng toLatLngM(String latitude, String longitude) {
    return LatLng(
        double.tryParse(latitude) ?? 0.0, double.tryParse(longitude) ?? 0.0);
  }
}

extension PeriodicTimer on Timer {
  Timer periodicTimer(Duration duration, void Function(Timer timer) callback,
      {bool onStart = false}) {
    var result = Timer.periodic(duration, callback);
    if (onStart) {
      Timer(Duration.zero, () {
        if (result.isActive) callback(result);
      });
    }
    return result;
  }
}