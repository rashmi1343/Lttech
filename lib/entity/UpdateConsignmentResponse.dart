// To parse this JSON data, do
//
//     final updateConsignmentResponse = updateConsignmentResponseFromJson(jsonString);

// import 'dart:convert';

// UpdateConsignmentResponse updateConsignmentResponseFromJson(String str) =>
//     UpdateConsignmentResponse.fromJson(json.decode(str));

// String updateConsignmentResponseToJson(UpdateConsignmentResponse data) =>
//     json.encode(data.toJson());

/*class UpdateConsignmentResponse {
  UpdateConsignmentResponse({
    required this.status,
    required this.updaterootdata,
  });
  late final int status;
  late final Updaterootdata  updaterootdata;

  UpdateConsignmentResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    updaterootdata = Updaterootdata.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = updaterootdata.toJson();
    return _data;
  }
}

class Updaterootdata  {
  Updaterootdata ({
    required this.success,
    required this.updateddata,
  });
  late final bool success;
  late final Updateddata updateddata;

  Updaterootdata.fromJson(Map<String, dynamic> json){
    success = json['success'];
    updateddata = Updateddata.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = updateddata.toJson();
    return _data;
  }
}

class Updateddata {
  Updateddata({
    required this.bookedDate,
    required this.pickupDate,
    required this.deliveryDate,
    required this.specialInstruction,
    required this.manifestNumber,
    required this.billingCustomer,
    required this.billingAddressId,
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
    required this.driverMobileNumber,
    required this.driverId,
    required this.createdBy,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final String bookedDate;
  late final String pickupDate;
  late final String deliveryDate;
  late final String specialInstruction;
  late final String manifestNumber;
  late final String billingCustomer;
  late final String billingAddressId;
  late final String customerAddress;
  late final String suburb;
  late final String zipCode;
  late final String stateId;
  late final String countryId;
  late final String chep;
  late final String loscom;
  late final String plain;
  late final String deliveryName;
  late final String deliveryAddres;
  late final String deliverySuburb;
  late final String deliveryZipCode;
  late final String deliveryStateId;
  late final String deliveryCountryId;
  late final int driverMobileNumber;
  late final String driverId;
  late final int createdBy;
  late final int updatedBy;
  late final String updatedAt;

  Updateddata.fromJson(Map<String, dynamic> json){
    bookedDate = json['booked_date'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'];
    specialInstruction = json['special_instruction'];
    manifestNumber = json['manifest_number'];
    billingCustomer = json['billing_customer'];
    billingAddressId = json['billing_address_id'];
    customerAddress = json['customer_address'];
    suburb = json['suburb'];
    zipCode = json['zip_code'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    chep = json['chep'];
    loscom = json['loscom'];
    plain = json['plain'];
    deliveryName = json['delivery_name'];
    deliveryAddres = json['delivery_addres'];
    deliverySuburb = json['delivery_suburb'];
    deliveryZipCode = json['delivery_zip_code'];
    deliveryStateId = json['delivery_state_id'];
    deliveryCountryId = json['delivery_country_id'];
    driverMobileNumber = json['driver_mobile_number'];
    driverId = json['driver_id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['booked_date'] = bookedDate;
    _data['pickup_date'] = pickupDate;
    _data['delivery_date'] = deliveryDate;
    _data['special_instruction'] = specialInstruction;
    _data['manifest_number'] = manifestNumber;
    _data['billing_customer'] = billingCustomer;
    _data['billing_address_id'] = billingAddressId;
    _data['customer_address'] = customerAddress;
    _data['suburb'] = suburb;
    _data['zip_code'] = zipCode;
    _data['state_id'] = stateId;
    _data['country_id'] = countryId;
    _data['chep'] = chep;
    _data['loscom'] = loscom;
    _data['plain'] = plain;
    _data['delivery_name'] = deliveryName;
    _data['delivery_addres'] = deliveryAddres;
    _data['delivery_suburb'] = deliverySuburb;
    _data['delivery_zip_code'] = deliveryZipCode;
    _data['delivery_state_id'] = deliveryStateId;
    _data['delivery_country_id'] = deliveryCountryId;
    _data['driver_mobile_number'] = driverMobileNumber;
    _data['driver_id'] = driverId;
    _data['created_by'] = createdBy;
    _data['updated_by'] = updatedBy;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
} */

