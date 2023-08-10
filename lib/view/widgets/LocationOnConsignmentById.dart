import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationOnConsignmentById {
  final String consignmentId;
  final LatLng startedLocation;
  final LatLng deliveredLocation;

  LocationOnConsignmentById({
    required this.consignmentId,
    required this.startedLocation,
    required this.deliveredLocation,
  });
}
