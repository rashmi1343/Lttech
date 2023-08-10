import 'dart:convert';

GetAllConsignmentResponse getAllConsignmentResponseFromJson(String str) =>
    GetAllConsignmentResponse.fromJson(json.decode(str));

class GetAllConsignmentResponse {
  GetAllConsignmentResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final Data? data;

  factory GetAllConsignmentResponse.fromJson(Map<String, dynamic> json) {
    return GetAllConsignmentResponse(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.count,
    required this.rows,
  });

  final int? count;
  final List<AllConsignmentsRow> rows;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      count: json["count"],
      rows: json["rows"] == null
          ? []
          : List<AllConsignmentsRow>.from(
              json["rows"]!.map((x) => AllConsignmentsRow.fromJson(x))),
    );
  }
}

class AllConsignmentsRow {
  AllConsignmentsRow({
    required this.consignmentId,
    required this.companyId,
    required this.jobNumber,
    required this.bookedDate,
    required this.pickupDate,
    required this.deliveryDate,
    required this.specialInstruction,
    required this.manifestNumber,
    required this.billingCustomer,
    required this.billingAddressId,
    required this.billingAddress,
    required this.customerId,
    required this.pickupcustomerid,
    required this.customerAddress,
    required this.suburb,
    required this.zipCode,
    required this.stateId,
    required this.countryId,
    required this.chep,
    required this.loscom,
    required this.plain,
    required this.deliveryName,
    required this.deliveryAddres,
    required this.deliverySuburb,
    required this.deliveryZipCode,
    required this.deliveryStateId,
    required this.deliveryCountryId,
    required this.driverId,
    required this.driverMobileNumber,
    required this.totalItems,
    required this.signature,
    required this.endLatitude,
    required this.endLongitude,
    required this.signatureDate,
    required this.totalPallets,
    required this.totalSpaces,
    required this.totalWeight,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.status,
    required this.customerDetails,
    required this.driver,
  });

  final String? consignmentId;
  final String? companyId;
  final String? jobNumber;
  final DateTime? bookedDate;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String? specialInstruction;
  final String? manifestNumber;
  final String? billingCustomer;
  final String? billingAddressId;
  final String? billingAddress;
  final String? customerId;
  final String? pickupcustomerid;
  final String? customerAddress;
  final String? suburb;
  final String? zipCode;
  final int? stateId;
  final int? countryId;
  final String? chep;
  final String? loscom;
  final String? plain;
  final String? deliveryName;
  final String? deliveryAddres;
  final String? deliverySuburb;
  final String? deliveryZipCode;
  final int? deliveryStateId;
  final int? deliveryCountryId;
  final String? driverId;
  final String? driverMobileNumber;
  final int? totalItems;
  final String? signature;
  final String? endLatitude;
  final String? endLongitude;
  final DateTime? signatureDate;
  final int? totalPallets;
  final int? totalSpaces;
  final int? totalWeight;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? isDeleted;
  final String? status;
  final CustomerDetails? customerDetails;
  final Driver? driver;

  factory AllConsignmentsRow.fromJson(Map<String, dynamic> json) {
    return AllConsignmentsRow(
      consignmentId: json["consignment_id"],
      companyId: json["company_id"],
      jobNumber: json["job_number"],
      bookedDate: DateTime.tryParse(json["booked_date"] ?? ""),
      pickupDate: DateTime.tryParse(json["pickup_date"] ?? ""),
      deliveryDate: DateTime.tryParse(json["delivery_date"] ?? ""),
      specialInstruction: json["special_instruction"],
      manifestNumber: json["manifest_number"],
      billingCustomer: json["billing_customer"],
      billingAddressId: json["billing_address_id"],
      billingAddress: json["billing_address"],
      customerId: json["customer_id"],
      pickupcustomerid: json["pickup_customer_id"],
      customerAddress: json["customer_address"],
      suburb: json["suburb"],
      zipCode: json["zip_code"],
      stateId: json["state_id"],
      countryId: json["country_id"],
      chep: json["chep"],
      loscom: json["loscom"],
      plain: json["plain"],
      deliveryName: json["delivery_name"],
      deliveryAddres: json["delivery_addres"],
      deliverySuburb: json["delivery_suburb"],
      deliveryZipCode: json["delivery_zip_code"],
      deliveryStateId: json["delivery_state_id"],
      deliveryCountryId: json["delivery_country_id"],
      driverId: json["driver_id"],
      driverMobileNumber: json["driver_mobile_number"],
      totalItems: json["total_items"],
      signature: json["signature"],
      endLatitude: json["end_latitude"],
      endLongitude: json["end_longitude"],
      signatureDate: DateTime.tryParse(json["signature_date"] ?? ""),
      totalPallets: json["total_pallets"],
      totalSpaces: json["total_spaces"],
      totalWeight: json["total_weight"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isDeleted: json["is_deleted"],
      status: json["status"],
      customerDetails: json["customer_details"] == null
          ? null
          : CustomerDetails.fromJson(json["customer_details"]),
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    );
  }
}

class CustomerDetails {
  CustomerDetails({
    required this.customerId,
    required this.firstName,
    required this.lastName,
  });

  final String? customerId;
  final String? firstName;
  final String? lastName;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      customerId: json["customer_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }
}

class Driver {
  Driver({
    required this.firstName,
    required this.lastName,
  });

  final String? firstName;
  final String? lastName;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }
}
