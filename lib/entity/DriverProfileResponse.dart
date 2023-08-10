// To parse this JSON data, do
//
//     final driverProfileResponse = driverProfileResponseFromJson(jsonString);

import 'dart:convert';

DriverProfileResponse driverProfileResponseFromJson(String str) =>
    DriverProfileResponse.fromJson(json.decode(str));

String driverProfileResponseToJson(DriverProfileResponse data) =>
    json.encode(data.toJson());

class DriverProfileResponse {
  int? status;
  ProfileData? data;

  DriverProfileResponse({
    this.status,
    this.data,
  });

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) =>
      DriverProfileResponse(
        status: json["status"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class ProfileData {
  String? driverId;
  String? driverNumber;
  String? title;
  String? firstName;
  String? lastName;
  String? userName;
  String? phone;
  String? mobile;
  String? emergencyContactName;
  String? emergencyPhone;
  String? contactRelation;
  String? address;
  String? suburb;
  String? zipCode;
  int? stateId;
  int? countryId;
  String? isDeleted;
  String? status;
  List<dynamic>? driverDocument;
  List<DriverNote>? driverNotes;

  ProfileData({
    this.driverId,
    this.driverNumber,
    this.title,
    this.firstName,
    this.lastName,
    this.userName,
    this.phone,
    this.mobile,
    this.emergencyContactName,
    this.emergencyPhone,
    this.contactRelation,
    this.address,
    this.suburb,
    this.zipCode,
    this.stateId,
    this.countryId,
    this.isDeleted,
    this.status,
    this.driverDocument,
    this.driverNotes,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        driverId: json["driver_id"],
        driverNumber: json["driver_number"],
        title: json["title"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userName: json["user_name"],
        phone: json["phone"],
        mobile: json["mobile"],
        emergencyContactName: json["emergency_contact_name"],
        emergencyPhone: json["emergency_phone"],
        contactRelation: json["contact_relation"],
        address: json["address"],
        suburb: json["suburb"],
        zipCode: json["zip_code"],
        stateId: json["state_id"],
        countryId: json["country_id"],
        isDeleted: json["is_deleted"],
        status: json["status"],
        driverDocument: json["driver_document"] == null
            ? []
            : List<dynamic>.from(json["driver_document"]!.map((x) => x)),
        driverNotes: json["driver_notes"] == null
            ? []
            : List<DriverNote>.from(
                json["driver_notes"]!.map((x) => DriverNote.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "driver_number": driverNumber,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "user_name": userName,
        "phone": phone,
        "mobile": mobile,
        "emergency_contact_name": emergencyContactName,
        "emergency_phone": emergencyPhone,
        "contact_relation": contactRelation,
        "address": address,
        "suburb": suburb,
        "zip_code": zipCode,
        "state_id": stateId,
        "country_id": countryId,
        "is_deleted": isDeleted,
        "status": status,
        "driver_document": driverDocument == null
            ? []
            : List<dynamic>.from(driverDocument!.map((x) => x)),
        "driver_notes": driverNotes == null
            ? []
            : List<dynamic>.from(driverNotes!.map((x) => x.toJson())),
      };
}

class DriverNote {
  String? notesId;
  String? driverId;
  String? notesContent;

  DriverNote({
    this.notesId,
    this.driverId,
    this.notesContent,
  });

  factory DriverNote.fromJson(Map<String, dynamic> json) => DriverNote(
        notesId: json["notes_id"],
        driverId: json["driver_id"],
        notesContent: json["notes_content"],
      );

  Map<String, dynamic> toJson() => {
        "notes_id": notesId,
        "driver_id": driverId,
        "notes_content": notesContent,
      };
}
