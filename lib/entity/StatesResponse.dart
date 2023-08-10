
import 'dart:convert';

StatesResponse statesResponseFromJson(String str) => StatesResponse.fromJson(json.decode(str));

class StatesResponse {
  StatesResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final List<StatesList> data;

  factory StatesResponse.fromJson(Map<String, dynamic> json){
    return StatesResponse(
      status: json["status"],
      data: json["data"] == null ? [] : List<StatesList>.from(json["data"]!.map((x) => StatesList.fromJson(x))),
    );
  }

}

class StatesList {
  StatesList({
    required this.id,
    required this.countryId,
    required this.stateName,
  });

  final int? id;
  final int? countryId;
  final String? stateName;

  factory StatesList.fromJson(Map<String, dynamic> json){
    return StatesList(
      id: json["id"],
      countryId: json["country_id"],
      stateName: json["state_name"],
    );
  }

}
