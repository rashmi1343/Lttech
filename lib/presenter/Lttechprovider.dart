import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lttechapp/entity/ApiRequests/AddGeoLocationRequest.dart';
import 'package:lttechapp/entity/ApiRequests/UpdateDocManagerRequest.dart';
import 'package:lttechapp/entity/GetGeoLocationResponse.dart';

import 'package:lttechapp/utility/env.dart';
import 'package:geocoding/geocoding.dart';

import 'dart:math';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/Interactor/repository/lttechrepository.dart';
import 'package:lttechapp/entity/ApiRequests/UpdateConsignmentrequest.dart';

import 'package:lttechapp/entity/AuthenticationResponse.dart';
import 'package:lttechapp/entity/Filltimesheetresponse.dart';
import 'package:lttechapp/entity/GetParticularCustomerAllAddressByCustomerId.dart';
import 'package:lttechapp/entity/getalltimesheetresponse.dart';
import 'package:lttechapp/entity/submitfilltimesheetresponse.dart';
import 'package:lttechapp/entity/trucktyperesponse.dart';

import 'package:lttechapp/router/routes.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/DateHelpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/shared_preferences/helper.dart';
import '../entity/AddConsignmentResponse.dart';

import '../entity/AddGeoLocationResponse.dart';
import '../entity/ApiRequests/AddConsignmentRequest.dart';
import '../entity/ApiRequests/AddDocumentRequest.dart';
import '../entity/ApiRequests/DeleteDocManagerRequest.dart';
import '../entity/ApiRequests/DeleteTimesheetRequest.dart';
import '../entity/ApiRequests/FaultReportingRequest.dart';
import '../entity/ApiRequests/SignOnConsignmentRequest.dart';
import '../entity/ApiRequests/SubmitDriverFitnessRequest.dart';
import '../entity/ApiRequests/SubmitVehicleFitnessRequest.dart';
import '../entity/ApiRequests/Updatetimesheetrequest.dart';
import '../entity/CompanyDriverList.dart';
import '../entity/CountriesResponse.dart';
import '../entity/CustomerCompanyAddressResponse.dart';
import '../entity/DriverProfileResponse.dart';
import '../entity/Driverjobresponse.dart';
import '../entity/FitnessSubmittedResponse.dart';
import '../entity/FitnessVehicleChecklistApiResponse.dart';
import '../entity/GetAllCustomerResponse.dart';
import '../entity/GetAllManifest.dart';
import '../entity/GetDocManagerResponse.dart';
import '../entity/ConsignmentByIdResponse.dart';
import '../entity/DriverUploadDocResponse.dart';
import '../entity/GetAllConsignmentResponse.dart';
import '../entity/GetDocTypeResponse.dart';
import '../entity/GetTimeSheetByIdResponse.dart';
import '../entity/SignOnConsignmentResponse.dart';
import '../entity/StatesResponse.dart';
import '../entity/UpdateConsignmentResponse.dart';
import '../entity/Updatetimesheetresponse.dart';
import '../entity/UploadDocumentResponse.dart';
import '../entity/VehicleRegistrationResponseList.dart';
import '../entity/VerifyTokenResponse.dart';
import '../main.dart';
import '../utility/Constant/endpoints.dart';
import '../utility/CustomTextStyle.dart';

import '../entity/AddTimeSheetResponse.dart';
import '../entity/ApiRequests/AddTimeSheetRequest.dart';
import '../view/widgets/ConsignmentJobScreen.dart';
import '../view/widgets/ListTimesheet/TimesheetList.dart';
import '../view/widgets/LocationOnConsignmentById.dart';

class Lttechprovider extends ChangeNotifier {
  final _lltechrepository = LttechRepository();
  bool isLoading = false;
  bool isError = false;
  bool buttonEnabled = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController subrubController = TextEditingController();
  TextEditingController arriveTimeController = TextEditingController();
  TextEditingController departTimeController = TextEditingController();
  TextEditingController pickupController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController refNumController = TextEditingController();
  TextEditingController tempController = TextEditingController();

  TextEditingController deliveredCController = TextEditingController();
  TextEditingController deliveredLController = TextEditingController();
  TextEditingController deliveredPController = TextEditingController();

  TextEditingController pickedupCController = TextEditingController();
  TextEditingController pickedupLController = TextEditingController();
  TextEditingController pickedupPController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  bool isSuccess = false;

  late BuildContext _providerContext;

  BuildContext get providerContext => _providerContext;

  set setproviderContext(BuildContext context) {
    _providerContext = context;
    notifyListeners();
  }

  bool _updateView = true;

  bool get updateView => _updateView;

  set setUpdateView(bool value) {
    _updateView = value;
    notifyListeners();
  }

  String newConsignmentId = '';

  String getConsignmentJobId() {
    return jobNumberController.text = "JOB${Random().nextInt(1000000000)}";
  }

  // Timesheet list searchview:-
  String _searchTimesheetString = "";
  final tsSearchController = TextEditingController();
  String _searchTSText = '';

  String get searchTSText => _searchTSText;

  bool _timesheetSearchbarToggle = true;

  bool get timesheetSearchbarToggle => _timesheetSearchbarToggle;

  void timesheetSearchToggle() {
    _timesheetSearchbarToggle = !_timesheetSearchbarToggle;
    notifyListeners();
  }

  void setupTimesheetSearchBar(bool value) {
    _timesheetSearchbarToggle = value;
    notifyListeners();
  }

// For Searchbar in timesheet list
  UnmodifiableListView<Rows>? get timesheetRowDataArr =>
      _searchTimesheetString.isEmpty || (alltimesheet.data?.rows == null)
          ? UnmodifiableListView(alltimesheet.data?.rows ?? [])
          : UnmodifiableListView(alltimesheet.data!.rows.where((row) =>
              row.timesheetId.toLowerCase().contains(_searchTimesheetString) ||
              row.startTime.contains(_searchTimesheetString) ||
              row.endTime.contains(_searchTimesheetString) ||
              (row.timesheetDateString ?? "")
                  .toLowerCase()
                  .contains(_searchTimesheetString) ||
              row.status.toLowerCase().contains(_searchTimesheetString)));

  void changeTimesheetSearchString(String searchString) {
    _searchTimesheetString = searchString.toLowerCase();
    // print(_searchTimesheetString);
    notifyListeners();
  }

  void getTimesheetSearchText(String searchString) {
    _searchTSText = searchString;
    notifyListeners();
  }

// Filter functionlaity on timesheet list
  bool isFilterEnabled = false;
  List<Rows> filteredTimesheetRowDataArr = [];

  getTimesheetFilteredData(FilterOptions selectedFilter) {
    final now = DateTime.now();
    final weekAgo = now.add(const Duration(days: -7));
    final onemonthAgo = DateTime(now.year, now.month - 1, now.day);
    filteredTimesheetRowDataArr = [];
    // var oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    print('${weekAgo.getDateOnly()}, $onemonthAgo');

    final selectedFilterDate = selectedFilter == FilterOptions.sevendays
        ? weekAgo.getDateOnly()
        : onemonthAgo;
    for (var item in alltimesheet.data?.rows ?? []) {
      var searchDate = DateTime.parse(item.timesheetDate.toString());

      // print(searchDate.compareTo(selectedFilterDate) >= 0 &&
      // //    searchDate.compareTo(now) <= 0);
      if (searchDate.compareTo(selectedFilterDate) >= 0 &&
          searchDate.compareTo(now) <= 0) {
        filteredTimesheetRowDataArr.add(item);
      }
    }
    if (filteredTimesheetRowDataArr.isNotEmpty) {
      notifyListeners();
    }

    //var dataArr = alltimesheet.data.rows.where((x) =>
    //     DateTime.parse(x.timesheetDate).isAfter(
    //         selectedFilter == FilterOptions.sevendays ? weekAgo : onemonthAgo));
    // filteredTimesheetRowDataArr = dataArr.toList();
    print(filteredTimesheetRowDataArr.map((e) => e.timesheetId));
  }

  // getFilteredData(FilterOptions selectedFilter) {
  //   filteredTimesheetRowDataArr = [];
  //   var now = DateTime.now();

  String selectedfilterdaterange = '';

  pickDateByRange(BuildContext context) async {
    // DateTimeRange? pickedRange = await showDateRangePicker(
    //   context: context,
    //   saveText: 'DONE',
    //   firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
    //   lastDate: DateTime(
    //       DateTime.now().year, DateTime.now().month, DateTime.now().day),
    //   initialEntryMode: DatePickerEntryMode.calendarOnly,
    //   initialDateRange: DateTimeRange(
    //     end: DateTime(
    //         DateTime.now().year, DateTime.now().month, DateTime.now().day),
    //     start: DateTime(
    //         DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
    //   ),
    //   builder: (context, child) {
    //     return Theme(
    //       data: ThemeData(
    //         primarySwatch: Colors.grey,
    //         splashColor: Colors.black,
    //         textTheme: TextTheme(
    //           titleMedium: TextStyle(color: Colors.black),
    //           labelLarge: TextStyle(color: Colors.black),
    //         ),
    //         colorScheme: ColorScheme.light(
    //           primary: ThemeColor.themeGreenColor,
    //           onSecondary: Colors.black,
    //           onPrimary: Colors.white,
    //           surface: Colors.black,
    //           onSurface: Colors.black,
    //           secondary: Colors.black,
    //         ),
    //         dialogBackgroundColor: Colors.white,
    //       ),
    //       child: Center(
    //         child: ConstrainedBox(
    //           constraints: const BoxConstraints(
    //             maxWidth: 320.0,
    //             maxHeight: 530.0,
    //           ),
    //           child: child,
    //         ),
    //       ),
    //     );
    //   },
    // );
    showCustomDateRangePicker(
      context,
      dismissible: true,
      backgroundColor: Colors.white,
      primaryColor: Colors.green,
      fontFamily: "InterMedium",
      minimumDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
      maximumDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
      endDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      startDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
      onApplyClick: (start, end) {
        selectedfilterdaterange =
            "${DateFormat.yMMMMd().format(DateTime.parse(start.toString()))} - ${DateFormat.yMMMMd().format(DateTime.parse(end.toString()))}";
        print('selectedfilterdaterange: $selectedfilterdaterange');

        filteredTimesheetRowDataArr = [];
        final startDate = start;
        final endDate = end;

        for (var item in alltimesheet.data?.rows ?? []) {
          var searchDate = DateTime.parse(item.timesheetDate.toString());

          if (searchDate.compareTo(startDate) >= 0 &&
              searchDate.compareTo(endDate) <= 0) {
            filteredTimesheetRowDataArr.add(item);
            print('matched data');
          }
        }
        if (filteredTimesheetRowDataArr.isEmpty) {
          isFilterEnabled = false;
          filteredTimesheetRowDataArr = [];
        } else {
          isFilterEnabled = true;
        }
      },
      onCancelClick: () {
        isFilterEnabled = false;
      },
    );
    // if (newDateRange == null) return;
    // setState(() => dateRange = newDateRange);

    notifyListeners();
  }

  // getFilteredData(FilterOptions selectedFilter) {
  //   // For Next Days
  //   filteredTimesheetRowDataArr = [];
  //   var startDate = DateTime.now();

  //   var endDate = DateTime(startDate.year, startDate.month,
  //       startDate.day + 3); // For Next Two Days
  //   // var endDate = DateTime(startDate.year, startDate.month, startDate.day + 6); // For Next Five Days
  //   for (var item in alltimesheet.data.rows) {
  //     var itemDate = DateTime.parse(item.timesheetDate.toString());
  //     print(itemDate);
  //     print(
  //         itemDate.compareTo(startDate) > 0 && itemDate.compareTo(endDate) < 0);

  //     if (itemDate.compareTo(startDate) > 0 &&
  //         itemDate.compareTo(endDate) < 0) {
  //       print(item.timesheetDate);
  //       filteredTimesheetRowDataArr.add(item);
  //     }
  //   }
  //   notifyListeners();
  // }

// Add New Timesheet Textfields Array:
  final List<TextEditingController> _jobNameArr = <TextEditingController>[];

  List<TextEditingController> get jobNameArr => _jobNameArr;

  final List<TextEditingController> _customerNameArr =
      <TextEditingController>[];

  List<TextEditingController> get customerNameArr => _customerNameArr;

  final List<TextEditingController> _customerAddressArr =
      <TextEditingController>[];

  List<TextEditingController> get customerAddressArr => _customerAddressArr;

  final List<TextEditingController> _subrubControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get subrubControllerArr => _subrubControllerArr;

  final List<TextEditingController> _arriveTimeControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get arriveTimeControllerArr =>
      _arriveTimeControllerArr;

  String _updateTime = "";

  set updateTime(String updateTime) {
    _updateTime = updateTime;
    notifyListeners();
  }

  final List<TextEditingController> _departTimeControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get departTimeControllerArr =>
      _departTimeControllerArr;

  final List<TextEditingController> _pickupControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get pickupControllerArr => _pickupControllerArr;

  final List<TextEditingController> _deliveryControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get deliveryControllerArr =>
      _deliveryControllerArr;

  final List<TextEditingController> _refNumControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get refNumControllerArr => _refNumControllerArr;

  final List<TextEditingController> _tempControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get tempControllerArr => _tempControllerArr;

  final List<TextEditingController> _deliveredCControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get deliveredCControllerArr =>
      _deliveredCControllerArr;

  final List<TextEditingController> _deliveredLControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get deliveredLControllerArr =>
      _deliveredLControllerArr;

  final List<TextEditingController> _deliveredPControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get deliveredPControllerArr =>
      _deliveredPControllerArr;

  final List<TextEditingController> _pickedupCControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get pickedupCControllerArr =>
      _pickedupCControllerArr;

  final List<TextEditingController> _pickedupLControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get pickedupLControllerArr =>
      _pickedupLControllerArr;

  final List<TextEditingController> _pickedupPControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get pickedupPControllerArr =>
      _pickedupPControllerArr;

  final List<TextEditingController> _weightControllerArr =
      <TextEditingController>[];

  List<TextEditingController> get weightControllerArr => _weightControllerArr;

  bool _isExpanded = false;
  bool _isvisible = true;
  bool _isDatevisible = false;
  bool _selectAllCheckBox = false;
  bool _childCheckedBoxSelected = false;
  List<dynamic> _checklistOptionArr = [];

  bool get isExpanded => _isExpanded;

  bool get isvisible => _isvisible;

  bool get isDatevisible => _isDatevisible;

  bool get selectAllCheckBox => _selectAllCheckBox;

  bool get childCheckedBoxSelected => _childCheckedBoxSelected;

  List<dynamic> get checklistOptionArr => _checklistOptionArr;

  set setDateRangeVisibility(bool selected) {
    _isDatevisible = selected;
    notifyListeners();
  }

  set setChecklistOptionArr(List<dynamic> checklistoptionarr) {
    _checklistOptionArr = checklistoptionarr;
    notifyListeners();
  }

  set isChildCheckedBoxSelected(bool selected) {
    _childCheckedBoxSelected = selected;
    notifyListeners();
  }

  set isTileExpended(bool expended) {
    _isExpanded = expended;
    notifyListeners();
  }

  set isSelectAllCheckBox(bool selectallcheckbox) {
    _selectAllCheckBox = selectallcheckbox;
    notifyListeners();
  }

//<<<<<<<<==================Add New Consignment Four Fields Start:================================>>>>>>>>>
  bool _addNCFourIntialLoaded = true;

  bool get addNCFourIntialLoaded => _addNCFourIntialLoaded;

  set updateNCFourIntialLoaded(bool value) {
    _addNCFourIntialLoaded = value;
    notifyListeners();
  }

  // List<RestDetail> addNCFourDetailsDataArr = [];
  List<Widget> addNCFourNoOfChildWidgetArr = <Widget>[];

  //final List<TextEditingController> _noOfItemControllersArr =
  //  <TextEditingController>[];

  List<TextEditingController> noOfItemControllersArr = [];

//  List<TextEditingController> get noOfItemControllersArr =>
  //    _noOfItemControllersArr;

  //final List<TextEditingController> _palletsControllersArr =
  //  <TextEditingController>[];

  // List<TextEditingController> get palletsControllersArr =>
  ///   _palletsControllersArr;
  List<TextEditingController> palletsControllersArr = [];

  //final List<TextEditingController> _spacesControllersArr =
  // <TextEditingController>[];

  // List<TextEditingController> get spacesControllersArr => _spacesControllersArr;
  List<TextEditingController> spacesControllersArr = [];

  // final List<TextEditingController> _weightControllersArr =
  //   <TextEditingController>[];

  //List<TextEditingController> get weightControllersArr => _weightControllersArr;
  List<TextEditingController> weightControllersArr = [];

  // final List<TextEditingController> _jobTempControllersArr =
  //   <TextEditingController>[];

  //List<TextEditingController> get jobTempControllersArr =>
  //  _jobTempControllersArr;
  List<TextEditingController> jobTempControllersArr = [];

  //final List<TextEditingController> _recipientRefNoControllersArr =
  //  <TextEditingController>[];

  //List<TextEditingController> get recipientRefNoControllersArr =>
  //  _recipientRefNoControllersArr;
  List<TextEditingController> recipientRefNoControllersArr = [];

  //final List<TextEditingController> _senderRefNoControllersArr =
  //  <TextEditingController>[];

  //List<TextEditingController> get senderRefNoControllersArr =>
  //  _senderRefNoControllersArr;
  List<TextEditingController> senderRefNoControllersArr = [];

  // final List<TextEditingController> _equipmentControllersArr =
  //   <TextEditingController>[];

  //List<TextEditingController> get equipmentControllersArr =>
  //  _equipmentControllersArr;
  List<TextEditingController> equipmentControllersArr = [];

  // final List<TextEditingController> _freightDescriptionControllersArr =
  //   <TextEditingController>[];

  //List<TextEditingController> get freightDescriptionControllersArr =>
  //  _freightDescriptionControllersArr;
  List<TextEditingController> freightDescriptionControllersArr = [];

  clearAddConsignmentFourArrData() {
    noOfItemControllersArr.clear();
    palletsControllersArr.clear();
    spacesControllersArr.clear();
    weightControllersArr.clear();
    jobTempControllersArr.clear();
    recipientRefNoControllersArr.clear();
    senderRefNoControllersArr.clear();
    equipmentControllersArr.clear();
    freightDescriptionControllersArr.clear();
    addConsignmentRequestObj.consignmentDetails = [];
    addNCFourNoOfChildWidgetArr = [];
  }

  clearAddConsignmentOnEdit() {
    itemsController.clear();
    palletsController.clear();
    spacesController.clear();
    weighttController.clear();
    jobTempController.clear();
    recipientRefController.clear();
    sendersRefController.clear();
    equipmentController.clear();
    freightDescController.clear();
  }

  //Update item on edit consignment job detail in consignmentDetails Array
  updateConsignmentArr(int index) {
    print(json.encode(
        updateConsignmentRequestObj.consignmentDetails![index].toJson()));

    var updateConsignmentArr =
        updateConsignmentRequestObj.consignmentDetails![index];

    if (consignmentByIdresponse.data!.consignmentDetails.isNotEmpty) {
      updateConsignmentArr.noOfItems =
          int.parse(noOfItemControllersArr[index].text);
      updateConsignmentArr.pallets =
          int.parse(palletsControllersArr[index].text);
      updateConsignmentArr.spaces = int.parse(spacesControllersArr[index].text);
      updateConsignmentArr.weight = int.parse(weightControllersArr[index].text);
      updateConsignmentArr.freightDesc =
          freightDescriptionControllersArr[index].text.toString();
      updateConsignmentArr.equipment =
          equipmentControllersArr[index].text.toString();
      updateConsignmentArr.sendersNo =
          senderRefNoControllersArr[index].text.toString();
      updateConsignmentArr.recipientNo =
          recipientRefNoControllersArr[index].text.toString();
      updateConsignmentArr.jobTemp =
          jobTempControllersArr[index].text.toString();

      print(updateConsignmentArr.toJson());
      notifyListeners();
    }
  }

  //to add job detail in edit consignment

  addJobDetailConsignmentArr(int pst) {
    print("weightcontroller : " + weighttController.text.toString());

    var addConsignmentDetailObj = ConsignmentDetail(
        consignmentDetailsId: '',
        noOfItems: int.parse(itemsController.text.toString()),
        freightDesc: freightDescController.text,
        pallets: int.parse(palletsController.text.toString()),
        spaces: int.parse(spacesController.text.toString()),
        weight: int.parse(weighttController.text.toString()),
        jobTemp: jobTempController.text,
        recipientNo: recipientRefController.text,
        sendersNo: sendersRefController.text,
        equipment: equipmentController.text);
    consignmentByIdresponse.data!.consignmentDetails
        .add(addConsignmentDetailObj);

    updateconsignmentDetailArr.add(ConsignmentDetail(
        consignmentDetailsId: '',
        noOfItems: int.parse(itemsController.text.toString()),
        freightDesc: freightDescController.text,
        pallets: int.parse(palletsController.text.toString()),
        spaces: int.parse(spacesController.text.toString()),
        weight: int.parse(weighttController.text.toString()),
        jobTemp: jobTempController.text,
        recipientNo: recipientRefController.text,
        sendersNo: sendersRefController.text,
        equipment: equipmentController.text));
    //initiallistvalue = initiallistvalue+1;
    notifyListeners();
    print(
        "consignmentdetailsarr" + updateconsignmentDetailArr.length.toString());
  }

  processinitialConsignmentjobdata() {
    noOfItemControllersArr = [];
    palletsControllersArr = [];
    spacesControllersArr = [];
    weightControllersArr = [];
    jobTempControllersArr = [];
    recipientRefNoControllersArr = [];
    senderRefNoControllersArr = [];
    equipmentControllersArr = [];
    freightDescriptionControllersArr = [];

    for (var element in consignmentByIdresponse.data!.consignmentDetails) {
      updateconsignmentDetailArr.add(ConsignmentDetail(
          consignmentDetailsId: '',
          noOfItems: element.noOfItems,
          freightDesc: element.freightDesc,
          pallets: element.pallets,
          spaces: element.spaces,
          weight: element.weight,
          jobTemp: element.jobTemp,
          recipientNo: element.recipientNo,
          sendersNo: element.sendersNo,
          equipment: element.equipment));
    }

    /*  print("len_1:noOfItemControllersArr:"+noOfItemControllersArr.length.toString());
    print("palletsControllersArr len:"+palletsControllersArr.length.toString());
*/
  }

//<<<<<<<<==================Add New Consignment Four Fields End :================================>>>>>>>>>

// Vehicle Checklist Data list:-
  List<String> vehicleimages = [
    "assets/images/VehicleScreenIcons/brakes.png",
    "assets/images/VehicleScreenIcons/couplings.png",
    "assets/images/VehicleScreenIcons/windscreens.png",
    "assets/images/VehicleScreenIcons/engine.png",
    "assets/images/VehicleScreenIcons/wheels.png",
    "assets/images/VehicleScreenIcons/structure.png",
    "assets/images/VehicleScreenIcons/lights.png",
    "assets/images/VehicleScreenIcons/mirror.png",
    "assets/images/VehicleScreenIcons/brakes.png",
    "assets/images/VehicleScreenIcons/couplings.png",
    "assets/images/VehicleScreenIcons/windscreens.png",
    "assets/images/VehicleScreenIcons/engine.png",
    "assets/images/VehicleScreenIcons/wheels.png",
    "assets/images/VehicleScreenIcons/structure.png",
    "assets/images/VehicleScreenIcons/lights.png",
    "assets/images/VehicleScreenIcons/mirror.png",
  ];

