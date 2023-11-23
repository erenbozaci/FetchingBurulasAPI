import 'package:fetchingburulasapi/fetch/fetch_burulas_data.dart';
import 'package:fetchingburulasapi/models/abstracts/route_data.dart';
import 'package:fetchingburulasapi/models/buslocation_model.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/durak_data.dart';
import 'package:fetchingburulasapi/models/route_coordinates.dart';
import 'package:fetchingburulasapi/models/schedule_by_stop.dart';
import 'package:latlong2/latlong.dart';

typedef SearchApi = Map<String, dynamic>;

class BurulasApi {
  static Future<List<SearchApi>> fetchSearch(String search) async {
    try {
      return fetchBurulasData<SearchApi>("api/static/routeandstation",
          {"keyword": search}, (data) => SearchApi.from(data));
    } catch (e) {
      throw Exception('Failed to load SearchRouteAndStation: $e');
    }
  }

  static Future<List<BusLocation>> fetchGetBusLoc(String routeName) async {
    try {
      return fetchBurulasData<BusLocation>("api/static/realtimedata",
          {"keyword": routeName}, (data) => BusLocation.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load BusLocation: $e');
    }
  }

  static Future<List<RouteCoordinates>> fetchRouteCoordinates(
      String hatId) async {
    try {
      return fetchBurulasData<RouteCoordinates>("api/static/routecoordinate",
          {"keyword": hatId}, (data) => RouteCoordinates.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load RouteCoordinates: $e');
    }
  }

  static Future<List<BusStop>> fetchBusStops(String hatId) async {
    try {
      return fetchBurulasData<BusStop>("api/static/routestat",
          {"routeCode": int.parse(hatId)}, (data) => BusStop.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load BusStop: $e');
    }
  }

  static Future<List<DurakData>> getDurakData(String durakId) async {
    try {
      return fetchBurulasData<DurakData>("api/static/stationremainingtime",
          {"keyword": int.parse(durakId)}, (data) => DurakData.fromJSON(data));
    } catch (e) {
      throw Exception('Failed to load DurakData: $e');
    }
  }

  static Future<List<ScheduleByStop>> fetchBusTimes(
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

  static List<LatLng> toLatLng(List<RouteData> list) {
    return list.map((data) => LatLng(data.latitude, data.longitude)).toList();
  }

  static LatLng toLatLngM(String latitude, String longitude) {
    return LatLng(
        double.tryParse(latitude) ?? 0.0, double.tryParse(longitude) ?? 0.0);
  }
}
