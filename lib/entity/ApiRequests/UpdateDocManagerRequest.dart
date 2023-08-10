// To parse this JSON data, do
//
//     final updateDocManagerRequest = updateDocManagerRequestFromJson(jsonString);

import 'dart:convert';

UpdateDocManagerRequest updateDocManagerRequestFromJson(String str) =>
    UpdateDocManagerRequest.fromJson(json.decode(str));

String updateDocManagerRequestToJson(UpdateDocManagerRequest data) =>
    json.encode(data.toJson());

class UpdateDocManagerRequest {
  List<DocManagerDetail>? docManagerDetails;

  UpdateDocManagerRequest({
    this.docManagerDetails,
  });

  factory UpdateDocManagerRequest.fromJson(Map<String, dynamic> json) =>
      UpdateDocManagerRequest(
        docManagerDetails: json["doc_manager_details"] == null
            ? []
            : List<DocManagerDetail>.from(json["doc_manager_details"]!
                .map((x) => DocManagerDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doc_manager_details": docManagerDetails == null
            ? []
            : List<dynamic>.from(docManagerDetails!.map((x) => x.toJson())),
      };
}

class DocManagerDetail {
  List<String>? documentType;
  List<String>? documentNumber;
  List<String>? documentFile;
  List<String>? docManagerId;
  String? companyId;

  DocManagerDetail({
    this.documentType,
    this.documentNumber,
    this.documentFile,
    this.docManagerId,
    this.companyId,
  });

  factory DocManagerDetail.fromJson(Map<String, dynamic> json) =>
      DocManagerDetail(
        documentType: json["document_type"] == null
            ? []
            : List<String>.from(json["document_type"]!.map((x) => x)),
        documentNumber: json["document_number"] == null
            ? []
            : List<String>.from(json["document_number"]!.map((x) => x)),
        documentFile: json["document_file"] == null
            ? []
            : List<String>.from(json["document_file"]!.map((x) => x)),
        docManagerId: json["doc_manager_id"] == null
            ? []
            : List<String>.from(json["doc_manager_id"]!.map((x) => x)),
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "document_type": documentType == null
            ? []
            : List<dynamic>.from(documentType!.map((x) => x)),
        "document_number": documentNumber == null
            ? []
            : List<dynamic>.from(documentNumber!.map((x) => x)),
        "document_file": documentFile == null
            ? []
            : List<dynamic>.from(documentFile!.map((x) => x)),
        "doc_manager_id": docManagerId == null
            ? []
            : List<dynamic>.from(docManagerId!.map((x) => x)),
        "company_id": companyId,
      };
}
