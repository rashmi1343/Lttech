import '../ConsignmentByIdResponse.dart';

// class Updateconsignmentrequest {
//   String? consignmentId;
//   String? companyId;
//   String? jobNumber;
//   String? bookedDate;
//   String? pickupDate;
//   String? deliveryDate;
//   String? specialInstruction;
//   String? manifestNumber;
//   String? billingCustomer;
//   String? billingAddress;
//   String? billingAddressId;
//   String? customerId;
//   String? customerAddress;
//   String? suburb;
//   String? zipCode;
//   String? stateId;
//   String? countryId;
//   String? deliveryName;
//   String? deliveryAddres;
//   String? deliverySuburb;
//   String? deliveryZipCode;
//   String? deliveryStateId;
//   String? deliveryCountryId;

//   List<ConsignmentDetail>? consignmentDetails = [];
//   String? chep;
//   String? loscom;
//   String? plain;
//   List<TruckDetails>? truckDetails;
//   String? driverId;
//   int? driverMobileNumber;

//   Updateconsignmentrequest(
//       {this.consignmentId,
//       this.companyId,
//       this.jobNumber,
//       this.bookedDate,
//       this.pickupDate,
//       this.deliveryDate,
//       this.specialInstruction,
//       this.manifestNumber,
//       this.billingCustomer,
//       this.billingAddress,
//       this.billingAddressId,
//       this.customerId,
//       this.customerAddress,
//       this.suburb,
//       this.zipCode,
//       this.stateId,
//       this.countryId,
//       this.deliveryName,
//       this.deliveryAddres,
//       this.deliverySuburb,
//       this.deliveryZipCode,
//       this.deliveryStateId,
//       this.deliveryCountryId,
//       this.consignmentDetails,
//       this.chep,
//       this.loscom,
//       this.plain,
//       this.truckDetails,
//       this.driverId,
//       this.driverMobileNumber});

//   Updateconsignmentrequest.fromJson(Map<String, dynamic> json) {
//     consignmentId = json['consignment_id'];
//     companyId = json['company_id'];
//     jobNumber = json['job_number'];
//     bookedDate = json['booked_date'];
//     pickupDate = json['pickup_date'];
//     deliveryDate = json['delivery_date'];
//     specialInstruction = json['special_instruction'];
//     manifestNumber = json['manifest_number'];
//     billingCustomer = json["billing_customer"];
//     billingAddress = json["billing_address"];
//     billingAddressId = json["billing_address_id"];
//     customerId = json['customer_id'];
//     customerAddress = json['customer_address'];
//     suburb = json['suburb'];
//     zipCode = json['zip_code'];
//     stateId = json['state_id'];
//     countryId = json['country_id'];
//     deliveryName = json['delivery_name'];
//     deliveryAddres = json['delivery_addres'];
//     deliverySuburb = json['delivery_suburb'];
//     deliveryZipCode = json['delivery_zip_code'];
//     deliveryStateId = json['delivery_state_id'];
//     deliveryCountryId = json['delivery_country_id'];
//     if (json['consignment_details'] != null) {
//       consignmentDetails = <ConsignmentDetail>[];
//       json['consignment_details'].forEach((v) {
//         consignmentDetails!.add(new ConsignmentDetail.fromJson(v));
//       });
//     }
//     chep = json['chep'];
//     loscom = json['loscom'];
//     plain = json['plain'];
//     if (json['truck_details'] != null) {
//       truckDetails = <TruckDetails>[];
//       json['truck_details'].forEach((v) {
//         truckDetails!.add(new TruckDetails.fromJson(v));
//       });
//     }
//     driverId = json['driver_id'];
//     driverMobileNumber = json['driver_mobile_number'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['consignment_id'] = consignmentId;
//     data['company_id'] = companyId;
//     data['job_number'] = jobNumber;
//     data['booked_date'] = bookedDate;
//     data['pickup_date'] = pickupDate;
//     data['delivery_date'] = deliveryDate;
//     data['special_instruction'] = specialInstruction;
//     data['manifest_number'] = manifestNumber;
//     data['billing_customer'] = billingCustomer;
//     data['billing_address'] = billingAddress;
//     data['billing_address_id'] = billingAddressId;
//     data['customer_id'] = customerId;
//     data['customer_address'] = customerAddress;
//     data['suburb'] = suburb;
//     data['zip_code'] = zipCode;
//     data['state_id'] = int.parse(stateId ?? "");
//     data['country_id'] = int.parse(countryId ?? "");
//     data['delivery_name'] = deliveryName;
//     data['delivery_addres'] = deliveryAddres;
//     data['delivery_suburb'] = deliverySuburb;
//     data['delivery_zip_code'] = deliveryZipCode;
//     data['delivery_state_id'] = int.parse(deliveryStateId ?? "");
//     data['delivery_country_id'] = int.parse(deliveryCountryId ?? "");

