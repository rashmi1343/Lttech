// To parse this JSON data, do
//
//     final addGeoLocationRequest = addGeoLocationRequestFromJson(jsonString);

import 'dart:convert';

AddGeoLocationRequest addGeoLocationRequestFromJson(String str) =>
    AddGeoLocationRequest.fromJson(json.decode(str));

String addGeoLocationRequestToJson(AddGeoLocationRequest data) =>
    json.encode(data.toJson());

class AddGeoLocationRequest {
  List<GeoDetail> geoDetails;

  AddGeoLocationRequest({
    required this.geoDetails,
  });

  factory AddGeoLocationRequest.fromJson(Map<String, dynamic> json) =>
      AddGeoLocationRequest(
        geoDetails: json["geo_details"] == null
            ? []
            : List<GeoDetail>.from(
                json["geo_details"]!.map((x) => GeoDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "geo_details": List<dynamic>.from(geoDetails.map((x) => x.toJson())),
      };
}

class GeoDetail {
  String? consignmentId;
  String? driverId;
  String? startedLatitude;
  String? startedLongitude;
  String? deliveredLatitude;
  String? deliveredLongitude;
  DateTime? geoDate;

  GeoDetail({
    this.consignmentId,
    this.driverId,
    this.startedLatitude,
    this.startedLongitude,
    this.deliveredLatitude,
    this.deliveredLongitude,
    this.geoDate,
  });

  factory GeoDetail.fromJson(Map<String, dynamic> json) => GeoDetail(
        consignmentId: json["consignment_id"],
        driverId: json["driver_id"],
        startedLatitude: json["started_latitude"],
        startedLongitude: json["started_longitude"],
        deliveredLatitude: json["delivered_latitude"],
        deliveredLongitude: json["delivered_longitude"],
        geoDate:
            json["geo_date"] == null ? null : DateTime.parse(json["geo_date"]),
      );

  Map<String, dynamic> toJson() => {
        "consignment_id": consignmentId,
        "driver_id": driverId,
        "started_latitude": startedLatitude,
        "started_longitude": startedLongitude,
        "delivered_latitude": deliveredLatitude,
        "delivered_longitude": deliveredLongitude,
        "geo_date": geoDate?.toIso8601String(),
      };
}
