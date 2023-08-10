// To parse this JSON data, do
//
//     final addTimeSheetResponse = addTimeSheetResponseFromJson(jsonString);

import 'dart:convert';

AddTimeSheetResponse addTimeSheetResponseFromJson(String str) =>
    AddTimeSheetResponse.fromJson(json.decode(str));

String addTimeSheetResponseToJson(AddTimeSheetResponse data) =>
    json.encode(data.toJson());

class AddTimeSheetResponse {
  final int? status;
  final AddTimeSheetData? data;

  AddTimeSheetResponse({
    this.status,
    this.data,
  });

  factory AddTimeSheetResponse.fromJson(Map<String, dynamic> json) =>
      AddTimeSheetResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : AddTimeSheetData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class AddTimeSheetData {
  final bool? success;
  final String? data;

  AddTimeSheetData({
    this.success,
    this.data,
  });

  factory AddTimeSheetData.fromJson(Map<String, dynamic> json) =>
      AddTimeSheetData(
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
      };
}
