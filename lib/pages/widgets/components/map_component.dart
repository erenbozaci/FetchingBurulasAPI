import 'dart:async';

import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/listeners/bus_search_notifier.dart';
import 'package:fetchingburulasapi/listeners/durak_click_notifier.dart';
import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/bus_location_marker.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/busstop_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({super.key});

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
  void initState() {
    super.initState();
  }

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

    mapController.fitCamera(CameraFit.coordinates(coordinates: gelisRoute, padding: const EdgeInsets.all(10.0)));
  }

  void populateDurak(SearchDurak durak) async {
    clearEverything();

    BusStop bs = BusStop.fromSearchDurak(durak);
    busStops.add(BusStopMarker(busStop: BusStop.fromSearchDurak(durak)));

    Provider.of<DurakClickNotifier>(context, listen: false).setIsOpened(true);
    Provider.of<DurakClickNotifier>(context, listen: false).setDurak(bs);

    mapController.fitCamera(CameraFit.coordinates(coordinates: BurulasApi.toLatLng([bs])));

  }

  void startFetchingData(String kod) {
    _busTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      BurulasApi.fetchGetBusLoc(kod).then((busLocationData) {
        if (busLocationData.isEmpty) return timer.cancel();
        buses.clear();
        for (var bus in busLocationData) {
          buses.add(BusLocationMarker(busLocation: bus));
        }
      }).catchError((error) {
        timer.cancel();
        throw Exception('Error fetching data: $error');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<BusSearchNotifier>(context).searchData;
    if (search != null && search is SearchOtobus) populateRoutes(search);
    if (search != null && search is SearchDurak) populateDurak(search);


    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
          initialCenter: LatLng(40.20, 29.00), initialZoom: 12.0, maxZoom: 18.0),
      children: [
        TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c']),
        PolylineLayer(
          polylines: [
            Polyline(
                points: donusRoute, strokeWidth: 5, color: Colors.blueAccent),
            Polyline(
                points: gelisRoute, strokeWidth: 5, color: Colors.redAccent)
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
