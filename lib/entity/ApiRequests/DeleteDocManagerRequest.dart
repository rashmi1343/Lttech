// To parse this JSON data, do
//
//     final deleteDocManagerRequest = deleteDocManagerRequestFromJson(jsonString);

import 'dart:convert';

DeleteDocManagerRequest deleteDocManagerRequestFromJson(String str) =>
    DeleteDocManagerRequest.fromJson(json.decode(str));

String deleteDocManagerRequestToJson(DeleteDocManagerRequest data) =>
    json.encode(data.toJson());

class DeleteDocManagerRequest {
  List<String>? id;

  DeleteDocManagerRequest({
    this.id,
  });

  factory DeleteDocManagerRequest.fromJson(Map<String, dynamic> json) =>
      DeleteDocManagerRequest(
        id: json["id"] == null
            ? []
            : List<String>.from(json["id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? [] : List<dynamic>.from(id!.map((x) => x)),
      };
}
