import 'dart:convert';

AddGeoLocationResponse addGeoLocationResponseFromJson(String str) =>
    AddGeoLocationResponse.fromJson(json.decode(str));

String addGeoLocationResponseToJson(AddGeoLocationResponse data) =>
    json.encode(data.toJson());

class AddGeoLocationResponse {
  int? status;
  String? data;

  AddGeoLocationResponse({
    this.status,
    this.data,
  });

  factory AddGeoLocationResponse.fromJson(Map<String, dynamic> json) =>
      AddGeoLocationResponse(
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}
