

import 'dart:convert';




SubmitDriverFitnessRequest submitchklistFromJson(String strchklist) =>
    SubmitDriverFitnessRequest.fromJson(json.decode(strchklist));

String submitchklistToJson(SubmitDriverFitnessRequest allchklist) =>
    json.encode(allchklist.toJson());



class SubmitDriverFitnessRequest {
  SubmitDriverFitnessRequest({
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
  List<driverfitnessdata> checklistvalue;


  factory SubmitDriverFitnessRequest.fromJson(Map<String, dynamic> json)=>
      SubmitDriverFitnessRequest(
          timesheetid: json['timesheetid'],
          driverid:json['driverid'],
          companyid :json['companyid'],
          checklistdate : json['checklistdate'],
          checklisttype : json['checklisttype'],
          checklistvalue : List<driverfitnessdata>.from(json["checklistvalue"]!.map((e)=>driverfitnessdata.fromJson(e))));


  Map<String, dynamic> toJson() => {
    "timesheetid" : timesheetid,
    "driverid" :driverid,
    "companyid" :companyid,
    "checklistdate" : checklistdate,
    "checklisttype" : checklisttype,
    "checklistvalue":checklistvalue==null?[]:List<dynamic>.from(checklistvalue!.map((x) => x.toJson())),
  };


}



class driverfitnessdata {
  driverfitnessdata({
    required this.checklistid,
    required this.checklistname,
    required this.checklist_value,
  });

  String checklistid='';
  String checklistname='';
  int checklist_value=0;

  /*driverfitnessdata chklistitemFromJson(String strchklist) =>
      driverfitnessdata.fromJson(json.decode(strchklist));

  String chklistitemToJson(driverfitnessdata allchklist) =>
      json.encode(allchklist.toJson());
*/

  factory driverfitnessdata.fromJson(Map<String, dynamic> json)=>
      driverfitnessdata(
          checklistid :json['checklistid'],
          checklistname : json['checklist_name'],
          checklist_value : json['Yes']
      );

  Map<String, dynamic> toJson() => {
    "checklistid": checklistid,
    "checklist_name": checklistname,
    "Yes" : checklist_value
  };
}