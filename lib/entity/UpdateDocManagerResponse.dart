// To parse this JSON data, do
//
//     final updateDocManagerResponse = updateDocManagerResponseFromJson(jsonString);

import 'dart:convert';

UpdateDocManagerResponse updateDocManagerResponseFromJson(String str) =>
    UpdateDocManagerResponse.fromJson(json.decode(str));

String updateDocManagerResponseToJson(UpdateDocManagerResponse data) =>
    json.encode(data.toJson());

class UpdateDocManagerResponse {
  int? status;
  UpdateDocData? data;

  UpdateDocManagerResponse({
    this.status,
    this.data,
  });

  factory UpdateDocManagerResponse.fromJson(Map<String, dynamic> json) =>
      UpdateDocManagerResponse(
        status: json["status"],
        data:
            json["data"] == null ? null : UpdateDocData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class UpdateDocData {
  bool? success;
  String? data;

  UpdateDocData({
    this.success,
    this.data,
  });

  factory UpdateDocData.fromJson(Map<String, dynamic> json) => UpdateDocData(
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
      };
}
