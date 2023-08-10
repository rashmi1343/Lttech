

import 'dart:convert';

FitnessSubmittedResponse fitnesssubmittedFromJson(String strchklist) =>
    FitnessSubmittedResponse.fromJson(json.decode(strchklist));

String fitnesssubmittedToJson(FitnessSubmittedResponse allchklist) =>
    json.encode(allchklist.toJson());

class FitnessSubmittedResponse {
  FitnessSubmittedResponse({
    required this.status,
    required this.data,
  });
  late final int status;
  late final fitnessData data;

  FitnessSubmittedResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = fitnessData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class fitnessData {
  fitnessData({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final String data;

  fitnessData.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data;
    return _data;
  }
}