

import 'dart:convert';
import 'dart:ffi';

import '../FitnessVehicleChecklistApiResponse.dart';



SubmitVehicleFitnessRequest getallchklistFromJson(String strchklist) =>
    SubmitVehicleFitnessRequest.fromJson(json.decode(strchklist));

String chklistToJson(SubmitVehicleFitnessRequest allchklist) =>
    json.encode(allchklist.toJson());



class SubmitVehicleFitnessRequest {
  SubmitVehicleFitnessRequest({
    required this.timesheetid,
    required this.driverid,
    required this.companyid,
    required this.checklistdate,
    required this.checklisttype,
    required this.checklistvalue
  });

  String timesheetid = '';
  String driverid='';
  String companyid='';
  String checklistdate='';
  String checklisttype='';
  List<vehiclefitnessdata> checklistvalue=[];


  factory SubmitVehicleFitnessRequest.fromJson(Map<String, dynamic> json)=>
      SubmitVehicleFitnessRequest(timesheetid: json['timesheetid'],
      driverid : json['driverid'],
    companyid : json['companyid'],
    checklistdate : json['checklistdate'],
    checklisttype : json['checklisttype'],
          checklistvalue : jsonDecode(json['arrvehiclefitnessdata'])==null?[]:List<vehiclefitnessdata>.from(json['arrvehiclefitnessdata']!.map((e)=>vehiclefitnessdata.fromJson(e))));

  Map<String, dynamic> toJson() => {
    'timesheetid' : timesheetid,
    'driverid' : driverid,
    'companyid': companyid,
    'checklistdate': checklistdate,
    'checklisttype' : checklisttype,
    //'arrvehiclefitnessdata' : checklistvalue==null?[]:List<dynamic>.from(checklistvalue!.map((x) => x.toJson())),
    'checklistvalue':List<dynamic>.from(checklistvalue!.map((x) => x.toJson())),


  };
}



class vehiclefitnessdata {
  vehiclefitnessdata({
    required this.checklistid,
    required this.checklistname,
    required this.description,
    required this.subcategories,
  });

  String checklistid='';
  String checklistname='';
  String description='';
  List<subcategoriesdata> subcategories=[];
  bool isExpanded = false;
  bool isallselect = false;
  vehiclefitnessdata chklistitemFromJson(String strchklist) =>
      vehiclefitnessdata.fromJson(json.decode(strchklist));

  String chklistitemToJson(vehiclefitnessdata allchklist) =>
      json.encode(allchklist.toJson());


 factory vehiclefitnessdata.fromJson(Map<String, dynamic> json) =>
 vehiclefitnessdata(checklistid : json['checklistid'],
    checklistname :json['checklist_name'],
     description: json['description'],
    subcategories : List<subcategoriesdata>.from(json['subcategories']!.map((e)=>subcategoriesdata.fromJson(e))));


  Map<String, dynamic> toJson() => {

    'checklistid':checklistid,
    'checklist_name': checklistname,
    'description': description,
   'subcategories': subcategories==null?[]:List<dynamic>.from(subcategories!.map((x) => x.toJson())),

  };
}