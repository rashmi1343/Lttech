
import 'dart:convert';

Filltimesheetresponse filltimesheetFromJson(String strauth) =>
    Filltimesheetresponse.fromJson(json.decode(strauth));

String filltimesheetToJson(Filltimesheetresponse filltimesheetdata) =>
    json.encode(filltimesheetdata.toJson());

class Filltimesheetresponse {
  late int status;
  late filltimesheetData data;

  Filltimesheetresponse( this.status,  this.data);

  Filltimesheetresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? new filltimesheetData.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class filltimesheetData {
  late String timeId;
  late String timesheetId;
  late String companyId;
  late String timesheetDate;
  late String startTime;
  late String startOdometer;
  late String endTime;
  late String endOdometer;
  late String driverId;
  late String driverMobile;
  late String truck;
  late List<String> trailer;
  late String signature;
  late List<Timesheetjobs> timesheetjobs;
  late List<FillRestdetails> restdetails;

  filltimesheetData(
      this.timeId,
        this.timesheetId,
        this.companyId,
        this.timesheetDate,
        this.startTime,
        this.startOdometer,
        this.endTime,
        this.endOdometer,
        this.driverId,
        this.driverMobile,
        this.truck,
        this.trailer,
        this.signature,
        this.timesheetjobs,
        this.restdetails);

  filltimesheetData.fromJson(Map<String, dynamic> json) {
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
    trailer = json['trailer'].cast<String>();
    signature = json['signature'];
    if (json['timesheetjobs'] != null) {
      timesheetjobs = <Timesheetjobs>[];
      json['timesheetjobs'].forEach((v) {
        timesheetjobs.add(new Timesheetjobs.fromJson(v));
      });
    }
    if (json['restdetails'] != null) {
      restdetails = <FillRestdetails>[];
      json['restdetails'].forEach((v) {
        restdetails.add(new FillRestdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_id'] = this.timeId;
    data['timesheet_id'] = this.timesheetId;
    data['company_id'] = this.companyId;
    data['timesheet_date'] = this.timesheetDate;
    data['start_time'] = this.startTime;
    data['start_odometer'] = this.startOdometer;
    data['end_time'] = this.endTime;
    data['end_odometer'] = this.endOdometer;
    data['driver_id'] = this.driverId;
    data['driver_mobile'] = this.driverMobile;
    data['truck'] = this.truck;
    data['trailer'] = this.trailer;
    data['signature'] = this.signature;
    if (this.timesheetjobs != null) {
      data['timesheetjobs'] =
          this.timesheetjobs.map((v) => v.toJson()).toList();
    }
    if (this.restdetails != null) {
      data['restdetails'] = this.restdetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timesheetjobs {
  late String timesheetJobId;
  late String timesheetId;
  late String companyId;
  late String consignmentId;
  late String jobName;
  late String customerName;
  late String address;
  late String suburb;
  late String arrivalTime;
  late String departTime;
  late String pickup;
  late String delivery;
  late String referenceNumber;
  late String temp;
  late String deliveredChep;
  late String deliveredLoscomp;
  late String deliveredPlain;
  late String pickedUpChep;
  late String pickedUpLoscomp;
  late String pickedUpPlain;
  late String weight;

  Timesheetjobs(
      this.timesheetJobId,
        this.timesheetId,
        this.companyId,
        this.consignmentId,
        this.jobName,
        this.customerName,
        this.address,
        this.suburb,
        this.arrivalTime,
        this.departTime,
        this.pickup,
        this.delivery,
        this.referenceNumber,
        this.temp,
        this.deliveredChep,
        this.deliveredLoscomp,
        this.deliveredPlain,
        this.pickedUpChep,
        this.pickedUpLoscomp,
        this.pickedUpPlain,
        this.weight);

  Timesheetjobs.fromJson(Map<String, dynamic> json) {
    timesheetJobId = json['timesheet_job_id'];
    timesheetId = json['timesheet_id'];
    companyId = json['company_id'];
    consignmentId = json['consignment_id'];
    jobName = json['job_name'];
    customerName = json['customer_name'];
    address = json['address'];
    suburb = json['suburb'];
    arrivalTime = json['arrival_time'];
    departTime = json['depart_time'];
    pickup = json['pickup'];
    delivery = json['delivery'];
    referenceNumber = json['reference_number'];
    temp = json['temp'];
    deliveredChep = json['delivered_chep'];
    deliveredLoscomp = json['delivered_loscomp'];
    deliveredPlain = json['delivered_plain'];
    pickedUpChep = json['picked_up_chep'];
    pickedUpLoscomp = json['picked_up_loscomp'];
    pickedUpPlain = json['picked_up_plain'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timesheet_job_id'] = this.timesheetJobId;
    data['timesheet_id'] = this.timesheetId;
    data['company_id'] = this.companyId;
    data['consignment_id'] = this.consignmentId;
    data['job_name'] = this.jobName;
    data['customer_name'] = this.customerName;
    data['address'] = this.address;
    data['suburb'] = this.suburb;
    data['arrival_time'] = this.arrivalTime;
    data['depart_time'] = this.departTime;
    data['pickup'] = this.pickup;
    data['delivery'] = this.delivery;
    data['reference_number'] = this.referenceNumber;
    data['temp'] = this.temp;
    data['delivered_chep'] = this.deliveredChep;
    data['delivered_loscomp'] = this.deliveredLoscomp;
    data['delivered_plain'] = this.deliveredPlain;
    data['picked_up_chep'] = this.pickedUpChep;
    data['picked_up_loscomp'] = this.pickedUpLoscomp;
    data['picked_up_plain'] = this.pickedUpPlain;
    data['weight'] = this.weight;
    return data;
  }
}

class FillRestdetails {
  late String restId;
  late String timesheetId;
  late String companyId;
  late String description;
  late String startTime;
  late String endTime;

  FillRestdetails(
      this.restId,
        this.timesheetId,
        this.companyId,
        this.description,
        this.startTime,
        this.endTime);

  FillRestdetails.fromJson(Map<String, dynamic> json) {
    restId = json['rest_id'];
    timesheetId = json['timesheet_id'];
    companyId = json['company_id'];
    description = json['description'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rest_id'] = this.restId;
    data['timesheet_id'] = this.timesheetId;
    data['company_id'] = this.companyId;
    data['description'] = this.description;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}