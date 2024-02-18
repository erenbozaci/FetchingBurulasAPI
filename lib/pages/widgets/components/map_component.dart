import 'dart:async';

import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/buslocation_model.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/bus_location_marker.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/bus_stop_marker.dart';
import 'package:fetchingburulasapi/storage/ayarlar_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class MapComponent extends StatefulWidget {
  final ISearchData searchData;
  const MapComponent({super.key, required this.searchData});

  @override
  State<StatefulWidget> createState() => MapComponentState();
}

class MapComponentState extends State<MapComponent> {
  MapController mapController = MapController();

  final List<LatLng> gelisRoute = [];
  final List<LatLng> donusRoute = [];

  final List<Marker> busStops = [];
  final List<Marker> buses = [];

  Timer? _busTimer;

  @override
  void dispose() {
    clearEverything();
    super.dispose();
  }

  void clearEverything() {
    gelisRoute.clear();
    donusRoute.clear();
    busStops.clear();
    buses.clear();
    _busTimer?.cancel();
  }

  void populateRoutes(SearchOtobus search) async {
    clearEverything();

    await addBuses(search.kod);
    startFetchingData(search.kod);

    final busRouteData = await BurulasApi.fetchRouteCoordinates(search.hatId.toString());

    for (var point in busRouteData) {
      // G = gidis | R = ring | D = donus
      if (point.routeDirection == 'G' || point.routeDirection == 'R') {
        gelisRoute.add(LatLng(point.latitude, point.longitude));
      } else if (point.routeDirection == 'D') {
        donusRoute.add(LatLng(point.latitude, point.longitude));
      }
    }

    final busStopData = await BurulasApi.fetchBusStops(search.hatId.toString());
    for (var busStop in busStopData) {
      busStops.add(BusStopMarker(busStop: busStop));
    }

    mapController.fitCamera(CameraFit.coordinates(
        coordinates: gelisRoute, padding: const EdgeInsets.all(10.0)));
  }

  void populateDurak(SearchDurak durak) async {
    clearEverything();

    BusStop bs = BusStop.fromSearchDurak(durak);
    busStops.add(BusStopMarker(busStop: bs));

    mapController.fitCamera(CameraFit.coordinates(coordinates: [bs.toLatLng()]));
  }

  void startFetchingData(String kod) {
    _busTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      addBuses(kod).then((data) {
        if(data.isEmpty) timer.cancel();
      });
    });
  }

  Future<List<BusLocation>> addBuses(String kod) async {
    final busLocationData = await BurulasApi.fetchGetBusLoc(kod);
    buses.clear();
    for (var bus in busLocationData) {
      buses.add(BusLocationMarker(busLocation: bus));
    }
    return busLocationData;
  }

  @override
  Widget build(BuildContext context) {
    final search = widget.searchData;

    if (search is SearchOtobus) populateRoutes(search);
    if (search is SearchDurak) populateDurak(search);

    return drawMap();
  }

  Widget drawMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          initialCenter: LatLng(AyarlarStorage.ayarlar.mainLat, AyarlarStorage.ayarlar.mainLong),
          initialZoom: 12.0,
          maxZoom: 18.0),
      children: [
        TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c']),
        PolylineLayer(
          polylines: [
            Polyline(
                points: donusRoute, strokeWidth: 6, color: Colors.blueAccent),
            Polyline(
                points: gelisRoute, strokeWidth: 6, color: Colors.redAccent)
          ],
        ),
        PopupMarkerLayer(options: PopupMarkerLayerOptions(
          markers: busStops,
          popupDisplayOptions: PopupDisplayOptions(
            builder: (_, Marker marker) {
              if (marker is BusStopMarker) {
                return BusStopMarkerPopup(busStop: marker.busStop);
              }
              return const Card(child: Text('Hata'));
            },
          ),
        )),
        MarkerLayer(
          markers: buses,
        )
      ],
    );
  }
}
