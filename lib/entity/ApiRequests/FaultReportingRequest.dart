// To parse this JSON data, do
//
//     final faultReportingRequest = faultReportingRequestFromJson(jsonString);

import 'dart:convert';

FaultReportingRequest faultReportingRequestFromJson(String str) =>
    FaultReportingRequest.fromJson(json.decode(str));

String faultReportingRequestToJson(FaultReportingRequest data) =>
    json.encode(data.toJson());

class FaultReportingRequest {
  String? driverid;
  String? companyid;
  String? reportdate;
  String? reporttime;
  String? vehiclenumber;
  String? vehicletype;
  String? reportcontent;
  String? faultlevel;
  String? attachment;

  FaultReportingRequest({
    this.driverid,
    this.companyid,
    this.reportdate,
    this.reporttime,
    this.vehiclenumber,
    this.vehicletype,
    this.reportcontent,
    this.faultlevel,
    this.attachment,
  });

  factory FaultReportingRequest.fromJson(Map<String, dynamic> json) =>
      FaultReportingRequest(
        driverid: json["driverid"],
        companyid: json["companyid"],
        reportdate: json["reportdate"],
        reporttime: json["reporttime"],
        vehiclenumber: json["vehiclenumber"],
        vehicletype: json["vehicletype"],
        reportcontent: json["reportcontent"],
        faultlevel: json["faultlevel"],
        attachment: json["attachment"],
      );

  Map<String, dynamic> toJson() => {
        "driverid": driverid,
        "companyid": companyid,
        "reportdate": reportdate,
        "reporttime": reporttime,
        "vehiclenumber": vehiclenumber,
        "vehicletype": vehicletype,
        "reportcontent": reportcontent,
        "faultlevel": faultlevel,
        "attachment": attachment,
      };
}
