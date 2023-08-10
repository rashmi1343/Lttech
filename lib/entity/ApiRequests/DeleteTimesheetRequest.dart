// To parse this JSON data, do
//
//     final deleteTimesheetRequest = deleteTimesheetRequestFromJson(jsonString);

import 'dart:convert';

String deleteTimesheetRequestToJson(DeleteTimesheetRequest data) =>
    json.encode(data.toJson());

class DeleteTimesheetRequest {
  List<String> id;

  DeleteTimesheetRequest({
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "id": List<dynamic>.from(id.map((x) => x)),
      };
}
