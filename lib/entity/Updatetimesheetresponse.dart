

import 'dart:convert';

Updatetimesheetresponse updatetimesheetResponseFromJson(String str) => Updatetimesheetresponse.fromJson(json.decode(str));

String updatetimesheetResponseToJson(Updatetimesheetresponse data) => json.encode(data.toJson());

class Updatetimesheetresponse {
  Updatetimesheetresponse({
    required this.status,
    required this.rootdata,
  });
  late final int status;
  late final Rootdata rootdata;

  Updatetimesheetresponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    rootdata = Rootdata.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = rootdata.toJson();
    return _data;
  }
}

class Rootdata {
  Rootdata({
    required this.success,
    required this.subdata,
  });
  late final bool success;
  late final Subdata subdata;

  Rootdata.fromJson(Map<String, dynamic> json){
    success = json['success'];
    subdata = Subdata.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = subdata.toJson();
    return _data;
  }
}

class Subdata {
  Subdata({
    required this.timesheetDate,
    required this.startTime,
    required this.startOdometer,
    required this.endTime,
    required this.endOdometer,
    required this.driverId,
    required this.driverMobile,
    required this.truck,
    required this.trailer,
    required this.updatedAt,
  });
  late final String timesheetDate;
  late final String startTime;
  late final String startOdometer;
  late final String endTime;
  late final String endOdometer;
  late final String driverId;
  late final String driverMobile;
  late final String truck;
  late final String trailer;
  late final String updatedAt;

  Subdata.fromJson(Map<String, dynamic> json){
    timesheetDate = json['timesheet_date'];
    startTime = json['start_time'];
    startOdometer = json['start_odometer'];
    endTime = json['end_time'];
    endOdometer = json['end_odometer'];
    driverId = json['driver_id'];
    driverMobile = json['driver_mobile'];
    truck = json['truck'];
    trailer = json['trailer'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['timesheet_date'] = timesheetDate;
    _data['start_time'] = startTime;
    _data['start_odometer'] = startOdometer;
    _data['end_time'] = endTime;
    _data['end_odometer'] = endOdometer;
    _data['driver_id'] = driverId;
    _data['driver_mobile'] = driverMobile;
    _data['truck'] = truck;
    _data['trailer'] = trailer;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

/*
class Updatetimesheetresponse {
  Updatetimesheetresponse({
   this.status,
    required this.data,
  });
  late final int? status;
  late final updatetimesheetData data;

  Updatetimesheetresponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = updatetimesheetData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class updatetimesheetData {
  updatetimesheetData({
     this.success,
     this.data,
  });
  late final bool? success;
  late final updatetimesheetdatadata? data;

  updatetimesheetData.fromJson(Map<String, dynamic> json){
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


class updatetimesheetdatadata {

  updatetimesheetdatadata({
    required timesheetdate,
    required starttime,
    required startodometer,
    required endtime,
    required endodometer,
    required driver_id,
    required drivermob,
    required truck,
    required trailer,
    required updatedAt
});


  DateTime? timesheetdate;
  String? starttime;
  int? startodometer;
  String? endtime;
  int? endodometer;
  String? driver_id;
  String? drivermob;
  String? truck;
   List<String>? trailer;
   String? updatedAt;

  updatetimesheetdatadata.fromJson(Map<String, dynamic> json){
    timesheetdate = json['timesheet_date'];
    starttime = json['start_time'];
    startodometer = json['start_odometer'];
    endtime = json['end_time'];
    endodometer = json['end_odometer'];
    driver_id = json['driver_id'];
    drivermob = json['driver_mobile'];
    truck = json['truck'];
    trailer = json['trailer'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['timesheet_date'] = timesheetdate;
    _data['starttime'] = starttime;
    _data['start_odometer'] = startodometer;
    _data['end_time'] = endtime;
    _data['end_odometer'] = endodometer;
    _data['driver_id'] = driver_id;
    _data['driver_mobile'] = drivermob;
    _data['truck'] = truck;
    _data['trailer'] = trailer;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}*/

