import 'dart:convert';

CustomersResponse customersResponseFromJson(String str) => CustomersResponse.fromJson(json.decode(str));


class CustomersResponse {
  CustomersResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final List<CustomerList> data;

  factory CustomersResponse.fromJson(Map<String, dynamic> json){
    return CustomersResponse(
      status: json["status"],
      data: json["data"] == null ? [] : List<CustomerList>.from(json["data"]!.map((x) => CustomerList.fromJson(x))),
    );
  }

}

class CustomerList {
  CustomerList({
    required this.customerId,
    required this.firstName,
    required this.lastName,
  });

  final String? customerId;
  final String? firstName;
  final String? lastName;

  factory CustomerList.fromJson(Map<String, dynamic> json){
    return CustomerList(
      customerId: json["customer_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }

}