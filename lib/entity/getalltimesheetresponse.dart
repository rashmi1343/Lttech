import 'dart:convert';

getalltimesheetresponse getalltimesheetFromJson(String strauth) =>
    getalltimesheetresponse.fromJson(json.decode(strauth));

String authToJson(getalltimesheetresponse alltimesheetdata) =>
    json.encode(alltimesheetdata.toJson());

class getalltimesheetresponse {
  late int status;
  Alltimesheetdata? data;

  getalltimesheetresponse(status, data);

  getalltimesheetresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null
        ? Alltimesheetdata.fromJson(json['data'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data?.toJson();
    return data;
  }
}

class Alltimesheetdata {
  late int count;
  late List<Rows> rows;

  Alltimesheetdata(count, rows);

  Alltimesheetdata.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (rows != null) {
      data['rows'] = rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  late String timeId;
  late String timesheetId;
  late String companyId;
  late String timesheetDate;
  String? timesheetDateString;
  late String startTime;
  late String startOdometer;
  late String endTime;
  late String endOdometer;
  late String driverId;
  late String driverMobile;
  late String truck;
  late String trailer;
   String? signature;
  late String createdAt;
  late String updatedAt;
  late String isDeleted;
  late String status;
  late Drivers drivers;
  late List<GetRestdetails> restdetails;
   String? totalbreaktime;
    int? datediff;
  Rows(
      this.timeId,
      this.timesheetId,
      this.companyId,
      this.timesheetDate,
      this.timesheetDateString,
      this.startTime,
      this.startOdometer,
      this.endTime,
      this.endOdometer,
      this.driverId,
      this.driverMobile,
      this.truck,
      this.trailer,
      this.signature,
      this.createdAt,
      this.updatedAt,
      this.isDeleted,
      this.status,
      this.drivers,
      this.restdetails);

  Rows.fromJson(Map<String, dynamic> json) {
    timeId = json['time_id'];
    timesheetId = json['timesheet_id'];
    companyId = json['company_id'];
    timesheetDate = json['timesheet_date'];
    startTime = json['start_time'];
    startOdometer = json['start_odometer'];
    endTime = json['end_time'];
    endOdometer = json['end_odometer'];
    driverId = json['driver_id'];
    driverMobile = json['driver_mobile'];
    truck = json['truck'];
    trailer = json['trailer'];
    signature = json['signature'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isDeleted = json['is_deleted'];
    status = json['status'];
    if (status == "1") {
      status = "Approved";
    } else {
      status = "Rejected";
    }
    drivers =
        (json['drivers'] != null ? Drivers.fromJson(json['drivers']) : null)!;
    if (json['restdetails'] != null) {
      restdetails = <GetRestdetails>[];
      json['restdetails'].forEach((v) {
        restdetails.add(GetRestdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_id'] = timeId;
    data['timesheet_id'] = timesheetId;
    data['company_id'] = companyId;
    data['timesheet_date'] = timesheetDate;
    data['start_time'] = startTime;
    data['start_odometer'] = startOdometer;
    data['end_time'] = endTime;
    data['end_odometer'] = endOdometer;
    data['driver_id'] = driverId;
    data['driver_mobile'] = driverMobile;
    data['truck'] = truck;
    data['trailer'] = trailer;
    data['signature'] = signature;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['is_deleted'] = isDeleted;
    data['status'] = status;
    if (drivers != null) {
      data['drivers'] = drivers.toJson();
    }
    if (restdetails != null) {
      data['restdetails'] = restdetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Drivers {
  late String title;
  late String firstName;
  late String lastName;

  Drivers(this.title, this.firstName, this.lastName);

  Drivers.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

class GetRestdetails {
  late String startTime;
  late String endTime;
  late String breakTime;
  GetRestdetails(this.startTime, this.endTime);

  GetRestdetails.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