// To parse this JSON data, do
//
//     final updateConsignmentResponse = updateConsignmentResponseFromJson(jsonString);

import 'dart:convert';

UpdateConsignmentResponse updateConsignmentResponseFromJson(String str) =>
    UpdateConsignmentResponse.fromJson(json.decode(str));

String updateConsignmentResponseToJson(UpdateConsignmentResponse data) =>
    json.encode(data.toJson());

class UpdateConsignmentResponse {
  int? status;
  UpdateConsignmentResponseData? data;

  UpdateConsignmentResponse({
    this.status,
    this.data,
  });

  factory UpdateConsignmentResponse.fromJson(Map<String, dynamic> json) =>
      UpdateConsignmentResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : UpdateConsignmentResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class UpdateConsignmentResponseData {
  bool? success;
  DataData? data;

  UpdateConsignmentResponseData({
    this.success,
    this.data,
  });

  factory UpdateConsignmentResponseData.fromJson(Map<String, dynamic> json) =>
      UpdateConsignmentResponseData(
        success: json["success"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class DataData {
  String? bookedDate;
  String? pickupDate;
  String? deliveryDate;
  String? specialInstruction;
  String? manifestNumber;
  String? billingCustomer;
  String? billingAddressId;
  String? pickupCustomerId;
  String? customerAddress;
  String? suburb;
  String? zipCode;
  int? stateId;
  int? countryId;
  String? chep;
  String? loscom;
  String? plain;
  String? deliveryName;
  String? deliveryAddres;
  String? deliverySuburb;
  String? deliveryZipCode;
  int? deliveryStateId;
  int? deliveryCountryId;
  String? driverMobileNumber;
  int? totalItems;
  int? totalPallets;
  int? totalSpaces;
  int? totalWeight;
  String? driverId;
  int? createdBy;
  int? updatedBy;
  String? updatedAt;

  DataData({
    this.bookedDate,
    this.pickupDate,
    this.deliveryDate,
    this.specialInstruction,
    this.manifestNumber,
    this.billingCustomer,
    this.billingAddressId,
    this.pickupCustomerId,
    this.customerAddress,
    this.suburb,
    this.zipCode,
    this.stateId,
    this.countryId,
    this.chep,
    this.loscom,
    this.plain,
    this.deliveryName,
    this.deliveryAddres,
    this.deliverySuburb,
    this.deliveryZipCode,
    this.deliveryStateId,
    this.deliveryCountryId,
    this.driverMobileNumber,
    this.totalItems,
    this.totalPallets,
    this.totalSpaces,
    this.totalWeight,
    this.driverId,
    this.createdBy,
    this.updatedBy,
    this.updatedAt,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        bookedDate: json["booked_date"],
        pickupDate: json["pickup_date"],
        deliveryDate: json["delivery_date"],
        specialInstruction: json["special_instruction"],
        manifestNumber: json["manifest_number"],
        billingCustomer: json["billing_customer"],
        billingAddressId: json["billing_address_id"],
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
        driverMobileNumber: json["driver_mobile_number"],
        totalItems: json["total_items"],
        totalPallets: json["total_pallets"],
        totalSpaces: json["total_spaces"],
        totalWeight: json["total_weight"],
        driverId: json["driver_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "booked_date": bookedDate,
        "pickup_date": pickupDate,
        "delivery_date": deliveryDate,
        "special_instruction": specialInstruction,
        "manifest_number": manifestNumber,
        "billing_customer": billingCustomer,
        "billing_address_id": billingAddressId,
        "pickup_customer_id": pickupCustomerId,
        "customer_address": customerAddress,
        "suburb": suburb,
        "zip_code": zipCode,
        "state_id": stateId,
        "country_id": countryId,
        "chep": chep,
        "loscom": loscom,
        "plain": plain,
        "delivery_name": deliveryName,
        "delivery_addres": deliveryAddres,
        "delivery_suburb": deliverySuburb,
        "delivery_zip_code": deliveryZipCode,
        "delivery_state_id": deliveryStateId,
        "delivery_country_id": deliveryCountryId,
        "driver_mobile_number": driverMobileNumber,
        "total_items": totalItems,
        "total_pallets": totalPallets,
        "total_spaces": totalSpaces,
        "total_weight": totalWeight,
        "driver_id": driverId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "updatedAt": updatedAt,
      };
}
