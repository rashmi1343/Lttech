

import 'dart:convert';
import 'dart:ui';

import '../utility/ColorTheme.dart';



FitnessVehicleChecklistApiResponse getallfitnesschklistFromJson(String strchklist) =>
    FitnessVehicleChecklistApiResponse.fromJson(json.decode(strchklist));

String chklistToJson(FitnessVehicleChecklistApiResponse allchklist) =>
    json.encode(allchklist.toJson());





class FitnessVehicleChecklistApiResponse {
  FitnessVehicleChecklistApiResponse({
    required this.status,
    required this.fcdata,
  });

  late final int status;
  late final List<FitnessChecklistData> fcdata;

  FitnessVehicleChecklistApiResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    fcdata = List.from(json['data']).map((e)=>FitnessChecklistData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = fcdata.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FitnessColorData {
  FitnessColorData({
    required this.YesColor,
    required this.NoColor
});
  late Color YesColor;
  late Color NoColor;
}

class FitnessChecklistData {
  FitnessChecklistData({
    required this.id,
    required this.checklistName,
    required this.subcategories,
    required this.description
  });
  late final String id;
  late final String checklistName;
  String? description;
  late final List<subcategoriesdata> subcategories;
  bool isYes=false;
  bool isNo=false;
  bool isall=false;
 Color YesColor=ThemeColor.themeLightGrayColor;
  Color NoColor=ThemeColor.themeLightGrayColor;

  FitnessChecklistData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    checklistName = json['checklist_name'];
    description = json['description'];
    subcategories =List.from(json['subcategories']).map((e)=>subcategoriesdata.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['checklist_name'] = checklistName;
    _data['description'] = description;
    _data['subcategories'] = subcategories;
    return _data;
  }
}

class subcategoriesdata {
  subcategoriesdata({
    required this.id,
    required this.checklistname,
    required this.checklistvalue
  });
  late String id;
  late String checklistname;
  bool checklistvalue=false;

  factory subcategoriesdata.fromJson(Map<String, dynamic> json) =>
      subcategoriesdata(
          id:json['id'],
          checklistname :json['checklist_name'],
          checklistvalue : json['checklistvalue']==null?false:json['checklistvalue']);


  Map<String, dynamic> toJson() => {

    'id' : id,
    'checklist_name': checklistname,
    'checklistvalue':checklistvalue ==null?false:checklistvalue

  };
}