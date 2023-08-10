
import 'dart:convert';

Driverjobsresponse driverjobsResponseFromJson(String str) =>
    Driverjobsresponse.fromJson(json.decode(str));

String getdriverjobResponseToJson(Driverjobsresponse data) =>
    json.encode(data.toJson());


class Driverjobsresponse {
  int? status;
  late Driverjobsdata data;

  Driverjobsresponse({this.status, required this.data});

  Driverjobsresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? new Driverjobsdata.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Driverjobsdata {
  bool? success;
  late List<Driverjob> data;

  Driverjobsdata({this.success, required this.data});

  Driverjobsdata.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Driverjob>[];
      json['data'].forEach((v) {
        data!.add(new Driverjob.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Driverjob {
  String? consignmentId;
  String? companyId;
  String? jobNumber;
  String? bookedDate;
  DateTime? pickupDate;
  DateTime? deliveryDate;
  String? specialInstruction;
  String? manifestNumber;
  String? billingCustomer;
  String? billingAddressId;
  String? billingAddress;
  String? customerId;
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
  String? driverId;
  String? driverMobileNumber;
  int? totalItems;
  int? totalPallets;
  int? totalSpaces;
  int? totalWeight;
  CustomerDetails? customerDetails;

  Driverjob(
      {this.consignmentId,
        this.companyId,
        this.jobNumber,
        this.bookedDate,
        this.pickupDate,
        this.deliveryDate,
        this.specialInstruction,
        this.manifestNumber,
        this.billingCustomer,
        this.billingAddressId,
        this.billingAddress,
        this.customerId,
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
        this.driverId,
        this.driverMobileNumber,
        this.totalItems,
        this.totalPallets,
        this.totalSpaces,
        this.totalWeight,
        this.customerDetails});

  Driverjob.fromJson(Map<String, dynamic> json) {
    consignmentId = json['consignment_id'];
    companyId = json['company_id'];
    jobNumber = json['job_number'];
    bookedDate = json['booked_date'];
    pickupDate =  DateTime.parse(json["pickup_date"]);
    deliveryDate = DateTime.parse(json["delivery_date"]);
    specialInstruction = json['special_instruction'];
    manifestNumber = json['manifest_number'];
    billingCustomer = json['billing_customer'];
    billingAddressId = json['billing_address_id'];
    billingAddress = json['billing_address'];
    customerId = json['customer_id'];
    pickupCustomerId = json['pickup_customer_id'];
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
    driverId = json['driver_id'];
    driverMobileNumber = json['driver_mobile_number'];
    totalItems = json['total_items'];
    totalPallets = json['total_pallets'];
    totalSpaces = json['total_spaces'];
    totalWeight = json['total_weight'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consignment_id'] = this.consignmentId;
    data['company_id'] = this.companyId;
    data['job_number'] = this.jobNumber;
    data['booked_date'] = this.bookedDate;
    data['pickup_date'] = this.pickupDate!.toIso8601String();
    data['delivery_date'] = this.deliveryDate!.toIso8601String();
    data['special_instruction'] = this.specialInstruction;
    data['manifest_number'] = this.manifestNumber;
    data['billing_customer'] = this.billingCustomer;
    data['billing_address_id'] = this.billingAddressId;
    data['billing_address'] = this.billingAddress;
    data['customer_id'] = this.customerId;
    data['pickup_customer_id'] = this.pickupCustomerId;
    data['customer_address'] = this.customerAddress;
    data['suburb'] = this.suburb;
    data['zip_code'] = this.zipCode;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['chep'] = this.chep;
    data['loscom'] = this.loscom;
    data['plain'] = this.plain;
    data['delivery_name'] = this.deliveryName;
    data['delivery_addres'] = this.deliveryAddres;
    data['delivery_suburb'] = this.deliverySuburb;
    data['delivery_zip_code'] = this.deliveryZipCode;
    data['delivery_state_id'] = this.deliveryStateId;
    data['delivery_country_id'] = this.deliveryCountryId;
    data['driver_id'] = this.driverId;
    data['driver_mobile_number'] = this.driverMobileNumber;
    data['total_items'] = this.totalItems;
    data['total_pallets'] = this.totalPallets;
    data['total_spaces'] = this.totalSpaces;
    data['total_weight'] = this.totalWeight;
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    return data;
  }
}

class CustomerDetails {
  String? firstName;
  String? lastName;

  CustomerDetails({this.firstName, this.lastName});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}