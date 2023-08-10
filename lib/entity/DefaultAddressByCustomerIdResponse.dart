import 'dart:convert';

DefaultAddressByCustomerIdResponse defaultAddByCustomerIdResponseFromJson(
        String str) =>
    DefaultAddressByCustomerIdResponse.fromJson(json.decode(str));

class DefaultAddressByCustomerIdResponse {
  DefaultAddressByCustomerIdResponse({
    required this.status,
    required this.customerdefaultaddressdata,
  });

  final int? status;
 // final List<DefaultAddress> data;
  final List<CustomDefaultAddress> customerdefaultaddressdata;

  factory DefaultAddressByCustomerIdResponse.fromJson(
      Map<String, dynamic> json) {
    return DefaultAddressByCustomerIdResponse(
      status: json["status"],
      customerdefaultaddressdata: json["data"] == null
          ? []
          : List<CustomDefaultAddress>.from(json["data"]!.map((x) => CustomDefaultAddress.fromJson(x))),
    );
  }
}

class DefaultAddress {
  DefaultAddress({
    required this.address,
    required this.suburb,
    required this.zipCode,
    required this.countryId,
    required this.stateId,
    required this.defaultStatus,
  });

  final String? address;
  final String? suburb;
  final String? zipCode;
  final int? countryId;
  final int? stateId;
  final String? defaultStatus;

  factory DefaultAddress.fromJson(Map<String, dynamic> json) {
    return DefaultAddress(
      address: json["address"],
      suburb: json["suburb"],
      zipCode: json["zip_code"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      defaultStatus: json["default_status"],
    );
  }
}
//Custom class for default address including customer id
class CustomDefaultAddress {
  CustomDefaultAddress({

    required this.customerId,
    required this.address,
    required this.suburb,
    required this.zipCode,
    required this.countryId,
    required this.stateId,
    required this.defaultStatus,
  });

  final String? customerId;
  final String? address;
  final String? suburb;
  final String? zipCode;
  final int? countryId;
  final int? stateId;
  final String? defaultStatus;

  factory CustomDefaultAddress.fromJson(Map<String, dynamic> json) {
    return CustomDefaultAddress(
      customerId: json["customer_id"],
      address: json["address"],
      suburb: json["suburb"],
      zipCode: json["zip_code"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      defaultStatus: json["default_status"],
    );
  }
}
