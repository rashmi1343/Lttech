// To parse this JSON data, do
//
//      addTimeSheetRequest = addTimeSheetRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

AddTimeSheetRequest addTimeSheetRequestFromJson(String str) =>
    AddTimeSheetRequest.fromJson(json.decode(str));

String addTimeSheetRequestToJson(AddTimeSheetRequest data) =>
    json.encode(data.toJson());

class AddTimeSheetRequest {
  String timesheetid;
  String companyid;
  String timesheetdate;
  String starttime;
  String startodometer;
  String endtime;
  String endodometer;
  String driverId;
  String drivermobile;
  String truck;
  List<String> trailer;
  List<JobDetail> jobDetails;
  List<RestDetail> restDetails;
  String? signature;


  AddTimeSheetRequest({
    required this.timesheetid,
    required this.companyid,
    required this.timesheetdate,
    required this.starttime,
    required this.startodometer,
    required this.endtime,
    required this.endodometer,
    required this.driverId,
    required this.drivermobile,
    required this.truck,
    required this.trailer,
    required this.jobDetails,
    required this.restDetails,
    this.signature
  });

  factory AddTimeSheetRequest.fromJson(Map<String, dynamic> json) =>
      AddTimeSheetRequest(
        timesheetid: json["timesheetid"],
        companyid: json["companyid"],
        timesheetdate: json["timesheetdate"],
        starttime: json["starttime"],
        startodometer: json["startodometer"],
        endtime: json["endtime"],
        endodometer: json["endodometer"],
        driverId: json["driver_id"],
        drivermobile: json["drivermobile"],
        truck: json["truck"],
        trailer: json["trailer"],
        jobDetails: json["job_details"] == null
            ? []
            : List<JobDetail>.from(
                json["job_details"]!.map((x) => JobDetail.fromJson(x))),
        restDetails: json["rest_details"] == null
            ? []
            : List<RestDetail>.from(
                json["rest_details"]!.map((x) => RestDetail.fromJson(x))),
          signature: json["signature"]
      );

  Map<String, dynamic> toJson() => {
        "timesheetid": timesheetid,
        "companyid": companyid,
        "timesheetdate": timesheetdate,
        "starttime": starttime,
        "startodometer": startodometer,
        "endtime": endtime,
        "endodometer": endodometer,
        "driver_id": driverId,
        "drivermobile": drivermobile,
        "truck": truck,
        "trailer": trailer,
        "job_details": jobDetails == null
            ? []
            : List<dynamic>.from(jobDetails!.map((x) => x.toJson())),
        "rest_details": restDetails == null
            ? []
            : List<dynamic>.from(restDetails!.map((x) => x.toJson())),
        "signature":signature
      };
}

class JobDetail {
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
  String? consignmentID;

  JobDetail({
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
    this.consignmentID,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
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
        consignmentID: json["consignment_id"],
      );

  Map<String, dynamic> toJson() => {
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
        "consignment_id": consignmentID,
      };
}

class RestDetail {
  String? description;
  String? startTime;
  String? endTime;

  RestDetail({
    this.description,
    this.startTime,
    this.endTime,
  });

  factory RestDetail.fromJson(Map<String, dynamic> json) => RestDetail(
        description: json["description"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "start_time": startTime,
        "end_time": endTime,
      };
}
