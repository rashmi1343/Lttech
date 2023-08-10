

import 'dart:convert';

submitfilltimesheetresponse submitfilltimesheetFromJson(String strauth) =>
    submitfilltimesheetresponse.fromJson(json.decode(strauth));

String submitfilltimesheetToJson(submitfilltimesheetresponse timesheetdata) =>
    json.encode(timesheetdata.toJson());



class submitfilltimesheetresponse {
  late int status;
  late submittimesheetdata data;

  submitfilltimesheetresponse(
      this.status,
        this.data);

  submitfilltimesheetresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}

class submittimesheetdata {
  late bool success;


  submittimesheetdata(
      this.success,
      );

  submittimesheetdata.fromJson(Map<String, dynamic> json) {
    success = json['success'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;

    return data;
  }
}

