import 'dart:convert';

ConsignmentByIdResponse consignmentByIdResponseFromJson(String str) =>
    ConsignmentByIdResponse.fromJson(json.decode(str));

class ConsignmentByIdResponse {
  ConsignmentByIdResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final ConsignmentByIdData? data;

  factory ConsignmentByIdResponse.fromJson(Map<String, dynamic> json) {
    return ConsignmentByIdResponse(
      status: json["status"],
      data: json["data"] == null
          ? null
          : ConsignmentByIdData.fromJson(json["data"]),
    );
  }
}

class ConsignmentByIdData {
  ConsignmentByIdData({
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
    required this.pickupCustomerId,
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
    required this.status,
    required this.consignmentDetails,
    required this.truckDetails,
    required this.customerPickupDetails,
    required this.customerDeliveryDetails,
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
  final String? pickupCustomerId;
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
  final String? status;
  List<ConsignmentDetail> consignmentDetails;
  final List<TruckDetail> truckDetails;
  final CustomerPickUpDetails? customerPickupDetails;
  final CustomerPickUpDetails? customerDeliveryDetails;

  factory ConsignmentByIdData.fromJson(Map<String, dynamic> json) {
    return ConsignmentByIdData(
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
      pickupCustomerId: json["pickup_customer_id"],
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
      status: json["status"],
      consignmentDetails: json["consignment_details"] == null
          ? []
          : List<ConsignmentDetail>.from(json["consignment_details"]!
              .map((x) => ConsignmentDetail.fromJson(x))),
      truckDetails: json["truck_details"] == null
          ? []
          : List<TruckDetail>.from(
              json["truck_details"]!.map((x) => TruckDetail.fromJson(x))),
      customerPickupDetails: json["customer_pickup_details"] == null
          ? null
          : CustomerPickUpDetails.fromJson(json["customer_pickup_details"]),
      customerDeliveryDetails: json["customer_delivery_details"] == null
          ? null
          : CustomerPickUpDetails.fromJson(json["customer_delivery_details"]),
    );
  }
}

class ConsignmentDetail {
  ConsignmentDetail({
    required this.consignmentDetailsId,
    required this.noOfItems,
    required this.freightDesc,
    required this.pallets,
    required this.spaces,
    required this.weight,
    required this.jobTemp,
    required this.recipientNo,
    required this.sendersNo,
    required this.equipment,
  });

  String? consignmentDetailsId;
  int? noOfItems;
  String? freightDesc;
  int? pallets;
  int? spaces;
  int? weight;
  String? jobTemp;
  String? recipientNo;
  String? sendersNo;
  String? equipment;

  factory ConsignmentDetail.fromJson(Map<String, dynamic> json) {
    return ConsignmentDetail(
      consignmentDetailsId: json["consignment_details_id"],
      noOfItems: json["no_of_items"],
      freightDesc: json["freight_desc"],
      pallets: json["pallets"],
      spaces: json["spaces"],
      weight: json["weight"],
      jobTemp: json["job_temp"],
      recipientNo: json["recipient_no"],
      sendersNo: json["senders_no"],
      equipment: json["equipment"],
    );
  }

  Map<String, dynamic> toJson() => {
        "consignment_details_id": consignmentDetailsId,
        "no_of_items": noOfItems,
        "freight_desc": freightDesc,
        "pallets": pallets,
        "spaces": spaces,
        "weight": weight,
        "job_temp": jobTemp,
        "recipient_no": recipientNo,
        "senders_no": sendersNo,
        "equipment": equipment,
      };
}

class CustomerPickUpDetails {
  CustomerPickUpDetails({
    required this.customerCompanyName,
  });

  final String? customerCompanyName;

  factory CustomerPickUpDetails.fromJson(Map<String, dynamic> json) {
    return CustomerPickUpDetails(
      customerCompanyName: json["customer_company_name"],
    );
  }
  Map<String, dynamic> toJson() => {
        "customer_company_name": customerCompanyName,
      };
}

class TruckDetail {
  TruckDetail({
    required this.truckDocumentId,
    required this.document,
    required this.truckType,
    required this.truckNumber,
  });

  final String? truckDocumentId;
  final String? document;
  final String? truckType;
  final String? truckNumber;

  factory TruckDetail.fromJson(Map<String, dynamic> json) {
    return TruckDetail(
      truckDocumentId: json["truck_document_id"],
      document: json["document"],
      truckType: json["truck_type"],
      truckNumber: json["truck_number"],
    );
  }
}
