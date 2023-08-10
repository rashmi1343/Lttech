
import 'dart:convert';

CompanyDriverList companydriverFromJson(String str) =>
    CompanyDriverList.fromJson(json.decode(str));

class CompanyDriverList {
  CompanyDriverList({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<CompanyData> data;

  CompanyDriverList.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>CompanyData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CompanyData {
  CompanyData({
    required this.companyId,
    required this.companyName,
  });
  late final String companyId;
  late final String companyName;

  CompanyData.fromJson(Map<String, dynamic> json){
    companyId = json['company_id'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['company_id'] = companyId;
    _data['company_name'] = companyName;
    return _data;
  }
}