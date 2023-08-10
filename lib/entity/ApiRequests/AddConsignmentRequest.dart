import 'dart:convert';

AddConsignmentRequest addConsignmentRequestFromJson(String str) =>
    AddConsignmentRequest.fromJson(json.decode(str));

String addConsignmentRequestToJson(AddConsignmentRequest data) =>
    json.encode(data.toJson());

class AddConsignmentRequest {
  String? companyId;
  String? jobNumber;
  String? bookedDate;
  String? pickupDate;
  String? deliveryDate;
  String? specialInstruction;
  String? manifestNumber;
  String? billingCustomer;
  String? billingAddress;
  String? billingAddressId;
  String? customerId;
  String? pickupCustomerId;

  String? customerAddress;
  String? suburb;
  String? zipCode;
  String? stateId;
  String? countryId;
  String? deliveryName;
  String? deliveryAddres;
  String? deliverySuburb;
  String? deliveryZipCode;
  String? deliveryStateId;
  String? deliveryCountryId;
  List<AddConsignmentDetail>? consignmentDetails;
  String? totalItems;
  String? totalPallets;
  String? totalSpaces;
  String? totalWeight;
  String? chep;
  String? loscom;
  String? plain;
  List<AddTruckDetail>? truckDetails;
  String? driverId;
  String? driverMobileNumber;

  AddConsignmentRequest({
    this.companyId,
    this.jobNumber,
    this.bookedDate,
    this.pickupDate,
    this.deliveryDate,
    this.specialInstruction,
    this.manifestNumber,
    this.billingCustomer,
    this.billingAddress,
    this.billingAddressId,
    this.customerId,
    this.pickupCustomerId,
    this.customerAddress,
    this.suburb,
    this.zipCode,
    this.stateId,
    this.countryId,
    this.deliveryName,
    this.deliveryAddres,
    this.deliverySuburb,
    this.deliveryZipCode,
    this.deliveryStateId,
    this.deliveryCountryId,
    this.consignmentDetails,
    this.totalItems,
    this.totalPallets,
    this.totalSpaces,
    this.totalWeight,
    this.chep,
    this.loscom,
    this.plain,
    this.truckDetails,
    this.driverId,
    this.driverMobileNumber,
  });

  factory AddConsignmentRequest.fromJson(Map<String, dynamic> json) =>
      AddConsignmentRequest(
        companyId: json["company_id"],
        jobNumber: json["job_number"],
        bookedDate: json["booked_date"],
        pickupDate: json["pickup_date"],
        deliveryDate: json["delivery_date"],
        specialInstruction: json["special_instruction"],
        manifestNumber: json["manifest_number"],
        billingCustomer: json["billing_customer"],
        billingAddress: json["billing_address"],
        billingAddressId: json["billing_address_id"],
        customerId: json["customer_id"],
        customerAddress: json["customer_address"],
        suburb: json["suburb"],
        zipCode: json["zip_code"],
        stateId: json["state_id"],
        countryId: json["country_id"],
        deliveryName: json["delivery_name"],
        deliveryAddres: json["delivery_addres"],
        deliverySuburb: json["delivery_suburb"],
        deliveryZipCode: json["delivery_zip_code"],
        deliveryStateId: json["delivery_state_id"],
        deliveryCountryId: json["delivery_country_id"],
        consignmentDetails: List<AddConsignmentDetail>.from(
            json["consignment_details"]
                .map((x) => AddConsignmentDetail.fromJson(x))),
        totalItems: json["total_items"],
        totalPallets: json["total_pallets"],
        totalSpaces: json["total_spaces"],
        totalWeight: json["total_weight"],
        chep: json["chep"],
        loscom: json["loscom"],
        plain: json["plain"],
        truckDetails: List<AddTruckDetail>.from(
            json["truck_details"].map((x) => AddTruckDetail.fromJson(x))),
        driverId: json["driver_id"],
        driverMobileNumber: json["driver_mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "job_number": jobNumber,
        "booked_date": bookedDate,
        "pickup_date": pickupDate,
        "delivery_date": deliveryDate,
        "special_instruction": specialInstruction,
        "manifest_number": manifestNumber,
        "billing_customer": billingCustomer,
        "billing_address": billingAddress,
        "billing_address_id": billingAddressId,
        "customer_id": customerId,
        "pickup_customer_id": pickupCustomerId,
        "customer_address": customerAddress,
        "suburb": suburb,
        "zip_code": zipCode,
        "state_id": stateId,
        "country_id": countryId,
        "delivery_name": deliveryName,
        "delivery_addres": deliveryAddres,
        "delivery_suburb": deliverySuburb,
        "delivery_zip_code": deliveryZipCode,
        "delivery_state_id": deliveryStateId,
        "delivery_country_id": deliveryCountryId,
        "consignment_details":
            List<dynamic>.from(consignmentDetails!.map((x) => x.toJson())),
        "total_items": totalItems,
        "total_pallets": totalPallets,
        "total_spaces": totalSpaces,
        "total_weight": totalWeight,
        "chep": chep,
        "loscom": loscom,
        "plain": plain,
        "truck_details":
            List<dynamic>.from(truckDetails!.map((x) => x.toJson())),
        "driver_id": driverId,
        "driver_mobile_number": driverMobileNumber,
      };
}

class AddConsignmentDetail {
  String? noOfItems;
  String? freightDesc;
  String? pallets;
  String? spaces;
  String? weight;
  String? jobTemp;
  String? recipientNo;
  String? sendersNo;
  String? equipment;

  AddConsignmentDetail({
    this.noOfItems,
    this.freightDesc,
    this.pallets,
    this.spaces,
    this.weight,
    this.jobTemp,
    this.recipientNo,
    this.sendersNo,
    this.equipment,
  });

  factory AddConsignmentDetail.fromJson(Map<String, dynamic> json) =>
      AddConsignmentDetail(
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

  Map<String, dynamic> toJson() => {
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

class AddTruckDetail {
  String? document;
  String? truckNumber;
  String? truckDocumentId;
  String? truckDetails;

  AddTruckDetail({
    this.document,
    this.truckNumber,
    this.truckDocumentId,
    this.truckDetails,
  });

  factory AddTruckDetail.fromJson(Map<String, dynamic> json) => AddTruckDetail(
        document: json["document"],
        truckNumber: json["truck_number"],
        truckDocumentId: json["truck_document_id"],
        truckDetails: json["truck_details"],
      );

  Map<String, dynamic> toJson() => {
        "document": document,
        "truck_number": truckNumber,
        "truck_document_id": truckDocumentId,
        "truck_details": truckDetails,
      };
}
