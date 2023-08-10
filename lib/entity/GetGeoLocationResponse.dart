import 'dart:convert';

GetGeoLocationResponse getGeoLocationResponseFromJson(String str) =>
    GetGeoLocationResponse.fromJson(json.decode(str));

String getGeoLocationResponseToJson(GetGeoLocationResponse data) =>
    json.encode(data.toJson());

class GetGeoLocationResponse {
  int? status;
  GeoLocationData data;

  GetGeoLocationResponse({
    this.status,
    required this.data,
  });

  factory GetGeoLocationResponse.fromJson(Map<String, dynamic> json) =>
      GetGeoLocationResponse(
        status: json["status"],
        data: GeoLocationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class GeoLocationData {
  int? count;
  List<GeoLocationRow> rows;

  GeoLocationData({
    this.count,
    required this.rows,
  });

  factory GeoLocationData.fromJson(Map<String, dynamic> json) =>
      GeoLocationData(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<GeoLocationRow>.from(
                json["rows"]!.map((x) => GeoLocationRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
      };
}

class GeoLocationRow {
  String? geoId;
  String? consignmentId;
  String? driverId;
  String? startedLatitude;
  String? startedLongitude;
  String? deliveredLatitude;
  String? deliveredLongitude;
  DateTime? geoDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isDeleted;
  String? status;

  GeoLocationRow({
    this.geoId,
    this.consignmentId,
    this.driverId,
    this.startedLatitude,
    this.startedLongitude,
    this.deliveredLatitude,
    this.deliveredLongitude,
    this.geoDate,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.status,
  });

  factory GeoLocationRow.fromJson(Map<String, dynamic> json) => GeoLocationRow(
        geoId: json["geo_id"],
        consignmentId: json["consignment_id"],
        driverId: json["driver_id"],
        startedLatitude: json["started_latitude"],
        startedLongitude: json["started_longitude"],
        deliveredLatitude: json["delivered_latitude"],
        deliveredLongitude: json["delivered_longitude"],
        geoDate:
            json["geo_date"] == null ? null : DateTime.parse(json["geo_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isDeleted: json["is_deleted"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "geo_id": geoId,
        "consignment_id": consignmentId,
        "driver_id": driverId,
        "started_latitude": startedLatitude,
        "started_longitude": startedLongitude,
        "delivered_latitude": deliveredLatitude,
        "delivered_longitude": deliveredLongitude,
        "geo_date": geoDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_deleted": isDeleted,
        "status": status,
      };
}