//     if (consignmentDetails != null) {
//       data['consignment_details'] =
//           consignmentDetails!.map((v) => v.toJson()).toList();
//     }
//     data['chep'] = chep;
//     data['loscom'] = loscom;
//     data['plain'] = plain;
//     if (truckDetails != null) {
//       data['truck_details'] = truckDetails!.map((v) => v.toJson()).toList();
//     }
//     data['driver_id'] = driverId;
//     data['driver_mobile_number'] = driverMobileNumber.toString();
//     return data;
//   }
// }

// class ConsignmentDetails {
//   String? consignmentDetailsId;
//   int? noOfItems;
//   String? freightDesc;
//   int? pallets;
//   int? spaces;
//   int? weight;
//   String? jobTemp;
//   String? recipientNo;
//   String? sendersNo;
//   String? equipment;

//   ConsignmentDetails(
//       {this.consignmentDetailsId,
//       this.noOfItems,
//       this.freightDesc,
//       this.pallets,
//       this.spaces,
//       this.weight,
//       this.jobTemp,
//       this.recipientNo,
//       this.sendersNo,
//       this.equipment});

//   ConsignmentDetails.fromJson(Map<String, dynamic> json) {
//     consignmentDetailsId = json['consignment_details_id'];
//     noOfItems = json['no_of_items'];
//     freightDesc = json['freight_desc'];
//     pallets = json['pallets'];
//     spaces = json['spaces'];
//     weight = json['weight'];
//     jobTemp = json['job_temp'];
//     recipientNo = json['recipient_no'];
//     sendersNo = json['senders_no'];
//     equipment = json['equipment'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['consignment_details_id'] = consignmentDetailsId;
//     data['no_of_items'] = noOfItems;
//     data['freight_desc'] = freightDesc;
//     data['pallets'] = pallets;
//     data['spaces'] = spaces;
//     data['weight'] = weight;
//     data['job_temp'] = jobTemp;
//     data['recipient_no'] = recipientNo;
//     data['senders_no'] = sendersNo;
//     data['equipment'] = equipment;
//     return data;
//   }
// }

// class TruckDetails {
//   String? document;
//   String? truckType;
//   String? truckNumber;
//   String? truckDocumentId;

//   TruckDetails(
//       {this.document, this.truckType, this.truckNumber, this.truckDocumentId});

//   TruckDetails.fromJson(Map<String, dynamic> json) {
//     document = json['document'];
//     truckType = json['truck_type'];
//     truckNumber = json['truck_number'];
//     truckDocumentId = json['truck_document_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['document'] = document;
//     data['truck_type'] = truckType;
//     data['truck_number'] = truckNumber;
//     data['truck_document_id'] = truckDocumentId;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final updateconsignmentrequest = updateconsignmentrequestFromJson(jsonString);

// To parse this JSON data, do
//
//     final updateconsignmentrequest = updateconsignmentrequestFromJson(jsonString);

import 'dart:convert';

Updateconsignmentrequest updateconsignmentrequestFromJson(String str) =>
    Updateconsignmentrequest.fromJson(json.decode(str));

String updateconsignmentrequestToJson(Updateconsignmentrequest data) =>
    json.encode(data.toJson());

class Updateconsignmentrequest {
  String? consignmentId;
  String? companyId;
  String? jobNumber;
  String? bookedDate;
  String? pickupDate;
  String? deliveryDate;
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
  List<ConsignmentDetail>? consignmentDetails;
  CustomerPickUpDetails? customerPickupDetails;
  CustomerPickUpDetails? customerDeliveryDetails;
  List<TruckDetail>? truckDetails;

  Updateconsignmentrequest({
    this.consignmentId,
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
    this.consignmentDetails,
    this.customerPickupDetails,
    this.customerDeliveryDetails,
    this.truckDetails,
  });

