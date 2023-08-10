
import 'dart:convert';

import 'package:equatable/equatable.dart';

GetParticularCustomerAllAddressByCustomerId ParticularCustomerAllAddressResponseFromJson(
    String str) =>
    GetParticularCustomerAllAddressByCustomerId.fromJson(json.decode(str));

class GetParticularCustomerAllAddressByCustomerId {
  GetParticularCustomerAllAddressByCustomerId({
    required this.status,
    required this.data,
  });

  final int? status;
  final ParticularCustomerData? data;

  factory GetParticularCustomerAllAddressByCustomerId.fromJson(Map<String, dynamic> json){
    return GetParticularCustomerAllAddressByCustomerId(
      status: json["status"],
      data: json["data"] == null ? null : ParticularCustomerData.fromJson(json["data"]),
    );
  }

}

class ParticularCustomerData {
  ParticularCustomerData({
    required this.count,
    required this.rows,
  });

  final int? count;
  final List<ParticularCustomerRow> rows;

  factory ParticularCustomerData.fromJson(Map<String, dynamic> json){
    return ParticularCustomerData(
      count: json["count"],
      rows: json["rows"] == null ? [] : List<ParticularCustomerRow>.from(json["rows"]!.map((x) => ParticularCustomerRow.fromJson(x))),
    );
  }

}

class ParticularCustomerRow {
  ParticularCustomerRow({
    required this.customerAddressId,
    required this.customerId,
    required this.companyId,
    required this.customerCompanyName,
    required this.address,
    required this.suburb,
    required this.zipCode,
    required this.countryId,
    required this.stateId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.status,
    required this.defaultStatus,
    required this.countries,
    required this.customerstates,
  });

  final String? customerAddressId;
  final String? customerId;
  final String? companyId;
  final String? customerCompanyName;
  final String? address;
  final String? suburb;
  final String? zipCode;
  final int? countryId;
  final int? stateId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? isDeleted;
  final String? status;
  final String? defaultStatus;
  final Countries? countries;
  final Customerstates? customerstates;

  factory ParticularCustomerRow.fromJson(Map<String, dynamic> json){
    return ParticularCustomerRow(
      customerAddressId: json["customer_address_id"],
      customerId: json["customer_id"],
      companyId: json["company_id"],
      customerCompanyName: json["customer_company_name"],
      address: json["address"],
      suburb: json["suburb"],
      zipCode: json["zip_code"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isDeleted: json["is_deleted"],
      status: json["status"],
      defaultStatus: json["default_status"],
      countries: json["countries"] == null ? null : Countries.fromJson(json["countries"]),
      customerstates: json["customerstates"] == null ? null : Customerstates.fromJson(json["customerstates"]),
    );
  }




}

class Countries {
  Countries({
    required this.id,
    required this.countryName,
  });

  final int? id;
  final String? countryName;

  factory Countries.fromJson(Map<String, dynamic> json){
    return Countries(
      id: json["id"],
      countryName: json["country_name"],
    );
  }

}

class Customerstates {
  Customerstates({
    required this.id,
    required this.countryId,
    required this.stateName,
  });

  final int? id;
  final int? countryId;
  final String? stateName;

  factory Customerstates.fromJson(Map<String, dynamic> json){
    return Customerstates(
      id: json["id"],
      countryId: json["country_id"],
      stateName: json["state_name"],
    );
  }

}
