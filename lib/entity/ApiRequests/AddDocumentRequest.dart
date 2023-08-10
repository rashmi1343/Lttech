// To parse this JSON data, do
//
//     final addDocumentRequest = addDocumentRequestFromJson(jsonString);

import 'dart:convert';

AddDocumentRequest addDocumentRequestFromJson(String str) =>
    AddDocumentRequest.fromJson(json.decode(str));

String addDocumentRequestToJson(AddDocumentRequest data) =>
    json.encode(data.toJson());

class AddDocumentRequest {
  List<DocManagerDetail>? docManagerDetails;

  AddDocumentRequest({
    this.docManagerDetails,
  });

  factory AddDocumentRequest.fromJson(Map<String, dynamic> json) =>
      AddDocumentRequest(
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
  String? documentType;
  String? documentNumber;
  String? documentFile;
  String? docManagerId;
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
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        documentFile: json["document_file"],
        docManagerId: json["doc_manager_id"],
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "document_type": documentType,
        "document_number": documentNumber,
        "document_file": documentFile,
        "doc_manager_id": docManagerId,
        "company_id": companyId,
      };
}