  factory Updateconsignmentrequest.fromJson(Map<String, dynamic> json) =>
      Updateconsignmentrequest(
        consignmentId: json["consignment_id"],
        companyId: json["company_id"],
        jobNumber: json["job_number"],
        bookedDate: json["booked_date"],
        pickupDate: json["pickup_date"],
        deliveryDate: json["delivery_date"],
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
        totalPallets: json["total_pallets"],
        totalSpaces: json["total_spaces"],
        totalWeight: json["total_weight"],
        consignmentDetails: json["consignment_details"] == null
            ? []
            : List<ConsignmentDetail>.from(json["consignment_details"]!
                .map((x) => ConsignmentDetail.fromJson(x))),
        customerPickupDetails: json["customer_pickup_details"] == null
            ? null
            : CustomerPickUpDetails.fromJson(json["customer_pickup_details"]),
        customerDeliveryDetails: json["customer_delivery_details"] == null
            ? null
            : CustomerPickUpDetails.fromJson(json["customer_delivery_details"]),
        truckDetails: json["truck_details"] == null
            ? []
            : List<TruckDetail>.from(
                json["truck_details"]!.map((x) => TruckDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "consignment_id": consignmentId,
        "company_id": companyId,
        "job_number": jobNumber,
        "booked_date": bookedDate,
        "pickup_date": pickupDate,
        "delivery_date": deliveryDate, //?.toIso8601String(),
        "special_instruction": specialInstruction,
        "manifest_number": manifestNumber,
        "billing_customer": billingCustomer,
        "billing_address_id": billingAddressId,
        "billing_address": billingAddress,
        "customer_id": customerId,
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
        "driver_id": driverId,
        "driver_mobile_number": driverMobileNumber,
        "total_items": totalItems,
        "total_pallets": totalPallets,
        "total_spaces": totalSpaces,
        "total_weight": totalWeight,
        "consignment_details": consignmentDetails == null
            ? []
            : List<dynamic>.from(consignmentDetails!.map((x) => x.toJson())),
        "customer_pickup_details": customerPickupDetails?.toJson(),
        "customer_delivery_details": customerDeliveryDetails?.toJson(),
        "truck_details": truckDetails == null
            ? []
            : List<dynamic>.from(truckDetails!.map((x) => x.toJson())),
      };
}

// class ConsignmentDetail {
//   String? consignmentDetailsId;
//   int? noOfItems;
//   String? freightDesc;
//   int? pallets;
//   int? spaces;
//   int? weight;
//   String? jobTemp;
//   String? recipientNo;
//   String? sendersNo;
//   String? equipment;

//   ConsignmentDetail({
//     this.consignmentDetailsId,
//     this.noOfItems,
//     this.freightDesc,
//     this.pallets,
//     this.spaces,
//     this.weight,
//     this.jobTemp,
//     this.recipientNo,
//     this.sendersNo,
//     this.equipment,
//   });

//   factory ConsignmentDetail.fromJson(Map<String, dynamic> json) =>
//       ConsignmentDetail(
//         consignmentDetailsId: json["consignment_details_id"],
//         noOfItems: json["no_of_items"],
//         freightDesc: json["freight_desc"],
//         pallets: json["pallets"],
//         spaces: json["spaces"],
//         weight: json["weight"],
//         jobTemp: json["job_temp"],
//         recipientNo: json["recipient_no"],
//         sendersNo: json["senders_no"],
//         equipment: json["equipment"],
//       );

//   Map<String, dynamic> toJson() => {
//         "consignment_details_id": consignmentDetailsId,
//         "no_of_items": noOfItems,
//         "freight_desc": freightDesc,
//         "pallets": pallets,
//         "spaces": spaces,
//         "weight": weight,
//         "job_temp": jobTemp,
//         "recipient_no": recipientNo,
//         "senders_no": sendersNo,
//         "equipment": equipment,
//       };
// }

// class CustomerDetails {
//   String? customerCompanyName;

//   CustomerDetails({
//     this.customerCompanyName,
//   });

//   factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
//       CustomerDetails(
//         customerCompanyName: json["customer_company_name"],
//       );

// Map<String, dynamic> toJson() => {
//       "customer_company_name": customerCompanyName,
//     };
// }

class TruckDetail {
  List<dynamic>? document;
  String? truckDetails;
  String? truckNumber;
  String? truckDocumentId;

  TruckDetail({
    this.document,
    this.truckDetails,
    this.truckNumber,
    this.truckDocumentId,
  });

  factory TruckDetail.fromJson(Map<String, dynamic> json) => TruckDetail(
        document: json["document"] == null
            ? []
            : List<dynamic>.from(json["document"]!.map((x) => x)),
        truckDetails: json["truck_details"],
        truckNumber: json["truck_number"],
        truckDocumentId: json["truck_document_id"],
      );

  Map<String, dynamic> toJson() => {
        "document":
            document == null ? [] : List<dynamic>.from(document!.map((x) => x)),
        "truck_details": truckDetails,
        "truck_number": truckNumber,
        "truck_document_id": truckDocumentId,
      };
}
