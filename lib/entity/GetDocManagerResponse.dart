// To parse this JSON data, do
//
//     final getDocManagerResponse = getDocManagerResponseFromJson(jsonString);

import 'dart:convert';

GetDocManagerResponse getDocManagerResponseFromJson(String str) =>
    GetDocManagerResponse.fromJson(json.decode(str));

String getDocManagerResponseToJson(GetDocManagerResponse data) =>
    json.encode(data.toJson());

class GetDocManagerResponse {
  int? status;
  GetDocData? data;

  GetDocManagerResponse({
    this.status,
    this.data,
  });

  factory GetDocManagerResponse.fromJson(Map<String, dynamic> json) =>
      GetDocManagerResponse(
        status: json["status"],
        data: json["data"] == null ? null : GetDocData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class GetDocData {
  int? count;
  List<GetDocRow>? rows;

  GetDocData({
    this.count,
    this.rows,
  });

  factory GetDocData.fromJson(Map<String, dynamic> json) => GetDocData(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<GetDocRow>.from(
                json["rows"]!.map((x) => GetDocRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class GetDocRow {
  String? docManagerId;
  String? companyId;
  String? documentType;
  String? documentNumber;
  String? documentFile;
  String? documentFileType;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isDeleted;
  String? status;
  DocManagerType? docManagerType;

  GetDocRow({
    this.docManagerId,
    this.companyId,
    this.documentType,
    this.documentNumber,
    this.documentFile,
    this.documentFileType,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.status,
    this.docManagerType,
  });

  factory GetDocRow.fromJson(Map<String, dynamic> json) => GetDocRow(
        docManagerId: json["doc_manager_id"],
        companyId: json["company_id"],
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        documentFile: json["document_file"],
        documentFileType: json["document_file_type"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        isDeleted: json["is_deleted"],
        status: json["status"],
        docManagerType: json["docManagerType"] == null
            ? null
            : DocManagerType.fromJson(json["docManagerType"]),
      );

  Map<String, dynamic> toJson() => {
        "doc_manager_id": docManagerId,
        "company_id": companyId,
        "document_type": documentType,
        "document_number": documentNumber,
        "document_file": documentFile,
        "document_file_type": documentFileType,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "is_deleted": isDeleted,
        "status": status,
        "docManagerType": docManagerType?.toJson(),
      };
}

class DocManagerType {
  String? documentId;
  String? documentType;

  DocManagerType({
    this.documentId,
    this.documentType,
  });

  factory DocManagerType.fromJson(Map<String, dynamic> json) => DocManagerType(
        documentId: json["document_id"],
        documentType: json["document_type"],
      );

  Map<String, dynamic> toJson() => {
        "document_id": documentId,
        "document_type": documentType,
      };
}
