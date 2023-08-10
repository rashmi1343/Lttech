// To parse this JSON data, do
//
//     final getDocTypeResponse = getDocTypeResponseFromJson(jsonString);

import 'dart:convert';

GetDocTypeResponse getDocTypeResponseFromJson(String str) =>
    GetDocTypeResponse.fromJson(json.decode(str));

String getDocTypeResponseToJson(GetDocTypeResponse data) =>
    json.encode(data.toJson());

class GetDocTypeResponse {
  int? status;
  List<DocTypeData>? data;

  GetDocTypeResponse({
    this.status,
    this.data,
  });

  factory GetDocTypeResponse.fromJson(Map<String, dynamic> json) =>
      GetDocTypeResponse(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<DocTypeData>.from(
                json["data"]!.map((x) => DocTypeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DocTypeData {
  String? documentId;
  String? companyId;
  String? documentType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isDeleted;
  String? status;

  DocTypeData({
    this.documentId,
    this.companyId,
    this.documentType,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.status,
  });

  factory DocTypeData.fromJson(Map<String, dynamic> json) => DocTypeData(
        documentId: json["document_id"],
        companyId: json["company_id"],
        documentType: json["document_type"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        isDeleted: json["is_deleted"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "document_id": documentId,
        "company_id": companyId,
        "document_type": documentType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "is_deleted": isDeleted,
        "status": status,
      };
}
