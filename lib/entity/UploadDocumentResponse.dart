// To parse this JSON data, do
//
//     final uploadDocumentResponse = uploadDocumentResponseFromJson(jsonString);

import 'dart:convert';

UploadDocumentResponse uploadDocumentResponseFromJson(String str) =>
    UploadDocumentResponse.fromJson(json.decode(str));

String uploadDocumentResponseToJson(UploadDocumentResponse data) =>
    json.encode(data.toJson());

class UploadDocumentResponse {
  int? status;
  String? data;
  String? message;

  UploadDocumentResponse({this.status, this.data, this.message});

  factory UploadDocumentResponse.fromJson(Map<String, dynamic> json) =>
      UploadDocumentResponse(
        status: json["status"],
        data: json["data"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}