  var vehicleChecklistDataArr = [
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Brakes",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Couplings",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {"value": false, "name": "Windows are operational", "id": 101},
        {
          "value": false,
          "name":
              "Wipers and windscreen washers are functioning to ensure a clear forward vision",
          "id": 102
        },
      ],
      "name": "Windscreens and Windows",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Engine, Driveline and Exhaust",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Wheels, Tyres and Hubs",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Structure and Body Condition",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Lights and Reflectors",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    },
    {
      "checklist": [
        {
          "value": false,
          "name": "Brake failure indicators are operational",
          "id": 101
        },
        {
          "value": false,
          "name": "Pressure/vacuum gauges are operational",
          "id": 102
        },
        {
          "value": false,
          "name": "Air tank drain valves are operational",
          "id": 103
        }
      ],
      "name": "Mirrors",
      "is_active": true,
      "id": 1,
      "isExpanded": false,
      "selectAllCheckBox": false
    }
  ];

  var _email;

  void logoutcontent(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Container(
            height: 80,
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: Platform.isAndroid ? 300.0 : 240,
                ),
                title: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.interSemiBold,
                    fontSize: 16,
                    color: Color(0xff243444),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Do you Really want to logout?",
                      style: TextStyle(
                        fontFamily: FontName.interMedium,
                        fontSize: 14,
                        color: Color(0xff243444),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.themeGreenColor,
                            //onPrimary: Colors.black,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: FontName.interMedium,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            logoutApiRequest(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontFamily: FontName.interMedium,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  // Fitness Checklist
  bool isYesPhysicallybuttonEnabled = false;
  bool isNoPhysicallybuttonEnabled = false;
  bool isYesMedicationbuttonEnabled = false;
  bool isNoMedicationbuttonEnabled = false;
  bool isYesStressbuttonEnabled = false;
  bool isNoStressbuttonEnabled = false;
  bool isYesEffectsbuttonEnabled = false;
  bool isNoEffectsbuttonEnabled = false;
  bool isYesRestbuttonEnabled = false;
  bool isNoRestbuttonEnabled = false;
  bool isYesEatenbuttonEnabled = false;
  bool isNoEatenbuttonEnabled = false;

  //Consignment Screen 1/2/3/4/5/6
  TextEditingController _jobNumberController = TextEditingController();
  TextEditingController _instructionController = TextEditingController();
  TextEditingController _manifestController = TextEditingController();
  TextEditingController _bookedDateController = TextEditingController();
  TextEditingController _pickUpDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _customerAddressController = TextEditingController();
  TextEditingController _customerSuburbController = TextEditingController();
  TextEditingController _customerZipCodeController = TextEditingController();
  TextEditingController _customerStateController = TextEditingController();
  TextEditingController _customerCountryController = TextEditingController();
  TextEditingController _billingCustomerController = TextEditingController();
  TextEditingController _billingAddressController = TextEditingController();
  TextEditingController _deliverycustomerNameController =
      TextEditingController();
  TextEditingController _deliverycustomerAddressController =
      TextEditingController();
  TextEditingController _deliverycustomerSuburbController =
      TextEditingController();
  TextEditingController _deliverycustomerZipCodeController =
      TextEditingController();
  TextEditingController _deliverycustomerStateController =
      TextEditingController();
  TextEditingController _deliverycustomerCountryController =
      TextEditingController();
  TextEditingController _itemsController = TextEditingController();
  TextEditingController _palletsController = TextEditingController();
  TextEditingController _spacesController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _jobTempController = TextEditingController();
  TextEditingController _recipientRefController = TextEditingController();
  TextEditingController _sendersRefController = TextEditingController();
  TextEditingController _equipmentController = TextEditingController();
  TextEditingController _freightDescController = TextEditingController();
  TextEditingController _chepController = TextEditingController();
  TextEditingController _loscomController = TextEditingController();
  TextEditingController _plainController = TextEditingController();
  TextEditingController _truckTypeController = TextEditingController();
  TextEditingController _truckNumberController = TextEditingController();

  String? consignmentbookdate = '';
  String? consignmentpickupdate = '';
  String? consignmentdeliverydate = '';

  //FaultReporting textEditingController

  bool isprimeMoverbuttonEnabled = false;
  bool istrailerbuttonEnabled = false;
  bool isdollyrbuttonEnabled = false;
  bool isMinorbuttonEnabled = false;
  bool isMajorbuttonEnabled = false;
  bool isSeriousbuttonEnabled = false;

  var faultReportSelectedDate = '';
  var faultReportSelectedTime = '';
  TruckData? vehicleDropdownSelectedValue;

  TextEditingController _DateController = TextEditingController();
  TextEditingController _NatureOfFaultController = TextEditingController();
  TextEditingController _timeinputController = TextEditingController();
  TextEditingController _VehicleRegistrationNoController =
      TextEditingController();

  TextEditingController get DateController => _DateController;

  TextEditingController get NatureOfFaultController => _NatureOfFaultController;

  TextEditingController get VehicleRegistrationNoController =>
      _VehicleRegistrationNoController;

  TextEditingController get timeinputController => _timeinputController;

  Color _primeMoverbuttonColor = ThemeColor.themeLightColor;
  Color _trailerbuttonColor = ThemeColor.themeLightColor;
  Color _dollybuttonColor = ThemeColor.themeLightColor;
  Color _minorbuttonColor = ThemeColor.themeLightColor;
  Color _majorbuttonColor = ThemeColor.themeLightColor;
  Color _seriousbuttonColor = ThemeColor.themeLightColor;

  Color get primeMoverStatusColor => _primeMoverbuttonColor;

  Color get trailerStatusColor => _trailerbuttonColor;

  Color get dollyStatusColor => _dollybuttonColor;

  Color get minorStatusColor => _minorbuttonColor;

  Color get majorStatusColor => _majorbuttonColor;

  Color get seriousStatusColor => _seriousbuttonColor;

  set primeMoverStatusColor(Color color) {
    _primeMoverbuttonColor = color;
    notifyListeners();
  }

  set trailerStatusColor(Color color) {
    _trailerbuttonColor = color;
    notifyListeners();
  }

  set dollyStatusColor(Color color) {
    _dollybuttonColor = color;
    notifyListeners();
  }

  set minorStatusColor(Color color) {
    _minorbuttonColor = color;
    notifyListeners();
  }

  set majorStatusColor(Color color) {
    _majorbuttonColor = color;
    notifyListeners();
  }

  set seriousStatusColor(Color color) {
    _seriousbuttonColor = color;
    notifyListeners();
  }

  void clearFaultReportingText() {
    DateController.clear();
    NatureOfFaultController.clear();
    VehicleRegistrationNoController.clear();
    timeinputController.clear();
    isMinorbuttonEnabled = false;
    isMajorbuttonEnabled = false;
    isSeriousbuttonEnabled = false;
    _minorbuttonColor = ThemeColor.themeLightColor;
    _majorbuttonColor = ThemeColor.themeLightColor;
    _seriousbuttonColor = ThemeColor.themeLightColor;
    _uploadedFilename = "";
  }

  TextEditingController get jobNumberController => _jobNumberController;

  TextEditingController get billingCustomerController =>
      _billingCustomerController;

  TextEditingController get billingAddressController =>
      _billingAddressController;

  TextEditingController get instructionController => _instructionController;

  TextEditingController get manifestController => _manifestController;

  TextEditingController get bookedDateController => _bookedDateController;

  TextEditingController get pickUpDateController => _pickUpDateController;

  TextEditingController get deliveryDateController => _deliveryDateController;

  TextEditingController get customerNameController => _customerNameController;

  TextEditingController get customerAddressController =>
      _customerAddressController;

  TextEditingController get customerSuburbController =>
      _customerSuburbController;

  TextEditingController get customerZipCodeController =>
      _customerZipCodeController;

  TextEditingController get customerStateController => _customerStateController;

  TextEditingController get customerCountryController =>
      _customerCountryController;

  TextEditingController get deliverycustomerNameController =>
      _deliverycustomerNameController;

  TextEditingController get deliverycustomerAddressController =>
      _deliverycustomerAddressController;

  TextEditingController get deliverycustomerSuburbController =>
      _deliverycustomerSuburbController;

  TextEditingController get deliverycustomerZipCodeController =>
      _deliverycustomerZipCodeController;

  TextEditingController get deliverycustomerStateController =>
      _deliverycustomerStateController;

  TextEditingController get deliverycustomerCountryController =>
      _deliverycustomerCountryController;

  TextEditingController get itemsController => _itemsController;

  TextEditingController get palletsController => _palletsController;

  TextEditingController get spacesController => _spacesController;

  TextEditingController get weighttController => _weightController;

  TextEditingController get jobTempController => _jobTempController;

  TextEditingController get recipientRefController => _recipientRefController;

  TextEditingController get sendersRefController => _sendersRefController;

  TextEditingController get equipmentController => _equipmentController;

  TextEditingController get freightDescController => _freightDescController;

  TextEditingController get chepController => _chepController;

  TextEditingController get loscomController => _loscomController;

  TextEditingController get plainController => _plainController;

  TextEditingController get truckTypeController => _truckTypeController;

  TextEditingController get truckNumberController => _truckNumberController;

  void clearConsignmentText() {
    selectedBillingCustomer = "";
    manifestNumberdropdownValue = "";
    arrcustomercompanyaddressstr = [];

    countriesdropdownValue = "";
    selectedcountryid = 0;

    statesdropdownValue = "";
    selectedStateId = 0;

    jobNumberController.clear();
    billingAddressController.clear();
    billingCustomerController.clear();
    instructionController.clear();
    manifestController.clear();
    bookedDateController.clear();
    pickUpDateController.clear();
    deliveryDateController.clear();
    customerNameController.clear();
    customerAddressController.clear();
    customerSuburbController.clear();
    customerZipCodeController.clear();
    customerStateController.clear();
    customerCountryController.clear();
    deliverycustomerNameController.clear();
    deliverycustomerAddressController.clear();
    deliverycustomerSuburbController.clear();
    deliverycustomerZipCodeController.clear();
    deliverycustomerStateController.clear();
    deliverycustomerCountryController.clear();
    itemsController.clear();
    palletsController.clear();
    spacesController.clear();
    weighttController.clear();
    jobTempController.clear();
    recipientRefController.clear();
    sendersRefController.clear();
    equipmentController.clear();
    freightDescController.clear();
    chepController.clear();
    loscomController.clear();
    plainController.clear();
    truckTypeController.clear();
    truckNumberController.clear();

    _uploadedFilename = "";
  }

  int _counter = 0;

  int get counter => _counter;

  set counter(int value) {
    if (value != _counter) {
      _counter = value;
      notifyListeners();
    }
  }

// ADD DOCUMENT FIELDS:-
  List<PlatformFile>? _paths;
  static var dio = Dio();
  var file = "";

  DocTypeData? docTypeDataObj = DocTypeData();

  String _uploadedFilename = '';

  String get uploadedFilename => _uploadedFilename;

  String _selectedDocTypeID = '';

  String get selectedDocTypeID => _selectedDocTypeID;

  set setSelectedDocumentID(String selectedDocid) {
    _selectedDocTypeID = selectedDocid;
    notifyListeners();
  }

  TextEditingController _docNumberController = TextEditingController();

  TextEditingController get docNumberController => _docNumberController;

  String get docNumber => docNumberController.text;

  void clearAddDocumentData() {
    _docNumberController.text = '';
    _uploadedFilename = '';
    docTypeDataObj = null;
  }

  int filesize = 0;
  String fileext = '';

  int get uploadedFileSize => filesize;

  String get uploadedFileExtension => fileext;

  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'xls', 'jpeg'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation$e');
    } catch (e) {
      print(e.toString());
    }

    if (_paths != null) {
//passing file bytes and file name for API call
      PlatformFile file = _paths!.first;

      filesize = file.size;
      fileext = file.extension.toString();

      print("FileName:${file.name}");
      print("FileBytes:${file.bytes}");
      print("FileSize:$filesize");
      print("FileExtension:${file.extension}");
      print("FilePath:${file.path}");

      if (file.extension == "pdf") {
        var multipartFile = await MultipartFile.fromFile(file.path.toString(),
            filename: file.path!.split('/').last,

            /// for pdf
            contentType: MediaType('application', 'pdf')
// content image/png
            );
        print("file:$multipartFile");
        FormData formData = FormData.fromMap({
          "driver_doc": multipartFile,
        }, ListFormat.multiCompatible);

        final response = await dio.post(
          Endpoints.baseurl + Endpoints.uploadDocUrl,
          data: formData,
          options: Options(
              contentType: 'application/pdf',
              headers: {"Authorization": "Bearer ${Environement.ACCESS_TOKEN}"},
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }),
        );
        print(response.statusCode);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Fluttertoast.showToast(
              msg: "Document Uploaded Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: ThemeColor.themeGreenColor,
              textColor: Colors.white,
              fontSize: 16.0);
          print(response.statusCode);
          print(response.data);

          _uploadedFilename = response.data["data"] ?? "";
          print("uploaded filename:$_uploadedFilename");
        } else if (response.statusCode == 401) {
          print("add geo location status code:${response.statusCode}");
          navigatorKey.currentState!.pushNamed('/login');
          // return AddGeoLocationResponse(status: 0, data: '');
        }
      } else if (file.extension == "png" ||
          file.extension == "jpg" ||
          file.extension == "jpeg") {
        var multipartFile = await MultipartFile.fromFile(file.path.toString(),
            filename: file.path!.split('/').last,

            /// for pdf
            contentType: MediaType('image', 'png')
            // content image/png
            );
        print("file:$multipartFile");
        FormData formData = FormData.fromMap({
          "driver_doc": multipartFile,
        }, ListFormat.multiCompatible);
        final response = await dio.post(
          Endpoints.baseurl + Endpoints.uploadDocUrl,
          data: formData,
          // options: Options(
          //     // contentType: 'application/pdf',
          //     followRedirects: false,
          //     validateStatus: (status) {
          //       return status! <= 500;
          //     }),
          options: Options(
              contentType: 'multipart/form-data',
              headers: {"Authorization": "Bearer ${Environement.ACCESS_TOKEN}"},
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Fluttertoast.showToast(
              msg: "Document Uploaded Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: ThemeColor.themeGreenColor,
              textColor: Colors.white,
              fontSize: 16.0);
          print(response.statusCode);
          print(response.data);

          _uploadedFilename = response.data["data"] ?? "";
          print("uploaded filename:$_uploadedFilename");
          notifyListeners();
        } else if (response.statusCode == 401) {
          print("add geo location status code:${response.statusCode}");
          navigatorKey.currentState!.pushNamed('/login');
          // return AddGeoLocationResponse(status: 0, data: '');
        }
      }
    }
  }

  Color _yesphysicallybuttonColor = ThemeColor.themeLightGrayColor;
  Color _nophysicallybuttonColor = ThemeColor.themeLightGrayColor;

  Color _yesmedicationbuttonColor = ThemeColor.themeLightGrayColor;
  Color _nomedicationbuttonColor = ThemeColor.themeLightGrayColor;

  Color _yesstressbuttonColor = ThemeColor.themeLightGrayColor;
  Color _nostressbuttonColor = ThemeColor.themeLightGrayColor;

  Color _yeseffectsbuttonColor = ThemeColor.themeLightGrayColor;
  Color _noeffectsbuttonColor = ThemeColor.themeLightGrayColor;

  Color _yesrestbuttonColor = ThemeColor.themeLightGrayColor;
  Color _norestbuttonColor = ThemeColor.themeLightGrayColor;

  Color _yeseatenbuttonColor = ThemeColor.themeLightGrayColor;
  Color _noeatenbuttonColor = ThemeColor.themeLightGrayColor;

  Color get yesphysicallyStatusColor => _yesphysicallybuttonColor;

  Color get nophysicallyStatusColor => _nophysicallybuttonColor;

  Color get yesmedicationbuttonColor => _yesmedicationbuttonColor;

  Color get nomedicationbuttonColor => _nomedicationbuttonColor;

  Color get yesstressbuttonColor => _yesstressbuttonColor;

  Color get nostressbuttonColor => _nostressbuttonColor;

  Color get yeseffectsbuttonColor => _yeseffectsbuttonColor;

  Color get noeffectsbuttonColor => _noeffectsbuttonColor;

  Color get yesrestbuttonColor => _yesrestbuttonColor;

  Color get norestbuttonColor => _norestbuttonColor;

  Color get yeseatenbuttonColor => _yeseatenbuttonColor;

  Color get noeatenbuttonColor => _noeatenbuttonColor;

  set yesphysicallyStatusColor(Color color) {
    _yesphysicallybuttonColor = color;
    notifyListeners();
  }

  set nophysicallyStatusColor(Color color) {
    _nophysicallybuttonColor = color;
    notifyListeners();
  }

  set yesmedicationbuttonColor(Color color) {
    _yesmedicationbuttonColor = color;
    notifyListeners();
  }

  set nomedicationbuttonColor(Color color) {
    _nomedicationbuttonColor = color;
    notifyListeners();
  }

  set yesstressbuttonColor(Color color) {
    _yesstressbuttonColor = color;
    notifyListeners();
  }

  set nostressbuttonColor(Color color) {
    _nostressbuttonColor = color;
    notifyListeners();
  }

  set yeseffectsbuttonColor(Color color) {
    _yeseffectsbuttonColor = color;
    notifyListeners();
  }

  set noeffectsbuttonColor(Color color) {
    _noeffectsbuttonColor = color;
    notifyListeners();
  }

  set yesrestbuttonColor(Color color) {
    _yesrestbuttonColor = color;
    notifyListeners();
  }

  set norestbuttonColor(Color color) {
    _norestbuttonColor = color;
    notifyListeners();
  }

  set yeseatenbuttonColor(Color color) {
    _yeseatenbuttonColor = color;
    notifyListeners();
  }

  set noeatenbuttonColor(Color color) {
    _noeatenbuttonColor = color;
    notifyListeners();
  }

  List<TruckData> vehicleTypeArr = [];

  List<TruckData?> arrtrailer = [];
  List<String> arrtrailerid = [];

  List<String> arrtruck = [];
  List<String> arrtruckid = [];

  List<RegistrationList> arrtruckreg = [];
  List<String> arrtruckregstr = [];
  List<String> arrtruckregid = [];

  List<RegistrationList> arrtrailerreg = [];
  List<String> arrtrailerregstr = [];
  List<String> arrtrailerregid = [];

  List<FitnessChecklistData> arrfitnesschklist = [];
  List<FitnessChecklistData> arrvehiclechklist = [];

  var _verifyTokenResponseObj = VerifyTokenResponse();

  late AuthenticationResponse _authresponse = AuthenticationResponse(
      accessToken: '',
      expiresIn: 0,
      refreshExpiresIn: 0,
      refreshToken: '',
      tokenType: '',
      notBeforePolicy: 0,
      sessionState: '',
      scope: '');
  late DriverUploadDocResponse _docresponse =
      DriverUploadDocResponse(status: 1, filedata: '');

  // late AddConsignmentResponse _addConsignmentResponse = AddConsignmentResponse(
  //     status: 1,
  //     addConsignment: AddConsignment(success: true, consignmentdata: ''));

  AuthenticationResponse get authresponse => _authresponse;

  DriverUploadDocResponse get docresponse => _docresponse;

  // AddConsignmentResponse get addConsignmentresponse => _addConsignmentResponse;

  /* alltimesheet Api response variable declaration*/
  getalltimesheetresponse _objalltimesheetdataresponse =
      getalltimesheetresponse(0, Alltimesheetdata(0, []));

  /*filltimesheet Api response variable declaration*/

  Filltimesheetresponse _objfilltimesheetdataresponse = Filltimesheetresponse(
      0,
      filltimesheetData('0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
          [], 'sdiugdyfgiu', [], []));

  /*submitfilltimesheet api response variable declaration*/
  submitfilltimesheetresponse _objsubmitfilltimesheetresponse =
      submitfilltimesheetresponse(0, submittimesheetdata(false));

  /*vehciletype Api response variable declaration */

  TruckTypeResponse _objgetalltrucktype = TruckTypeResponse(0, []);

  VehicleRegistrationResponseList _objgetalltruckreg =
      VehicleRegistrationResponseList(status: 0, data: []);

  TruckTypeResponse _objgetalltrailertype = TruckTypeResponse(0, []);

  VehicleRegistrationResponseList _objgetalltrailerreg =
      VehicleRegistrationResponseList(status: 0, data: []);

  FitnessVehicleChecklistApiResponse _objfitnesschecklistapi =
      FitnessVehicleChecklistApiResponse(status: 0, fcdata: []);

  FitnessVehicleChecklistApiResponse get objfitnesschecklistapi =>
      _objfitnesschecklistapi;

  FitnessVehicleChecklistApiResponse _objvehiclechecklistapi =
      FitnessVehicleChecklistApiResponse(status: 0, fcdata: []);

  FitnessVehicleChecklistApiResponse get objvehiclechecklistapi =>
      _objvehiclechecklistapi;

  getalltimesheetresponse get alltimesheet => _objalltimesheetdataresponse;

  Filltimesheetresponse get filltimesheet => _objfilltimesheetdataresponse;

  TruckTypeResponse get objgetalltrucktype => _objgetalltrucktype;

  TruckTypeResponse get objgetalltrailertype => _objgetalltrailertype;

  VehicleRegistrationResponseList get objgetalltruckreg => _objgetalltruckreg;

  VehicleRegistrationResponseList get objgetalltrailerreg =>
      _objgetalltrailerreg;

  submitfilltimesheetresponse get objsubmitfilltimesheetresponse =>
      _objsubmitfilltimesheetresponse;

  Future<AuthenticationResponse> authenticateApiRequest(
      String email, String pwd, BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final authresponse =
          await _lltechrepository.checkuserAuthentication(email, pwd);
      _authresponse = authresponse;

      if (_authresponse.accessToken!.isEmpty) {
        isError = true;
        isLoading = false;

        notifyListeners();
      } else {
        isLoading = false;
        isError = false;
        // Navigator.of(context).pushNamed(Routes.fillTimesheet);

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.fillTimesheet, (route) => false);
        // notifyListeners();
        if (context.mounted) await verifyTokenApiRequest(context);
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
    return _authresponse;
  }

  void setSelectedState(int stateID, int selectedCountryID) {
    List<StatesList> arrstatelist = objgetallStates.data
        .where((element) => element.countryId == selectedCountryID)
        .toList();
    print("selectedState List:${arrstatelist.map((e) => e.stateName)}");
    final selectedStateID =
        arrstatelist.indexWhere((element) => element.id == stateID);
    print("selectedStateID:$selectedStateID");
    if (selectedStateID > -1) {
      if (isConsignmentEdit) {
        statesdropdownValue = arrstatelist[selectedStateID].stateName;
      } else {
        selectedPickupCustomerState =
            arrstatelist[selectedStateID].stateName.toString();
      }

      selectedStateId = arrstatelist[selectedStateID].id ?? 0;
      print("provider.statesdropdownValue for edit:$statesdropdownValue");
      print(
          "provider.selectedPickupCustomerState:$selectedPickupCustomerState");

      // provider.setUpdateView = true;
    }
  }

  void setSelectedCountry(int countryID) {
    final selectedCountryID =
        arrcountriesid.indexWhere((element) => element.id == countryID);
    if (selectedCountryID > -1) {
      if (isConsignmentEdit) {
        countriesdropdownValue = arrcountriesid[selectedCountryID].countryName;
      } else {
        selectedPickupCustomerCountry =
            arrcountriesid[selectedCountryID].countryName.toString();
      }
      selectedcountryid = arrcountriesid[selectedCountryID].id ?? 0;
      print("provider.countriesdropdownValue:$countriesdropdownValue");
      // provider.setUpdateView = true;
    }
  }

  bool isInactive = false;
  bool isloginsuccess = false;

  Future<void> verifyTokenApiRequest(BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      isloginsuccess = false;
      notifyListeners();
      final authresponse = await _lltechrepository.verifyTokenRepo();
      _verifyTokenResponseObj = authresponse!;

      if (_verifyTokenResponseObj.status == 0) {
        isError = false;
        isInactive = true;
        isLoading = false;
        isloginsuccess = false;
        notifyListeners();
      } else if (_verifyTokenResponseObj.data!.status == "0") {
        isError = true;
        isInactive = false;
        isLoading = false;
        isloginsuccess = false;
        notifyListeners();
      } else {
        isLoading = false;
        isError = false;
        isInactive = false;

        Environement.driverID = _verifyTokenResponseObj.data?.relationId ?? "";
        Environement.companyID = _verifyTokenResponseObj.data?.companyId ?? "";
        Environement.userID = _verifyTokenResponseObj.data?.userId ?? "";
        Environement.driverfirstname =
            _verifyTokenResponseObj.data?.userData?.firstName ?? "";
        Environement.driverlastname =
            _verifyTokenResponseObj.data?.userData!.lastName ?? "";
        print(
            'Environement.driverID:${Environement.driverID}, Environement.companyID: ${Environement.companyID}, Environement.userID: ${Environement.userID} }');
        // Navigator.of(context).pushNamed(Routes.fillTimesheet);
        /* Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.fillTimesheet, (route) => false);*/
        getinitialchar();
        arrcompanylist = [];
        getallcompanylistbyid(
            _verifyTokenResponseObj.data!.userId.toString(), context);
        // notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      isInactive = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
    // return _authresponse;
  }

  // Logout API
  Future<bool> forgetPasswordApiRequest(String email) async {
    bool forgetPasswordResponse = false;
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      forgetPasswordResponse =
          await _lltechrepository.forgetPasswordRepo(email);

      if (forgetPasswordResponse == false) {
        isError = true;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        isError = false;
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_forgetPasswordApiRequest $e");
    }
    return forgetPasswordResponse;
  }

  void getinitialchar() {
    //  Environement.initialloginname = usernameController.text[0];
    Environement.initialloginname =
        Environement.driverfirstname.characters.take(1).toString();
    print("Initial:${Environement.initialloginname}");
  }

  bool isrem = false;
  String username = '';
  String password = '';

  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

// Logout API
  Future<bool> logoutApiRequest(BuildContext context) async {
    try {
      isLoading = true;
      isError = false;

      notifyListeners();
      final logoutResponse = await _lltechrepository.logOutRepo();

      if (logoutResponse == false) {
        isError = true;
        isLoading = false;

        notifyListeners();
      } else {
        isLoading = false;
        isError = false;

        await SharedPreferenceHelper
            .clear(); // Clearing all shared Prefrence Data
        await SharedPreferenceHelper.isRemberme.then((value) => isrem = value);
        if (isrem) {
          await SharedPreferenceHelper.username
              .then((value) => username = value);
          await SharedPreferenceHelper.userpwd
              .then((value) => password = value);
          Environement.isremuser = isrem;
          Environement.remusername = username;
          Environement.remuserpwd = password;
        } else {
          isrem = false;
          username = '';
          password = '';
        }
        print("isrem:" + isrem.toString());
        print("username:" + username.toString());
        print("password:" + password.toString());

        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                title: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/AppBarIcon/LogoAppBar@2x.png",
                    height: 45,
                    width: 120,
                  ),
                ),
                // Text(
                //   "Logout Successful",
                //   style: TextStyle(
                //     fontFamily: FontName.interMedium,
                //     fontSize: 14,
                //     color: Colors.black,
                //   ),
                // ),
                content: Text(
                  "You have been logout successfully!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.interSemiBold,
                    fontSize: 13,
                    color: ThemeColor.themeGreenColor,
                  ),
                ),
                // actions: [
                //   TextButton(
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //       child: Text(
                //         "OK",
                //         style: TextStyle(
                //           fontFamily: FontName.interMedium,
                //           fontSize: 13,
                //           color: ThemeColor.themeDarkGreyColor,
                //         ),
                //       ))
                // ],
              );
            });

        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
    return false;
  }

  /*Api to get all time sheets*/

  Future<void> getalltimesheetApiRequest(
      String companyid, String driverid, int pageNum) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final alltimesheetresponse = await _lltechrepository.repogetalltimesheet(
          companyid, driverid, pageNum);
      _objalltimesheetdataresponse = alltimesheetresponse;
      if (_objalltimesheetdataresponse.data?.count == 0) {
        isError = true;
        isLoading = false;
        isSuccess = false;
        notifyListeners();
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_getalltimesheet $e");
    }
  }

  Future<void> getfilltimesheetapi(String companyid, String driverid) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final filltimesheetresponse = await _lltechrepository
          .repogetfilltimesheetresponse(companyid, driverid);
      _objfilltimesheetdataresponse = filltimesheetresponse;
      if (_objfilltimesheetdataresponse.data.timesheetId.isNotEmpty) {
        isError = false;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        isError = false;
        // getvehicletype("1");
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_getalltimesheet $e");
    }
  }

  List<bool> isselected = [];

  Future<void> getvehicletype(String vehicletype) async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();
      final objgetalltrucktype =
          await _lltechrepository.repogetallvehicleresponse(vehicletype);
      if (vehicletype == "1") {
        _objgetalltrucktype = objgetalltrucktype;
        _objgetalltrucktype.data?.forEach((element) {
          arrtruck.add(element.truckDetails.toString());
          arrtruckid.add(element.truckId.toString());
          isselected.add(false);
        });
      } else if (vehicletype == "2") {
        _objgetalltrailertype = objgetalltrucktype;
        _objgetalltrailertype.data?.forEach((element) {
          arrtruck.add(element.truckDetails.toString());
          arrtruckid.add(element.truckId.toString());
          //arrtrailer.add(element.truckDetails.toString());
          // arrtrailer.add(element);
          // arrtrailerid.add(element.truckId.toString());
        });
      }
      print(objgetalltrucktype.toJson());
      vehicleTypeArr = objgetalltrucktype.data ?? [TruckData()];
      isError = false;
      isLoading = false;
      notifyListeners();
      // getvehicletype("2");
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();

      print("Exception_provider_getvehicletype $e");
    }
  }

  int cntvehreg = 0;

  Future<void> getvehicleregistered(String vehicletype) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      cntvehreg = cntvehreg + 1;
      final objgetalltruckreg =
          await _lltechrepository.repogetallregvehicleresponse(vehicletype);
      if (vehicletype == "1") {
        // _objgetalltrucktype = objgetalltrucktype;
        _objgetalltruckreg = objgetalltruckreg;

        for (var element in _objgetalltruckreg.data) {
          arrtruckreg.add(element);
          arrtruckregstr.add(element.truckRegistration);
          arrtruckregid.add(element.truckSetupId);
          isselected.add(false);
        }
      } else if (vehicletype == "2") {
        // _objgetalltrailertype = objgetalltrucktype;
        _objgetalltrailerreg = objgetalltruckreg;
        for (var element in _objgetalltrailerreg.data) {
          //arrtrailer.add(element.truckDetails.toString());
          //  arrtrailer.add(element);
          // arrtrailerid.add(element.truckId.toString());
          arrtrailerreg.add(element);
          arrtrailerregstr.add(element.truckRegistration);
          arrtrailerregid.add(element.truckSetupId);
        }
      }
      isError = false;

      if (cntvehreg == 1) {
        getvehicleregistered('2');
        isLoading = true;
      } else {
        cntvehreg = 0;
      }
      notifyListeners();

      // getvehicletype("2");
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();

      print("Exception_provider_getvehicletype $e");
    }
  }

  int chklistcnt = 0;

  Future<void> getchecklistapi(String type, BuildContext ctx) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final objchecklist = await _lltechrepository.getchklistapirepo(type);

      //vehicle checklist

      if (type == "1") {
        _objvehiclechecklistapi = objchecklist;
        for (var vchklist in _objvehiclechecklistapi.fcdata) {
          arrvehiclechklist.add(vchklist);
        }
      }
      // fitness checklist
      else if (type == "2") {
        _objfitnesschecklistapi = objchecklist;
        for (var fchklist in _objfitnesschecklistapi.fcdata) {
          arrfitnesschklist.add(fchklist);
        }
        if (isEditTimesheet) {
          print("edittimesheetcounter:" +
              ApiCounter.edittimesheetcounter.toString());
          if (ApiCounter.edittimesheetcounter == 0) {
            getTimesheetByIdRequest(
                selectedTimesheetCompanyID, slectedTimesheetID);
            ApiCounter.edittimesheetcounter =
                ApiCounter.edittimesheetcounter + 1;
          }
        } else if (isviewtimesheet) {
          getTimesheetByIdRequest(
              selectedTimesheetCompanyID, slectedTimesheetID);
        }
      }

      print("fitneschklist:" + arrfitnesschklist.length.toString());
      print("arrvehiclechklist:" + arrvehiclechklist.length.toString());
      for (var element in arrvehiclechklist) {
        print(
            "vehiclesubcategories:" + element.subcategories.length.toString());
      }

      isError = false;

      if (chklistcnt == 0) {
        arrfitnesschklist = [];
        getchecklistapi("2", ctx);
        isLoading = true;
        chklistcnt = chklistcnt + 1;
      } else {
        isLoading = false;
        chklistcnt = 0;
      }
      notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();

      print("Exception_provider_getchecklisttype $e");
    }
  }

  Future<void> addFaultReportApiRequest(
      FaultReportingRequest reqdata, BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final response = await _lltechrepository.addFaultReportRepo(reqdata);

      if (response == 0) {
        isError = true;
        isLoading = false;
        isSuccess = false;
        notifyListeners();
      } else if (response == 401) {
        //Authentication error
        isError = true;
        isLoading = false;
        isSuccess = false;
        tokenExpiredToast();
        if (context.mounted) logoutApiRequest(context);
        notifyListeners();
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;

        Fluttertoast.showToast(
            msg: "Fault report added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);

        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.dashboard, (route) => false);
        }
        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_addfaultreport $e");
    }
  }

  void tokenExpiredToast() {
    Fluttertoast.showToast(
        msg: "Token Expired",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ThemeColor.themeGreenColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  void showCommonToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: ThemeColor.themeGreenColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  var driverProfileResponseObj = DriverProfileResponse();

  Future<void> getDriverProfileApiRequest(BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;

      final response = await _lltechrepository.getDriverProfileRepo();
      driverProfileResponseObj = response;

      if (response.status == 0) {
        isError = true;
        isLoading = false;
        isSuccess = false;
        notifyListeners();
      } else if (response.status == 401) {
        //Authentication error
        isError = true;
        isLoading = false;
        isSuccess = false;
        tokenExpiredToast();
        if (context.mounted) logoutApiRequest(context);
        notifyListeners();
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_ getDriverProfile $e");
    }
  }

  Future<void> submitfilltimesheet(
      String companyid, String timesheetid, BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final objsubmitfilltimesheet = await _lltechrepository
          .reposubmitfilltimesheet(companyid, timesheetid);
      _objsubmitfilltimesheetresponse = objsubmitfilltimesheet;

      if (_objsubmitfilltimesheetresponse.status == 1) {
        /*Provider.of<Lttechprovider>(context,
            listen: false)
            .navigatetodashboard(context);*/
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.dashboard, (route) => false);
      } else {}
      isLoading = false;
      isError = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isError = true;
      notifyListeners();
    }
  }

  // Delete Timesheet
  Future<void> deleteTimesheet(
      DeleteTimesheetRequest deleteTimesheetRequest, String companyID) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final resObj = await _lltechrepository.deleteTimesheetApiRepo(
          deleteTimesheetRequest, companyID);

      print('resObj:$resObj');
      if (resObj == 1) {
        /*Provider.of<Lttechprovider>(context,
            listen: false)
            .navigatetodashboard(context);*/
        isLoading = false;
        isSuccess = true;
        isError = false;

        await Future.delayed(Duration.zero, () {
          getalltimesheetApiRequest(Environement.companyID, '', 1);
        });

        Fluttertoast.showToast(
            msg: "Timesheet deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);

        notifyListeners();
      } else {
        isLoading = false;
        isError = true;
        isSuccess = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      isSuccess = false;
      isError = true;
      notifyListeners();
    }
  }

  Future<void> uploadDocApiRequest(BuildContext context) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final docresponse = await _lltechrepository.docUpload();
      _docresponse = docresponse!;

      if (_docresponse.status == '1') {
        isError = true;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        isError = false;
        // Navigator.of(context).pushNamed(Routes.fillTimesheet);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.consignmentJob, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  // Delete Document Type
  Future<void> deleteDocumentType(
      DeleteDocManagerRequest deleteDocumentTypeRequest) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final resObj = await _lltechrepository
          .deleteDocumentTypeRepo(deleteDocumentTypeRequest);

      print('resObj:$resObj');
      if (resObj == 1) {
        isLoading = false;
        isSuccess = true;
        isError = false;

        await Future.delayed(Duration.zero, () {
          getDocManagerListRequest();
        });

        Fluttertoast.showToast(
            msg: "Document deleted successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);

        notifyListeners();
      } else {
        isLoading = false;
        isError = true;
        isSuccess = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      isSuccess = false;
      isError = true;
      notifyListeners();
    }
  }

//Update Document

  bool isUpdateDocumentType = false;

  Future<void> updateDocumentTypeRequest(
      UpdateDocManagerRequest updateDocumentTypeRequest,
      String docManagerId) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final resObj = await _lltechrepository.updateDocumentTypeRepo(
          updateDocumentTypeRequest, docManagerId);

      print('resObj:$resObj');
      if (resObj == 1) {
        isLoading = false;
        isSuccess = true;
        isError = false;

        Fluttertoast.showToast(
            msg: "Document Updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);

        notifyListeners();
      } else {
        isLoading = false;
        isError = true;
        isSuccess = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      isSuccess = false;
      isError = true;
      notifyListeners();
    }
  }

  //GetAllCustomer
  GetAllCustomerResponse getAllCustomerResponse = GetAllCustomerResponse(
      status: 0, data: GetAllCustomerList(count: 3, rows: []));
  String billingcustomerdropdownValue = 'Atlassian';
  String billingcustomerAddressdropdownValue =
      'Perry - 8/300 George St, Sydney';
  String pickupcustomername = '';

  GetAllCustomerResponse get objgetallBillingCustomers =>
      getAllCustomerResponse;
  List<GetAllCustomerRows> arrcustomer = [];
  List<String> arrcustomermenuItems = [];
  String selectedBillingCustomer = '';

  // List<GetAllCustomerRows> arrcustomerid = [];
  List<CustomCustomerBillingAddressDetail> arrcustomercompanyaddress = [];
  List<String> arrcustomercompanyaddressstr = [];
  GetParticularCustomerAllAddressByCustomerId arrcustomeralladdress =
      GetParticularCustomerAllAddressByCustomerId(
          status: 0, data: ParticularCustomerData(count: 0, rows: []));

  List<String> arrcustomerstr = [];

  List<ParticularCustomerRow> arcustomerrow = <ParticularCustomerRow>[];

  int selectedcustomerid = 1;
  int selectedcustomerbillingaddressid = 0;
  int selectedpickupcustomerid = 0;
  int selecteddeliverycustomerid = 0;

  String selectedPickupCustomerName = "";
  String selectedDeliveryCustomerName = "";

  String selectedPickupCustomerCountry = "";
  String selectedPickupCustomerState = "";

  String selectedCustomerDeliveryCountry = "";
  String selectedCustomerDeliveryState = "";

  String maincustomerid = "";

  String editCustomerBillingName = '';
  String billingCustomerid = '';
  int editCustomerIndexPosition = 0;

  String pickupCustomerbillingid = '';
  String deliverycustomerbillingid = '';
  String selected_billing_address = '';
  String billingaddressid = '';

  getBillingCustomerNameByIdOnEdit(String billingCustomerId) {
    try {
      // isSuccess = true;
      isError = false;
      isLoading = true;
      notifyListeners();

      print("billingCustomerId:$billingCustomerId");

      editCustomerIndexPosition = objgetallBillingCustomers.data!.rows
          .indexWhere((element) => element.customerId == billingCustomerId);

      print(
          "editCustomerIndexPosition: " + editCustomerIndexPosition.toString());

      if (editCustomerIndexPosition > 0) {
        editCustomerBillingName = arrcustomer[
                editCustomerIndexPosition] //arrcustomer[editCustomerIndexPosition - 1]
            .customerCompanyName
            .toString();

        selectedBillingCustomer = arrcustomer[editCustomerIndexPosition]
            .customerCompanyName
            .toString();
      }
      print("editCustomerBillingName:$editCustomerBillingName");
      isError = false;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("on customer name change $e");
      rethrow;
    }
  }

  String editPickUpCustomerNameOnEdit = '';
  int editPickUpCustomerIndexPosition = 0;

  getPickUpCustomerNameByIdOnEdit(String pickUpCustomerId) {
    try {
      // isSuccess = true;
      isError = false;
      isLoading = true;
      notifyListeners();

      editPickUpCustomerIndexPosition = objgetallBillingCustomers.data!.rows
          .indexWhere((element) => element.customerId == pickUpCustomerId);

      editPickUpCustomerNameOnEdit =
          arrcustomer[editPickUpCustomerIndexPosition]
              .customerCompanyName
              .toString();
      print("editPickUpCustomerNameOnEdit:$editPickUpCustomerNameOnEdit");
      isError = false;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("on pick up name change $e");
      rethrow;
    }
  }

  String editDeliveryNameOnEdit = '';
  int editDeliveryIndexPosition = 0;

  getDeliveryNameByIdOnEdit(String deliveryCustomerId) {
    try {
      // isSuccess = true;
      isError = false;
      isLoading = true;
      notifyListeners();

      editDeliveryIndexPosition = objgetallBillingCustomers.data!.rows
          .indexWhere((element) => element.customerId == deliveryCustomerId);

      editDeliveryNameOnEdit =
          arrcustomer[editDeliveryIndexPosition].customerCompanyName.toString();
      print("editDeliveryNameOnEdit:$editDeliveryNameOnEdit");
      isError = false;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("on delivery name change $e");
      rethrow;
    }
  }

  Future<int> getcustomerpstbyid(String customerid) async {
    try {
      selectedcustomerid = objgetallBillingCustomers.data!.rows
          .indexWhere((element) => element.customerId == customerid);
      getbilladdressbycustid();
    } catch (e) {
      print("getcustomerpstbyid" + e.toString());
    }

    return selectedcustomerid;
  }

  int selectedbillingidindex = 0;

  int getcustomerbillingidbycustomername(String customer_name) {
    print("customername:" + customer_name);

    /* arrcustomercompanyaddress.forEach((element) {

      print("custname:"+element.customerName.toString());
      print("custbillingid:"+element.customerBillingId.toString());
      if(element.customerName==customer_name) {
        print("customerbillingid:"+element.customerBillingId.toString());
       // print("selectedcustomerbillingid:"+selectedcustomerbillingid);
        selectedcustomerbillingid = element.customerBillingId.toString();
        selectedbillingidindex = selectedbillingidindex+1;
      }

    });*/
    selectedbillingidindex = 0;
    /* arrcustomeralladdress.data?.rows.forEach((element) {
      print("customer_address_id:" + element.customerAddressId.toString());
      print("custid:" + element.customerId.toString());
      print("address:" + element.address.toString());
      print("name:"+element.customerCompanyName.toString());

         });*/
    selectedbillingidindex = arrcustomeralladdress.data!.rows
        .indexWhere((element) => element.customerCompanyName == customer_name);

    print("selectedbillingidindex:" + selectedbillingidindex.toString());

    if (ispickupclick) {
      getpickupcustomerpstbyid(arrcustomeralladdress
          .data!.rows[selectedbillingidindex].customerAddressId
          .toString());
    } else if (isdeliveryclick) {
      getdeliverycustomerpstbyid(arrcustomeralladdress
          .data!.rows[selectedbillingidindex].customerAddressId
          .toString());
    }

    return selectedbillingidindex;
  }

  bool ispickupclick = false;

  int getpickupcustomerpstbyid(String customer_address_id) {
    int selectedpickupcustomerid = 0;
    print("getpickupcustomerpstbyid");
    try {
      print("customerAddressid:" + customer_address_id);
      //objgetallBillingCustomers.data!.rows.forEach((element) {
      /* arrcustomeralladdress.data?.rows.forEach((element) {
        print("customer_address_id:" + element.customerAddressId.toString());
        print("custid:" + element.customerId.toString());
        print("address:" + element.address.toString());
      });*/

      selectedpickupcustomerid = arrcustomeralladdress.data!.rows.indexWhere(
          (element) => element.customerAddressId == customer_address_id);
      // getbilladdressbycustid();
      print("selectedpickupcustomerid" + selectedpickupcustomerid.toString());
      selectedPickupCustomerName = arrcustomeralladdress
          .data!.rows[selectedpickupcustomerid].customerCompanyName!;
      pickupCustomerbillingid = arrcustomeralladdress
          .data!.rows[selectedpickupcustomerid].customerAddressId!;

      /* if (selectedpickupcustomerid == -1) {
        // arrcustomerstr = [];
        selectedpickupcustomerid =0;
      }

      pickupCustomerbillingid =
          arrcustomercompanyaddress[selectedpickupcustomerid]
              .customerBillingId!;
      selectedPickupCustomerName =
          arrcustomercompanyaddress[selectedpickupcustomerid].customerName!;
      print("pickupCustomerid:" + pickupCustomerbillingid.toString());
      print("selectedcustomer:" + selectedPickupCustomerName.toString());
      print("pickup_address:" +arrcustomercompanyaddress[selectedpickupcustomerid].address.toString());
*/
    } catch (e) {
      print("getcustomerpstbyid" + e.toString());
    }

    return selectedpickupcustomerid;
  }

  String setdefaultaddress() {
    selectedpickupcustomerid = arrcustomeralladdress.data!.rows
        .indexWhere((element) => element.defaultStatus == 1);
    print("selectedpickupcustomerid_default" +
        selectedpickupcustomerid.toString());
    selectedPickupCustomerName = arrcustomeralladdress
        .data!.rows[selectedpickupcustomerid].customerCompanyName!;
    pickupCustomerbillingid = arrcustomeralladdress
        .data!.rows[selectedpickupcustomerid].customerAddressId!;
    print("default_customer:" + selectedPickupCustomerName);

    return selectedPickupCustomerName;
  }

  bool isdeliveryclick = false;

  int getdeliverycustomerpstbyid(String customer_address_id) {
    print("getdeliverycustomerpstbyid");
    try {
      print("customerAddressid:" + customer_address_id);

      /*  arrcustomeralladdress.data?.rows.forEach((element) {
        print("customer_address_id:" + element.customerAddressId.toString());
        print("custid:" + element.customerId.toString());
        print("address:" + element.address.toString());
      });*/

      // selecteddeliverycustomerid = objgetallBillingCustomers.data!.rows
      selecteddeliverycustomerid = arrcustomeralladdress.data!.rows.indexWhere(
          (element) => element.customerAddressId == customer_address_id);

      selectedDeliveryCustomerName = arrcustomeralladdress
          .data!.rows[selecteddeliverycustomerid].customerCompanyName!;
      deliverycustomerbillingid = arrcustomeralladdress
          .data!.rows[selecteddeliverycustomerid].customerAddressId!;
      // getbilladdressbycustid();
      /*  if(selecteddeliverycustomerid==-1) {
        selecteddeliverycustomerid=0;
      }
      print(
          "selecteddeliverycustomerid" + selecteddeliverycustomerid.toString());
      deliverycustomerbillingid =
          arrcustomercompanyaddress[selecteddeliverycustomerid]
              .customerBillingId!;
      selectedDeliveryCustomerName =
          arrcustomercompanyaddress[selecteddeliverycustomerid].customerName!;

      print("deliveryCustomerid:" + deliverycustomerbillingid.toString());
      print("DeliveryCustomer:" + selectedDeliveryCustomerName.toString());
      */
    } catch (e) {
      print("getdeliverypstbyid" + e.toString());
    }

    return selecteddeliverycustomerid;
  }

  int selectedcompanyid = 0;

  // String selectedcompanyname ='';
  String selectedcompanyidstr = '';

  Future<void> onchangecompanyselection(int pst, BuildContext ctx) async {
    try {
      print("onchange_selectedcompany :$pst");
      selectedcompanyid = pst;
      selectedcompanystr = arrcompanylist[pst];
      Environement.driverselectedCompany = selectedcompanystr;

      selectedcompanyidstr =
          objcompanydriverlist.data[pst].companyId.toString();
      print("selectedcompany_name:" + selectedcompanystr);
      print("selectedcompany_str:" + selectedcompanyidstr);
      Environement.companyID = selectedcompanyidstr;
      print("Environement.companyID:" + Environement.companyID);
      ApiCounter.consignmentgetcustomerallcounter = 0;
      if (isloginsuccess) {
        // navigatetofilltimesheet(ctx);
        navigatetoListTimeSheet(ctx);
      }
      notifyListeners();
    } catch (e) {
      print("on customer company change $e");
      rethrow;
    }
  }

  //Future<void> onchangeBillingCustomer(String billingcustomername) async {
  Future<void> onchangeBillingCustomer(int pst) async {
    try {
      //  billingcustomerdropdownValue = billingcustomername;

      /*selectedcustomerid = objgetallBillingCustomers.data!.rows.indexWhere(
          (element) => element.customerCompanyName == billingcustomername);
      */
      //selectedcustomerid = selectedcustomerid + 1;

      print("onchange_selectedcustomerid :$pst");
      selectedcustomerid = pst;
      //Customer id of Selected Company Name
      maincustomerid = arrcustomer[pst].customerId.toString();
      billingCustomerid = maincustomerid;
      print("maincustomerid:$maincustomerid");

      //getCustomerCompanyAddress Api Calling
      // customercompanyAddressRequest(maincustomerid);
      /* List<CustomCustomerBillingAddressDetail> arrselectaddresslist =
      arrcustomercompanyaddress
          .where((element) => element.customerId == maincustomerid)
          .toList();*/

      isError = false;
      isLoading = false;

      filtercustomerbillingaddressbycustid(maincustomerid);

      notifyListeners();
    } catch (e) {
      print("on customer company change $e");
      rethrow;
    }
    // notifyListeners();
  }

  Future<void> filtercustomerbillingaddressbycustid(String custid) async {
    List<CustomCustomerBillingAddressDetail> arrcustomeraddresslistbycustid =
        arrcustomercompanyaddress
            .where((element) => element.customerId == custid)
            .toList();

    // List<CustomCustomerBillingAddressDetail> arrcustomeraddresslistbycustid =
    //     arrcustomercompanyaddress
    //         .where((element) =>
    //             element.address == consignmentByIdresponse.data!.billingAddress)
    //         .toList();

    print(
        "arrcustomeraddresslistbycustid${arrcustomeraddresslistbycustid.length}");

    arrcustomercompanyaddressstr = [];
    for (var element in arrcustomeraddresslistbycustid) {
      billingcustomerAddressdropdownValue = element.custvalue.toString();
      arrcustomercompanyaddressstr.add(billingcustomerAddressdropdownValue);
      print("customername :$billingcustomerAddressdropdownValue");
      // billingCustomerid = element.customerId ?? "";
      print("customerid :${element.customerId}");
    }
    notifyListeners();
  }

  Future<void> getAllCustomerRequest() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final objgetallCustomers = await _lltechrepository.getAllCustomerRepo();

      getAllCustomerResponse = objgetallCustomers;
      arrcustomer = [];
      arrcustomercompanyaddress = [];
      arrcustomermenuItems = [];
      // arrcustomerdefaultaddress = [];

      if (getAllCustomerResponse.data!.rows.isNotEmpty) {
        for (var element in getAllCustomerResponse.data!.rows) {
          arrcustomer.add(element);
          // arrcustomerid.add(element);
          //  pickupcustomername = element.name.toString();
          arrcustomermenuItems.add(element.customerCompanyName.toString());

          // print("arrcustomerid:$arrcustomerid");
          customercompanyAddressRequest(element.customerId.toString());
        }

        print("arrcustomer length :${arrcustomer.length}");

        // if (isConsignmentEdit) {
        //   isError = false;
        //   isLoading = true;
        //   customercompanyAddressRequest(maincustomerid.toString());
        // }
        /*else {
        isError = false;
        isLoading = false;
        notifyListeners();
      }*/
      } else {
        isError = true;
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_getAllCustomerRequest $e");
      ApiCounter.consignmentgetcustomerallcounter = 0;
    }
  }

  Future<void> filtercustomerlistbyid() async {
    List<GetAllCustomerRows> arrfiltercustomerlist = arrcustomer
        .where((element) => element.customerId == maincustomerid)
        .toList();
    print("arrfiltercustomerlist${arrfiltercustomerlist.length}");

    for (var element in arrfiltercustomerlist) {
      pickupcustomername = element.name.toString();
      print("customername :$pickupcustomername");
    }
  }

  int cntidx = 0;

  Future<void> customercompanyAddressRequest(String customerid) async {
    print("customerid in customercompanyAddressRequest:$customerid");
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final getcustomerCompanyAddressResponse = await _lltechrepository
          .getcustomercompanyaddressRepobyclientid(customerid);
      // customerCompanyAddressstr = getcustomerCompanyAddressResponse;
      print(
          "customerCompanyAddressstr:${getcustomerCompanyAddressResponse.objcustomerbilladdressdata.length}");
      // cntidx=0;
      arrcustomercompanyaddressstr = [];
      for (var element
          in getcustomerCompanyAddressResponse.objcustomerbilladdressdata) {
        for (var element in element.customerBillingAddressDetails) {
          cntidx = cntidx + 1;
          var custvalue = " ";
          /*if(element.customerName!="" && element.address!="" ) {
          custvalue = element.customerName.toString() + "-" +
             element.address.toString();
       }
       else {
          custvalue = "NA" + "-" + "NA";
       }*/
          var custname = "";
          var custadd = "";
          /*  if (element.customerName?.isEmpty ?? true) {
            custname = "Mr";
            if (element.address?.isEmpty ?? true) {
              custadd = "na";
            }
            custvalue = "$custname-$custadd$cntidx";
          } else if (element.address?.isEmpty ?? true) {
            custadd = "na";
            custvalue = "${element.customerName!}-$custadd$cntidx";
          } else {
            custvalue = "${element.customerName}-${element.address}";
          }*/
          //
          /*var custvalue = element.customerName.toString() + "-" +
            element.address.toString();*/
          custvalue = "${element.customerName}-${element.address}";
          arrcustomercompanyaddress.add(CustomCustomerBillingAddressDetail(
              customerId: customerid,
              customerBillingId: element.customerBillingId,
              customerName: element.customerName,
              address: element.address,
              custvalue: custvalue));
          //  particularcustomeralladdressbycustomeridRequest(customerid);
          if (!arrcustomercompanyaddressstr.contains(custvalue)) {
            arrcustomercompanyaddressstr.add(custvalue);
          }
        }
      }
      particularcustomeralladdressbycustomeridRequest();
      print(
          "arrcustomercompanyaddress length :${arrcustomercompanyaddress.length}");

      isError = false;
      isLoading = true;
      //  notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_customercompanyAddressRequest $e");
    }
  }

  Future<int> getbilladdressbycustid() async {
    try {
      // selectedcustomerbillingaddressid = objgetallBillingCustomers.data!.rows.indexWhere(
      //        (element) => element.customerId == customerid);

      selectedcustomerbillingaddressid = arrcustomercompanyaddress.indexWhere(
          (element) =>
              element.address == consignmentByIdresponse.data!.billingAddress);
      print(
          "selectedcustomerbillingaddressid: ${arrcustomercompanyaddress[selectedcustomerbillingaddressid].address}");
    } catch (e) {
      print("getcustomerpstbyid" + e.toString());
    }

    return selectedcustomerbillingaddressid;
  }

  String defaultcustomername = '';
  bool isconsignmentpageone = false;

  Future<void> particularcustomeralladdressbycustomeridRequest() async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();
      print(
          "maincustomerid in particularcustomeralladdressbycustomeridRequest: $maincustomerid");
      arrcustomeralladdress = await _lltechrepository
          .repogetparticularcustomeralladdress(maincustomerid);
      print(
          "customeralladdressbycustomeridRequest:${arrcustomeralladdress.data?.rows.length}");
      arrcustomerstr = [];
      arcustomerrow = [];
      for (var element in arrcustomeralladdress.data!.rows) {
        // arrcustomeralladdress.add(CustomDefaultAddress(customerId: customerid, address: element.address, suburb: element.suburb, zipCode: element.zipCode, countryId: element.countryId, stateId: element.stateId, defaultStatus: element.defaultStatus));
        //   pickupcustomername = element.customerCompanyName.toString();
        //  arrcustomerstr.add(element.customerCompanyName.toString());
        arrcustomerstr.add(element.customerCompanyName.toString());
        arcustomerrow.add(element);
        if (element.defaultStatus == "1") {
          // Setting default values on Pickup customer on add consignment screen 2

          selectedPickupCustomerName = element.customerCompanyName.toString();
          defaultcustomername = element.customerCompanyName.toString();
          customerAddressController.text = element.address.toString();
          customerSuburbController.text = element.suburb.toString();
          customerZipCodeController.text = element.zipCode.toString();

          setSelectedCountry(element.countryId ?? -1);
          setSelectedState(element.stateId ?? -1, element.countryId ?? -1);

          pickupCustomerbillingid = element.customerAddressId.toString();
        }
        if (element.customerId.toString() ==
            consignmentByIdresponse.data!.pickupCustomerId.toString()) {
          selectedPickupCustomerName = element.customerCompanyName!;
          print("inside");
        }
      }
      if (isconsignmentpageone) {
        isError = false;
        isLoading = true;
        getAllManifestRequest();
      } else {
        isError = false;
        isLoading = false;
      }
      notifyListeners();

      // isError = false;
      // isLoading = true;
      // getAllManifestRequest();
      //notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_customerallAddressstr $e");
    }
  }

  //GetAllManifest
  GetAllManifestResponse getAllManifestListResponse = GetAllManifestResponse(
      status: 0, data: GetAllManifestData(count: 0, rows: []));

  GetAllManifestResponse get objgetallmanifestlist =>
      getAllManifestListResponse;
  String manifestNumberdropdownValue = '';

  Future<void> onchangeManifestNumber(String manifestNumber) async {
    try {
      manifestNumberdropdownValue = manifestNumber;
      notifyListeners();
    } catch (e) {
      print("on manifest number change $e");
      rethrow;
    }
    // notifyListeners();
  }

  List<String> arrgetAllManifest = [];

  Future<void> getAllManifestRequest() async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();
      var getAllManifestList = await _lltechrepository.getAllManifestListRepo();
      getAllManifestListResponse = getAllManifestList;
      print(
          "getAllManifestList list length:${getAllManifestListResponse.data!.rows.length}");
      for (var element in getAllManifestListResponse.data!.rows) {
        arrgetAllManifest.add(element.manifestNumber.toString());

        // print("arrgetAllManifest:$arrgetAllManifest");
      }

      isError = false;
      isLoading = false;
      print("consignmentByIdresponse.data!.billingCustomer.toString()" +
          consignmentByIdresponse.data!.billingCustomer.toString());

      print("consignmentByIdresponse.data!.pickupCustomerId.toString()" +
          consignmentByIdresponse.data!.pickupCustomerId.toString());

      print("consignmentByIdresponse.data!.deliveryName.toString()" +
          consignmentByIdresponse.data!.deliveryName.toString());

      // getcustomerpstbyid(consignmentByIdresponse.data!.customerId.toString());
      getcustomerpstbyid(
          consignmentByIdresponse.data!.billingCustomer.toString());
      filtercustomerbillingaddressbycustid(
          consignmentByIdresponse.data!.billingCustomer.toString());

      if (isConsignmentEdit) {
        getBillingCustomerNameByIdOnEdit(
            consignmentByIdresponse.data!.billingCustomer.toString());
      } else {
        getpickupcustomerpstbyid(maincustomerid.toString());
        //  setdefaultaddress();
      }
      notifyListeners();
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  //GetAllCountries

  CountriesResponse _allCountriesObj = CountriesResponse(status: 0, data: []);
  String? countriesdropdownValue; // = "Select Country"; //'India';
  String? deliverycountriesdropdownValue;

  CountriesResponse get objgetallCountries => _allCountriesObj;

  Future<void> onchangeCountries(String countryname) async {
    try {
      countriesdropdownValue = countryname;
      // arrstates = [];
      // arrstatesid = [];
      // isError = true;
      // isLoading = true;
      //notifyListeners();

      selectedcountryid = objgetallCountries.data
          .indexWhere((element) => element.countryName == countryname);
      selectedcountryid = selectedcountryid + 1;
      print("onchange_selectedcountryid$selectedcountryid");
      // statesdropdownValue = 'Northern Territory';

      isError = false;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("on country change $e");
      rethrow;
    }
    // notifyListeners();
  }

  List<String> arrcountries = [];
  List<CountriesList> arrcountriesid = [];

  // default value selectedcountryid set to 1 to get state value of default country id 1
  int selectedcountryid = 1;
  int selectedDeliveryCountryid = 1;

  Future<void> getAllCountriesRequest(String countries) async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();

      arrcountriesid = [];
      arrcountries = [];
      final objgetallCountries =
          await _lltechrepository.getAllCountries(countries);

      _allCountriesObj = objgetallCountries;

      // arrcountriesid.add(CountriesList(
      //     countryName: "Select Country", id: 0)); //"Select Country");
      for (var element in _allCountriesObj.data) {
        //  arrcountries.add("Please select country name");
        arrcountries.add(element.countryName.toString());
        arrcountriesid.add(element);

        print("arrcountries:$arrcountries");
        print("arrcountriesid:$arrcountriesid");
      }
      isError = false;
      isLoading = false;
      notifyListeners();
      // getvehicletype("2");
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();

      print("Exception_provider_getcountry $e");
    }
  }

