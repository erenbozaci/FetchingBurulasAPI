import 'dart:async';

import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_bloc.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_event.dart';
import 'package:fetchingburulasapi/bloc/bus_direction_bloc/bus_direction_state.dart';
import 'package:fetchingburulasapi/models/bus_route.dart';
import 'package:fetchingburulasapi/pages/components/errors/otobus_error_component.dart';
import 'package:fetchingburulasapi/pages/components/future_builder_extended.dart';
import 'package:fetchingburulasapi/pages/components/map_components.dart';
import 'package:fetchingburulasapi/pages/components/markers/bus_location_marker.dart';
import 'package:fetchingburulasapi/pages/components/markers/bus_stop_marker.dart';
import 'package:fetchingburulasapi/api/burulas_api.dart';
import 'package:fetchingburulasapi/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class BusMapPage extends StatefulWidget {
  final BusRoute otobus;

  const BusMapPage({super.key, required this.otobus});

  @override
  State<StatefulWidget> createState() => BusMapPageState();
}

class BusMapPageState extends State<BusMapPage> {
  late final MapController _mapController;
  late Timer _timer;

  final StreamController<BusLocationList> _streamController =
      StreamController.broadcast();

  @override
  void initState() {
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getBusCoordinatesPeriodicly(secs: 5);
    });
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
          Stream.fromFuture(BurulasApi.getBusMapData(widget.otobus.hatAdi)));
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
          title: Text(widget.otobus.hatAdi),
        ),
        body: FlutterMap(
            mapController: _mapController,
            options: MapComponents.getMapOptions(),
            children: [
              MapComponents.getTileLayer(),
              BlocBuilder<BusDirectionBloc, BusDirectionState>(
                  builder: (context, state) {
                if (state.status == "error") {
                  return OtobusErrorComponent(
                      errorText: "Otobüs durakları alınırken hata oluştu.");
                } else {
                  return Stack(
                    children: [
                      ...(_drawMapInfoAboutBus(state.direction)),
                      Positioned(
                        left: 5.0,
                        top: 5.0,
                        child: Container(
                            margin: const EdgeInsets.all(5.0),
                            alignment: Alignment.topCenter,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                              onTap: () {
                                context.read<BusDirectionBloc>().add(
                                    BusDirectionFetch(
                                        busId: widget.otobus.hatId.toString(),
                                        direction: state.direction == "G"
                                            ? "D"
                                            : "G"));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Row(
                                  children: [
                                    const Icon(Icons.repeat_rounded),
                                    const SizedBox(width: 15.0),
                                    Text("KALKIŞ: ${state.kalkisDurak}",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  );
                }
              }),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ]));
  }

  List<Widget> _drawMapInfoAboutBus(String direction) {
    List<BusStopMarker> directionBusStops = CacheManager.directions.firstWhere((e) => e.direction == direction).busStops.map((e) => BusStopMarker(busStop: e)).toList();
    return [
      // BusRoute
      FutureBuilderExtended<RouteCoordinatesList>(
          future:
              BurulasApi.getBusRouteCoordinates(widget.otobus.hatId.toString()),
          errors: FutureBuilderErrors(
              hasDataError: "Otobüs rotası alınırken hata oluştu."),
          outputFunc: (busRouteData) {
            final List<LatLng> routePoints = busRouteData!
                .where((a) => a.routeDirection == direction)
                .map((a) => a.toLatLng())
                .toList();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.fitCamera(CameraFit.coordinates(
                  coordinates: routePoints,
                  padding: const EdgeInsets.all(10.0)));
            });

            return PolylineLayer(
              polylines: [
                Polyline(
                    points: routePoints,
                    strokeWidth: 6,
                    colorsStop: const [0.0, 1.0],

                    pattern: StrokePattern.dashed(segments: [5, 5]),
                    color: direction == "D"
                        ? Colors.blueAccent
                        : Colors.redAccent),
              ],
            );
          }),
      // Buses
      StreamBuilder<BusLocationList>(
          stream: _streamController.stream.distinct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return OtobusErrorComponent(
                  errorText: "Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.toString().isEmpty) {
              return OtobusErrorComponent(
                  errorText: "Otobüs lokasyonları alınırken hata oluştu.");
            } else {
              final busLocs = snapshot.data!;
              return MarkerLayer(
                markers: busLocs
                    .map((busLoc) => BusLocationMarker(busLocation: busLoc))
                    .toList(),
              );
            }
          }),
      PopupMarkerLayer(
        options: PopupMarkerLayerOptions(
            markers: directionBusStops,
            popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) {
              if (marker is BusStopMarker) {
                return BusStopMarkerPopup(busStop: marker.busStop);
              }
              return const SizedBox.shrink();
            })),
      )
    ];
  }
}
