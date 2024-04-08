import 'package:fetchingburulasapi/models/bus_stop.dart';
import 'package:fetchingburulasapi/models/interfaces/search_data.dart';
import 'package:fetchingburulasapi/models/search/search_durak.dart';
import 'package:fetchingburulasapi/pages/subpages/about_bus_and_stops/durak_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusStopMarker extends Marker {
  BusStopMarker({required this.busStop})
      : super(
          alignment: Alignment.topCenter,
          point: LatLng(busStop.latitude, busStop.longitude),
          width: 20,
          height: 20,
          child: Container(
              decoration: BoxDecoration(
                  color: (busStop.routeDirection == "G" ||
                          busStop.routeDirection == "R")
                      ? Colors.red
                      : Colors.indigo,
                  shape: BoxShape.circle),
              child: const Center(
                  child: Text("D",
                      style: TextStyle(fontWeight: FontWeight.bold)))),
        );

  final BusStop busStop;
}

class BusStopMarkerPopup extends StatelessWidget {
  const BusStopMarkerPopup({super.key, required this.busStop});

  final BusStop busStop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(busStop.stopName,
                    style: const TextStyle(fontSize: 14)),
                subtitle: Text(busStop.stopId.toString()),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DurakInfoPage(
                          durak: SearchDurak(
                              type: SearchType.DURAK,
                              stationId: busStop.stopId,
                              stationName: busStop.stopName,
                              latitude: busStop.latitude,
                              longitude: busStop.latitude))));
                },
              ),
            ],
          ),
        ));
  }
}
