import 'dart:async';
import 'dart:developer';

import 'package:fetchingburulasapi/classes/map_components.dart';
import 'package:fetchingburulasapi/fetch/burulas_api.dart';
import 'package:fetchingburulasapi/models/search/search_otobus.dart';
import 'package:fetchingburulasapi/pages/widgets/components/errors/otobus_error_widget.dart';
import 'package:fetchingburulasapi/pages/widgets/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/bus_location_marker.dart';
import 'package:fetchingburulasapi/pages/widgets/components/markers/bus_stop_marker.dart';
import 'package:fetchingburulasapi/storage/ayarlar_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class BusMapPage extends StatefulWidget {
  final SearchOtobus otobus;

  const BusMapPage({super.key, required this.otobus});

  @override
  State<StatefulWidget> createState() => BusMapPageState();
}

class BusMapPageState extends State<BusMapPage> {
  late final MapController _mapController;
  late Timer _timer;

  final StreamController<BusLocationList> _streamController = StreamController.broadcast();

  @override
  void initState() {
    _mapController = MapController();
    _getBusCoordinatesPeriodicly(secs: 5);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    _mapController.dispose();
    super.dispose();
  }

  void _getBusCoordinatesPeriodicly({required int secs}) {
    _timer = periodicTimer(Duration(seconds: secs), (timer) {
      _streamController.addStream(
          Stream.fromFuture(BurulasApi.fetchGetBusLoc(widget.otobus.kod)));
    }, onStart: true);
  }

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.otobus.kod),
        ),
        body: FlutterMap(
            mapController: _mapController,
            options: MapComponents.getMapOptions(),
            children: [
              MapComponents.getTileLayer(),
              ...(_drawMapInfoAboutBus()),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ]));
  }

  List<Widget> _drawMapInfoAboutBus() {
    return [
      // BusRoute
      FutureBuilderExtended<RouteCoordinatesList>(
          future:
              BurulasApi.fetchRouteCoordinates(widget.otobus.hatId.toString()),
          errors: FutureBuilderErrors(
              hasDataError: "Otobüs rotası alınırken hata oluştu."),
          outputFunc: (busRouteData) {
            final List<LatLng> gelisRoute = [];
            final List<LatLng> donusRoute = [];

            for (var point in busRouteData!) {
              // G = gidis | R = ring | D = donus
              if (point.routeDirection == 'G' || point.routeDirection == 'R') {
                gelisRoute.add(LatLng(point.latitude, point.longitude));
              } else if (point.routeDirection == 'D') {
                donusRoute.add(LatLng(point.latitude, point.longitude));
              }
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.fitCamera(CameraFit.coordinates(
                  coordinates: busRouteData
                      .map((busRoutePoint) => busRoutePoint.toLatLng())
                      .toList(),
                  padding: const EdgeInsets.all(
                      10.0))); // Call fitBounds when the frame is ready
            });

            return PolylineLayer(
              polylines: [
                Polyline(
                    points: gelisRoute,
                    strokeWidth: 6,
                    color: Colors.redAccent),
                Polyline(
                    points: donusRoute,
                    strokeWidth: 6,
                    color: Colors.blueAccent)
              ],
            );
          }),
      // BusStops
      FutureBuilderExtended<BusStopList>(
          future: BurulasApi.fetchBusStops(widget.otobus.hatId.toString()),
          errors: FutureBuilderErrors(
              hasDataError: "Otobüs durakları alınırken hata oluştu."),
          outputFunc: (busStops) {
            inspect(_mapController);

            return PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
              markers: busStops!
                  .map((busStop) => BusStopMarker(busStop: busStop))
                  .toList(),
              popupDisplayOptions: PopupDisplayOptions(
                builder: (_, Marker marker) {
                  if (marker is BusStopMarker) {
                    return BusStopMarkerPopup(busStop: marker.busStop);
                  }
                  return const Card(child: Text('Hata'));
                },
              ),
            ));
          }),
      // Buses
      StreamBuilder<BusLocationList>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return OtobusErrorWidget(errorText: "Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
              return OtobusErrorWidget(
                  errorText: "Otobüs lokasyonları alınırken hata oluştu.");
            } else {
              final busLocs = snapshot.data!;
              return MarkerLayer(
                markers: busLocs
                    .map((busLoc) => BusLocationMarker(busLocation: busLoc))
                    .toList(),
              );
            }
          })
    ];
  }


}
