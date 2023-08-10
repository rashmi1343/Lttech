import 'dart:convert';

import 'package:equatable/equatable.dart';

CustomerCompanyAddressResponse customerCompanyAddressResponseFromJson(
        String str) =>
    CustomerCompanyAddressResponse.fromJson(json.decode(str));

class CustomerCompanyAddressResponse {
  CustomerCompanyAddressResponse({
    required this.status,
    required this.objcustomerbilladdressdata,
  });

  final int? status;
  final List<CustomerBillingAddress> objcustomerbilladdressdata;

  factory CustomerCompanyAddressResponse.fromJson(Map<String, dynamic> json) {
    return CustomerCompanyAddressResponse(
      status: json["status"],
      objcustomerbilladdressdata: json["data"] == null
          ? []
          : List<CustomerBillingAddress>.from(json["data"]!.map((x) => CustomerBillingAddress.fromJson(x))),
    );
  }

}

class CustomerBillingAddress {
  CustomerBillingAddress({
    required this.customerId,
    required this.customerCompanyName,
    required this.customerBillingAddressDetails,
  });

  final String? customerId;
  final String? customerCompanyName;
  //final List<CustomerBillingAddressDetail> customerBillingAddressDetails;
  final List<CustomCustomerBillingAddressDetail> customerBillingAddressDetails;

  factory CustomerBillingAddress.fromJson(Map<String, dynamic> json) {
    return CustomerBillingAddress(
      customerId: json["customer_id"],
      customerCompanyName: json["customer_company_name"],
      customerBillingAddressDetails:
          json["customer_billing_address_details"] == null
              ? []
              : List<CustomCustomerBillingAddressDetail>.from(
                  json["customer_billing_address_details"]!
                      .map((x) => CustomCustomerBillingAddressDetail.fromJson(x))),
    );
  }

}

class CustomerBillingAddressDetail {
  CustomerBillingAddressDetail({
    required this.customerBillingId,
    required this.customerName,
    required this.address,
  });

  final String? customerBillingId;
  final String? customerName;
  final String? address;

  factory CustomerBillingAddressDetail.fromJson(Map<String, dynamic> json) {
    return CustomerBillingAddressDetail(
      customerBillingId: json["customer_billing_id"],
      customerName: json["customer_name"],
      address: json["address"],
    );
  }
}

// Custom class for Billing Address detail including customer id
class CustomCustomerBillingAddressDetail extends Equatable{
  CustomCustomerBillingAddressDetail({
    required this.customerId,
    required this.customerBillingId,
    required this.customerName,
    required this.address,
    required this.custvalue
  });
  final String? customerId;
  final String? customerBillingId;
  final String? customerName;
  final String? address;
  final String? custvalue;

  factory CustomCustomerBillingAddressDetail.fromJson(Map<String, dynamic> json) {
    return CustomCustomerBillingAddressDetail(
      customerId: json["customer_id"],
      customerBillingId: json["customer_billing_id"],
      customerName: json["customer_name"],
      address: json["address"], custvalue : json["custvalue"]
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [customerId,customerBillingId,customerName,address,custvalue];
}
