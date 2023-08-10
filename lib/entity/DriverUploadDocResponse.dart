import 'dart:convert';

DriverUploadDocResponse driverUploadDocResponseFromJson(String str) => DriverUploadDocResponse.fromJson(json.decode(str));

String driverUploadDocResponseToJson(DriverUploadDocResponse data) => json.encode(data.toJson());

class DriverUploadDocResponse {
  int status;
  String filedata;

  DriverUploadDocResponse({
    required this.status,
    required this.filedata,
  });

  factory DriverUploadDocResponse.fromJson(Map<String, dynamic> json) => DriverUploadDocResponse(
    status: json["status"],
    filedata: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": filedata,
  };
}
