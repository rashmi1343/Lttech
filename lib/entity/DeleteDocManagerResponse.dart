// To parse this JSON data, do
//
//     final deleteDocManagerResponse = deleteDocManagerResponseFromJson(jsonString);

import 'dart:convert';

DeleteDocManagerResponse deleteDocManagerResponseFromJson(String str) =>
    DeleteDocManagerResponse.fromJson(json.decode(str));

String deleteDocManagerResponseToJson(DeleteDocManagerResponse data) =>
    json.encode(data.toJson());

class DeleteDocManagerResponse {
  int? status;
  DeleteDocData? data;

  DeleteDocManagerResponse({
    this.status,
    this.data,
  });

  factory DeleteDocManagerResponse.fromJson(Map<String, dynamic> json) =>
      DeleteDocManagerResponse(
        status: json["status"],
        data:
            json["data"] == null ? null : DeleteDocData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DeleteDocData {
  bool? success;
  List<int>? data;

  DeleteDocData({
    this.success,
    this.data,
  });

  factory DeleteDocData.fromJson(Map<String, dynamic> json) => DeleteDocData(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<int>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
