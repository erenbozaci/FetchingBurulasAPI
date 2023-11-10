import 'package:fetchingburulasapi/models/buslocation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusLocationMarker extends Marker {
  final BusLocation busLocation;

  BusLocationMarker({required this.busLocation})
      : super(
            width: 40.0,
            height: 40.0,
            point: LatLng(busLocation.latitude, busLocation.longitude),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            );
}