//GetAllStates
  String? statesdropdownValue; // = 'Select State'; //'UP';
  String? deliverystatesdropdownValue;

  StatesResponse _objgetallStates = StatesResponse(status: 0, data: []);

  StatesResponse get objgetallStates => _objgetallStates;
  int selectedStateId = 0;
  int selectedDeliveryStateId = 0;

  Future<void> onchangeStates(String statename) async {
    statesdropdownValue = statename;

    selectedStateId = objgetallStates.data
        .indexWhere((element) => element.stateName == statename);
    selectedStateId = selectedStateId + 1;
    print("onchange_selectedStateId$selectedStateId");

    notifyListeners();
  }

  List<String> arrstates = ["UP", "Delhi"];
  List<String> arrstatesid = [];
  List<String> arrcountryid = [];

  List<StatesList> arrstatescustom = [];

  List<StatesList> getstatebycountryid(int countryid) {
    var newList = objgetallStates.data
        .where((element) => element.countryId == countryid)
        .toList();

    return newList;
  }

  Future<void> getAllStatesRequest(String countryname) async {
    try {
      for (var element in arrcountriesid) {
        if (element.countryName == countryname) {
          selectedcountryid = element.id!;
          print("countryid:$selectedcountryid");
          break;
        }
      }
      final objgetallStates =
          await _lltechrepository.getAllStates(selectedcountryid);

      _objgetallStates = objgetallStates;
      // arrstatescustom = objgetallStates.data.where((element) => element.countryId ==selectedcountryid).toList();
      for (var element in objgetallStates.data) {
        arrstatescustom.add(element);
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();

      print("Exception_provider_getstates $e");
    }
  }

  ConsignmentByIdResponse consignmentByIdresponse = ConsignmentByIdResponse(
      status: 0,
      data: ConsignmentByIdData(
        consignmentId: '',
        companyId: '',
        jobNumber: '',
        bookedDate: DateTime.now(),
        pickupDate: DateTime.now(),
        deliveryDate: DateTime.now(),
        specialInstruction: '',
        manifestNumber: '',
        billingCustomer: '',
        billingAddressId: '',
        billingAddress: '',
        customerAddress: '',
        suburb: '',
        zipCode: '',
        stateId: 1,
        countryId: 2,
        chep: '',
        loscom: '',
        plain: '',
        deliveryName: '',
        deliveryAddres: '',
        deliverySuburb: '',
        deliveryZipCode: '',
        deliveryStateId: 1,
        deliveryCountryId: 2,
        driverId: '',
        driverMobileNumber: '',
        totalItems: 1,
        totalPallets: 1,
        totalSpaces: 1,
        totalWeight: 1,
        createdBy: 1,
        consignmentDetails: [],
        truckDetails: [],
        customerId: '',
        status: '',
        customerPickupDetails: CustomerPickUpDetails(customerCompanyName: ''),
        customerDeliveryDetails: CustomerPickUpDetails(customerCompanyName: ''),
        pickupCustomerId: '',
        signature: "",
        endLatitude: "",
        endLongitude: "0.0",
        signatureDate: DateTime.now(),
      ));

  Future<void> consignmentByIdRequest(
      String consignmentId, BuildContext? context) async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();
      ConsignmentByIdResponse getConsignmentByIdresponse =
          await _lltechrepository.ConsignmentByIdRepo(consignmentId);
      consignmentByIdresponse = getConsignmentByIdresponse;
      if (consignmentByIdresponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;
        consignmentByIdresponse.data!.status == "2"
            ? getGeoLocationByConsignmentIdRequest(
                consignmentByIdresponse.data!.consignmentId.toString())
            : getCurrentPosition(context);
        selected_billing_address =
            consignmentByIdresponse.data!.billingAddress.toString();

        final selectedvalueindex = arrcustomercompanyaddress.indexWhere(
            (element) => element.address == selected_billing_address);

        selected_billing_address =
            arrcustomercompanyaddress[selectedvalueindex].custvalue!;
        editPickUpCustomerIndexPosition = objgetallBillingCustomers.data!.rows
            .indexWhere((element) =>
                element.customerId ==
                consignmentByIdresponse.data!.billingCustomer);

        editPickUpCustomerNameOnEdit =
            arrcustomer[editPickUpCustomerIndexPosition]
                .customerCompanyName
                .toString();
        print("editPickUpCustomerNameOnEdit:$editPickUpCustomerNameOnEdit");
        editCustomerBillingName = editPickUpCustomerNameOnEdit;
        selectedBillingCustomer = editPickUpCustomerNameOnEdit;
// Intializing updateConsignmentRequestObj.consignmentDetails Arr
        updateConsignmentRequestObj.consignmentDetails =
            consignmentByIdresponse.data?.consignmentDetails ?? [];

        print("status:${consignmentByIdresponse.data!.status}");

        //  getAllCustomerRequest();

        notifyListeners();
        //  getAllManifestRequest();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.fillTimesheet, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  //GetAllCOnsignment
  GetAllConsignmentResponse allConsignmenttObj =
      GetAllConsignmentResponse(status: 0, data: Data(count: 0, rows: []));

  Future<void> getAllConsignmentRequest(
      int pageNum, String consignmentTypestatus, String pageSize) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final getAllresponse = await _lltechrepository.getAllConsignment(
          pageNum, consignmentTypestatus, pageSize);
      allConsignmenttObj = getAllresponse;
      if (allConsignmenttObj.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        // if (allConsignmenttObj.data!.rows.isEmpty) {
        //   Fluttertoast.showToast(
        //       msg: "No Data found!!!",
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 2,
        //       backgroundColor: ThemeColor.themeGreenColor,
        //       textColor: Colors.white,
        //       fontSize: 14.0);
        // }
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        // Fluttertoast.showToast(
        //     msg: "No Data found!!!",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 2,
        //     backgroundColor: ThemeColor.themeGreenColor,
        //     textColor: Colors.white,
        //     fontSize: 14.0);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  GetDocManagerResponse _getDocManagerResponseObj = GetDocManagerResponse();

  GetDocManagerResponse get getDocManagerResponseObj =>
      _getDocManagerResponseObj;

  Future<void> getDocManagerListRequest() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final getAllresponse = await _lltechrepository.getDocManagerApiRepo();
      _getDocManagerResponseObj = getAllresponse;

      if (getAllresponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = true;
        // Navigator.of(context).pushNamed(Routes.fillTimesheet);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.consignmentJob, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  GetDocTypeResponse _getDocTypeResponseObj = GetDocTypeResponse();

  GetDocTypeResponse get getDocTypeResponseObj => _getDocTypeResponseObj;

  Future<void> getDocTypeListRequest({required String companyID}) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      final getAllresponse =
          await _lltechrepository.getDocTypeApiRepo(companyID: companyID);

      print(getAllresponse.data?.length);
      _getDocTypeResponseObj = getAllresponse;

      if (getAllresponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = true;
        // Navigator.of(context).pushNamed(Routes.fillTimesheet);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.consignmentJob, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  Future<void> addDocumentApiRequest(
      {required AddDocumentRequest reqdata,
      required BuildContext context}) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final getAllresponse =
          await _lltechrepository.addDocumentApiRepo(reqdata: reqdata);

      if (getAllresponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        Fluttertoast.showToast(
            msg: getAllresponse.data ?? "Something went wrong!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);
        navigatetoDocManager(context);
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = true;

        Fluttertoast.showToast(
            msg: getAllresponse.message ?? "Something went wrong!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 14.0);

        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  String strtrucktype = ''; //'Car Carrier';
  int selectedtruckindex = 1;
  int selectedtruckid = 0;

  String? truckID;

  Future<void> onchangetrucktype(String truckType) async {
    strtrucktype = truckType;

    selectedtruckindex = objgetalltrucktype.data!
        .indexWhere((element) => element.truckDetails == truckType);

    truckID = objgetalltrucktype.data?[selectedtruckindex].truckId ?? "";

    print(truckID);
    selectedtruckindex = selectedtruckindex + 1;
    if (selectedtruckindex > -1)
      print("onchange_selectedtruckindex: $selectedtruckindex");
    notifyListeners();
  }

  String selectedtruckstr = '';

  Future<void> onchangetrucktypefillltimesheet(int truckid) async {
    print("truckid::" + truckid.toString());
    print("selected truck:" + arrtruckreg[truckid].toString());
    if (isEditTimesheet) {
      //  updatetimesheetrequestObj.truck = arrtruckid[truckid];
      updatetimesheetrequestObj.truck = arrtruckregid[truckid];
      selectedtruckstr = arrtruckregstr[truckid];
    } else {
      // addTimeSheetRequestObj.truck = arrtruckid[truckid];
      addTimeSheetRequestObj.truck = arrtruckregid[truckid];
      selectedtruckstr = arrtruckregstr[truckid];
    }
    notifyListeners();
  }

  // int addmorecnt = 0;

  // Array for Rest Details widgets in RestDetails.dart
  List<RestDetail> restDetailsDataArr = [];
  List<Widget> noOfChildWidgetArr = <Widget>[];

  final List<TextEditingController> _descriptionControllersArr =
      <TextEditingController>[];

  List<TextEditingController> get descriptionControllersArr =>
      _descriptionControllersArr;

  final List<TextEditingController> _startTimeControllersArr =
      <TextEditingController>[];

  List<TextEditingController> get startTimeControllersArr =>
      _startTimeControllersArr;

  final List<TextEditingController> _endTimeControllersArr =
      <TextEditingController>[];

  List<TextEditingController> get endTimeControllersArr =>
      _endTimeControllersArr;

  /*for single screen addition of rest details*/
  TextEditingController objdescriptionControllers = TextEditingController();
  TextEditingController objstarttimeControllers = TextEditingController();
  TextEditingController objendtimeControllers = TextEditingController();

  // TextEditingController objdescriptioneditControllers = TextEditingController();
  //TextEditingController objstarttimeeditControllers = TextEditingController();
  //TextEditingController objendtimeeditControllers = TextEditingController();

  // Array for Add timesheet widgets in AddtimeSheetview.dart
  List<Widget> arradddetail = [];

  void addConsignmentDialog(BuildContext context, Lttechprovider value) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Container(
            height: 80,
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: Platform.isAndroid ? 300.0 : 240,
                ),
                title: Text(
                  "Confirmation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.interSemiBold,
                    fontSize: 16,
                    color: Color(0xff243444),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Are you sure you want to proceed?",
                      style: TextStyle(
                        fontFamily: FontName.interMedium,
                        fontSize: 13,
                        color: Color(0xff243444),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              //onPrimary: Colors.black,
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontFamily: FontName.interMedium,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        value.isConsignmentEdit
                            ? Expanded(
                                child: ElevatedButton(
                                onPressed: () {
                                  value.updateConsignmentRequest(
                                      value.updateConsignmentRequestObj,
                                      context);
                                  value.clearConsignmentText();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.themeGreenColor,
                                ),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontFamily: FontName.interMedium,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                            : Expanded(
                                child: ElevatedButton(
                                onPressed: () {
                                  value.addConsignmentRequest(
                                      value.addConsignmentRequestObj, context);
                                  value.clearConsignmentText();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.themeGreenColor,
                                ),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontFamily: FontName.interMedium,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  List<ConsignmentDetail> updateconsignmentDetailArr = [];

  /*
  getUpdateConsignmentDetails() {
    var updateconsignmentDetailObj = ConsignmentDetails();
    List<ConsignmentDetails> updateconsignmentDetailArr = [];
    print("itemsController.text: " + itemsController.text);
    if (itemsController.text.isNotEmpty) {
      updateconsignmentDetailObj.noOfItems = int.parse(itemsController.text);
    } else {
      updateconsignmentDetailObj.noOfItems = 0;
    }

    if (palletsController.text.isNotEmpty) {
      updateconsignmentDetailObj.pallets = int.parse(palletsController.text);
    } else {
      updateconsignmentDetailObj.pallets = 0;
    }
    if (spacesController.text.isNotEmpty) {
      updateconsignmentDetailObj.spaces = int.parse(spacesController.text);
    } else {
      updateconsignmentDetailObj.spaces = 0;
    }
    if (weighttController.text.isNotEmpty) {
      updateconsignmentDetailObj.weight = int.parse(weighttController.text);
    } else {
      updateconsignmentDetailObj.weight = 0;
    }

    updateconsignmentDetailObj.jobTemp = jobTempController.text;
    updateconsignmentDetailObj.recipientNo = recipientRefController.text;
    updateconsignmentDetailObj.sendersNo = sendersRefController.text;
    updateconsignmentDetailObj.equipment = equipmentController.text;
    updateconsignmentDetailObj.freightDesc = freightDescController.text;

    updateconsignmentDetailArr.add(updateconsignmentDetailObj);

    print(
        "Consignment Details Page four:${updateconsignmentDetailObj.toJson()}");

    updateConsignmentRequestObj.consignmentDetails = updateconsignmentDetailArr;
    updateConsignmentRequestObj.consignmentId = selectedConsignmentId;

    /* updateConsignmentRequestObj.noOfItems =
        "${updateConsignmentRequestObj.consignmentDetails?.map((value) => int.parse(value.noOfItems ?? "")).reduce((x, y) => x + y)}";
    updateConsignmentRequestObj.totalPallets =
        "$updateConsignmentRequestObj.consignmentDetails?.map((value) => int.parse(value.pallets ?? "
        ")).reduce((x, y) => x + y)}";
    updateConsignmentRequestObj.totalSpaces =
        "${updateConsignmentRequestObj.consignmentDetails?.map((value) => int.parse(value.spaces ?? "")).reduce((x, y) => x + y)}";;
    updateConsignmentRequestObj.totalWeight =
        "${updateConsignmentRequestObj.consignmentDetails?.map((value) => int.parse(value.weight ?? "")).reduce((x, y) => x + y)}";;
*/
    notifyListeners();

/*
    print(
        'UpdateConsignmentRequest totalItems: ${updateConsignmentRequestObj.totalItems}');

    print(
        'UpdateConsignmentRequest totalPallets: ${updateConsignmentRequestObj.totalPallets}');
    print(
        'UpdateConsignmentRequest totalSpaces: ${updateConsignmentRequestObj.totalSpaces}');
    print(
        'UpdateConsignmentRequest totalWeight: ${updateConsignmentRequestObj.totalWeight}');

 */
  }
*/
  AddConsignmentResponse _addConsignmentsResponse = AddConsignmentResponse();

  AddConsignmentResponse get addConsignmentResponse => _addConsignmentsResponse;

  var addConsignmentRequestObj = AddConsignmentRequest();
  bool _addConsignmentIntialLoaded = true;

  bool get addConsignmentIntialLoaded => _addConsignmentIntialLoaded;

  set updateConsignmentIntialLoaded(bool value) {
    _addConsignmentIntialLoaded = value;
    notifyListeners();
  }

  // Add Consignment API Call:
  Future<void> addConsignmentRequest(
      AddConsignmentRequest addConsignmentRequestData,
      BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      notifyListeners();
      final addconsignmentresponse =
          await _lltechrepository.AddConsignmentRepo(addConsignmentRequestData);
      _addConsignmentsResponse = addconsignmentresponse!;

      if (_addConsignmentsResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        Fluttertoast.showToast(
            msg: "Consignment Successfully Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.consignmentJob, (route) => false);

        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  // Future<void> addmoredetail(width, height, BuildContext context) async {
  //   addmorecnt++;
  //   arradddetail.add(createdetailcolumn(width, height, context));
  //   notifyListeners();
  // }

  //Update Consignment
  UpdateConsignmentResponse _updateConsignmentsResponse =
      UpdateConsignmentResponse();

  UpdateConsignmentResponse get updateConsignmentResponse =>
      _updateConsignmentsResponse;

  var updateConsignmentRequestObj = Updateconsignmentrequest();
  bool _updateConsignmentIntialLoaded = true;

  bool get updateConsignmentIntialLoaded => _updateConsignmentIntialLoaded;

  set updateConsignmentDataIntialLoaded(bool value) {
    _updateConsignmentIntialLoaded = value;
    notifyListeners();
  }

  // Update Consignment API Call:
  Future<void> updateConsignmentRequest(
      Updateconsignmentrequest updateConsignmentRequestData,
      BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      notifyListeners();
      final updateConsignmentResponse =
          await _lltechrepository.updateConsignmentRepo(
              updateConsignmentRequestData, selectedConsignmentId);
      _updateConsignmentsResponse = updateConsignmentResponse!;

      if (_updateConsignmentsResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        Fluttertoast.showToast(
            msg: "Consignment Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.consignmentJob, (route) => false);

        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

// AddTimeSheet Data:-
  AddTimeSheetResponse _addTimesheetResponse = AddTimeSheetResponse();

  AddTimeSheetResponse get addTimesheetResponse => _addTimesheetResponse;

  var addTimeSheetRequestObj = AddTimeSheetRequest(
      timesheetid: '',
      companyid: '',
      timesheetdate: '',
      starttime: '',
      startodometer: '',
      endtime: '',
      endodometer: '',
      driverId: '',
      drivermobile: '',
      truck: '',
      trailer: [],
      jobDetails: [],
      restDetails: [],
      signature: '');

  bool _addTimesheetIntialLoaded = true;

  bool get addTimesheetIntialLoaded => _addTimesheetIntialLoaded;

  Updatetimesheetresponse _updatetimesheetResponse = Updatetimesheetresponse(
      status: 0,
      rootdata: Rootdata(
          success: false,
          subdata: Subdata(
              timesheetDate: '',
              startTime: '',
              startOdometer: '',
              endTime: '',
              endOdometer: '',
              driverId: '',
              driverMobile: '',
              truck: '',
              trailer: '',
              updatedAt: '')));

  Updatetimesheetresponse get updatetimesheetResponse =>
      _updatetimesheetResponse;

  var updatetimesheetrequestObj = Updatetimesheetrequest();

  set updateIntialLoaded(bool value) {
    _addTimesheetIntialLoaded = value;
    notifyListeners();
  }

  bool _addRestDetailsIntialLoaded = true;

  bool get addRestDetailsIntialLoaded => _addRestDetailsIntialLoaded;

  final TextEditingController _addTSIdTF =
      TextEditingController(text: "TIM${Random().nextInt(1000000000)}");

  TextEditingController get addTSIdTF => _addTSIdTF;

  TextEditingController _addTSDateTF = TextEditingController();

  TextEditingController get addTSDateTF => _addTSDateTF;

  TextEditingController _addTSStartTimeTF = TextEditingController();

  TextEditingController get addTSStartTimeTF => _addTSStartTimeTF;

  TextEditingController _addTSStartOdometerTF = TextEditingController();

  TextEditingController get addTSStartOdometerTF => _addTSStartOdometerTF;

  TextEditingController _addTSEndTimeTF = TextEditingController();

  TextEditingController get addTSEndTimeTF => _addTSEndTimeTF;

  TextEditingController _addTSEndOdometerTF = TextEditingController();

  TextEditingController get addTSEndOdometerTF => _addTSEndOdometerTF;

  set updateRestDetailsIntialLoaded(bool value) {
    _addRestDetailsIntialLoaded = value;
    notifyListeners();
  }

  String gettimesheetid() {
    return "TIM${Random().nextInt(1000000000)}";
  }

  // Add Timesheet API Call:
  Future<void> addTimeSheetApiRequest(BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      notifyListeners();
      final addtimesheetresponse =
          await _lltechrepository.addTimesheetApiRepo(addTimeSheetRequestObj);
      _addTimesheetResponse = addtimesheetresponse;

      if (_addTimesheetResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;
        notifyListeners();
        //   navigatetoListTimeSheet(context);
        await SharedPreferenceHelper.isTimesheetcreated(true);
        await SharedPreferenceHelper.savecreatedtimesheetid(
            _addTimesheetResponse.data!.data.toString());
        Environement.istimesheetcreated = true;
        Environement.timesheetcreatedid =
            _addTimesheetResponse.data!.data.toString();
        // setEditTimesheet = true;
        setSelectedTimesheetID = Environement.timesheetcreatedid;

        setSelectedTimesheetCompanyID = Environement.companyID;
        navigatetoJobdetail(context);
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.fillTimesheet, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  List<updateRestDetails> updatearrestdetail = [];

  Future<void> updateTimeSheetApiRequest(BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      /* arrselectedtrailer?.forEach((element) {
        print("val:"+element!.truckDetails.toString());
      addTimeSheetRequestObj.trailer?.add(element!.truckDetails.toString());
      });
      print("trailer_len:"+ addTimeSheetRequestObj.trailer!.length.toString());
      */
      notifyListeners();
      final updatetimesheetresponse = await _lltechrepository
          .updatetimesheetRepo(updatetimesheetrequestObj, _slectedTimesheetID);
      _updatetimesheetResponse = updatetimesheetresponse;

      if (_updatetimesheetResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;
        notifyListeners();
        navigatetoListTimeSheet(context);
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(Routes.fillTimesheet, (route) => false);
        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  Future<void> navigatetologin(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.login);
    notifyListeners();
  }

  Future<void> navigatetoforgetpassword(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.forgetpassword);
    notifyListeners();
  }

  Future<void> navigatetosignatureview(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.signatureview);
    notifyListeners();
  }

  Future<void> navigatetofilltimesheet(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.fillTimesheet);
    notifyListeners();
  }

  Future<void> navigatetodashboard(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.dashboard);
    notifyListeners();
  }

  Future<void> navigatetolocation(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.location);
    notifyListeners();
  }

  Future<void> navigatetosettings(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.settings);
    notifyListeners();
  }

  Future<void> navigatetoprofile(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.profile);
    notifyListeners();
  }

  Future<void> navigatetoConsignmentJob(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.consignmentJob);
    notifyListeners();
  }

  Future<void> navigatetoFaultReporting(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.faultReporting);
    notifyListeners();
  }

  Future<void> navigatetoConsignmentDetails(
      BuildContext context, int index, String consignmentId) async {
    Navigator.of(context).pushNamed(Routes.consignmentDetails);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentOne(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignment);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentTwo(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignmenttwo);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentThree(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignmentthree);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentFour(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignmentfour);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentFive(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignmentfive);
    notifyListeners();
  }

  Future<void> navigatetoAddConsignmentSix(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addconsignmentsix);
    notifyListeners();
  }

  Future<void> navigatetoListTimeSheet(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.listtimesheet);
    notifyListeners();
  }

  Future<void> navigatetoJobdetail(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.addjobdetail);
    notifyListeners();
  }

  Future<void> navigatetoRestDetails(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.restDetails);
    notifyListeners();
  }

  Future<void> navigatetoFitnessChecklist(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.fitnessChecklist);
    notifyListeners();
  }

  Future<void> navigatetoVehicleChecklist(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.vehicleChecklist);
    notifyListeners();
  }

  Future<void> navigatetoDocManager(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.docmanager);
    notifyListeners();
  }

  Future<void> navigatetoAddDocument(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.adddocument);
    notifyListeners();
  }

  Future<void> calculatebreaktime(
      List<GetRestdetails> restdetails, Rows rows) async {
    int totalstarthour = 0;
    int totalstartmin = 0;
    int totalstartsec = 0;

    int totalendhour = 0;
    int totalendmin = 0;
    int totalendsec = 0;

    for (var element in restdetails) {
      print("starttime:" + element.startTime);
      print("endtime:" + element.endTime);

      if (element.startTime != "" && element.endTime != "") {
        // Calculate time only when starttime and endtime has value
        final startformattedTime = DateTime.tryParse(element.startTime);
        final endformattedTime = DateTime.tryParse(element.endTime);

        if (startformattedTime.toString().contains(" ")) {
          List<String> startTime = startformattedTime.toString().split(" ");
          List<String> mainstarttime = startTime[1].split(".");

          String strstarttime = mainstarttime[0].toString();

          // print("rest_start_time" + strstarttime);

          List<String> strstartsplit = strstarttime.split(":");

          String strstarthour = strstartsplit[0];
          String strstartmin = strstartsplit[1];
          String strstartsec = strstartsplit[2];

          // print("strstarthour: " + strstarthour);
          // print("strstartmin: " + strstartmin);
          // print("strstartsec: " + strstartsec);

          totalstarthour = totalstarthour + int.parse(strstarthour);
          totalstartmin = totalstartmin + int.parse(strstartmin);
          totalstartsec = totalstartsec + int.parse(strstartsec);
        } else if (startformattedTime.toString().contains('T')) {
          List<String> startTime = startformattedTime.toString().split("T");
          List<String> mainstarttime = startTime[1].split(".");

          String strstarttime = mainstarttime[0].toString();

          // print("rest_start_time" + strstarttime);

          List<String> strstartsplit = strstarttime.split(":");

          String strstarthour = strstartsplit[0];
          String strstartmin = strstartsplit[1];
          String strstartsec = strstartsplit[2];

          // print("strstarthour: " + strstarthour);
          // print("strstartmin: " + strstartmin);
          // print("strstartsec: " + strstartsec);

          totalstarthour = totalstarthour + int.parse(strstarthour);
          totalstartmin = totalstartmin + int.parse(strstartmin);
          totalstartsec = totalstartsec + int.parse(strstartsec);
        }

        if (endformattedTime.toString().contains(" ")) {
          List<String> endTime = endformattedTime.toString().split(" ");
          List<String> mainendtime = endTime[1].split(".");

          String strendtime = mainendtime[0].toString();

          // print("rest_end_time" + strendtime);

          List<String> strendsplit = strendtime.split(":");

          String strendhour = strendsplit[0];
          String strendmin = strendsplit[1];
          String strendsec = strendsplit[2];

          // print("strendhour: " + strendhour);
          // print("strendmin: " + strendmin);
          // print("strendsec: " + strendsec);

          if (strendmin == "00") {
            strendmin = "60";
            int newhr = int.parse(strendhour) - 1;
            strendhour = newhr.toString();
          }

          totalendhour = totalendhour + int.parse(strendhour);
          totalendmin = totalendmin + int.parse(strendmin);
          totalendsec = totalendsec + int.parse(strendsec);
        } else if (endformattedTime.toString().contains("T")) {
          List<String> endTime = endformattedTime.toString().split("T");
          List<String> mainendtime = endTime[1].split(".");

          String strendtime = mainendtime[0].toString();

          // print("rest_end_time" + strendtime);

          List<String> strendsplit = strendtime.split(":");

          String strendhour = strendsplit[0];
          String strendmin = strendsplit[1];
          String strendsec = strendsplit[2];

          // print("strendhour: " + strendhour);
          // print("strendmin: " + strendmin);
          // print("strendsec: " + strendsec);

          if (strendmin == "00") {
            strendmin = "60";
            int newhr = int.parse(strendhour) - 1;
            strendhour = newhr.toString();
          }

          totalendhour = totalendhour + int.parse(strendhour);
          totalendmin = totalendmin + int.parse(strendmin);
          totalendsec = totalendsec + int.parse(strendsec);
        }

        int totalbreakhour = totalendhour - totalstarthour;
        int totalbreakmin = totalendmin - totalstartmin;
        int totalbreaksec = totalendsec - totalstartsec;

        if (totalbreaksec == 0) {
          element.breakTime = "$totalbreakhour:$totalbreakmin";
          //  + " : " +
          // totalbreaksec.toString();
        } else {
          element.breakTime = "$totalbreakhour:$totalbreakmin : $totalbreaksec";
        }
        // print("rest_break:" + element.breakTime);
      }
      int totalbreakhour = totalendhour - totalstarthour;
      int totalbreakmin = totalendmin - totalstartmin;
      int totalbreaksec = totalendsec - totalstartsec;

      // print("total_break :" +
      //     totalbreakhour.toString() +
      //     " : " +
      //     totalbreakmin.toString() +
      //     " : " +
      //     totalbreaksec.toString());

      if (totalbreaksec == 0) {
        rows.totalbreaktime = "$totalbreakhour : $totalbreakmin";
      } else {
        rows.totalbreaktime =
            "$totalbreakhour : $totalbreakmin : $totalbreaksec";
      }
    }
  }

  /*Api to get timesheet by id*/

  GetTimeSheetByIdResponse _getTimesheetByIdResponse =
      GetTimeSheetByIdResponse();

  GetTimeSheetByIdResponse get getTimesheetByIdResponse =>
      _getTimesheetByIdResponse;

  bool _isEditTimesheet = false;
  bool isviewtimesheet = false;
  int createtimesheet = 0;

  bool get isEditTimesheet => _isEditTimesheet;

  set setEditTimesheet(bool value) {
    _isEditTimesheet = value;
    notifyListeners();
  }

  String _selectedTimesheetCompanyID = '';

  String get selectedTimesheetCompanyID => _selectedTimesheetCompanyID;

  set setSelectedTimesheetCompanyID(String value) {
    _selectedTimesheetCompanyID = value;
    notifyListeners();
  }

  String _slectedTimesheetID = '';

  String get slectedTimesheetID => _slectedTimesheetID;

  set setSelectedTimesheetID(String value) {
    _slectedTimesheetID = value;
    notifyListeners();
  }

  TextEditingController timesheetdateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startOdometerController = TextEditingController();
  TextEditingController endOdometerController = TextEditingController();

  int selectedindexidchecklisttype2 = 0;
  int slectedindexchecklisttype1 = 0;

  bool istimesheetsignscreenfirsttime = false;
  String jobdetailformatteddatefortimesheet = '';
  Future<void> getTimesheetByIdRequest(
      String companyid, String timesheetid) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();

      final timesheetresponse =
          await _lltechrepository.getTimesheetByIdRepo(companyid, timesheetid);
      _getTimesheetByIdResponse = timesheetresponse;
      updatearrestdetail = [];
      if (_getTimesheetByIdResponse.status == 0) {
        isError = true;
        isLoading = true;
        isSuccess = false;
        notifyListeners();
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;

        startTimeController.text =
            getTimesheetByIdResponse.data?.startTime ?? "";
        endTimeController.text = getTimesheetByIdResponse.data?.endTime ?? "";
        startOdometerController.text =
            getTimesheetByIdResponse.data?.startOdometer ?? "";
        endOdometerController.text =
            getTimesheetByIdResponse.data?.endOdometer ?? "";

        var timesheetdate =
            getTimesheetByIdResponse.data?.timesheetDate.toString() ?? "";

        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
            .parse(getTimesheetByIdResponse.data!.timesheetDate.toString());
        var inputDate = DateTime.parse(parseDate.toString());

        print("timesheet_Date_z:" + inputDate.toIso8601String());

        if (!inputDate.toString().isEmpty) {
          print(
              "getTimesheetByIdResponse_timesheetdate:" + inputDate.toString());
          var actualtimesheetdate = DateTime.parse(inputDate.toString());
          String formattimesheetDate =
              //  Jiffy.parse(actualtimesheetdate.addDays(1).toString())
              Jiffy.parse(actualtimesheetdate.toString()).yMMMMEEEEd;
          timesheetdateController.text = formattimesheetDate;
          jobdetailformatteddatefortimesheet =
              Jiffy.parse(actualtimesheetdate.toString()).yMMMd;
          //var initialtimesheetdate = formattimesheetDate;
          filltimesheet.data.timesheetDate =
              DateFormat("yyyy-MM-dd").format(actualtimesheetdate.addDays(1));
          pickupdatefortimesheetjob = DateFormat("yyyy-MM-dd")
              //    .format(actualtimesheetdate.addDays(1));
              .format(actualtimesheetdate);
          // updatetimesheetrequestObj.timesheetdate =
          // DateFormat("dd-MM-yyy").format(actualtimesheetdate.addDays(1));
        }
        updatetimesheetrequestObj.timesheetdate =
            //   getTimesheetByIdResponse.data?.timesheetDate.toString();
            inputDate.toIso8601String();

        //print("updtetimesheet_date:"+)
        // sending value for update to api
        updatetimesheetrequestObj.timesheetid =
            getTimesheetByIdResponse.data?.timesheetId;
        //   updatetimesheetrequestObj.timeid =
        //     getTimesheetByIdResponse.data?.timeId;
        updatetimesheetrequestObj.companyid =
            getTimesheetByIdResponse.data?.companyId;
        updatetimesheetrequestObj.starttime = startTimeController.text;
        updatetimesheetrequestObj.endtime = endTimeController.text;
        updatetimesheetrequestObj.startodometer = startOdometerController.text;
        updatetimesheetrequestObj.endodometer = endOdometerController.text;
        updatetimesheetrequestObj.driverId =
            getTimesheetByIdResponse.data?.driverId;
        updatetimesheetrequestObj.drivermobile =
            getTimesheetByIdResponse.data?.driverMobile;
        updatetimesheetrequestObj.jobDetails = [];
        updatetimesheetrequestObj.restDetails = [];

        if (getTimesheetByIdResponse.data?.signature == "") {
          istimesheetsignscreenfirsttime = true;
        }

        getTimesheetByIdResponse.data?.timesheetjobs!.forEach((element) {
          updatetimesheetrequestObj.jobDetails?.add(JobDetails(
              timesheetJobId: element.timesheetJobId,
              jobName: element.jobName,
              customerName: element.customerName,
              address: element.address,
              suburb: element.suburb,
              arrivalTime: element.arrivalTime,
              departTime: element.departTime,
              pickup: element.pickup,
              delivery: element.delivery,
              referenceNumber: element.referenceNumber,
              temp: element.temp,
              deliveredChep: element.deliveredChep,
              deliveredLoscomp: element.deliveredLoscomp,
              deliveredPlain: element.deliveredPlain,
              pickedUpChep: element.pickedUpChep,
              pickedUpLoscomp: element.pickedUpLoscomp,
              pickedUpPlain: element.pickedUpPlain,
              weight: element.weight));
        });
        getTimesheetByIdResponse.data?.restdetails!.forEach((element) {
          updatetimesheetrequestObj.restDetails?.add(updateRestDetails(
              restId: element.restId,
              description: element.description,
              startTime: element.startTime.toString(),
              endTime: element.endTime.toString()));
        });
        // getselectedtrailer();
        // check for checklist type 2
        selectedindexidchecklisttype2 = getTimesheetByIdResponse
            .data!.checklist!
            .indexWhere((element) => element.checklisttype == 2);

        if (selectedindexidchecklisttype2! == -1) {
          // Add
          selectedindexidchecklisttype2 = 0;
        } else {
          // pending approval if status ==0
          print("submitted status:" +
              getTimesheetByIdResponse
                  .data!.checklist![selectedindexidchecklisttype2].status
                  .toString());
//1 pending approval
          // 2 rejected
          // 3 accepted

          if (getTimesheetByIdResponse
                  .data!.checklist![selectedindexidchecklisttype2].status ==
              "0") {
            // pending approval
            print("12423423");
            selectedindexidchecklisttype2 = 1;
          }
        }
        print("selectedindexidchecklisttype2:" +
            selectedindexidchecklisttype2.toString());

        // check for checklist type 1
        slectedindexchecklisttype1 = getTimesheetByIdResponse.data!.checklist!
            .indexWhere((element) => element.checklisttype == 1);

        if (slectedindexchecklisttype1! == -1) {
          // Add
          slectedindexchecklisttype1 = 0;
        } else {
// pending approval if status ==0
          print("submitted status:" +
              getTimesheetByIdResponse
                  .data!.checklist![slectedindexchecklisttype1].status
                  .toString());

          if (getTimesheetByIdResponse
                  .data!.checklist![slectedindexchecklisttype1].status ==
              0) {
            // pending approval
            slectedindexchecklisttype1 = 1;
          }
        }

        updatetimesheetrequestObj.truck = _getTimesheetByIdResponse.data?.truck;
        getselectedtruckregno(getTimesheetByIdResponse.data!.truck.toString());

        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_getalltimesheet $e");
    }
  }

  var _objdriverjobs = Driverjobsresponse(data: Driverjobsdata(data: []));

  Driverjobsresponse get objdriverjob => _objdriverjobs;

  String pickupdatefortimesheetjob = '';

  List<String> arrconsignmentstr = [];

  int selectedconsignmentidforjob = 0;

  Future<void> getdrivejobprovider(
      String? driverid, String pickupdate, String? truckid) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();
      _objdriverjobs = await _lltechrepository.getdriverjobsrepo(
          driverid, pickupdate, Environement.companyID);
      arrconsignmentstr = [];
      for (var element in _objdriverjobs.data.data) {
        arrconsignmentstr.add(element.jobNumber.toString());

        if (isEditTimesheet || isviewtimesheet) {
          if (updatetimesheetrequestObj.jobDetails?.length == 0) {
            updatetimesheetrequestObj.jobDetails?.add(JobDetails(
              timesheetJobId: element.consignmentId,
              jobName: element.jobNumber,
              customerName:
                  "${element.customerDetails?.firstName} ${element.customerDetails?.lastName}",
              address: element.deliveryAddres,
              suburb: element.suburb,
              arrivalTime: '',
              departTime: '',
              pickup: element.pickupDate.toString(),
              delivery: element.deliveryDate.toString(),
              referenceNumber: '',
              temp: '',
              deliveredChep: '',
              deliveredLoscomp: '',
              deliveredPlain: '',
              pickedUpChep: '',
              pickedUpLoscomp: '',
              pickedUpPlain: '',
              weight: '',
            ));
          }
        } else {
          if (addTimeSheetRequestObj.jobDetails.length == 0) {
            addTimeSheetRequestObj.jobDetails.add(JobDetail(
                jobName: element.jobNumber,
                customerName:
                    "${element.customerDetails?.firstName} ${element.customerDetails?.lastName}",
                address: element.deliveryAddres,
                suburb: element.suburb,
                arrivalTime: '',
                departTime: '',
                pickup: element.pickupDate.toString(),
                delivery: element.deliveryDate.toString(),
                referenceNumber: '',
                temp: '',
                deliveredChep: '',
                deliveredLoscomp: '',
                deliveredPlain: '',
                pickedUpChep: '',
                pickedUpLoscomp: '',
                pickedUpPlain: '',
                weight: '',
                consignmentID: element.consignmentId));
          }
        }
      }
      print("arrconsignmentstr " + arrconsignmentstr!.length.toString());
      isLoading = false;
      isError = false;
      //   gettruckbytruckid(truckid);
      //  getselectedtrailer();
      notifyListeners();
    } catch (e) {}
  }

  late String selectedtruckname = '';
  int selectedtruckidx = 0;

  Future<String> gettruckbytruckid(String? truckid) async {
    try {
      selectedtruckidx = objgetalltrucktype.data!
          .indexWhere((element) => element.truckId == truckid);
      print("selectedtruckidx:" + selectedtruckidx.toString());
      selectedtruckname =
          objgetalltrucktype.data![selectedtruckidx].truckDetails.toString();
      strtrucktype = selectedtruckname;
      print("selectedtruckname: " + selectedtruckname.toString());
      notifyListeners();
    } catch (e) {
      print("Exception:" + e.toString());
    }
    return selectedtruckname;
  }

  int selectedtrailerid = 0;
  late String strselectedtrailer = '';

  List<TruckData?> arrselectedtrailer = [];

  List<RegistrationList> arrselectedtrailerreg = [];

  List<String>? arrstrselectedtrailer = [];
  List<String> arrdisplayselectedtrailer = [];

  List<int> selectedtrailerindxposition = [];

  Future<int> gettrailerindx(String? trailerid) async {
    return objgetalltrailertype.data!
        .indexWhere((element) => element.truckId == trailerid);
  }

  Future<String> gettrailerbyid(String? trailerid) async {
    try {
      selectedtrailerid = objgetalltrailertype.data!
          .indexWhere((element) => element.truckId == trailerid);
      print("selectedtrailedid+ index" + selectedtrailerid.toString());
      selectedtrailerindxposition.add(selectedtrailerid);

      strselectedtrailer =
          objgetalltrailertype.data![selectedtrailerid].truckDetails.toString();

      // arrselectedtrailer.add(objgetalltrailertype.data![selectedtruckidx]);
      print("selectedtrailername: " + strselectedtrailer.toString());
    } catch (e) {
      print("Exception:" + e.toString());
    }

    print("arrselectedtrailer" + arrselectedtrailer.length.toString());
    return strselectedtrailer;
  }

  List<TruckData?> getselectedtrailer() {
    arrselectedtrailer = [];
    arrstrselectedtrailer = [];
    arrdisplayselectedtrailer = [];
    for (var elementall in objgetalltrailertype.data!) {
      _getTimesheetByIdResponse.data?.trailer?.forEach((elementselected) {
        if (elementall.truckId!.contains(elementselected)) {
          arrselectedtrailer.add(elementall);
          arrstrselectedtrailer!.add(elementall.truckId.toString());
          arrdisplayselectedtrailer!.add(elementall.truckDetails.toString());
          print("select_trail" + elementselected.toString());
        }
      });
      updatetimesheetrequestObj.trailer = arrstrselectedtrailer;
    }
    // print("selected_length" + arrselectedtrailer.length.toString());
    notifyListeners();
    return arrselectedtrailer;
  }

  List<RegistrationList> getselectedtrailerreg() {
    arrselectedtrailerreg = [];
    arrstrselectedtrailer = [];
    arrdisplayselectedtrailer = [];

    print("getselectedtrailerreg");

    print("objgetalltrailerreg:" + objgetalltrailerreg.data!.length.toString());

    for (var elementall in objgetalltrailerreg.data!) {
      _getTimesheetByIdResponse.data?.trailer?.forEach((elementselected) {
        if (elementall.truckSetupId!.contains(elementselected)) {
          print("getselectedtrailerreg match");

          arrselectedtrailerreg.add(elementall);
          arrstrselectedtrailer!.add(elementall.truckSetupId.toString());
          arrdisplayselectedtrailer!
              .add(elementall.truckRegistration.toString());
          print("select_trail123" + elementselected.toString());
        }
      });
      updatetimesheetrequestObj.trailer = arrstrselectedtrailer;
    }
    // print("selected_length" + arrselectedtrailer.length.toString());
    notifyListeners();
    setvalueforvehcilechecklist();
    // getselectedtruckregno(getTimesheetByIdResponse.data!.truck.toString());
    return arrselectedtrailerreg;
  }

  String getselectedtruckregno(String truckid) {
    objgetalltruckreg.data!.forEach((elementtruckreg) {
      // if (elementtruckreg.truckSetupId!.contains(truckid)) {
      if (elementtruckreg.truckRegistration!.contains(truckid)) {
        selectedtruckstr = elementtruckreg.truckRegistration.toString();
      }
    });
    notifyListeners();
    getselectedtrailerreg();

    return selectedtruckstr;
  }

  void setvalueforvehcilechecklist() {
    getTimesheetByIdResponse.data?.checklist!.forEach((element) {
      if (element.checklisttype == 2) {
        print("insdie :11");
        List<dynamic> arrsubmitteddriverfitnessdata =
            json.decode(element.checklistvalue.toString());

        List<driverfitnessdata> listdriverfitness =
            List<driverfitnessdata>.from(arrsubmitteddriverfitnessdata
                .map((x) => driverfitnessdata.fromJson(x)));

        for (int i = 0; i < listdriverfitness.length; i++) {
          if (listdriverfitness[i].checklist_value == 1) {
            arrfitnesschklist[i].isYes = true;
            arrfitnesschklist[i].isNo = false;
          } else {
            arrfitnesschklist[i].isYes = false;
            arrfitnesschklist[i].isNo = true;
          }
        }
      } else if (element.checklisttype == 1) {
        print("insdie :13");
        List<dynamic> arrsubmittedvehiclefitnessdata =
            json.decode(element.checklistvalue.toString());
        List<vehiclefitnessdata> listvehiclefitness =
            List<vehiclefitnessdata>.from(arrsubmittedvehiclefitnessdata
                .map((x) => vehiclefitnessdata.fromJson(x)));

        for (int i = 0; i < listvehiclefitness.length; i++) {
          print("subcatlen:" +
              listvehiclefitness[i].subcategories.length.toString());
          for (int j = 0; j < listvehiclefitness[i].subcategories.length; j++) {
            print("checklistname:" +
                listvehiclefitness[i].subcategories[j].checklistname);
            print("type_2_checklistvalue:" +
                listvehiclefitness[i]
                    .subcategories[j]
                    .checklistvalue
                    .toString());

            if (listvehiclefitness[i].subcategories[j].checklistvalue) {
              arrvehiclechklist[i].subcategories[j].checklistvalue = true;
            } else {
              arrvehiclechklist[i].subcategories[j].checklistvalue = false;
            }
          }
        }
      }
    });
    notifyListeners();
  }

  //Update Consignment

  bool isConsignmentEdit = false;
  String selectedConsignmentId = '';
  String driverId = '';

  // Filter functionality on Consignment list

  bool isConsignmentFilterEnabled = false;
  List<AllConsignmentsRow> filteredConsignmentRowDataArr = [];

  getConsignmentFilteredData(ConsignmentFilterOptions selectedFilter) {
    var now = DateTime.now();

    var tomorrowDate = DateTime(now.year, now.month, now.day + 1);
    print("Tomorrow:$tomorrowDate");

    var tomorrowItems = allConsignmenttObj.data!.rows.where((x) {
      return x.pickupDate!.year == tomorrowDate.year &&
          x.pickupDate!.month == tomorrowDate.month &&
          x.pickupDate!.day == tomorrowDate.day;
    }).toList();

    if (tomorrowItems.isEmpty) {
      Fluttertoast.showToast(
          msg: "No Data Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 16.0);
      filteredConsignmentRowDataArr = [];
      setDateRangeVisibility = false;
    } else {
      setDateRangeVisibility = false;
      filteredConsignmentRowDataArr = tomorrowItems.toList();
    }

    print(
        " filteredConsignmentRowDataArr  :${filteredConsignmentRowDataArr.map((e) => e.pickupDate!.toString())}");
    notifyListeners();
  }

  List<DateTime> getNextSevenDays() {
    List<DateTime> dateRange = [];
    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i));
      dateRange.add(date);
    }

    return dateRange;
  }

  void filterListForSevenDays(BuildContext buildContext) {
    List<DateTime> nextSevenDays = getNextSevenDays();

    var sevenDaysItems = allConsignmenttObj.data!.rows.where((item) {
      return nextSevenDays.any((date) =>
          item.pickupDate!.year == date.year &&
          item.pickupDate!.month == date.month &&
          item.pickupDate!.day == date.day);
    }).toList();

    if (sevenDaysItems.isEmpty) {
      Fluttertoast.showToast(
          msg: "No Data Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setDateRangeVisibility = false;
      notifyListeners();
    } else {
      setDateRangeVisibility = false;
      for (var item in sevenDaysItems) {
        filteredConsignmentRowDataArr.add(item);
      }
    }

    notifyListeners();
  }

  var startDate;
  var endDate;
  var formatSelectedStartDate;
  var formatSelectedEndDate;

//All Consignment Date Range
  getConsignmentDateRangeFilteredData(BuildContext context) {
    filteredConsignmentRowDataArr = [];
    showCustomDateRangePicker(
      context,
      dismissible: true,
      backgroundColor: Colors.white,
      primaryColor: Colors.green,
      fontFamily: "InterMedium",
      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now(),
      startDate: DateTime.now(),
      onApplyClick: (start, end) {
        endDate = end;
        startDate = start;
        print("Selected Date:$endDate \n$startDate");
        // Filtering items within the date range
        var filteredDateRangeItems = allConsignmenttObj.data!.rows
            .where((x) =>
                DateTime.parse(x.pickupDate!.toString()).isAfter(startDate) &&
                DateTime.parse(x.pickupDate!.toString()).isBefore(endDate))
            .toList();
        if (filteredDateRangeItems.isEmpty) {
          Fluttertoast.showToast(
              msg: "No Data Found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: ThemeColor.themeGreenColor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          for (var item in filteredDateRangeItems) {
            filteredConsignmentRowDataArr.add(item);
          }
        }
        // Printing the filtered items
        // filteredDateRangeItems.forEach((item) => print("FilteredDateRangeList:${item.jobNumber}"));

        DateTime? selectedstartdate = startDate;
        formatSelectedStartDate =
            DateFormat.yMMMMd().format(selectedstartdate ?? DateTime.now());
        DateTime? selectedenddate = endDate;
        formatSelectedEndDate =
            DateFormat.yMMMMd().format(selectedenddate ?? DateTime.now());
        notifyListeners();
      },
      onCancelClick: () {
        endDate = null;
        startDate = null;
        isConsignmentFilterEnabled = false;
        filteredConsignmentRowDataArr = [];
        setDateRangeVisibility = false;
        notifyListeners();
      },
    );
  }

  //all Consignment list search-view

  String _searchConsignmentString = "";
  final consignmentSearchController = TextEditingController();
  String _searchConsignmentText = '';

  String get searchConsignmentText => _searchConsignmentText;

  bool _consignmentSearchbarToggle = true;

  bool get consignmentSearchbarToggle => _consignmentSearchbarToggle;

  void consignmentListSearchToggle() {
    _consignmentSearchbarToggle = !_consignmentSearchbarToggle;
    notifyListeners();
  }

  void setupConsignmentListSearchBar(bool value) {
    _consignmentSearchbarToggle = value;
    notifyListeners();
  }

// For Searchbar in Consignment list
  UnmodifiableListView<AllConsignmentsRow>? get consignmentRowDataArr =>
      _searchConsignmentString.isEmpty
          ? UnmodifiableListView(allConsignmenttObj.data!.rows)
          : UnmodifiableListView(allConsignmenttObj.data!.rows.where((row) =>
              row.consignmentId!
                  .toLowerCase()
                  .contains(_searchConsignmentString) ||
              row.jobNumber!.contains(_searchConsignmentString) ||
              row.customerDetails!.firstName!
                  .toLowerCase()
                  .contains(_searchConsignmentString) ||
              row.customerDetails!.lastName!
                  .toLowerCase()
                  .contains(_searchConsignmentString) ||
              row.customerAddress!
                  .toLowerCase()
                  .contains(_searchConsignmentString) ||
              row.deliveryAddres!
                  .toLowerCase()
                  .contains(_searchConsignmentString)));

  void changeConsignmentSearchString(String searchString) {
    _searchConsignmentString = searchString;
    print(_searchConsignmentString);
    notifyListeners();
  }

  void getConsignmentSearchText(String searchString) {
    _searchConsignmentText = searchString;
    notifyListeners();
  }

  int fileNumber = 1;
  bool isPdfFileSignGenerated = false;
  var deliveredDateFormat;

// for print/download/view pdf consignment file
  Future<void> generatePdf(
    BuildContext context,
    String formatBookedDate,
    String formatPickUpDate,
    String formatrecieveddate,
    String signature,
    String customerCountryName,
    String deliveredCountryName,
    String toDelCustomerName,
    String fromCustomerName,
    double? getGeoStartedLatitude,
    double? getGeoStartedLongitude,
    double? getGeoDeliveredLatitude,
    double? getGeoDeliveredLongitude,
    String? delivereddate,
  ) async {
    if (consignmentByIdresponse.data == null) {
      return;
    }

    final pdf = pw.Document();

    print("delivereddate:$delivereddate");

    final ByteData bytes = await rootBundle.load('assets/images/pdflogo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    final ByteData locationbytes =
        await rootBundle.load('assets/images/ConsignmentIcon/geoloaction.png');
    final Uint8List locationbyteList = locationbytes.buffer.asUint8List();
    final images = <pw.ImageProvider>[];
    PdfImage logoImage = PdfImage.file(
      pdf.document,
      bytes: locationbyteList,
    );

    //   var signimage = pw.MemoryImage(Base64Decoder().convert(signature));
    //Add the content
    pdf.addPage(pw.MultiPage(build: (pw.Context context) {
      return [
        pw.Center(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                    height: 50,
                    width: 150,
                    padding: pw.EdgeInsets.all(10),
                    margin: pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: pw.Image(
                      pw.MemoryImage(
                        byteList,
                      ),
                    )

                    // child: pw.Text(Environement.driverselectedCompany,
                    //     style: pw.TextStyle(
                    //         color: PdfColors.black, fontSize: 20)),
                    ),
                pw.SizedBox(height: 30),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Container(
                              height: 80,
                              width: 200,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.SizedBox(height: 8),
                                    pw.Container(
                                      width: 50,
                                      child: pw.Text("From",
                                          style: pw.TextStyle(
                                              color: PdfColors.black,
                                              fontSize: 18,
                                              fontBold: pw.Font.helveticaBold(),
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Container(
                                        color: PdfColors.grey,
                                        width: 2,
                                        height: 80),
                                    pw.SizedBox(width: 5),
                                    pw.Container(
                                        width: 200,
                                        child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(fromCustomerName,
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontBold: pw.Font
                                                          .helveticaBold(),
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                      fontSize: 16)),
                                              pw.SizedBox(height: 5),
                                              pw.Text(
                                                  consignmentByIdresponse
                                                      .data!.customerAddress
                                                      .toString(),
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 15)),
                                              pw.Text(
                                                  "${consignmentByIdresponse.data!.suburb} \n$customerCountryName,${consignmentByIdresponse.data!.zipCode}",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 15)),
                                              // pw.Text(customerCountryName,
                                              //     style: pw.TextStyle(
                                              //         color: PdfColors.black,
                                              //         fontSize: 15)),
                                              // pw.Text(
                                              //     consignmentByIdresponse
                                              //         .data!.zipCode
                                              //         .toString(),
                                              //     style: pw.TextStyle(
                                              //         color: PdfColors.black,
                                              //         fontSize: 15)),
                                            ]))
                                  ]),
                            ),
                            pw.SizedBox(width: 70),
                            pw.Container(
                              height: 80,
                              width: 200,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.SizedBox(width: 5),
                                    pw.Container(
                                      width: 50,
                                      child: pw.Text("To",
                                          style: pw.TextStyle(
                                              color: PdfColors.black,
                                              fontSize: 18,
                                              fontBold: pw.Font.helveticaBold(),
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Container(
                                        color: PdfColors.grey,
                                        width: 2,
                                        height: 80),
                                    pw.Container(
                                        width: 200,
                                        child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(" $toDelCustomerName",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontBold: pw.Font
                                                          .helveticaBold(),
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                      fontSize: 16)),
                                              pw.SizedBox(height: 5),
                                              pw.Text(
                                                  " ${consignmentByIdresponse.data!.deliveryAddres.toString()}",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 15)),
                                              pw.Text(
                                                  " ${consignmentByIdresponse.data!.deliverySuburb.toString()} \n $deliveredCountryName,${consignmentByIdresponse.data!.deliveryZipCode.toString()}",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 15)),
                                              // pw.Text(" $deliveredCountryName",
                                              //     style: pw.TextStyle(
                                              //         color: PdfColors.black,
                                              //         fontSize: 15)),
                                              // pw.Text(
                                              //     " ${consignmentByIdresponse.data!.deliveryZipCode.toString()}",
                                              //     style: pw.TextStyle(
                                              //         color: PdfColors.black,
                                              //         fontSize: 15)),
                                            ])),
                                  ]),
                            ),
                          ]),
                    ]),
                pw.SizedBox(height: 30),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(Environement.driverselectedCompany,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontBold: pw.Font.helveticaBold(),
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 16)),
                              pw.SizedBox(height: 5),
                              // pw.Text("Recipient",
                              //     style: pw.TextStyle(
                              //         color: PdfColors.black,
                              //         fontSize: 16,
                              //         fontBold: pw.Font.helveticaBold(),
                              //         fontWeight: pw.FontWeight.bold)),
                              // pw.SizedBox(height: 5),
                              pw.Text("Booked Date :",
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text("Pickup Date :",
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text("Manifest # :",
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text("Consignment # : ",
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                            ]),
                        pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(height: 15),
                              pw.Text(formatBookedDate,
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text(formatPickUpDate,
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                  consignmentByIdresponse.data!.manifestNumber
                                      .toString(),
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                  consignmentByIdresponse.data!.jobNumber
                                      .toString(),
                                  style: pw.TextStyle(
                                      color: PdfColors.black, fontSize: 16)),
                            ]),
                      ]),
                    ]),
                pw.SizedBox(height: 50),
                pw.Table(
                    columnWidths: const {
                      0: pw.FixedColumnWidth(80),
                      1: pw.FlexColumnWidth(80),
                      3: pw.FlexColumnWidth(100),
                      4: pw.FlexColumnWidth(90),
                      5: pw.FlexColumnWidth(80),
                      6: pw.FlexColumnWidth(90),
                    },
                    border: pw.TableBorder.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Senders\nReference",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text("Items",
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 13,
                                    fontBold: pw.Font.helveticaBold(),
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Freight\nDescription",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Pallets",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Spaces",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Weight(KG)",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Job Temp",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                      ]),
                      for (var i = 0;
                          i <
                              consignmentByIdresponse
                                  .data!.consignmentDetails.length;
                          i++)
                        pw.TableRow(children: [
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse.data!
                                            .consignmentDetails[i].sendersNo
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse.data!
                                            .consignmentDetails[i].noOfItems
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse.data!
                                            .consignmentDetails[i].freightDesc
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse
                                            .data!.consignmentDetails[i].pallets
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse
                                            .data!.consignmentDetails[i].spaces
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse
                                            .data!.consignmentDetails[i].weight
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                          pw.Container(
                            height: 40,
                            padding: pw.EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        consignmentByIdresponse
                                            .data!.consignmentDetails[i].jobTemp
                                            .toString(),
                                        style: pw.TextStyle(fontSize: 12)),
                                  ),
                                ]),
                          ),
                        ]),
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text("Totals",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              consignmentByIdresponse.data!.totalItems
                                  .toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 12,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(" ",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              consignmentByIdresponse.data!.totalPallets
                                  .toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 12,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              consignmentByIdresponse.data!.totalSpaces
                                  .toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 12,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              consignmentByIdresponse.data!.totalWeight
                                  .toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 12,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text(" ",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                  fontBold: pw.Font.helveticaBold(),
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                      ]),
                    ]),
                pw.SizedBox(height: 40),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 100, top: 10, bottom: 10, right: 100),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1),
                                ),
                                child: pw.Text("Equipment",
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 13,
                                        fontBold: pw.Font.helveticaBold(),
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                        pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Table(
                                defaultColumnWidth: pw.FixedColumnWidth(133.5),
                                border: pw.TableBorder.all(
                                    width: 1, color: PdfColors.black),
                                children: [
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text("Chep",
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                              color: PdfColors.black,
                                              fontSize: 13,
                                              fontBold: pw.Font.helveticaBold(),
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text(
                                          consignmentByIdresponse.data!.chep
                                              .toString(),
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                            color: PdfColors.black,
                                            fontSize: 13,
                                            fontBold: pw.Font.helveticaBold(),
                                          )),
                                    ),
                                  ]),
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text("Loscom",
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                              color: PdfColors.black,
                                              fontSize: 13,
                                              fontBold: pw.Font.helveticaBold(),
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text(
                                          consignmentByIdresponse.data!.loscom
                                              .toString(),
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                            color: PdfColors.black,
                                            fontSize: 13,
                                            fontBold: pw.Font.helveticaBold(),
                                          )),
                                    ),
                                  ]),
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text("Other",
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                              color: PdfColors.black,
                                              fontSize: 13,
                                              fontBold: pw.Font.helveticaBold(),
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(8.0),
                                      child: pw.Text(
                                          consignmentByIdresponse.data!.plain
                                              .toString(),
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                            color: PdfColors.black,
                                            fontSize: 13,
                                            fontBold: pw.Font.helveticaBold(),
                                          )),
                                    ),
                                  ]),
                                ],
                              ),
                            ]),
                      ]),
                ),
                pw.SizedBox(height: 40),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        isPdfFileSignGenerated == true
                            ? pw.Container(
                                width: 267,
                                padding: pw.EdgeInsets.only(
                                    left: 5, top: 10, bottom: 10, right: 18),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1),
                                ),
                                child: pw.Text(
                                    "RECEIVED BY: $toDelCustomerName",
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 13,
                                        fontBold: pw.Font.helveticaBold(),
                                        fontWeight: pw.FontWeight.bold)))
                            : pw.Container(
                                width: 267,
                                padding: pw.EdgeInsets.only(
                                    left: 80, top: 10, bottom: 10, right: 91),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      color: PdfColors.black, width: 1),
                                ),
                                child: pw.Text("RECEIVED BY: ",
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 13,
                                        fontBold: pw.Font.helveticaBold(),
                                        fontWeight: pw.FontWeight.bold))),
                        pw.Container(
                            width: 267,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1),
                            ),
                            child: pw.Column(children: [
                              pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Row(children: [
                                      pw.SizedBox(width: 5),
                                      pw.Container(
                                          width: 130,
                                          child: pw.Row(children: [
                                            pw.Container(
                                              width: 40,
                                              child: pw.Text("Date :",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 13,
                                                      fontBold: pw.Font
                                                          .helveticaBold(),
                                                      fontWeight:
                                                          pw.FontWeight.bold)),
                                            ),
                                            pw.SizedBox(width: 2),
                                            pw.Container(
                                                width: 90,
                                                child: isPdfFileSignGenerated ==
                                                        true
                                                    ? pw.Text(
                                                        formatrecieveddate,
                                                        style: pw.TextStyle(
                                                          color:
                                                              PdfColors.black,
                                                          fontSize: 12,
                                                          fontBold: pw.Font
                                                              .helveticaBold(),
                                                        ))
                                                    : pw.Text(" ",
                                                        style: pw.TextStyle(
                                                          color:
                                                              PdfColors.black,
                                                          fontSize: 13,
                                                          fontBold: pw.Font
                                                              .helveticaBold(),
                                                        ))),
                                          ])),
                                      pw.Container(
                                          color: PdfColors.grey,
                                          width: 2,
                                          height: 40),
                                      pw.Container(
                                          width: 137,
                                          child: pw.Row(children: [
                                            pw.SizedBox(width: 5),
                                            pw.Container(
                                              width: 70,
                                              child: pw.Text("Signature :",
                                                  style: pw.TextStyle(
                                                      color: PdfColors.black,
                                                      fontSize: 12,
                                                      fontBold: pw.Font
                                                          .helveticaBold(),
                                                      fontWeight:
                                                          pw.FontWeight.bold)),
                                            ),
                                            pw.SizedBox(width: 2),
                                            pw.Container(
                                              width: 67,
                                              child: pw.SizedBox(
                                                  height: 40,
                                                  width: 67,
                                                  child: isPdfFileSignGenerated ==
                                                          true
                                                      ? pw.Image(pw.MemoryImage(
                                                              Base64Decoder()
                                                                  .convert(
                                                                      signature))
                                                          //  signimage
                                                          // ApiCounter.consignmentSignImageBytes ,
                                                          // style: pw.TextStyle(
                                                          //   color: PdfColors.black,
                                                          //   fontSize: 13,
                                                          //   fontBold: pw.Font.helveticaBold(),
                                                          // )
                                                          )
                                                      : pw.Text("",
                                                          style: pw.TextStyle(
                                                            color:
                                                                PdfColors.black,
                                                            fontSize: 13,
                                                            fontBold: pw.Font
                                                                .helveticaBold(),
                                                          ))),
                                            ),
                                          ])),
                                    ]),
                                  ]),
                              pw.Container(
                                width: 267,
                                height: 1,
                                color: PdfColors.black,
                              ),
                              pw.Row(children: [
                                pw.Row(children: [
                                  pw.Container(
                                    width: 140,
                                    padding: pw.EdgeInsets.only(
                                        left: 5,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: pw.Text(" Latitude /\n Longitude :",
                                        style: pw.TextStyle(
                                            color: PdfColors.black,
                                            fontSize: 13,
                                            fontBold: pw.Font.helveticaBold(),
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.SizedBox(width: 2),
                                  pw.Container(
                                      width: 127,
                                      padding: pw.EdgeInsets.all(10),
                                      child: isPdfFileSignGenerated == true
                                          ? pw.Text(
                                              "${consignmentByIdresponse.data!.endLatitude.toString() ?? "-"}\n${consignmentByIdresponse.data!.endLongitude.toString() ?? "-"}",
                                              style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontSize: 12,
                                                fontBold:
                                                    pw.Font.helveticaBold(),
                                              ))
                                          : pw.Text(" ",
                                              style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontSize: 12,
                                                fontBold:
                                                    pw.Font.helveticaBold(),
                                              )))
                                ])
                              ])
                            ])),
                      ]),
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                  width: 180,
                  child: pw.Text("Geo Location Log",
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 18,
                          fontBold: pw.Font.helveticaBold(),
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Table(
                        defaultColumnWidth: pw.FixedColumnWidth(250),
                        border: pw.TableBorder.all(
                            width: 1, color: PdfColors.black),
                        children: [
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text("Geo Location Started",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 13,
                                      fontBold: pw.Font.helveticaBold(),
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: isPdfFileSignGenerated == true
                                    ? pw.Text(
                                        " ${getGeoStartedLatitude.toString()}\n ${getGeoStartedLongitude.toString()}",
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))
                                    : pw.Text(" ",
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))),
                          ]),
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text("Geo Location Delivered",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 13,
                                      fontBold: pw.Font.helveticaBold(),
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: isPdfFileSignGenerated == true
                                    ? pw.Text(
                                        " ${getGeoDeliveredLatitude.toString()}\n ${getGeoDeliveredLongitude.toString()}",
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))
                                    : pw.Text(" ",
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))),
                          ]),
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8.0),
                              child: pw.Text("Date & Time",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 13,
                                      fontBold: pw.Font.helveticaBold(),
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: isPdfFileSignGenerated == true
                                    ? pw.Text(delivereddate.toString(),
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))
                                    : pw.Text(" ",
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 13,
                                          fontBold: pw.Font.helveticaBold(),
                                        ))),
                          ]),
                        ],
                      ),
                    ]),
                // pw.Table(
                //     columnWidths: const {
                //       0: pw.FixedColumnWidth(150),
                //       1: pw.FlexColumnWidth(150),
                //       3: pw.FlexColumnWidth(100),
                //       //4: pw.FlexColumnWidth(90),
                //     },
                //     border: pw.TableBorder.all(
                //       width: 1,
                //       color: PdfColors.black,
                //     ),
                //     children: [
                //       pw.TableRow(children: [
                //         pw.Padding(
                //           padding: pw.EdgeInsets.all(8.0),
                //           child: pw.Text("Geo Location Started",
                //               style: pw.TextStyle(
                //                   color: PdfColors.black,
                //                   fontSize: 13,
                //                   fontBold: pw.Font.helveticaBold(),
                //                   fontWeight: pw.FontWeight.bold)),
                //         ),
                //         pw.Padding(
                //             padding: pw.EdgeInsets.all(8.0),
                //             child: pw.Text("Geo Location Delivered",
                //                 style: pw.TextStyle(
                //                     color: PdfColors.black,
                //                     fontSize: 13,
                //                     fontBold: pw.Font.helveticaBold(),
                //                     fontWeight: pw.FontWeight.bold))),
                //         pw.Padding(
                //           padding: pw.EdgeInsets.all(8.0),
                //           child: pw.Text("Date & Time",
                //               style: pw.TextStyle(
                //                   color: PdfColors.black,
                //                   fontSize: 13,
                //                   fontBold: pw.Font.helveticaBold(),
                //                   fontWeight: pw.FontWeight.bold)),
                //         ),
                //         // pw.Padding(
                //         //   padding: pw.EdgeInsets.all(8.0),
                //         //   child: pw.Text("View In Map",
                //         //       style: pw.TextStyle(
                //         //           color: PdfColors.black,
                //         //           fontSize: 13,
                //         //           fontBold: pw.Font.helveticaBold(),
                //         //           fontWeight: pw.FontWeight.bold)),
                //         // ),
                //       ]),
                //       for (var i = 0;
                //           i < getGeoLocationobj.data.rows.length;
                //           i++)
                //         pw.TableRow(children: [
                //           pw.Container(
                //             height: 40,
                //             padding: pw.EdgeInsets.only(
                //               top: 10,
                //               bottom: 5,
                //             ),
                //             decoration: pw.BoxDecoration(
                //               border: pw.Border.all(
                //                   color: PdfColors.black, width: 1),
                //             ),
                //             child: pw.Column(
                //                 crossAxisAlignment:
                //                     pw.CrossAxisAlignment.center,
                //                 children: [
                //                   pw.Expanded(
                //                     child: pw.Text(
                //                         " ${getGeoStartedLatitude.toString()}\n ${getGeoStartedLongitude.toString()}",
                //                         style: pw.TextStyle(fontSize: 12)),
                //                   ),
                //                 ]),
                //           ),
                //           pw.Container(
                //             height: 40,
                //             padding: pw.EdgeInsets.only(
                //               top: 10,
                //               bottom: 5,
                //             ),
                //             decoration: pw.BoxDecoration(
                //               border: pw.Border.all(
                //                   color: PdfColors.black, width: 1),
                //             ),
                //             child: pw.Column(
                //                 crossAxisAlignment:
                //                     pw.CrossAxisAlignment.center,
                //                 children: [
                //                   pw.Expanded(
                //                     child: pw.Text(
                //                         " ${getGeoDeliveredLatitude.toString()}\n ${getGeoDeliveredLongitude.toString()}",
                //                         style: pw.TextStyle(fontSize: 12)),
                //                   ),
                //                 ]),
                //           ),
                //           pw.Container(
                //             height: 40,
                //             padding: pw.EdgeInsets.only(
                //               top: 10,
                //               bottom: 5,
                //             ),
                //             decoration: pw.BoxDecoration(
                //               border: pw.Border.all(
                //                   color: PdfColors.black, width: 1),
                //             ),
                //             child: pw.Column(
                //                 crossAxisAlignment:
                //                     pw.CrossAxisAlignment.center,
                //                 children: [
                //                   pw.Expanded(
                //                     child: pw.Text(delivereddate,
                //                         style: pw.TextStyle(fontSize: 12)),
                //                   ),
                //                 ]),
                //           ),
                //           // pw.Container(
                //           //   height: 40,
                //           //   padding: pw.EdgeInsets.only(
                //           //     top: 10,
                //           //     bottom: 5,
                //           //   ),
                //           //   decoration: pw.BoxDecoration(
                //           //     border: pw.Border.all(
                //           //         color: PdfColors.black, width: 1),
                //           //   ),
                //           //   child: pw.Column(
                //           //       crossAxisAlignment:
                //           //           pw.CrossAxisAlignment.center,
                //           //       children: [
                //           //         pw.Text(String.fromCharCode(0xf59f),
                //           //             style: pw.TextStyle(
                //           //               fontSize: 30,
                //           //               color: PdfColors.green,
                //           //             ))
                //           //         // pw.Container(
                //           //         //   child: locationbyteList != null
                //           //         //       ? pw.Image(
                //           //         //           pw.MemoryImage(locationbytes.buffer
                //           //         //               .asUint8List()),
                //           //         //           fit: pw.BoxFit.fitHeight,
                //           //         //           height: 30,
                //           //         //           width: 30)
                //           //         //       : pw.Container(),
                //           //         //   decoration: pw.BoxDecoration(
                //           //         //     color: PdfColors.green,
                //           //         //   ),
                //           //         //   height: 120,
                //           //         //   padding: pw.EdgeInsets.all(10),
                //           //         // ),
                //           //       ]),
                //           // ),
                //         ]),
                //     ]),
              ]),
        )
      ];
    }));

    //Generate pdf file data
    final pdfData = await pdf.save();

    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      // final appsDocumentDirectory = await getExternalStorageDirectory();
      // final downloadDirectory =
      //     Directory("${appsDocumentDirectory!.path}/Download");
      // print("download path:$downloadDirectory");
      // downloadDirectory.create(recursive: true);
      var dir = await _getDownloadDirectory();
      var downloadsPath = dir!.path;
      // final filePath = '${downloadDirectory.path}/screen.pdf';
      var filePath = '$downloadsPath/Consignment($fileNumber).pdf';
      print("file path:$filePath");
      final pdfFile = File(filePath);

      //check if the file already exists
      if (await pdfFile.exists()) {
        while (await pdfFile.exists()) {
          fileNumber++;
          final newfilename = "Consignment($fileNumber).pdf";
          filePath = '$downloadsPath/$newfilename';
          notifyListeners();
        }
      }
      //save the pdf file
      await pdfFile.writeAsBytes(pdfData);
      fileNumber++;
      notifyListeners();
      //open the pdf file

      PDFView(
        filePath: filePath,
      );

      Fluttertoast.showToast(
          msg: "File is saved to downloads folder.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 16.0);
      // await FlutterPdfview.openPdfFile(filePath);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Permission denied"),
                content: Text(
                    "Please grant storage permission to download pdf file"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Ok"),
                  )
                ],
              ));
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  String _fileurl = '';

  String get fileUrl => _fileurl;

  void loadFile(String url) {
    _fileurl = url;
    notifyListeners();
  }

  Future<void> viewpdf(String fileUrl, String filename) async {
    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      var dir = await _getDownloadDirectory();
      print("dir:$dir");
      var downloadsPath = dir!.path;
      print("downloadsPath:$downloadsPath");
      // final filePath = '${downloadDirectory.path}/screen.pdf';
      Response response = await Dio().get(
        fileUrl,

        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);

      File file1 = File("$downloadsPath/$filename");

      var raf = file1.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      PDFView(
        filePath: file1.path,
      );
      Fluttertoast.showToast(
          msg: "File is saved to downloads folder.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//for downloading file
  double _progress = 0.0;
  bool _isDownloading = false;

  double get progress => _progress;

  bool get isDownloading => _isDownloading;

  void startDownload() {
    _isDownloading = true;
    _progress = 0.0;
    notifyListeners();

    Future.delayed(Duration(seconds: 1), () {
      for (int i = 1; i <= 0; i++) {
        _progress = i / 10;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {});
      }
      _isDownloading = false;
      notifyListeners();
    });
  }

  int selectedIndex = 0;
  var currentLocation = Environement.myLocation;

  // Waypoints to mark trip start and end
  LatLng source = LatLng(28.6269, 77.3741);
  LatLng destination = LatLng(28.629876, 77.317654);

  // late WayPoint sourceWaypoint, destinationWaypoint;

  // var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  // MapBoxOptions? options;
  double? distanceRemaining, durationRemaining;

  // MapBoxNavigationViewController? controller;
  MapController? mapcontroller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;
  BuildContext? _context;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  bool isSaveButtonVisible = false;

  void setSaveButtonVisible(bool enabled) {
    isSaveButtonVisible = enabled;
    notifyListeners();
  }

  void setsignaturebutton(bool enable) {
    _isSignatureButtonDisable = true;
    notifyListeners();
  }

  List<LocationOnConsignmentById> _consignmentLocations = [];

  //List<bool> _isSaveButtonVisible = [];

  List<LocationOnConsignmentById> get consignmentLocations =>
      _consignmentLocations;

  //List<bool> get isSaveButtonVisible => _isSaveButtonVisible;

  // void setSaveButtonVisible(int index, bool enabled) {
  //   if (index >= 0 && index < _isSaveButtonVisible.length) {
  //     _isSaveButtonVisible[index] = enabled;
  //     notifyListeners();
  //   }
  // }

  void updateLocations(
      String consignmentId,
      double startedLatitude,
      double startedLongitude,
      double deliveredLatitude,
      double deliveredLongitude,
      int index) {
    var startedLocation = LatLng(
      startedLatitude,
      startedLongitude,
    );
    var deliveredLocation = LatLng(
      deliveredLatitude,
      deliveredLongitude,
    );
    print("startedLocation:$startedLocation");
    print("deliveredLocation:$deliveredLocation");

    final addLatlong = LocationOnConsignmentById(
        consignmentId: consignmentId,
        startedLocation: startedLocation,
        deliveredLocation: deliveredLocation);
    _consignmentLocations.add(addLatlong);
    // _isSaveButtonVisible.add(false);
    notifyListeners();

    print(
        "_consignmentStartedLocations length:${_consignmentLocations.length}");
    print(
        "_consignmentStartedLocations consignmentId:${_consignmentLocations[index].consignmentId}");
    print(
        "_consignmentStartedLocations startedLocation:${_consignmentLocations[index].startedLocation}");
    print(
        "_consignmentStartedLocations deliveredLocation:${_consignmentLocations[index].deliveredLocation}");
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/map_marker.svg")
        .then(
      (icon) {
        markerIcon = icon;
        notifyListeners();
      },
    );
  }

  // Future<void> initializeMap(double? latitude, double? longitude) async {
  //   MapBoxNavigation.instance.registerRouteEventListener(onRouteEvent);

  //   options = MapBoxOptions(
  //       initialLatitude: latitude,
  //       initialLongitude: longitude,
  //       zoom: 20.0,
  //       tilt: 0.0,
  //       alternatives: true,
  //       enableRefresh: true,
  //       animateBuildRoute: true,
  //       voiceInstructionsEnabled: true,
  //       bannerInstructionsEnabled: true,
  //       mode: MapBoxNavigationMode.drivingWithTraffic,
  //       isOptimized: true,
  //       units: VoiceUnits.metric,
  //       simulateRoute: true,
  //       showReportFeedbackButton: false,
  //       showEndOfRouteFeedback: false,
  //       language: "en");

  //   // Configure waypoints
  //   sourceWaypoint =
  //       WayPoint(name: "Source", latitude: latitude, longitude: longitude);
  //   // destinationWaypoint = WayPoint(
  //   //     name: "Destination",
  //   //     latitude: destination.latitude,
  //   //     longitude: destination.longitude);
  //   print("sourceWaypoint name:${sourceWaypoint.name}");
  //   print("sourceWaypoint latitude:${sourceWaypoint.latitude}");
  //   print("sourceWaypoint longitude:${sourceWaypoint.longitude}");
  //   // print("destinationWaypoint name:${destinationWaypoint.name}");
  //   // print("destinationWaypoint latitude:${destinationWaypoint.latitude}");
  //   // print("destinationWaypoint longitude:${destinationWaypoint.longitude}");

  //   wayPoints.add(sourceWaypoint);
  //   // wayPoints.add(destinationWaypoint);

  //   print("waypoint length:${wayPoints.length}");
  //   notifyListeners();

  //   // Start the trip
  //   // if (wayPoints.isNotEmpty) {
  //   // await MapBoxNavigation.instance
  //   //     .startNavigation(wayPoints: wayPoints, options: options);

  //   //  } else {
  //   //   print("WayPoints must be at least 1");
  //   //  }
  // }

  // Future<void> onRouteEvent(e) async {
  //   // distanceRemaining = (await directions!.getDistanceRemaining())!;
  //   // durationRemaining = (await directions!.getDurationRemaining())!;

  //   switch (e.eventType) {
  //     case MapBoxEvent.progress_change:
  //       var progressEvent = e.data as RouteProgressEvent;
  //       arrived = progressEvent.arrived!;
  //       if (progressEvent.currentStepInstruction != null) {
  //         instruction = progressEvent.currentStepInstruction!;
  //       }
  //       break;
  //     case MapBoxEvent.route_building:
  //     case MapBoxEvent.route_built:
  //       routeBuilt = true;
  //       break;
  //     case MapBoxEvent.route_build_failed:
  //       routeBuilt = false;
  //       break;
  //     case MapBoxEvent.navigation_running:
  //       isNavigating = true;
  //       break;
  //     case MapBoxEvent.on_arrival:
  //       arrived = true;
  //       if (!isMultipleStop) {
  //         await Future.delayed(const Duration(seconds: 3));
  //         await MapBoxNavigation.instance.finishNavigation();
  //         Navigator.pop(_context!);
  //       } else {}
  //       break;
  //     case MapBoxEvent.navigation_finished:
  //     case MapBoxEvent.navigation_cancelled:
  //       routeBuilt = false;
  //       isNavigating = false;
  //       break;
  //     default:
  //       break;
  //   }
  // }

  Position currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  String? currentAddress;
  bool? serviceEnabled;
  LocationPermission? permission;

  Future<bool> handleLocationPermission(BuildContext context) async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      locationEnabledDialog(context);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location services are disabled. Please enable the services')));
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress =
          '${place.street},\n${place.subLocality},\n${place.postalCode},\n${place.country}';
      print("currentAddress:$currentAddress");
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getCurrentPosition(BuildContext? context) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    // if (!isLocationEnabled) {
    //   locationEnabledDialog(context);
    // }
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        currentPosition = position;
        setDeliveredLocationVisible(true);
        getAddressFromLatLng(currentPosition);
        notifyListeners();
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
    // final hasPermission = await _handleLocationPermission(context);
    // if (!hasPermission) return;
  }

  bool _isSaveButtonDisable = false;
  bool _isSignatureButtonDisable = false;
  Color _saveButtonColor = ThemeColor.themeGreenColor;

  bool get isSaveButtonDisable => _isSaveButtonDisable;

  bool get isSignatureButtonDisable => _isSignatureButtonDisable;

  Color get saveButtonColor => _saveButtonColor;

  void saveButtonDisable() {
    _isSaveButtonDisable = true;
    _isSignatureButtonDisable = true;
    _saveButtonColor = ThemeColor.themeLightGrayColor;
    notifyListeners();
  }

  double? startingLatitude;
  double? startingLongitude;
  double deliveredLatitude = 0.0;
  double deliveredLongitude = 0.0;

  String? consignmentdeliveredDate;

  void setDeliveredDate(String? deliveredDate) {
    consignmentdeliveredDate = deliveredDate;
    notifyListeners();
  }

  String? consignmentReceivedDate;

  void setReceivedDate(String? receivedDate) {
    consignmentReceivedDate = receivedDate;
    notifyListeners();
  }

  void setStartingLocation(double latitude, double longitude) {
    startingLatitude = latitude;
    startingLongitude = longitude;
    notifyListeners();
  }

  void setDeliveredLocation(double latitude, double longitude) {
    deliveredLatitude = latitude;
    deliveredLongitude = longitude;
    notifyListeners();
  }

  bool isLocationEnabled = false;

  bool get isLocationEnable => isLocationEnabled;

  void setLocationEnabled(bool enabled) {
    isLocationEnabled = enabled;
    notifyListeners();
  }

  void checkLocationEnabled() async {
    // Location location =
    //     Location(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now());
    // bool serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   _isLocationEnabled = false;
    //   notifyListeners();
    //   return;
    // }
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus.isRestricted) {
      isLocationEnabled = false;
      notifyListeners();
      return;
    }
    isLocationEnabled = true;
    notifyListeners();
  }

  bool isDeliveredLocationOn = false;

  void setDeliveredLocationVisible(bool enabled) {
    isDeliveredLocationOn = enabled;
    notifyListeners();
  }

  Future<bool> showLocationAlertDialog(
    BuildContext context,
  ) async {
    if (!Platform.isIOS) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: Platform.isAndroid ? 280.0 : 230,
          ),
          title: const Text(
            'Location Services Disabled',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontName.interSemiBold,
              fontSize: 16,
              color: Color(0xff243444),
            ),
          ),
          content: const Text(
            'You need to enable Location Services in Settings.',
            style: TextStyle(
              fontFamily: FontName.interMedium,
              fontSize: 13,
              color: Color(0xff243444),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.themeDarkGreyColor,
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: FontName.interRegular,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
                // isDeliveredLocationOn=true;
                setDeliveredLocationVisible(true);
                //  openAppSettings();
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.themeGreenColor,
              ),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontFamily: FontName.interRegular,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Location Services Disabled',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FontName.interSemiBold,
            fontSize: 16,
            color: Color(0xff243444),
          ),
        ),
        content: const Text(
          'You need to enable location services in settings.',
          style: TextStyle(
            fontFamily: FontName.interMedium,
            fontSize: 13,
            color: Color(0xff243444),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: FontName.interRegular,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: const Text(
              'Settings',
              style: TextStyle(
                fontFamily: FontName.interRegular,
                fontSize: 12,
                color: ThemeColor.themeGreenColor,
              ),
            ),
            onPressed: () {
              // openAppSettings();
              Geolocator.openLocationSettings();
              setDeliveredLocationVisible(true);
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  void locationEnabledDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: Platform.isAndroid ? 280.0 : 230,
                ),
                title: Text(
                  "Location Permission",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.interSemiBold,
                    fontSize: 16,
                    color: Color(0xff243444),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Please grant permission to access your location.",
                      style: TextStyle(
                        fontFamily: FontName.interMedium,
                        fontSize: 13,
                        color: Color(0xff243444),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.themeDarkGreyColor,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: FontName.interRegular,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // PermissionStatus status =
                            //     await Permission.location.request();
                            // if (status.isGranted) {
                            //   setLocationEnabled(true);
                            // }
                            getCurrentPosition(context);

                            setLocationEnabled(true);
                            Navigator.pop(context);

                            notifyListeners();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.themeGreenColor,
                          ),
                          child: Text(
                            "Grant Permission",
                            style: TextStyle(
                              fontFamily: FontName.interRegular,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  double destinationLatitude = 0;
  double destinationLongitude = 0;

  Future<List<double>> getCoordinates(String deliveryAddress) async {
    try {
      List<Location> locations = await locationFromAddress(deliveryAddress);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        destinationLatitude = location.latitude;
        destinationLongitude = location.longitude;
        notifyListeners();

        return [destinationLatitude, destinationLongitude];
      }
    } catch (e) {
      print('Error:$e');
    }
    return [];
  }

  // openMap(double latitude, double longitude) async {
  //   final MapBoxNavigation mapBoxNavigation = MapBoxNavigation();
  //   bool? isInitialized = await mapBoxNavigation.init();
  //   if (isInitialized) {
  //     await mapBoxNavigation.startNavigation(
  //         options: MapBoxOptions(
  //             initialLatitude: latitude,
  //             initialLongitude: longitude,
  //             zoom: 16));
  //   }
  // }

  bool isConsignmentDetail = false;
  bool isDeliveredConsignment = false;

  SignatureView? signatureView;
  Uint8List? _signatureData;

  Uint8List? get signatureData => _signatureData;

  void setSignauteData(Uint8List data) {
    _signatureData = data;
    notifyListeners();
  }

  String? _signature;

  String? get signature => _signature;

  void setSignaute(String data) {
    _signature = data;
    notifyListeners();
  }

  // final SignatureController signatureController = SignatureController(
  //     penStrokeWidth: 3.0,
  //     penColor: Colors.black,
  //     exportBackgroundColor: Colors.white);
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  SubmitDriverFitnessRequest objdriverfitnessdata = SubmitDriverFitnessRequest(
      driverid: '',
      companyid: '',
      checklistdate: '',
      checklisttype: '0',
      checklistvalue: [],
      timesheetid: '');
  int fitnesschecklistpst = 0;
  List<driverfitnessdata> objitemfitnessdata = [];

  Widget createfitnesschecklistitem(
      BuildContext context, FitnessChecklistData objfitnessdata) {
    fitnesschecklistpst++;

    // in case checklist submitted to show all the filled value as at the time of submission
    print("isYes:" + objfitnessdata.isYes.toString());

    // if checklist already submitted
    if (selectedindexidchecklisttype2 == 1) {
      if (objfitnessdata.isYes) {
        //yesphysicallyStatusColor =
        objfitnessdata.YesColor = ThemeColor.themeGreenColor;
        // nophysicallyStatusColor =
        objfitnessdata.NoColor = ThemeColor.themeLightGrayColor;
        objfitnessdata.isYes = true;
        objfitnessdata.isNo = false;
      } else {
        // yesphysicallyStatusColor =
        objfitnessdata.YesColor = ThemeColor.themeLightGrayColor;
        //nophysicallyStatusColor =
        objfitnessdata.NoColor = ThemeColor.themeGreenColor;
        objfitnessdata.isYes = false;
        objfitnessdata.isNo = true;
      }
    }
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 10, left: 10, bottom: 13, right: 10),
        height: 20,
        width: MediaQuery.of(context).size.width,
        child: Text(
          // "Am I physically well?",
          objfitnessdata.checklistName,
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontFamily: 'InterSemiBold'),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 159,
              height: 38,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        //yesphysicallyStatusColor,
                        objfitnessdata.YesColor,
                    foregroundColor:
                        //  yesphysicallyStatusColor ==
                        objfitnessdata.YesColor == ThemeColor.themeGreenColor
                            ? Colors.white
                            : ThemeColor.themeDarkestGrayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                          width: 1,
                          color:
                              //yesphysicallyStatusColor ==
                              objfitnessdata.YesColor ==
                                      ThemeColor.themeGreenColor
                                  ? ThemeColor.themeGreenColor
                                  : ThemeColor.themeDarkestGrayColor),
                    ),
                  ),
                  onPressed: () {
                    if (selectedindexidchecklisttype2 == 0) {
                      if (!objfitnessdata.isYes) {
                        //yesphysicallyStatusColor =
                        objfitnessdata.YesColor = ThemeColor.themeGreenColor;
                        // nophysicallyStatusColor =
                        objfitnessdata.NoColor = ThemeColor.themeLightGrayColor;
                        objfitnessdata.isYes = true;
                        objfitnessdata.isNo = false;
                      } else {
                        // yesphysicallyStatusColor =
                        objfitnessdata.YesColor =
                            ThemeColor.themeLightGrayColor;
                        //nophysicallyStatusColor =
                        objfitnessdata.NoColor = ThemeColor.themeGreenColor;
                        objfitnessdata.isYes = false;
                        objfitnessdata.isNo = true;
                      }
                      print("fitnesschecklistpst::pressed:: Yes" +
                          fitnesschecklistpst.toString());
                      notifyListeners();
                    } else {
                      print("already submitted");
                    }
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'InterSemiBold',
                    ),
                  ))),
          const SizedBox(
            width: 17,
          ),
          SizedBox(
              width: 159,
              height: 38,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        //nophysicallyStatusColor,
                        objfitnessdata.NoColor,
                    foregroundColor:
                        //nophysicallyStatusColor ==
                        objfitnessdata.NoColor == ThemeColor.themeGreenColor
                            ? Colors.white
                            : ThemeColor.themeDarkestGrayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                          width: 1,
                          color:
                              //nophysicallyStatusColor ==
                              objfitnessdata.NoColor ==
                                      ThemeColor.themeGreenColor
                                  ? ThemeColor.themeGreenColor
                                  : ThemeColor.themeDarkestGrayColor),
                    ),
                  ),
                  onPressed: () {
                    if (selectedindexidchecklisttype2 == 0) {
                      if (!objfitnessdata.isNo) {
                        //nophysicallyStatusColor =
                        objfitnessdata.NoColor = ThemeColor.themeGreenColor;
                        //yesphysicallyStatusColor =
                        objfitnessdata.YesColor =
                            ThemeColor.themeLightGrayColor;
                        objfitnessdata.isNo = true;
                        objfitnessdata.isYes = false;
                        // itemfitnessdata.Yes = 0;
                        //  itemfitnessdata.No = 1;
                      } else {
                        //nophysicallyStatusColor =
                        objfitnessdata.NoColor = ThemeColor.themeLightGrayColor;
                        //yesphysicallyStatusColor =
                        objfitnessdata.YesColor = ThemeColor.themeGreenColor;
                        objfitnessdata.isNo = false;
                        objfitnessdata.isYes = true;
                        //  itemfitnessdata.Yes = 1;
                        //  itemfitnessdata.No = 0;
                      }
                      print("fitnesschecklistpst::pressed:: No" +
                          fitnesschecklistpst.toString());
                      notifyListeners();
                    } else {
                      print("already submitted");
                    }
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'InterSemiBold',
                    ),
                  ))),
        ],
      ),
    ]);
  }

  SubmitVehicleFitnessRequest objvehiclefitnessdata =
      SubmitVehicleFitnessRequest(
          driverid: '',
          companyid: '',
          checklistdate: '',
          checklisttype: '0',
          checklistvalue: [],
          timesheetid: '');

  List<bool> isallselect = [];

  // tabs in Consignment List screen for tracking consignments status
  PageController pageController = PageController(initialPage: 0);
  int _selectedTab = 0;
  var allpageNum = 1;
  var bookedpageNum = 1;
  var confirmedpageNum = 1;
  var deliveredpageNum = 1;

  int get selectedTab => _selectedTab;

  void selectConsignmentTab(int index) {
    _selectedTab = index;
    allpageNum = 1;
    bookedpageNum = 1;
    confirmedpageNum = 1;
    deliveredpageNum = 1;
    notifyListeners();
  }

  List<String> _signatures = [];

  List<String> get signatures => _signatures;

  Future<void> addSignature(String signature) async {
    _signatures.add(signature);
    notifyListeners();
  }

  Future<void> removeSignature(int index) async {
    _signatures.removeAt(index);
    await _saveSignatures();
    notifyListeners();
  }

  Future<void> _saveSignatures() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('signatures', _signatures);
    notifyListeners();
  }

  Future<void> loadSignatures() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.getStringList('signatures') ?? [];
    notifyListeners();
  }

  //Sign Consignment
  SignOnConsignmentResponse _signConsignmentsResponse =
      SignOnConsignmentResponse();

  SignOnConsignmentResponse get signConsignmentResponse =>
      _signConsignmentsResponse;

  var signConsignmentRequestObj = SignOnConsignmentRequest();
  bool _signConsignmentIntialLoaded = true;

  bool get signConsignmentIntialLoaded => _signConsignmentIntialLoaded;

  set signConsignmentDataIntialLoaded(bool value) {
    _signConsignmentIntialLoaded = value;
    notifyListeners();
  }

  // Sign Consignment API Call:

  Future<void> signConsignmentRequest(
      SignOnConsignmentRequest signConsignmentRequestData,
      String consignmentID,
      BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      notifyListeners();
      final signConsignmentResponse =
          await _lltechrepository.signConsignmentRepo(
              signConsignmentRequestData, consignmentID, Environement.driverID);
      _signConsignmentsResponse = signConsignmentResponse!;
      print("signConsignmentResponse:$signConsignmentResponse");

      if (_signConsignmentsResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        Fluttertoast.showToast(
            msg: "Consignment Delivered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);

        List<GeoDetail> consignmentGeoDetailArr = [
          GeoDetail(
              consignmentId:
                  consignmentByIdresponse.data!.consignmentId.toString(),
              driverId: Environement.driverID,
              startedLatitude: currentPosition.latitude.toString(),
              startedLongitude: currentPosition.longitude.toString(),
              deliveredLatitude: deliveredLatitude.toString(),
              deliveredLongitude: deliveredLongitude.toString(),
              geoDate: DateTime.now())
        ];
        //for (var i = 0; i < lp.addconsignmentGeoDetailWidgetArr.length; i++) {
        // var consignmentAddGeoDetailObj = GeoDetail();
        // consignmentAddGeoDetailObj.consignmentId =
        //     lp.consignmentByIdresponse.data!.consignmentId.toString();
        // consignmentAddGeoDetailObj.driverId = Environement.driverID;
        // consignmentAddGeoDetailObj.startedLatitude =
        //     lp.currentPosition.latitude.toString();
        // consignmentAddGeoDetailObj.startedLongitude =
        //     lp.currentPosition.longitude.toString();
        // consignmentAddGeoDetailObj.deliveredLatitude =
        //     lp.deliveredLatitude.toString();
        // consignmentAddGeoDetailObj.deliveredLongitude =
        //     lp.deliveredLongitude.toString();
        // consignmentAddGeoDetailObj.geoDate = DateTime.now();

        // lp.addGeoLocationRequest(lp.addGeoLocationRequestObj, context);
        //  consignmentAddGeoDetailObj.consignmentId =
        //      lp.consignmentByIdresponse.data!.consignmentId.toString();

        //  consignmentGeoDetailArr.add(consignmentAddGeoDetailObj);
        // print(
        //     "Consignment Add Geo Details consignmentId:$consignmentGeoDetailArr");
        // print(
        //     "Consignment Add Geo Details consignmentId:${consignmentGeoDetailArr[0].consignmentId}");
        // print(
        //     "Consignment Add Geo Details driverId:${consignmentGeoDetailArr[0].driverId}");
        // print(
        //     "Consignment Add Geo Details startedLatitude:${consignmentGeoDetailArr[0].startedLatitude}");
        // print(
        //     "Consignment Add Geo Details startedLongitude:${consignmentGeoDetailArr[0].startedLongitude}");
        // print(
        //     "Consignment Add Geo Details deliveredLatitude:${consignmentGeoDetailArr[0].deliveredLatitude}");
        // print(
        //     "Consignment Add Geo Details deliveredLongitude:${consignmentGeoDetailArr[0].deliveredLongitude}");
        // print(
        //     "Consignment Add Geo Details geoDate:${consignmentGeoDetailArr[0].geoDate}");

        addGeoLocationRequestObj = consignmentGeoDetailArr;

        addGeoLocationRequest(addGeoLocationRequestObj, context);

        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  List<Widget> addconsignmentGeoDetailWidgetArr = <Widget>[];

  //Add geoLocation
  AddGeoLocationResponse _addGeoLocationResponse = AddGeoLocationResponse();

  AddGeoLocationResponse get addGeoLocationResponse => _addGeoLocationResponse;

  List<GeoDetail> addGeoLocationRequestObj = [];
  bool _addGeoLocationIntialLoaded = true;

  bool get addGeoLocationIntialLoaded => _addGeoLocationIntialLoaded;

  set addGeoLocationDataIntialLoaded(bool value) {
    _addGeoLocationIntialLoaded = value;
    notifyListeners();
  }

  Future<void> addGeoLocationRequest(
      List<GeoDetail> addGeoLocationRequestData, BuildContext context) async {
    try {
      isSuccess = false;
      isLoading = true;
      isError = false;
      //notifyListeners();
      final addGeoLocationResponse =
          await _lltechrepository.addGeoLocationRepo(addGeoLocationRequestObj);
      _addGeoLocationResponse = addGeoLocationResponse!;
      print("addGeoLocationResponse:$addGeoLocationResponse");

      if (_addGeoLocationResponse.status == 1) {
        isSuccess = true;
        isError = false;
        isLoading = false;

        // Fluttertoast.showToast(
        //     msg: "Added Successfully",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: ThemeColor.themeGreenColor,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        navigatetoConsignmentDetails(
            context,
            Environement.indexPstConsignmentListing,
            Environement.consignmentId);
        // consignmentByIdRequest(Environement.consignmentId);
        //  navigatetoConsignmentJob(context);
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isSuccess = false;
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_authenticate $e");
    }
  }

  // Get GeoLocation
  GeoLocationData? _geoLocationData;

  GeoLocationData? get geoLocationData => _geoLocationData;

  void setFeoLocationData(GeoLocationData geoData) {
    _geoLocationData = geoData;
    notifyListeners();
  }

  GetGeoLocationResponse getGeoLocationobj =
      GetGeoLocationResponse(data: GeoLocationData(rows: []));

  Future<void> getGeoLocationByConsignmentIdRequest(
      String consignmentId) async {
    try {
      isLoading = true;
      isError = false;
      // notifyListeners();
      GetGeoLocationResponse? getGeoLocationresponse =
          await _lltechrepository.getGeoLocationRepo(consignmentId);
      getGeoLocationobj = getGeoLocationresponse!;

      if (getGeoLocationobj.status == 1) {
        isError = true;
        isLoading = false;
        isSuccess = false;

        notifyListeners();
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;

        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("GeoLocationByConsignmentIdRequest $e");
    }
  }

  FitnessSubmittedResponse _objdriverfitnessresponse = FitnessSubmittedResponse(
      status: 0, data: fitnessData(success: false, data: ''));
  FitnessSubmittedResponse _objvehiclefitnessresponse =
      FitnessSubmittedResponse(
          status: 0, data: fitnessData(success: false, data: ''));

  FitnessSubmittedResponse get objdriverfitnessresponse =>
      _objdriverfitnessresponse;

  FitnessSubmittedResponse get objvehiclefitnessresponse =>
      _objvehiclefitnessresponse;

  bool isdriverfitnesssubmitted = false;

  Future<void> submitdriverfitnessprovider(
      String type, BuildContext ctx) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final statusubmit = await _lltechrepository.submitdriverfitnessrepo(
          type, objdriverfitnessdata);

      if (statusubmit.data.success) {
        isError = false;
        isLoading = false;
        isSuccess = false;
        _objdriverfitnessresponse = statusubmit;
        Fluttertoast.showToast(
            msg: "Driver Fitness Submitted",
            //msg: statusubmit.data.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);
        isdriverfitnesssubmitted = true;
        selectedindexidchecklisttype2 = 1;
        notifyListeners();
        //navigatetofilltimesheet(ctx);
        navigatetoJobdetail(ctx);
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;
        selectedindexidchecklisttype2 = 0;
        Fluttertoast.showToast(
            //   msg: "Some thing Went Wrong, Please try Again",
            msg: statusubmit.data.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);
        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_submitdriverfitnessprovider $e");
    }
  }

  bool isvehiclefitnesssubmitted = false;

  Future<void> submitvehiclefitnessprovider(
      String type, BuildContext ctx) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      notifyListeners();
      final statusubmit = await _lltechrepository.submitvehiclefitnessrepo(
          type, objvehiclefitnessdata);

      if (statusubmit.data.success) {
        isError = false;
        isLoading = false;
        isSuccess = false;
        _objvehiclefitnessresponse = statusubmit;
        Fluttertoast.showToast(
            msg: "Vehicle Fitness Submitted",
            //msg: statusubmit.data.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);
        isvehiclefitnesssubmitted = true;
        slectedindexchecklisttype1 = 1;
        notifyListeners();
        //  navigatetofilltimesheet(ctx);
        navigatetoJobdetail(ctx);
      } else {
        isSuccess = true;
        isLoading = false;
        isError = false;
        slectedindexchecklisttype1 = 0;
        Fluttertoast.showToast(
            //   msg: "Some thing Went Wrong, Please try Again",
            msg: statusubmit.data.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);

        notifyListeners();
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      notifyListeners();
      print("Exception_provider_submitvehiclefitnessprovider $e");
    }
  }

  CompanyDriverList _objcompanydriverlist =
      CompanyDriverList(status: 0, data: []);

  CompanyDriverList get objcompanydriverlist => _objcompanydriverlist;

  List<String> arrcompanylist = [];
  String selectedcompanystr = '';

  Future<void> getallcompanylistbyid(String userid, BuildContext ctx) async {
    try {
      isLoading = true;
      isError = false;
      isSuccess = false;
      isloginsuccess = false;
      notifyListeners();
      final companylistbydriverid =
          await _lltechrepository.getcompanydriverlist(userid, "4");
      if (companylistbydriverid.status == 1) {
        isLoading = false;
        isError = false;
        isSuccess = false;
        isloginsuccess = true;
        _objcompanydriverlist = companylistbydriverid;
        arrcompanylist = [];
        for (var element in companylistbydriverid.data) {
          Environement.driverselectedCompany = element.companyName;
          arrcompanylist.add(element.companyName);
        }
        if (arrcompanylist.length == 1) {
          // navigatetofilltimesheet(ctx);
          navigatetoListTimeSheet(ctx);
        }
        notifyListeners();
      } else {
        isSuccess = false;
        isLoading = false;
        isError = false;
        isloginsuccess = false;
        Fluttertoast.showToast(
            msg: "Some thing Went Wrong, Please try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ThemeColor.themeGreenColor,
            textColor: Colors.white,
            fontSize: 16.0);

        notifyListeners();
      }
    } catch (e) {
      print("provider_companybydriver" + e.toString());
    }
  }

  bool _isPasswordHidden = false;
  bool get isPasswordHidden => _isPasswordHidden;
  void setPasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  bool _isSignClear = false;
  bool get isSignClear => _isSignClear;
  void setClearButtonDisabled(bool value) {
    _isSignClear = value;
    notifyListeners();
  }
}

extension MyDateExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }
}
