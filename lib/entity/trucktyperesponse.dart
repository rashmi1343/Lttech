import 'dart:convert';

TruckTypeResponse getalltrucktypeFromJson(String strauth) =>
    TruckTypeResponse.fromJson(json.decode(strauth));

String trucktypeToJson(TruckTypeResponse alltimesheetdata) =>
    json.encode(alltimesheetdata.toJson());

class TruckTypeResponse {
  late int? status;
  late List<TruckData>? data;

  TruckTypeResponse(this.status, this.data);

  TruckTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TruckData>[];
      json['data'].forEach((v) {
        data!.add(TruckData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TruckData {
  String? truckId;
  String? truckType;
  String? truckDetails;

  TruckData({this.truckId, this.truckType, this.truckDetails});

  TruckData.fromJson(Map<String, dynamic> json) {
    truckId = json['truck_id'];
    truckType = json['truck_type'];
    truckDetails = json['truck_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['truck_id'] = truckId;
    data['truck_type'] = truckType;
    data['truck_details'] = truckDetails;
    return data;
  }
}
