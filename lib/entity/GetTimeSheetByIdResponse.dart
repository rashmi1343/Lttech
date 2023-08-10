// To parse this JSON data, do
//
//     final getTimeSheetByIdResponse = getTimeSheetByIdResponseFromJson(jsonString);

import 'dart:convert';

import 'GetTimeSheetByIdResponse.dart';
import 'GetTimeSheetByIdResponse.dart';

GetTimeSheetByIdResponse getTimeSheetByIdResponseFromJson(String str) =>
    GetTimeSheetByIdResponse.fromJson(json.decode(str));

String getTimeSheetByIdResponseToJson(GetTimeSheetByIdResponse data) =>
    json.encode(data.toJson());

class GetTimeSheetByIdResponse {
  int? status;
  GetTimeSheetByIdData? data;

  GetTimeSheetByIdResponse({
    this.status,
    this.data,
  });

  factory GetTimeSheetByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetTimeSheetByIdResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GetTimeSheetByIdData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class GetTimeSheetByIdData {
  String? timeId;
  String? timesheetId;
  String? companyId;
  DateTime? timesheetDate;
  String? startTime;
  String? startOdometer;
  String? endTime;
  String? endOdometer;
  String? driverId;
  String? driverMobile;
  String? truck;
  List<String>? trailer;
  String? signature;
  List<Timesheetjob>? timesheetjobs;
  List<Restdetail>? restdetails;
  List<objchecklist>? checklist;

  GetTimeSheetByIdData({
    this.timeId,
    this.timesheetId,
    this.companyId,
    this.timesheetDate,
    this.startTime,
    this.startOdometer,
    this.endTime,
    this.endOdometer,
    this.driverId,
    this.driverMobile,
    this.truck,
    this.trailer,
    this.signature,
    this.timesheetjobs,
    this.restdetails,
    this.checklist
  });

  factory GetTimeSheetByIdData.fromJson(Map<String, dynamic> json) =>
      GetTimeSheetByIdData(
        timeId: json["time_id"],
        timesheetId: json["timesheet_id"],
        companyId: json["company_id"],
        timesheetDate: json["timesheet_date"] == null
            ? null
            : DateTime.parse(json["timesheet_date"]),
        startTime: json["start_time"],
        startOdometer: json["start_odometer"],
        endTime: json["end_time"],
        endOdometer: json["end_odometer"],
        driverId: json["driver_id"],
        driverMobile: json["driver_mobile"],
        truck: json["truck"],
        trailer: json["trailer"] == null
            ? []
            : List<String>.from(json["trailer"]!.map((x) => x)),
        signature: json["signature"],
        timesheetjobs: json["timesheetjobs"] == null
            ? []
            : List<Timesheetjob>.from(
                json["timesheetjobs"]!.map((x) => Timesheetjob.fromJson(x))),
        restdetails: json["restdetails"] == null
            ? []
            : List<Restdetail>.from(
                json["restdetails"]!.map((x) => Restdetail.fromJson(x))),
          checklist: json["checklist"] ==null?[]:List<objchecklist>.from(json["checklist"]!.map((x) => objchecklist.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
        "time_id": timeId,
        "timesheet_id": timesheetId,
        "company_id": companyId,
        "timesheet_date": timesheetDate?.toIso8601String(),
        "start_time": startTime,
        "start_odometer": startOdometer,
        "end_time": endTime,
        "end_odometer": endOdometer,
        "driver_id": driverId,
        "driver_mobile": driverMobile,
        "truck": truck,
        "trailer":
            trailer == null ? [] : List<dynamic>.from(trailer!.map((x) => x)),
        "signature": signature,
        "timesheetjobs": timesheetjobs == null
            ? []
            : List<dynamic>.from(timesheetjobs!.map((x) => x.toJson())),
        "restdetails": restdetails == null
            ? []
            : List<dynamic>.from(restdetails!.map((x) => x.toJson())),
        "checklist" :checklist ==null ?[]:List<dynamic>.from(checklist!.map((x) => x.toJson()))
      };
}

class Restdetail {
  String? restId;
  String? timesheetId;
  String? companyId;
  String? description;
  DateTime? startTime;
  DateTime? endTime;

  Restdetail({
    this.restId,
    this.timesheetId,
    this.companyId,
    this.description,
    this.startTime,
    this.endTime,
  });

  factory Restdetail.fromJson(Map<String, dynamic> json) => Restdetail(
        restId: json["rest_id"],
        timesheetId: json["timesheet_id"],
        companyId: json["company_id"],
        description: json["description"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "rest_id": restId,
        "timesheet_id": timesheetId,
        "company_id": companyId,
        "description": description,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
      };
}


class objchecklist {
  String? id;
  String? timesheetid;
  String? driverid;
  String? companyid;
  String? checklistdate;
  int? checklisttype;
  String? checklistvalue;
  String? status;

  objchecklist({this.id, this.timesheetid, this.driverid, this.companyid, this.checklistdate, this.checklisttype, this.checklistvalue, this.status});

  objchecklist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timesheetid = json['timesheet_id'];
    driverid = json['driver_id'];
    companyid = json['company_id'];
    checklistdate = json['checklist_date'];
    checklisttype = json['checklist_type'];
    checklistvalue = json['checklist_value'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['timesheet_id'] = timesheetid;
    data['driver_id'] = driverid;
    data['company_id'] = companyid;
    data['checklist_date'] = checklistdate;
    data['checklist_type'] = checklisttype;
    data['checklist_value'] = checklistvalue;
    data['status'] = status;
    return data;
  }
}

class Timesheetjob {
  String? timesheetJobId;
  String? timesheetId;
  String? companyId;
  String? consignmentId;
  String? jobName;
  String? customerName;
  String? address;
  String? suburb;
  String? arrivalTime;
  String? departTime;
  String? pickup;
  String? delivery;
  String? referenceNumber;
  String? temp;
  String? deliveredChep;
  String? deliveredLoscomp;
  String? deliveredPlain;
  String? pickedUpChep;
  String? pickedUpLoscomp;
  String? pickedUpPlain;
  String? weight;

  Timesheetjob({
    this.timesheetJobId,
    this.timesheetId,
    this.companyId,
    this.consignmentId,
    this.jobName,
    this.customerName,
    this.address,
    this.suburb,
    this.arrivalTime,
    this.departTime,
    this.pickup,
    this.delivery,
    this.referenceNumber,
    this.temp,
    this.deliveredChep,
    this.deliveredLoscomp,
    this.deliveredPlain,
    this.pickedUpChep,
    this.pickedUpLoscomp,
    this.pickedUpPlain,
    this.weight,
  });

  factory Timesheetjob.fromJson(Map<String, dynamic> json) => Timesheetjob(
        timesheetJobId: json["timesheet_job_id"],
        timesheetId: json["timesheet_id"],
        companyId: json["company_id"],
        consignmentId: json["consignment_id"],
        jobName: json["job_name"],
        customerName: json["customer_name"],
        address: json["address"],
        suburb: json["suburb"],
        arrivalTime: json["arrival_time"],
        departTime: json["depart_time"],
        pickup: json["pickup"],
        delivery: json["delivery"],
        referenceNumber: json["reference_number"],
        temp: json["temp"],
        deliveredChep: json["delivered_chep"],
        deliveredLoscomp: json["delivered_loscomp"],
        deliveredPlain: json["delivered_plain"],
        pickedUpChep: json["picked_up_chep"],
        pickedUpLoscomp: json["picked_up_loscomp"],
        pickedUpPlain: json["picked_up_plain"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "timesheet_job_id": timesheetJobId,
        "timesheet_id": timesheetId,
        "company_id": companyId,
        "consignment_id": consignmentId,
        "job_name": jobName,
        "customer_name": customerName,
        "address": address,
        "suburb": suburb,
        "arrival_time": arrivalTime,
        "depart_time": departTime,
        "pickup": pickup,
        "delivery": delivery,
        "reference_number": referenceNumber,
        "temp": temp,
        "delivered_chep": deliveredChep,
        "delivered_loscomp": deliveredLoscomp,
        "delivered_plain": deliveredPlain,
        "picked_up_chep": pickedUpChep,
        "picked_up_loscomp": pickedUpLoscomp,
        "picked_up_plain": pickedUpPlain,
        "weight": weight,
      };
}
