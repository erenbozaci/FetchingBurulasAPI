import 'package:fetchingburulasapi/fetch/fetch_burulas_data.dart';
import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/buslocation_model.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/durak_data.dart';
import 'package:fetchingburulasapi/models/route_coordinates.dart';
import 'package:fetchingburulasapi/models/route_price.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:latlong2/latlong.dart';

typedef SearchApiMap = Map<String, dynamic>;
typedef SearchApiList = List<SearchApiMap>;
typedef BusLocationList = List<BusLocation>;
typedef RouteCoordinatesList = List<RouteCoordinates>;
typedef BusStopList = List<BusStop>;
typedef DurakDataList = List<DurakData>;
typedef ScheduleByStopList = List<ScheduleByStop>;
typedef RoutePriceList = List<RoutePrice>;

class BurulasApi {
  static Future<SearchApiList> fetchSearch(String search) async {
    try {
      return fetchBurulasData<SearchApiMap>("api/static/routeandstation",
          {"keyword": search}, (data) => SearchApiMap.from(data));
    } catch (e) {
      throw Exception('Failed to load SearchRouteAndStation: $e');
    }
  }

  static Future<BusLocationList> fetchGetBusLoc(String routeName) async {
    try {
      return fetchBurulasData<BusLocation>("api/static/realtimedata",
          {"keyword": routeName}, (data) => BusLocation.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load BusLocation: $e');
    }
  }

  static Future<RouteCoordinatesList> fetchRouteCoordinates(
      String hatId) async {
    try {
      return fetchBurulasData<RouteCoordinates>("api/static/routecoordinate",
          {"keyword": hatId}, (data) => RouteCoordinates.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load RouteCoordinates: $e');
    }
  }

  static Future<BusStopList> fetchBusStops(String hatId) async {
    try {
      return fetchBurulasData<BusStop>("api/static/routestat",
          {"routeCode": int.parse(hatId)}, (data) => BusStop.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load BusStop: $e');
    }
  }

  static Future<DurakDataList> getDurakData(String durakId) async {
    try {
      return fetchBurulasData<DurakData>("api/static/stationremainingtime",
          {"keyword": int.parse(durakId)}, (data) => DurakData.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load DurakData: $e');
    }
  }

  static Future<ScheduleByStopList> fetchBusTimes(
      String direction, String hatId) {
    try {
      return fetchBurulasData<ScheduleByStop>(
          "api/static/schedulebystop",
          {
            "direction": direction,
            "routeId": int.parse(hatId),
            "stopSequenceNo": 0,
            "weekday": 0
          },
          (data) => ScheduleByStop.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load ScheduleByStop: $e');
    }
  }

  static Future<RoutePriceList> fetchRoutePrice(String routeName) async {
    try {
      return fetchBurulasData<RoutePrice>("api/static/routeprice", {"keyword": routeName}, (data) => RoutePrice.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load BusLocation: $e');
    }
  }

  static List<LatLng> toLatLng(List<RouteData> list) {
    return list.map((data) => data.toLatLng()).toList();
  }

  static LatLng toLatLngM(String latitude, String longitude) {
    return LatLng(
        double.tryParse(latitude) ?? 0.0, double.tryParse(longitude) ?? 0.0);
  }
}
