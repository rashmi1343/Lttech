class Updatetimesheetrequest {
  // String? timeid;
  String? timesheetid;
  String? companyid;
  String? timesheetdate;
  String? starttime;
  String? startodometer;
  String? endtime;
  String? endodometer;
  String? driverId;
  String? drivermobile;
  String? truck;
  List<String>? trailer;
  List<JobDetails>? jobDetails;
  List<updateRestDetails>? restDetails;
  String? signature;

  Updatetimesheetrequest(
      {
        //this.timeid,
        this.timesheetid,
        this.companyid,
        this.timesheetdate,
        this.starttime,
        this.startodometer,
        this.endtime,
        this.endodometer,
        this.driverId,
        this.drivermobile,
        this.truck,
        this.trailer,
        this.jobDetails,
        this.restDetails,
        this.signature});

  Updatetimesheetrequest.fromJson(Map<String, dynamic> json) {
    // timeid = json['time_id'];
    timesheetid = json['timesheet_id'];
    companyid = json['company_id'];
    timesheetdate = json['timesheet_date'];
    starttime = json['start_time'];
    startodometer = json['start_odometer'];
    endtime = json['end_time'];
    endodometer = json['end_odometer'];
    driverId = json['driver_id'];
    drivermobile = json['driver_mobile'];
    truck = json['truck'];
    trailer = json['trailer'];
    if (json['job_details'] != null) {
      jobDetails = <JobDetails>[];
      json['job_details'].forEach((v) {
        jobDetails!.add(new JobDetails.fromJson(v));
      });
    }
    if (json['rest_details'] != null) {
      restDetails = <updateRestDetails>[];
      json['rest_details'].forEach((v) {
        restDetails!.add(new updateRestDetails.fromJson(v));
      });
    }
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['timeid'] = this.timeid;
    data['timesheetid'] = this.timesheetid;
    data['companyid'] = this.companyid;
    data['timesheetdate'] = this.timesheetdate;
    data['starttime'] = this.starttime;
    data['startodometer'] = this.startodometer;
    data['endtime'] = this.endtime;
    data['endodometer'] = this.endodometer;
    data['driver_id'] = this.driverId;
    data['drivermobile'] = this.drivermobile;
    data['truck'] = this.truck;
    data['trailer'] = this.trailer;
    if (this.jobDetails != null) {
      data['job_details'] = this.jobDetails!.map((v) => v.toJson()).toList();
    }
    if (this.restDetails != null) {
      data['rest_details'] = this.restDetails!.map((v) => v.toJson()).toList();
    }
    data['signature'] = this.signature;
    return data;
  }
}

class JobDetails {
  String? timesheetJobId;
  String? jobName;
  String? customerName;
  String? address;
  String? suburb;
  String? arrivalTime;
  String? departTime;
  String? pickup;
  String? delivery;
  String? referenceNumber;
  String? temp;
  String? deliveredChep;
  String? deliveredLoscomp;
  String? deliveredPlain;
  String? pickedUpChep;
  String? pickedUpLoscomp;
  String? pickedUpPlain;
  String? weight;

  JobDetails(
      {this.timesheetJobId,
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
        this.weight});

  JobDetails.fromJson(Map<String, dynamic> json) {
    //timesheetJobId = json['timesheet_job_id'];
    timesheetJobId = json['consignment_id'];
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
    data['consignment_id'] = this.timesheetJobId;
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

class updateRestDetails {
  String? restId;
  String? description;
  String? startTime;
  String? endTime;

  updateRestDetails({this.restId, this.description, this.startTime, this.endTime});

  updateRestDetails.fromJson(Map<String, dynamic> json) {
    restId = json['rest_id'];
    description = json['description'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rest_id'] = this.restId;
    data['description'] = this.description;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
