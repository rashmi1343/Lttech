
import 'dart:convert';

VehicleRegistrationResponseList getallregvehiclelistFromJson(String strauth) =>
    VehicleRegistrationResponseList.fromJson(json.decode(strauth));

String regvehicleToJson(VehicleRegistrationResponseList alltimesheetdata) =>
    json.encode(alltimesheetdata.toJson());

class VehicleRegistrationResponseList {
  VehicleRegistrationResponseList({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<RegistrationList> data;

  VehicleRegistrationResponseList.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>RegistrationList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class RegistrationList{
  RegistrationList({
    required this.truckSetupId,
    required this.truckRegistration,
    required this.companyId,
  });
  late final String truckSetupId;
  late final String truckRegistration;
  late final String companyId;

  RegistrationList.fromJson(Map<String, dynamic> json){
    truckSetupId = json['truck_setup_id'];
    truckRegistration = json['truck_registration'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['truck_setup_id'] = truckSetupId;
    _data['truck_registration'] = truckRegistration;
    _data['company_id'] = companyId;
    return _data;
  }
}