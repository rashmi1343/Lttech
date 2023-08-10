import 'dart:convert';

AddConsignmentResponse addConsignmentResponseFromJson(String str) => AddConsignmentResponse.fromJson(json.decode(str));

String addConsignmentResponseToJson(AddConsignmentResponse data) => json.encode(data.toJson());

class AddConsignmentResponse {
  int? status;
  AddConsignment? addConsignment;

  AddConsignmentResponse({
     this.status,
     this.addConsignment,
  });

  factory AddConsignmentResponse.fromJson(Map<String, dynamic> json) => AddConsignmentResponse(
    status: json["status"],
    addConsignment: AddConsignment.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": addConsignment!.toJson(),
  };
}

class AddConsignment {
  bool success;
  String consignmentdata;

  AddConsignment({
    required this.success,
    required this.consignmentdata,
  });

  factory AddConsignment.fromJson(Map<String, dynamic> json) => AddConsignment(
    success: json["success"],
    consignmentdata: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": consignmentdata,
  };
}
