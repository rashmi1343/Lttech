import 'dart:convert';

SignOnConsignmentRequest signOnConsignmentRequestFromJson(String str) =>
    SignOnConsignmentRequest.fromJson(json.decode(str));

String signOnConsignmentRequestToJson(SignOnConsignmentRequest data) =>
    json.encode(data.toJson());

class SignOnConsignmentRequest {
  String? signature;
  String? endLatitude;
  String? endLongitude;
  DateTime? signatureDate;
  String? status;

  SignOnConsignmentRequest({
    this.signature,
    this.endLatitude,
    this.endLongitude,
    this.signatureDate,
    this.status,
  });

  factory SignOnConsignmentRequest.fromJson(Map<String, dynamic> json) =>
      SignOnConsignmentRequest(
        signature: json["signature"],
        endLatitude: json["end_latitude"],
        endLongitude: json["end_longitude"],
        signatureDate: json["signature_date"] == null
            ? null
            : DateTime.parse(json["signature_date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "signature": signature,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "signature_date": signatureDate?.toIso8601String(),
        "status": status,
      };
}
