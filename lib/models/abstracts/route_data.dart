import 'package:latlong2/latlong.dart';

abstract class RouteData {
  final double latitude;
  final double longitude;

  RouteData({required this.latitude, required this.longitude});

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}