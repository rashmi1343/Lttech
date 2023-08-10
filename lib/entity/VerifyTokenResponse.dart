// To parse this JSON data, do
//
//     final verifyTokenResponse = verifyTokenResponseFromJson(jsonString);

import 'dart:convert';

VerifyTokenResponse verifyTokenResponseFromJson(String str) =>
    VerifyTokenResponse.fromJson(json.decode(str));

String verifyTokenResponseToJson(VerifyTokenResponse data) =>
    json.encode(data.toJson());

class VerifyTokenResponse {
  int? status;
  VeriftTokenData? data;

  VerifyTokenResponse({
    this.status,
    this.data,
  });

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) =>
      VerifyTokenResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : VeriftTokenData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class VeriftTokenData {
  String? companyId;
  String? userId;
  String? roleId;
  String? userTypeId;
  String? relationId;
  String? isDeleted;
  String? status;
  UserData? userData;

  VeriftTokenData({
    this.companyId,
    this.userId,
    this.roleId,
    this.userTypeId,
    this.relationId,
    this.isDeleted,
    this.status,
    this.userData,
  });

  factory VeriftTokenData.fromJson(Map<String, dynamic> json) =>
      VeriftTokenData(
        companyId: json["company_id"],
        userId: json["user_id"],
        roleId: json["roleId"],
        userTypeId: json["user_typeId"],
        relationId: json["relation_id"],
        isDeleted: json["is_deleted"],
        status: json["status"],
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "user_id": userId,
        "roleId": roleId,
        "user_typeId": userTypeId,
        "relation_id": relationId,
        "is_deleted": isDeleted,
        "status": status,
        "userData": userData?.toJson(),
      };
}

class UserData {
  String? firstName;
  String? lastName;

  UserData({
    this.firstName,
    this.lastName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
      };
}
