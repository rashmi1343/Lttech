import 'dart:convert';

SignOnConsignmentResponse signOnConsignmentResponseFromJson(String str) =>
    SignOnConsignmentResponse.fromJson(json.decode(str));

class SignOnConsignmentResponse {
  SignOnConsignmentResponse({
    this.status,
    this.data,
  });

  final int? status;
  final SignOnConsignmentResponseData? data;

  factory SignOnConsignmentResponse.fromJson(Map<String, dynamic> json) {
    return SignOnConsignmentResponse(
      status: json["status"],
      data: json["data"] == null
          ? null
          : SignOnConsignmentResponseData.fromJson(json["data"]),
    );
  }
}

class SignOnConsignmentResponseData {
  SignOnConsignmentResponseData({
    this.success,
    this.data,
  });

  final bool? success;
  final SignData? data;

  factory SignOnConsignmentResponseData.fromJson(Map<String, dynamic> json) {
    return SignOnConsignmentResponseData(
      success: json["success"],
      data: json["data"] == null ? null : SignData.fromJson(json["data"]),
    );
  }
}

class SignData {
  SignData({
    this.signature,
    this.endLatitude,
    this.endLongitude,
    this.signatureDate,
    this.status,
  });

  final String? signature;
  final String? endLatitude;
  final String? endLongitude;
  final DateTime? signatureDate;
  final String? status;

  factory SignData.fromJson(Map<String, dynamic> json) {
    return SignData(
      signature: json["signature"],
      endLatitude: json["end_latitude"],
      endLongitude: json["end_longitude"],
      signatureDate: DateTime.tryParse(json["signature_date"] ?? ""),
      status: json["status"],
    );
  }
}
