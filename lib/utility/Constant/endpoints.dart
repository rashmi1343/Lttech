import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class Endpoints {
  static const String authurl = "https://idlttech.broadwayinfotech.net.au/";
  static const String baseurl =
      //  "https://lttech.broadwayinfotech.net.au:5001/api/";
      //static const String baseurl =
      "https://lttechdemo.broadwayinfotech.net.au:5002/api/";

  static const String docbaseurl =
      //  "https://lttech.broadwayinfotech.net.au:5001/";
      "https://lttechdemo.broadwayinfotech.net.au:5002/";
  static const String verifyToken = "company/tokenverification";
  static const String resetpassword = "company/resetpassword";

  static const String uploadDocUrl = "transport/driverdocumentupload";
  static const String addConsignmentUrl = "consignments/addConsignment";
  static const String updateConsignmentUrl = "consignments/updateConsignment/";
  static const String deleteConsignmentUrl = "consignments/deleteConsignment";
  static const String addTimesheet = 'transport/addtimesheet';
  static const String updatetimesheet = 'transport/updatetimesheet';
//  static const String getAllConsignmentUrl = "consignments/getAllConsignments";
  static const String getAllDriverConsignmentUrl =
      "consignments/getAllDriverConsignments";
  static const String consignmentByIdUrl = "consignments/getConsignmentById";
  static const String getAllDocManager = "docManager/allDocManager";
  static const String getCountriesUrl = "common/countries";
  static const String getStatesUrl = "common/states";
  static const String getAllManifestsUrl = "consignments/getallmanifests";
  static const String getTimesheetByIDUrl = "transport/gettimesheet";

  static const String getAllCustomerUrl = "customer/get-all-customers";
  static const String getCustomerCompanyAddressUrl =
      "common/getCustomerCompanyAddress";
  static const String getCustomerListUrl = "common/customerlist";
  static const String getDefaultAddressByCustomerIdUrl =
      "customer/getdefaultaddressbycustomerid";
  static const String getParticularcustomeralladdress =
      "customer/get-all-customer-address";

  //for sign on consignment
  static const String getSignOnConsignmentUrl = "geo/updateConsignment";
  //add geo Location url
  static const String addGeoLocationUrl = "geo/addGeoLocation";
  //get geo Location url
  static const String getGeoLocationUrl = "geo/geoLocation";

  static const String getDocTypeList = "documentType/allDocumentTypes";
  static const String addDocManager = "docManager/addDocManager";
  static const String deleteDocManager = "docManager/deleteDocManager";
  static const String updateDocManager = "docManager/updateDocManager/";
  //static const String getalltimesheet = "transport/timesheetlist/";
  static const String getalltimesheet = "transport/drivertimesheetlist/";

  static const String filltimesheet = "transport/gettimesheet/";
  static const String gettrucktype = "common/truck-type/";
  static const String submitfilltimesheet = "/transport/updatetimesheet/";

  static const String deletetimesheet = 'transport/deletetimesheet/';
  static const String getdriverjob = "transport/getdriverjobs/";

  static const String getvehiclereglist = "common/getvehiclelist/";

  static const String fitnessvehcilecheklist = "checklist/getchecklist";

  static const String addfaultreport = "checklist/addfaultreport";

  static const String addchecklist = "checklist/adddriverchecklist";
  static const String driverprofile = "transport/editdriver/";

  static const String getalldrivercompany = "company/getcompanydropdawn";

  // receiveTimeout
  static const dynamic receiveTimeout = 15000;

  // connectTimeout
  static const dynamic connectionTimeout = 30000;
}

class ApiCounter {
  static int consignmentgetcustomerallcounter = 0;
  static int consignmenteditcounterui = 0;
  static int consignmentbillingaddress = 0;
  static int edittimesheetcounter = 0;
  static Uint8List editimageBytes = Uint8List(640);
  static Uint8List consignmentSignImageBytes = Uint8List(640);

  static int loginuicounter = 0;
}

class AppConstants {
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoicmFzaG1pMjgxIiwiYSI6ImNsajg2eng4czB4cHYzcnF4cmUzOGx5NXIifQ.zUq1YdSQfZcASs1rRymKDw';

  static const String mapBoxStyleId =
      'https://api.mapbox.com/styles/v1/rashmi281/clj871h12007x01p939w22q9a/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFzaG1pMjgxIiwiYSI6ImNsajg2eng4czB4cHYzcnF4cmUzOGx5NXIifQ.zUq1YdSQfZcASs1rRymKDw';

  static final myLocation = LatLng(51.5090214, -0.1982948);
}
