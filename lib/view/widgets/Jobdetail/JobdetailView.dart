import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:lttechapp/entity/GetTimeSheetByIdResponse.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/router/routes.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/DateHelpers.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../entity/ApiRequests/AddTimeSheetRequest.dart';
import '../../../entity/ApiRequests/Updatetimesheetrequest.dart';
import '../../../entity/Driverjobresponse.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/SizeConfig.dart';
import '../../../utility/StatefulWrapper.dart';
import '../../../utility/env.dart';

class JobdetailView extends StatelessWidget {
  JobdetailView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final ScrollController _scrollController = ScrollController();

  late BuildContext _providerContext;

  // List<Widget> arradddetail = [];
  int addmorecnt = 0;

  /*Future _addingInitialJobCard(double width, double height) async {
    await Future.delayed(Duration.zero, () {
      addInitialData(width, height, _providerContext);
    });
  }*/

  /*addInitialData(width, height, BuildContext context) {
    final arrDetails =
        Provider.of<Lttechprovider>(context, listen: false).arradddetail;

    if (arrDetails.isEmpty) {
      arrDetails.add(createdetailcolumn(
        width,
        height,
        context,
        Provider.of<Lttechprovider>(context, listen: false),
      ));
      print('addInitialData called');
      // Provider.of<Lttechprovider>(context, listen: false).updateIntialLoaded =
      //     false;
      Provider.of<Lttechprovider>(context, listen: false).setUpdateView =
          true; // updating view
    }
  }*/

  var newtimesheetid = '';

  List<JobDetail> jobDetailArr = [];
  List<JobDetails> jobdetailarrupdate = [];
  String strtrailers = '';
  @override
  Widget build(BuildContext context) {
    _providerContext = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    // _decodedImage = base64Decode(_base64);
    SizeConfig().init(context);
    Future<bool> _onWillPop() async {
      print("back called");

      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoListTimeSheet(context);

      return true;
    }

    return StatefulWrapper(
        onInit: () {
          Future.delayed(Duration.zero, () async {
            final provider =
            Provider.of<Lttechprovider>(context, listen: false);
            print("value.selectedtruckstr:" +
                provider.selectedtruckstr.toString());
            String strtrailers =  provider.arrdisplayselectedtrailer.join(',');
            provider.isError = false;
            provider.isSuccess = false;
            if (!provider.isEditTimesheet) {
              provider.getdrivejobprovider(
                  Environement.driverID,
                  provider.pickupdatefortimesheetjob.toString(),
                  provider.addTimeSheetRequestObj.truck);

              updaterestdetailinofflinearray(provider);
            } else {


              provider.getdrivejobprovider(
                //provider.updatetimesheetrequestObj.driverId,
                  Environement.driverID,
                  provider.pickupdatefortimesheetjob.toString(),
                  provider.updatetimesheetrequestObj.truck);

              updaterestdetailinofflinearray(provider);
            }

          });
          jobDetailArr = [];
          jobdetailarrupdate = [];
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              key: _scaffoldKey,
              // appBar: commonAppBar('/TimesheetList'),
              appBar: commonAppBar('/FillTimesheet',
                  Provider.of<Lttechprovider>(context, listen: false)),
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffFAFAFA),
              body: Consumer<Lttechprovider>(builder: (context, value, child) {
              //  newtimesheetid = value.gettimesheetid();
                String? formattimesheetDate;
                if (value.isEditTimesheet) {
                  var timesheetdate = value
                      .getTimesheetByIdResponse.data?.timesheetDate
                      .toString() ??
                      "";
                  var actualtimesheetdate = DateTime.parse(timesheetdate);

                  if (!timesheetdate.isEmpty) {
                    formattimesheetDate =
                    // Jiffy.parse(actualtimesheetdate.addDays(1).toString())
                    Jiffy.parse(actualtimesheetdate.toString())
                        .yMMMMd;
                  } else {}
                } else {
                  formattimesheetDate =
                      value.addTimeSheetRequestObj.timesheetdate;
                }
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 18, top: 32, bottom: 27, right: 154),
                      height: 29,
                      width: 203,
                      child: Text(
                        "Fill Job Details",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff000000),
                            fontFamily: 'InterBold'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffEEEEEE),
                              blurRadius: 3.0,
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xffEEEEEE),
                            width: 1.0,
                          ),
                        ),
                        width: double.infinity,
                        height: Platform.isIOS
                            ? SizeConfig.safeBlockVertical * 75
                            : SizeConfig.safeBlockVertical * 74,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  height: Platform.isAndroid
                                      ? SizeConfig.screenHeight * 0.20
                                      : null,
                                  //  height:89,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffEEEEEE),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color(0xffEEEEEE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontFamily: 'InterMedium',
                                                      fontSize: 15,
                                                      color: Color(0xff000000)),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )),
                                          Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, right: 10),
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    //  "20 Jan 2022 | Friday",
                                                    //  formattimesheetDate.toString(),
                                                      value.jobdetailformatteddatefortimesheet.toString() ,
                                                    // value
                                                      //   .addTimeSheetRequestObj
                                                      // .timesheetdate,
                                                      //  DateFormat(
                                                      //    "MMMM, dd, yyyy")
                                                      //  .format(
                                                      //DateTime.now()),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'InterMedium',
                                                          fontSize: 15,
                                                          color: Colors.grey))))
                                        ]),
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Timesheet ID",
                                                  style: TextStyle(
                                                      fontFamily: 'InterMedium',
                                                      fontSize: 15,
                                                      color: Color(0xff000000)),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )),
                                          Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10, top: 10),
                                                  alignment: Alignment.topRight,
                                                  child: value.isEditTimesheet
                                                      ? Text(
                                                    // newtimesheetid,
                                                      value
                                                          .getTimesheetByIdResponse
                                                          .data!
                                                          .timesheetId
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'InterMedium',
                                                          fontSize: 15,
                                                          color:
                                                          Colors.grey))
                                                      : //Text(newtimesheetid,
                                                  Text( value.addTimeSheetRequestObj
                                                      .timesheetid.toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'InterMedium',
                                                          fontSize: 15,
                                                          color: Colors
                                                              .grey))))
                                        ]),
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text("Truck Registration",
                                                    style: TextStyle(
                                                        fontFamily: 'InterMedium',
                                                        fontSize: 15,
                                                        color: Color(0xff000000))),
                                              )),
                                          Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10, top: 10),
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    // "21 BH 2345 AA",
                                                    //  value.selectedtruckname,
                                                      value.selectedtruckstr,
                                                      //value.getTimesheetByIdResponse.data!.truck.toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'InterMedium',
                                                          fontSize: 15,
                                                          color: Colors.grey))))
                                        ]),
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                  top: 10,
                                                  bottom: 5,
                                                ),
                                                alignment: Alignment.topLeft,
                                                child: Text("Trailer",
                                                    style: TextStyle(
                                                        fontFamily: 'InterMedium',
                                                        fontSize: 15,
                                                        color: Color(0xff000000))),
                                              )),
                                          Expanded(
                                              child:
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child:
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left:80, top: 10),
                                                      alignment: Alignment.topRight,
                                                      child: //Text("S131 TDB",
                                                      Text(
                                                          value
                                                              .arrdisplayselectedtrailer!
                                                              .join(" , ").trim().toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'InterMedium',
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .grey)))))
                                        ])
                                      ])),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(child:
                                    Container(

                                      // width: Size
                                      //padding: EdgeInsets.all(5),
                                        child:
                                        Column(

                                            mainAxisSize: MainAxisSize.min,
                                            children:[
                                              Flexible(

                                                child: Container(

                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.only(
                                                    left: 20,
                                                    top: 15,
                                                    bottom: 10,
                                                  ),
                                                  child: Text("CheckList",
                                                      style: TextStyle(
                                                          fontFamily: FontName.interBold,
                                                          fontSize: 16,
                                                          color: Color(0xff000000))),
                                                ),
                                              ),

                                              value.selectedindexidchecklisttype2==0?
                                              createinitialfitnesschklist(context, "Add",value):
                                              createinitialfitnesschklist(context, "Pending Approval", value),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              value.slectedindexchecklisttype1==0?
                                              createinitialvehiclechklist(context, "Add", value):
                                              createinitialvehiclechklist(context, "Pending Approval", value)
                                            ]
                                        )
                                    )),


                                    /*value.isEditTimesheet
                                    ? Container()
                                    : Expanded(
                                    child: Container(
                                      margin:
                                      EdgeInsets.only(right: 5, top: 5),
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 15,
                                          color: Color(0xff0AAC19),
                                        ),
                                        onPressed: () {
                                          //Navigator.of(context)
                                          //  .pushNamed(Routes.addjobdetail);
                                          if (value
                                              .arrconsignmentstr.length ==
                                              0) {
                                            Fluttertoast.showToast(
                                                msg:
                                                "No Job Available for Driver, Please Add Consignment",
                                                toastLength:
                                                Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: ThemeColor
                                                    .themeGreenColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          } else {
                                            addMoreDetailsDialogfornew(
                                                context, index, value);
                                          }
                                        },
                                        label: Text(
                                          'Add Job Details',
                                          style: TextStyle(
                                              fontFamily:
                                              FontName.interRegular,
                                              fontSize: 14,
                                              color:
                                              ThemeColor.themeGreenColor),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor:
                                          ThemeColor.themeGreenColor,
                                          elevation: 0,
                                        ),
                                      ),
                                    ))*/
                                  ]),

                              Row(children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      top: 15,
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text("Job Details",
                                        style: TextStyle(
                                            fontFamily: FontName.interBold,
                                            fontSize: 16,
                                            color: Color(0xff000000))),
                                  ),
                                ) ]),

                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    value.isviewtimesheet?
                                    createjobdetailsonEditTimesheet(
                                        width, height, context, value, value.updatetimesheetrequestObj?.jobDetails):
                                    value.isEditTimesheet?
                                    createjobdetailsonEditTimesheet(
                                        width, height, context, value, value.updatetimesheetrequestObj?.jobDetails):
                                    createjobdetailsonAddTimesheet(
                                        width, height, context, value, value.addTimeSheetRequestObj.jobDetails)
                                  ],
                                ),
                              ),
                              Row(children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      top: 15,
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text("Rest Details",
                                        style: TextStyle(
                                            fontFamily: FontName.interBold,
                                            fontSize: 16,
                                            color: Color(0xff000000))),
                                  ),
                                ),

                                value.isviewtimesheet?Container():
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5, top: 5),
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 15,
                                          color: Color(0xff0AAC19),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(Routes.restDetails);
                                        },
                                        label: Text(
                                          'Add Rest Details',
                                          style: TextStyle(
                                              fontFamily: FontName.interRegular,
                                              fontSize: 14,
                                              color: ThemeColor.themeGreenColor),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor:
                                          ThemeColor.themeGreenColor,
                                          elevation: 0,
                                        ),
                                      ),
                                    )),
                              ]),

                              value.isviewtimesheet?
                              Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        createrestdetail(
                                            width, height, context, value)
                                      ],
                                    ),
                                  )):
                              value.isEditTimesheet
                                  ? Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        createrestdetail(
                                            width, height, context, value)
                                      ],
                                    ),
                                  ))
                                  : Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        createrestdetailnew(
                                            width, height, context, value)
                                      ],
                                    ),
                                  )),
                              Flexible(
                                child: RoundedLoadingButton(
                                    height: height * 0.060,
                                    width: width * 0.90,
                                    borderRadius: 5,
                                    color: Color(0xff0AAC19),
                                    successColor: Color(0xff0AAC19),
                                    successIcon: Icons.check_circle,
                                    failedIcon: Icons.error_outlined,
                                    resetAfterDuration: true,
                                    resetDuration: Duration(seconds: 3),
                                    controller: _btnController,
                                    onPressed: () {
                                      /*  value.addTimeSheetRequestObj.timesheetid =
                                          value.addTSIdTF.text;

                                      value.addTimeSheetRequestObj.companyid =
                                          "4b78417f-bd5a-4fca-8928-f959140dcc56";
                                      value.addTimeSheetRequestObj
                                              .timesheetdate =
                                          value.addTSDateTF.text;
                                      value.addTimeSheetRequestObj.starttime =
                                          value.addTSStartTimeTF.text;
                                      value.addTimeSheetRequestObj
                                              .startodometer =
                                          value.addTSStartOdometerTF.text;
                                      value.addTimeSheetRequestObj.endtime =
                                          value.addTSEndTimeTF.text;
                                      value.addTimeSheetRequestObj.endodometer =
                                          value.addTSEndOdometerTF.text;*/
                                      // value.addTimeSheetRequestObj.driverId =
                                      //"werqwe2342";
                                      //value.addTimeSheetRequestObj
                                      //  .drivermobile = "2234234234";
                                      // value.addTimeSheetRequestObj.truck =
                                      //"32423";
                                      /* value.addTimeSheetRequestObj.trailer = [
                                        "refsdfs",
                                        "sdfsd",
                                      ];*/

                                      print(
                                          'AddTimeSheetRequestObj: ${value.addTimeSheetRequestObj.toJson()}');

                                      //  value.navigatetoRestDetails(context);

                                      value.navigatetosignatureview(context);

                                      Timer(Duration(seconds: 3), () {
                                        _btnController.reset();
                                      });
                                    },
                                    child:
                                    value.isviewtimesheet?
                                    Text('Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: FontName.interBold)):
                                    Text('Save & Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: FontName.interBold))),
                              ),
                              SizedBox(
                                  height: height * 0.060,
                                  width: width, //
                                  child: Center(
                                    child: value.isLoading
                                        ? Text("Processing...",
                                        style: TextStyle(
                                            fontFamily: 'InterRegular',
                                            fontSize: 14,
                                            color: Color(0xff0AAC19)))
                                        : value.isError
                                        ? Text(
                                        "Something went wrong, Please try again",
                                        style: TextStyle(
                                            fontFamily: 'InterRegular',
                                            fontSize: 14,
                                            color: Color(0xff0AAC19)))
                                        : value.isSuccess
                                        ? Text(
                                        '${value.addTimesheetResponse.data?.success ?? ""}')
                                        : Text(""),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              })),
        ));
  }


  Widget createinitialfitnesschklist(BuildContext context, String message, Lttechprovider value) {

    return  Container(
        width:
        MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          left: 20,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.4),
              blurRadius: 1.0,
            )
          ],
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {

            Provider.of<Lttechprovider>(
                context,
                listen: false)
                .navigatetoFitnessChecklist(
                context);
          },
          child:
          Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/fitness.svg",
                  width: 20,
                  height: 20,
                  color: ThemeColor
                      .themeGreenColor,
                ),
                SizedBox(width: 10),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    "Fitness Checklist",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600),
                  ),
                ),
                Container(
                    margin:
                    EdgeInsets.only(left: 14),
                    height: Platform.isAndroid?30:null,
                    width: value.selectedindexidchecklisttype2==1?60:55,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Color(0xffFFF3CD),
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                3))),
                    child:
                    Text(
                      message,
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontFamily:
                        'InterRegular',
                        fontSize: 12,
                        color: Color(
                            0xff856404),
                      ),
                    )

                ),
              ]),
        ));
  }

  Widget createinitialvehiclechklist(BuildContext context, String message, Lttechprovider value) {
    return  Container(
      width:
      MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        left: 20,
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.4),
            blurRadius: 1.0,
          )
        ],
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          Provider.of<Lttechprovider>(
              context,
              listen: false)
              .navigatetoVehicleChecklist(
              context);
        },
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          mainAxisAlignment:
          MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/images/truck.svg",
              width: 20,
              height: 20,
              color: ThemeColor
                  .themeGreenColor,
            ),
            SizedBox(width: 10),
            const Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                "Vehicle Checklist",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600),
              ),
            ),
            Container(
              margin:
              EdgeInsets.only(left: 14),
              height: Platform.isAndroid?30:null,
              width: value.slectedindexchecklisttype1==1?60:55,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Color(0xffFFF3CD),
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(
                          3))),
              child:  Text(
                message,
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontFamily:
                  'InterRegular',
                  fontSize: 12,
                  color: Color(
                      0xff856404),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* RawMaterialButton timeSheetAddRemoveButtonWidget(
      width, height, BuildContext context, int index, Lttechprovider provider) {
    final arrDetails =
        Provider.of<Lttechprovider>(context, listen: false).arradddetail;
    return RawMaterialButton(
      key: Key(index.toString()),
      elevation: 0,
      onPressed: () {
       /* print('arradddetail:${arrDetails.length}');
        print(provider.jobNameArr[index].text);
        if (index == 0) {
          arrDetails.add(createdetailcolumn(width, height, context, provider));
          _scrollToEnd();
        } else if (arrDetails.length > 1) {
          arrDetails.removeAt(index);
          removeElementFromTFsArr(provider, index);
        }*/
        addMoreDetailsDialog(context,index,provider);
        Provider.of<Lttechprovider>(context, listen: false).setUpdateView =
            true;
      },
      fillColor: Colors.white,
      child: Icon(
        addmorecnt > 0 ? Icons.remove_circle_outline : Icons.add_circle_outline,
        size: 25,
        color: addmorecnt > 0 ? ThemeColor.red : ThemeColor.themeGreenColor,
      ),
    );
  }*/

  void updaterestdetailinofflinearray(Lttechprovider provider) {
    provider.getTimesheetByIdResponse.data?.restdetails?.forEach((element) {
      var restDetailsObj = RestDetail();
      restDetailsObj.description = element.description;
      restDetailsObj.startTime = element.startTime.toString();
      restDetailsObj.endTime = element.endTime.toString();
      provider.restDetailsDataArr.add(restDetailsObj);
    });
  }

  Widget createdetailcolumnnew(
      width, height, BuildContext context, Lttechprovider provider,  List<JobDetails>? arrjobDetails) {
    provider.jobNameArr.add(TextEditingController());
    provider.customerNameArr.add(TextEditingController());
    provider.customerAddressArr.add(TextEditingController());

    provider.subrubControllerArr.add(TextEditingController());
    provider.arriveTimeControllerArr.add(TextEditingController());
    provider.departTimeControllerArr.add(TextEditingController());

    provider.pickupControllerArr.add(TextEditingController());
    provider.deliveryControllerArr.add(TextEditingController());
    provider.refNumControllerArr.add(TextEditingController());

    provider.tempControllerArr.add(TextEditingController());
    provider.deliveredCControllerArr.add(TextEditingController());
    provider.deliveredLControllerArr.add(TextEditingController());
    provider.deliveredPControllerArr.add(TextEditingController());

    provider.pickedupCControllerArr.add(TextEditingController());
    provider.pickedupLControllerArr.add(TextEditingController());
    provider.pickedupPControllerArr.add(TextEditingController());

    provider.weightControllerArr.add(TextEditingController());

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // itemCount: provider.objdriverjob.data?.data?.length,
        itemCount: provider.isEditTimesheet? provider.updatetimesheetrequestObj.jobDetails?.length: provider.addTimeSheetRequestObj.jobDetails?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          addmorecnt = index;

          return getdriverjobitems(
              provider.objdriverjob.data.data[index], provider, context, index);
        });
  }

  Widget createjobdetailsonAddTimesheet(width, height, BuildContext context, Lttechprovider provider,  List<JobDetail> arrjobDetails) {
    provider.jobNameArr.add(TextEditingController());
    provider.customerNameArr.add(TextEditingController());
    provider.customerAddressArr.add(TextEditingController());

    provider.subrubControllerArr.add(TextEditingController());
    provider.arriveTimeControllerArr.add(TextEditingController());
    provider.departTimeControllerArr.add(TextEditingController());

    provider.pickupControllerArr.add(TextEditingController());
    provider.deliveryControllerArr.add(TextEditingController());
    provider.refNumControllerArr.add(TextEditingController());

    provider.tempControllerArr.add(TextEditingController());
    provider.deliveredCControllerArr.add(TextEditingController());
    provider.deliveredLControllerArr.add(TextEditingController());
    provider.deliveredPControllerArr.add(TextEditingController());

    provider.pickedupCControllerArr.add(TextEditingController());
    provider.pickedupLControllerArr.add(TextEditingController());
    provider.pickedupPControllerArr.add(TextEditingController());

    provider.weightControllerArr.add(TextEditingController());

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // itemCount: provider.objdriverjob.data?.data?.length,
        itemCount:  provider.addTimeSheetRequestObj.jobDetails?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          addmorecnt = index;

          return getdriverjobitemsonAddTimesheet(
              provider.objdriverjob.data.data[index], provider.addTimeSheetRequestObj.jobDetails[index], provider, context, index);
        });
  }

  Widget createjobdetailsonEditTimesheet(width, height, BuildContext context, Lttechprovider provider,  List<JobDetails>? arrjobDetails) {
    provider.jobNameArr.add(TextEditingController());
    provider.customerNameArr.add(TextEditingController());
    provider.customerAddressArr.add(TextEditingController());

    provider.subrubControllerArr.add(TextEditingController());
    provider.arriveTimeControllerArr.add(TextEditingController());
    provider.departTimeControllerArr.add(TextEditingController());

    provider.pickupControllerArr.add(TextEditingController());
    provider.deliveryControllerArr.add(TextEditingController());
    provider.refNumControllerArr.add(TextEditingController());

    provider.tempControllerArr.add(TextEditingController());
    provider.deliveredCControllerArr.add(TextEditingController());
    provider.deliveredLControllerArr.add(TextEditingController());
    provider.deliveredPControllerArr.add(TextEditingController());

    provider.pickedupCControllerArr.add(TextEditingController());
    provider.pickedupLControllerArr.add(TextEditingController());
    provider.pickedupPControllerArr.add(TextEditingController());

    provider.weightControllerArr.add(TextEditingController());

    print("value.updatetimesheetrequestObj?.jobDetails:"+provider.updatetimesheetrequestObj.jobDetails!.length.toString());
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // itemCount: provider.objdriverjob.data?.data?.length,
        itemCount: provider.updatetimesheetrequestObj.jobDetails!.length,
        itemBuilder: (BuildContext ctxt, int index) {
          addmorecnt = index;

          return getdriverjobitemsonEditTimesheet(
              provider.objdriverjob.data.data[index], provider.updatetimesheetrequestObj.jobDetails?[index], provider, context, index);

        });
  }

  Widget createrestdetail(
      width, height, BuildContext context, Lttechprovider provider) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.getTimesheetByIdResponse.data?.restdetails?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          addmorecnt = index;
          return getalreadyexitrestdetail(
              provider.getTimesheetByIdResponse?.data?.restdetails?[index],
              provider,
              context,
              index);
        });
  }

  Widget createrestdetailnew(
      width, height, BuildContext context, Lttechprovider provider) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //  itemCount: provider.getTimesheetByIdResponse.data?.restdetails?.length,
        //  itemCount: provider.addTimeSheetRequestObj.restDetails?.length,
        itemCount: provider.restDetailsDataArr.length,
        itemBuilder: (BuildContext ctxt, int index) {
          addmorecnt = index;
          var objrestdetail = Restdetail();
          objrestdetail.description =
              provider.restDetailsDataArr[index].description;
          objrestdetail.startTime = DateTime.parse(
              provider.restDetailsDataArr[index].startTime.toString());

          objrestdetail.endTime = DateTime.parse(
              provider.restDetailsDataArr[index].endTime.toString());
          return getalreadyexitrestdetail(
              objrestdetail, provider, context, index);
        });
  }

  Widget getalreadyexitrestdetail(Restdetail? restdetail,
      Lttechprovider provider, BuildContext context, int pst) {
    var starttime = restdetail!.startTime.toString().split(" ");

    var starttimeinhours = starttime[1].split(".");

    var endtime = restdetail.endTime.toString().split(" ");
    var endtimeinhours = endtime[1].split(".");

    var objrestdetails = updateRestDetails();
    objrestdetails.restId = restdetail.restId.toString();
    objrestdetails.description = restdetail.description.toString();
    objrestdetails.startTime = restdetail.startTime.toString();
    objrestdetails.endTime = restdetail.endTime.toString();
    provider.updatearrestdetail.add(objrestdetails);

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: Platform.isIOS ? null : SizeConfig.safeBlockVertical * 18,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEEEEEE),
            blurRadius: 3.0,
          ),
        ],
        border: Border.all(
          color: Color(0xffEEEEEE),
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff000000),
                      fontFamily: FontName.interSemiBold),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  "Start Time",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff000000),
                      fontFamily: FontName.interSemiBold),
                ),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      "End Time",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff000000),
                          fontFamily: FontName.interSemiBold),
                    ),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          restdetail!.description.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff666666),
                              fontFamily: FontName.interRegular),
                        ),
                      ))),
              Spacer(),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          //  DateFormat.jm().format(DateFormat("hh:mm")
                          //     .parse(starttimeinhours.toString())),
                          //DateFormat.jm().format(DateFormat("hh:mm")
                          //  .parse(starttimeinhours)),
                          starttimeinhours[0],
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff666666),
                              fontFamily: FontName.interRegular),
                        ),
                      ))),
              Spacer(),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          //DateFormat.jm().format(DateFormat("hh:mm")
                          //  .parse(endtimeinhours.toString())),
                          // getformattedTime(TimeOfDay.fromDateTime(restdetail.endTime!)),
                          endtimeinhours[0],
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff666666),
                              fontFamily: FontName.interRegular),
                        ),
                      )))
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 21),
                padding: EdgeInsets.all(1.0),
                child: Text(
                  //  "#DIGH0003H",
                  "",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterSemiBold',
                      color: Color(0xff0AAC19)),
                ),
              ),
              Spacer(),

              provider.isviewtimesheet?Container():
              Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                // child: IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: () {
                //     print("pst_Dialog" + pst.toString());

                //     Environement.restdetail = Restdetail();
                //     Environement.restdetail?.description =
                //         restdetail.description.toString();
                //     Environement.restdetail?.startTime = restdetail.startTime;
                //     Environement.restdetail?.endTime = restdetail.endTime;
                //     Environement.indexrestdetail = pst;
                //     Navigator.of(context).pushNamed(Routes.editrestdetail);
                //   },
                // ),
                child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print("pst_Dialog_edit: $pst");

                      if(!provider.isviewtimesheet) {
                        Environement.editrestdetailcounter = Environement.editrestdetailcounter+1;
                        Environement.restdetail = Restdetail();
                        Environement.restdetail?.description =
                            restdetail!.description.toString();
                        Environement.restdetail?.startTime =
                            restdetail!.startTime;
                        Environement.restdetail?.endTime =
                            restdetail!.endTime;
                        Environement.indexrestdetail = pst;
                        Navigator.of(context).pushNamed(
                            Routes.editrestdetail);
                      }
                    }),
              )
              /* Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    // addMoreDetailsDialog(context,pst,provider,objdriverjobitem);
                  },
                ),
              )*/
            ],
          ),
        ],
      ),
    );
  }

  getformattedTime(TimeOfDay time) {
    return '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}';
  }



  Widget getdriverjobitems(Driverjob objdriverjobitem, Lttechprovider provider,
      BuildContext context, int pst) {
    DateTime? pickupdate = objdriverjobitem.pickupDate;
    var formatPickUpDate =
    DateFormat.yMMMMd().format(pickupdate ?? DateTime.now());
    return Container(
      height: Platform.isIOS ? null : SizeConfig.safeBlockVertical * 25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEEEEEE),
            blurRadius: 3.0,
          ),
        ],
        border: Border.all(
          color: Color(0xffEEEEEE),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 21),
                padding: EdgeInsets.all(1.0),
                child: Text(
                  //  "#DIGH0003H",
                  // "Job Details",
                  " ${objdriverjobitem.jobNumber}",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterSemiBold',
                      color: Color(0xff0AAC19)),
                ),
              ),
              /* Container(
                margin: EdgeInsets.only(
                    top: 10, left: 14),
                height: 20,
                width: 55,
                padding:
                EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Color(
                        0xffFEF7E0),
                    borderRadius:
                    BorderRadius
                        .all(Radius
                        .circular(
                        3))),
                child: const Text(
                  "Booked",
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                    'InterRegular',
                    fontSize: 12,
                    color: Color(
                        0xffE58C33),
                  ),
                ),
              ),*/
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    addMoreDetailsDialog(
                        context, pst, provider, objdriverjobitem);
                  },
                ),
              )
              /*Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    // addMoreDetailsDialog(context,pst,provider,objdriverjobitem);
                  },
                ),
              )*/
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 21),
            alignment: Alignment.centerLeft,
            child: Text(
              "${objdriverjobitem.customerDetails?.firstName ?? ""} ${objdriverjobitem.customerDetails?.lastName ?? ""}",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff000000),
                  fontFamily: 'InterSemiBold'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xff0AAC19)),
                        ),
                        Dash(
                            direction: Axis.vertical,
                            length: 36,
                            dashLength: 5,
                            dashColor: Color(0xff0AAC19)),
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: Color(0xff0AAC19))),
                          child: Container(
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.customerAddress.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        /*Container(
                          margin: const EdgeInsets
                              .only(
                              left: 9,
                              top: 3),
                          alignment:
                          Alignment
                              .centerLeft,
                          child: Text(
                            formatBookedDate,
                            style: TextStyle(
                                fontSize:
                                13,
                                color: Color(
                                    0xff666666),
                                fontFamily:
                                'InterRegular'),
                          ),
                        ),*/
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 11),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.deliveryAddres.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatPickUpDate,
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff666666),
                                fontFamily: 'InterRegular'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getdriverjobitemsonAddTimesheet(Driverjob objdriverjobitem, JobDetail objjobDetails, Lttechprovider provider,
      BuildContext context, int pst) {
    DateTime? pickupdate = objdriverjobitem.pickupDate;
    var formatPickUpDate =
    DateFormat.yMMMMd().format(pickupdate ?? DateTime.now());
    return Container(
      height: Platform.isIOS ? null : SizeConfig.safeBlockVertical * 25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEEEEEE),
            blurRadius: 3.0,
          ),
        ],
        border: Border.all(
          color: Color(0xffEEEEEE),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 21),
                padding: EdgeInsets.all(1.0),
                child: Text(
                  //  "#DIGH0003H",
                  // "Job Details",
                  " ${objdriverjobitem.jobNumber}",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterSemiBold',
                      color: Color(0xff0AAC19)),
                ),
              ),
              /* Container(
                margin: EdgeInsets.only(
                    top: 10, left: 14),
                height: 20,
                width: 55,
                padding:
                EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Color(
                        0xffFEF7E0),
                    borderRadius:
                    BorderRadius
                        .all(Radius
                        .circular(
                        3))),
                child: const Text(
                  "Booked",
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                    'InterRegular',
                    fontSize: 12,
                    color: Color(
                        0xffE58C33),
                  ),
                ),
              ),*/
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    //  addMoreDetailsDialog(
                    //    context, pst, provider, objdriverjobitem);
                    updatejobdetaildialogonAddTimesheet(context, pst, provider, objdriverjobitem, objjobDetails);
                  },
                ),
              )
              /*Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    // addMoreDetailsDialog(context,pst,provider,objdriverjobitem);
                  },
                ),
              )*/
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 21),
            alignment: Alignment.centerLeft,
            child: Text(
              "${objdriverjobitem.customerDetails?.firstName ?? ""} ${objdriverjobitem.customerDetails?.lastName ?? ""}",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff000000),
                  fontFamily: 'InterSemiBold'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xff0AAC19)),
                        ),
                        Dash(
                            direction: Axis.vertical,
                            length: 36,
                            dashLength: 5,
                            dashColor: Color(0xff0AAC19)),
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: Color(0xff0AAC19))),
                          child: Container(
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.customerAddress.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        /*Container(
                          margin: const EdgeInsets
                              .only(
                              left: 9,
                              top: 3),
                          alignment:
                          Alignment
                              .centerLeft,
                          child: Text(
                            formatBookedDate,
                            style: TextStyle(
                                fontSize:
                                13,
                                color: Color(
                                    0xff666666),
                                fontFamily:
                                'InterRegular'),
                          ),
                        ),*/
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 11),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.deliveryAddres.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatPickUpDate,
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff666666),
                                fontFamily: 'InterRegular'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget getdriverjobitemsonEditTimesheet(Driverjob objdriverjobitem, JobDetails? objjobDetails, Lttechprovider provider,
      BuildContext context, int pst) {
    DateTime? pickupdate = objdriverjobitem.pickupDate;
    var formatPickUpDate =
    DateFormat.yMMMMd().format(pickupdate ?? DateTime.now());
    return Container(
      height: Platform.isIOS ? null : SizeConfig.safeBlockVertical * 25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEEEEEE),
            blurRadius: 3.0,
          ),
        ],
        border: Border.all(
          color: Color(0xffEEEEEE),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 21),
                padding: EdgeInsets.all(1.0),
                child: Text(
                  //  "#DIGH0003H",
                  // "Job Details",
                  " ${objdriverjobitem.jobNumber}",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterSemiBold',
                      color: Color(0xff0AAC19)),
                ),
              ),
              /* Container(
                margin: EdgeInsets.only(
                    top: 10, left: 14),
                height: 20,
                width: 55,
                padding:
                EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Color(
                        0xffFEF7E0),
                    borderRadius:
                    BorderRadius
                        .all(Radius
                        .circular(
                        3))),
                child: const Text(
                  "Booked",
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                    'InterRegular',
                    fontSize: 12,
                    color: Color(
                        0xffE58C33),
                  ),
                ),
              ),*/
              Spacer(),
              provider.isEditTimesheet?
              Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {


                    print("pst_Dialog$pst");
                    // addMoreDetailsDialog(
                    //   context, pst, provider, objdriverjobitem);
                    updatejobdetaildialogonEditTimesheet(context, pst, provider, objdriverjobitem, objjobDetails);
                  },
                ),
              ):Container()
              /*Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("pst_Dialog$pst");
                    // addMoreDetailsDialog(context,pst,provider,objdriverjobitem);
                  },
                ),
              )*/
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 21),
            alignment: Alignment.centerLeft,
            child: Text(
              "${objdriverjobitem.customerDetails?.firstName ?? ""} ${objdriverjobitem.customerDetails?.lastName ?? ""}",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff000000),
                  fontFamily: 'InterSemiBold'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xff0AAC19)),
                        ),
                        Dash(
                            direction: Axis.vertical,
                            length: 36,
                            dashLength: 5,
                            dashColor: Color(0xff0AAC19)),
                        Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: Color(0xff0AAC19))),
                          child: Container(
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.customerAddress.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        /*Container(
                          margin: const EdgeInsets
                              .only(
                              left: 9,
                              top: 3),
                          alignment:
                          Alignment
                              .centerLeft,
                          child: Text(
                            formatBookedDate,
                            style: TextStyle(
                                fontSize:
                                13,
                                color: Color(
                                    0xff666666),
                                fontFamily:
                                'InterRegular'),
                          ),
                        ),*/
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 11),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            objdriverjobitem.deliveryAddres.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: 'InterMedium'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 9, top: 3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatPickUpDate,
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff666666),
                                fontFamily: 'InterRegular'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  /* Widget createdetailcolumn(
      width, height, BuildContext context, Lttechprovider provider) {
    provider.jobNameArr.add(TextEditingController());
    provider.customerNameArr.add(TextEditingController());
    provider.customerAddressArr.add(TextEditingController());

    provider.subrubControllerArr.add(TextEditingController());
    provider.arriveTimeControllerArr.add(TextEditingController());
    provider.departTimeControllerArr.add(TextEditingController());

    provider.pickupControllerArr.add(TextEditingController());
    provider.deliveryControllerArr.add(TextEditingController());
    provider.refNumControllerArr.add(TextEditingController());

    provider.tempControllerArr.add(TextEditingController());
    provider.deliveredCControllerArr.add(TextEditingController());
    provider.deliveredLControllerArr.add(TextEditingController());
    provider.deliveredPControllerArr.add(TextEditingController());

    provider.pickedupCControllerArr.add(TextEditingController());
    provider.pickedupLControllerArr.add(TextEditingController());
    provider.pickedupPControllerArr.add(TextEditingController());

    provider.weightControllerArr.add(TextEditingController());

    final arrDetails =
        Provider.of<Lttechprovider>(context, listen: false).arradddetail;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: arrDetails.length,
      itemBuilder: (BuildContext ctxt, int index) {
        addmorecnt = index;

        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffEEEEEE),
                blurRadius: 3.0,
              ),
            ],
            border: Border.all(
              color: Color(0xffEEEEEE),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(top: 5, right: 20),
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 30,
                    child: timeSheetAddRemoveButtonWidget(
                        width, height, context, index, provider),
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: Text("Job Name"))),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(
                          left: 20, bottom: 10, right: 20, top: 5),
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: provider.jobNameArr[index],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffFAFAFA),
                            focusedBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffD4D4D4), width: 1.0),
                            ),
                            hintText: 'Frozen Delivery',
                          )))),
              Flexible(
                  child: Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: Text("Name of Customer"))),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(
                          left: 20, bottom: 10, right: 20, top: 5),
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: provider.customerNameArr[index],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffFAFAFA),
                            focusedBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffD4D4D4), width: 1.0),
                            ),
                            hintText: 'SA Frozen Delivery',
                          )))),
              Flexible(
                  child: Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: Text("Address"))),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(
                          left: 20, bottom: 10, right: 20, top: 5),
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: provider.customerAddressArr[index],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffFAFAFA),
                            focusedBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffD4D4D4), width: 1.0),
                            ),
                            hintText: 'Level 14/70 Pitt St, Sydney NSW 2000',
                          )))),
              Flexible(
                  child: Container(
                margin: EdgeInsets.only(top: 11, bottom: 20),
                color: Colors.white,
                width: width,
                height: SizeConfig.screenHeight * 0.05,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0AAC19)),
                    child: Text("Add More Details",
                        style: TextStyle(
                            fontFamily: 'InterRegular',
                            fontSize: 14,
                            color: Colors.white)),
                    onPressed: () {
                      addMoreDetailsDialog(_providerContext, index, provider);
                    },
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }*/

  void addMoreDetailsDialog(BuildContext context, int index,
      Lttechprovider provider, Driverjob objdriverjobitem) {
    //  provider.jobNameArr[index].text = objdriverjobitem.jobNumber.toString();
    provider.customerNameArr[index].text =
        objdriverjobitem.customerDetails!.firstName.toString();
    provider.customerAddressArr[index].text =
        objdriverjobitem.customerAddress.toString();
    provider.subrubControllerArr[index].text =
        objdriverjobitem.suburb.toString();
    int jobidx = 0;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // objdriverjobitem.jobNumber.toString(),
                              "Job Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: FontName.interBold,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: RawMaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                fillColor: Colors.white,
                                // padding: const EdgeInsets.all(5),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: ThemeColor.themeGreenColor)),
                                // textColor: ThemeColor.themeGreenColor,
                                child: const Icon(
                                  Icons.close_sharp,
                                  size: 16,
                                  color: ThemeColor.themeGreenColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // padding:
                          //     const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Job Name",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue:
                                  objdriverjobitem.jobNumber.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller: provider.jobNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                                /*ChipsChoice<int>.single(
                                    value: provider.selectedconsignmentidforjob,
                                    choiceItems: C2Choice.listFrom(
                                        source: provider.arrconsignmentstr,
                                        value: (i, v) => i,
                                        label: (i, v) => v),
                                    onChanged: (val) {
                                      //String
                                      //  value.onchangeBillingCustomer(val);
                                      // provider.selectedtruckid =
                                      //   val;
                                      //provider
                                      //  .onchangetrucktypefillltimesheet(
                                      // val);
                                      jobidx = val;
                                      provider.jobNameArr[index].text =
                                          provider.arrconsignmentstr[val];
                                    },
                                  )*/
                              ),
                              const Text(
                                "Name of Customer ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem
                                      .customerDetails!.firstName
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  //controller:
                                  // provider.customerNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Address ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem.customerAddress
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller:
                                  // provider.customerAddressArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Subrub",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  initialValue:
                                  objdriverjobitem.suburb.toString(),
                                  // controller:
                                  //   provider.subrubControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //     ? null
                                  //     : "Please select subrub",
                                ),
                              ),
                              SizedBox(
                                // height: 90,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Arrive Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .arriveTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select arrive time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Depart Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .departTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .departTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select depart time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Pickup",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.pickupControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter pickup",
                                ),
                              ),
                              const Text(
                                "Delivery",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.deliveryControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter delivery",
                                ),
                              ),
                              const Text(
                                "Reference No. / Load Description",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.refNumControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter ref no.",
                                ),
                              ),
                              const Text(
                                "Temp",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: provider.tempControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter temp",
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Delivered ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Picked Up ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Weights",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.weightControllerArr[index],
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter weights",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                            MaterialStateProperty.all(0),
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: Colors.grey)))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Clear",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                            color:
                                            ThemeColor.themeDarkGreyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ThemeColor.themeGreenColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: ThemeColor
                                                            .themeGreenColor)))),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();

                                            if (provider.isEditTimesheet) {
                                              var jobupdatedetailobj =
                                              JobDetails();
                                              provider.jobNameArr[index].text =
                                              provider.arrconsignmentstr[
                                              jobidx];

                                              jobupdatedetailobj.jobName =
                                                  provider
                                                      .jobNameArr[index].text;

                                              jobupdatedetailobj.customerName =
                                                  provider
                                                      .customerNameArr[index]
                                                      .text;
                                              jobupdatedetailobj.address =
                                                  provider
                                                      .customerAddressArr[index]
                                                      .text;
                                              jobupdatedetailobj.suburb =
                                                  provider
                                                      .subrubControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.arrivalTime =
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.departTime =
                                                  provider
                                                      .departTimeControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.pickup =
                                                  provider
                                                      .pickupControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.delivery =
                                                  provider
                                                      .deliveryControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj
                                                  .referenceNumber =
                                                  provider
                                                      .refNumControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.temp = provider
                                                  .tempControllerArr[index]
                                                  .text;
                                              jobupdatedetailobj.deliveredChep =
                                                  provider
                                                      .deliveredCControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj
                                                  .deliveredLoscomp =
                                                  provider
                                                      .deliveredLControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj
                                                  .deliveredPlain =
                                                  provider
                                                      .deliveredPControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.pickedUpChep =
                                                  provider
                                                      .pickedupCControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj
                                                  .pickedUpLoscomp =
                                                  provider
                                                      .pickedupLControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.pickedUpPlain =
                                                  provider
                                                      .pickedupPControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj.weight =
                                                  provider
                                                      .weightControllerArr[
                                                  index]
                                                      .text;
                                              jobupdatedetailobj
                                                  .timesheetJobId =
                                                  objdriverjobitem.consignmentId
                                                      .toString();
                                              jobdetailarrupdate
                                                  .add(jobupdatedetailobj);
                                              provider.updatetimesheetrequestObj
                                                  .jobDetails =
                                                  jobdetailarrupdate;
                                              /*"Consign${Random().nextInt(100)}lttech"; */
                                              // jobDetailArr.add(jobupdatedetailobj);
                                            } else {
                                              var jobDetailObj = JobDetail();

                                              provider.jobNameArr[index].text =
                                              provider.arrconsignmentstr[
                                              jobidx];

                                              jobDetailObj.jobName = provider
                                                  .jobNameArr[index].text;

                                              jobDetailObj.customerName =
                                                  provider
                                                      .customerNameArr[index]
                                                      .text;
                                              jobDetailObj.address = provider
                                                  .customerAddressArr[index]
                                                  .text;
                                              jobDetailObj.suburb = provider
                                                  .subrubControllerArr[index]
                                                  .text;
                                              jobDetailObj.arrivalTime =
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.departTime = provider
                                                  .departTimeControllerArr[
                                              index]
                                                  .text;
                                              jobDetailObj.pickup = provider
                                                  .pickupControllerArr[index]
                                                  .text;
                                              jobDetailObj.delivery = provider
                                                  .deliveryControllerArr[index]
                                                  .text;
                                              jobDetailObj.referenceNumber =
                                                  provider
                                                      .refNumControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.temp = provider
                                                  .tempControllerArr[index]
                                                  .text;
                                              jobDetailObj.deliveredChep =
                                                  provider
                                                      .deliveredCControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.deliveredLoscomp =
                                                  provider
                                                      .deliveredLControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.deliveredPlain =
                                                  provider
                                                      .deliveredPControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.pickedUpChep =
                                                  provider
                                                      .pickedupCControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.pickedUpLoscomp =
                                                  provider
                                                      .pickedupLControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.pickedUpPlain =
                                                  provider
                                                      .pickedupPControllerArr[
                                                  index]
                                                      .text;
                                              jobDetailObj.weight = provider
                                                  .weightControllerArr[index]
                                                  .text;
                                              jobDetailObj.consignmentID =
                                                  objdriverjobitem.consignmentId
                                                      .toString();
                                              /*"Consign${Random().nextInt(100)}lttech"; */
                                              jobDetailArr.add(jobDetailObj);

                                              provider.addTimeSheetRequestObj
                                                  .jobDetails = jobDetailArr;
                                            }
                                            //  provider.updatetimesheetrequestObj.jobDetails = jobDetailArr;

                                            Navigator.of(context).pop();
                                          }
                                          // Navigator.of(context)
                                          //     .pushNamed(Routes.restDetails);
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  void updatejobdetaildialogonAddTimesheet(BuildContext context, int index,
      Lttechprovider provider, Driverjob objdriverjobitem,JobDetail objjobDetails) {
    //  provider.jobNameArr[index].text = objdriverjobitem.jobNumber.toString();
    provider.customerNameArr[index].text =
        objdriverjobitem.customerDetails!.firstName.toString();
    provider.customerAddressArr[index].text =
        objdriverjobitem.customerAddress.toString();
    provider.subrubControllerArr[index].text =
        objdriverjobitem.suburb.toString();
    int jobidx = 0;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // objdriverjobitem.jobNumber.toString(),
                              "Job Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: FontName.interBold,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: RawMaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                fillColor: Colors.white,
                                // padding: const EdgeInsets.all(5),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: ThemeColor.themeGreenColor)),
                                // textColor: ThemeColor.themeGreenColor,
                                child: const Icon(
                                  Icons.close_sharp,
                                  size: 16,
                                  color: ThemeColor.themeGreenColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // padding:
                          //     const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Job Name",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue:
                                  objdriverjobitem.jobNumber.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller: provider.jobNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                                /*ChipsChoice<int>.single(
                                    value: provider.selectedconsignmentidforjob,
                                    choiceItems: C2Choice.listFrom(
                                        source: provider.arrconsignmentstr,
                                        value: (i, v) => i,
                                        label: (i, v) => v),
                                    onChanged: (val) {
                                      //String
                                      //  value.onchangeBillingCustomer(val);
                                      // provider.selectedtruckid =
                                      //   val;
                                      //provider
                                      //  .onchangetrucktypefillltimesheet(
                                      // val);
                                      jobidx = val;
                                      provider.jobNameArr[index].text =
                                          provider.arrconsignmentstr[val];
                                    },
                                  )*/
                              ),
                              const Text(
                                "Name of Customer ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem
                                      .customerDetails!.firstName
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  //controller:
                                  // provider.customerNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Address ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem.customerAddress
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller:
                                  // provider.customerAddressArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Subrub",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  initialValue:
                                  objdriverjobitem.suburb.toString(),
                                  // controller:
                                  //   provider.subrubControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //     ? null
                                  //     : "Please select subrub",
                                ),
                              ),
                              SizedBox(
                                // height: 90,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Arrive Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .arriveTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select arrive time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Depart Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .departTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .departTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select depart time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Pickup",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.pickupControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter pickup",
                                ),
                              ),
                              const Text(
                                "Delivery",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.deliveryControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter delivery",
                                ),
                              ),
                              const Text(
                                "Reference No. / Load Description",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.refNumControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter ref no.",
                                ),
                              ),
                              const Text(
                                "Temp",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: provider.tempControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter temp",
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Delivered ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Picked Up ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Weights",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.weightControllerArr[index],
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter weights",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                            MaterialStateProperty.all(0),
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: Colors.grey)))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Clear",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                            color:
                                            ThemeColor.themeDarkGreyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ThemeColor.themeGreenColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: ThemeColor
                                                            .themeGreenColor)))),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();

                                            provider.jobNameArr[index].text =
                                            provider.arrconsignmentstr[
                                            jobidx];

                                            objjobDetails.jobName =
                                                provider
                                                    .jobNameArr[index].text;

                                            objjobDetails.customerName =
                                                provider
                                                    .customerNameArr[index]
                                                    .text;
                                            objjobDetails.address =
                                                provider
                                                    .customerAddressArr[index]
                                                    .text;
                                            objjobDetails.suburb =
                                                provider
                                                    .subrubControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.arrivalTime =
                                                provider
                                                    .arriveTimeControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.departTime =
                                                provider
                                                    .departTimeControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.pickup =
                                                provider
                                                    .pickupControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.delivery =
                                                provider
                                                    .deliveryControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails
                                                .referenceNumber =
                                                provider
                                                    .refNumControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.temp = provider
                                                .tempControllerArr[index]
                                                .text;
                                            objjobDetails.deliveredChep =
                                                provider
                                                    .deliveredCControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails
                                                .deliveredLoscomp =
                                                provider
                                                    .deliveredLControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails
                                                .deliveredPlain =
                                                provider
                                                    .deliveredPControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.pickedUpChep =
                                                provider
                                                    .pickedupCControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails
                                                .pickedUpLoscomp =
                                                provider
                                                    .pickedupLControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.pickedUpPlain =
                                                provider
                                                    .pickedupPControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.weight =
                                                provider
                                                    .weightControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails.consignmentID=
                                                objdriverjobitem.consignmentId
                                                    .toString();

                                            Navigator.of(context).pop();
                                          }
                                          // Navigator.of(context)
                                          //     .pushNamed(Routes.restDetails);
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void updatejobdetaildialogonEditTimesheet(BuildContext context, int index,
      Lttechprovider provider, Driverjob objdriverjobitem,JobDetails? objjobDetails) {
    //  provider.jobNameArr[index].text = objdriverjobitem.jobNumber.toString();
    provider.customerNameArr[index].text =
        objdriverjobitem.customerDetails!.firstName.toString();
    provider.customerAddressArr[index].text =
        objdriverjobitem.customerAddress.toString();
    provider.subrubControllerArr[index].text =
        objdriverjobitem.suburb.toString();
    int jobidx = 0;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // objdriverjobitem.jobNumber.toString(),
                              "Job Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: FontName.interBold,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: RawMaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                fillColor: Colors.white,
                                // padding: const EdgeInsets.all(5),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: ThemeColor.themeGreenColor)),
                                // textColor: ThemeColor.themeGreenColor,
                                child: const Icon(
                                  Icons.close_sharp,
                                  size: 16,
                                  color: ThemeColor.themeGreenColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // padding:
                          //     const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Job Name",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue:
                                  objdriverjobitem.jobNumber.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller: provider.jobNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                                /*ChipsChoice<int>.single(
                                    value: provider.selectedconsignmentidforjob,
                                    choiceItems: C2Choice.listFrom(
                                        source: provider.arrconsignmentstr,
                                        value: (i, v) => i,
                                        label: (i, v) => v),
                                    onChanged: (val) {
                                      //String
                                      //  value.onchangeBillingCustomer(val);
                                      // provider.selectedtruckid =
                                      //   val;
                                      //provider
                                      //  .onchangetrucktypefillltimesheet(
                                      // val);
                                      jobidx = val;
                                      provider.jobNameArr[index].text =
                                          provider.arrconsignmentstr[val];
                                    },
                                  )*/
                              ),
                              const Text(
                                "Name of Customer ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem
                                      .customerDetails!.firstName
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  //controller:
                                  // provider.customerNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Address ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  initialValue: objdriverjobitem.customerAddress
                                      .toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller:
                                  // provider.customerAddressArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Subrub",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  initialValue:
                                  objdriverjobitem.suburb.toString(),
                                  // controller:
                                  //   provider.subrubControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //     ? null
                                  //     : "Please select subrub",
                                ),
                              ),
                              SizedBox(
                                // height: 90,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Arrive Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .arriveTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select arrive time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Depart Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .departTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .departTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select depart time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Pickup",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.pickupControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter pickup",
                                ),
                              ),
                              const Text(
                                "Delivery",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.deliveryControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter delivery",
                                ),
                              ),
                              const Text(
                                "Reference No. / Load Description",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.refNumControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter ref no.",
                                ),
                              ),
                              const Text(
                                "Temp",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: provider.tempControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter temp",
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Delivered ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Picked Up ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Weights",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.weightControllerArr[index],
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter weights",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                            MaterialStateProperty.all(0),
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: Colors.grey)))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Clear",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                            color:
                                            ThemeColor.themeDarkGreyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ThemeColor.themeGreenColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: ThemeColor
                                                            .themeGreenColor)))),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();



                                            provider.jobNameArr[index].text =
                                            provider.arrconsignmentstr[
                                            jobidx];

                                            objjobDetails?.jobName = provider
                                                .jobNameArr[index].text;

                                            objjobDetails?.customerName =
                                                provider
                                                    .customerNameArr[index]
                                                    .text;
                                            objjobDetails?.address = provider
                                                .customerAddressArr[index]
                                                .text;
                                            objjobDetails?.suburb = provider
                                                .subrubControllerArr[index]
                                                .text;
                                            objjobDetails?.arrivalTime =
                                                provider
                                                    .arriveTimeControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.departTime = provider
                                                .departTimeControllerArr[
                                            index]
                                                .text;
                                            objjobDetails?.pickup = provider
                                                .pickupControllerArr[index]
                                                .text;
                                            objjobDetails?.delivery = provider
                                                .deliveryControllerArr[index]
                                                .text;
                                            objjobDetails?.referenceNumber =
                                                provider
                                                    .refNumControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.temp = provider
                                                .tempControllerArr[index]
                                                .text;
                                            objjobDetails?.deliveredChep =
                                                provider
                                                    .deliveredCControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.deliveredLoscomp =
                                                provider
                                                    .deliveredLControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.deliveredPlain =
                                                provider
                                                    .deliveredPControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.pickedUpChep =
                                                provider
                                                    .pickedupCControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.pickedUpLoscomp =
                                                provider
                                                    .pickedupLControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.pickedUpPlain =
                                                provider
                                                    .pickedupPControllerArr[
                                                index]
                                                    .text;
                                            objjobDetails?.weight = provider
                                                .weightControllerArr[index]
                                                .text;
                                            //  objjobDetails.timesheetJobId =
                                            //      objdriverjobitem.consignmentId
                                            //        .toString();
                                            /*"Consign${Random().nextInt(100)}lttech"; */
                                            // jobDetailArr.add(jobDetailObj);

                                            // provider.addTimeSheetRequestObj
                                            //   .jobDetails = jobDetailArr;

                                            //  provider.updatetimesheetrequestObj.jobDetails = jobDetailArr;

                                            Navigator.of(context).pop();
                                          }
                                          // Navigator.of(context)
                                          //     .pushNamed(Routes.restDetails);
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }




  void addMoreDetailsDialogfornew(
      BuildContext context, int index, Lttechprovider provider) {
    //  provider.jobNameArr.add(TextEditingController());
    provider.customerNameArr.add(TextEditingController());
    provider.customerAddressArr.add(TextEditingController());

    provider.subrubControllerArr.add(TextEditingController());
    provider.arriveTimeControllerArr.add(TextEditingController());
    provider.departTimeControllerArr.add(TextEditingController());

    provider.pickupControllerArr.add(TextEditingController());
    provider.deliveryControllerArr.add(TextEditingController());
    provider.refNumControllerArr.add(TextEditingController());

    provider.tempControllerArr.add(TextEditingController());
    provider.deliveredCControllerArr.add(TextEditingController());
    provider.deliveredLControllerArr.add(TextEditingController());
    provider.deliveredPControllerArr.add(TextEditingController());

    provider.pickedupCControllerArr.add(TextEditingController());
    provider.pickedupLControllerArr.add(TextEditingController());
    provider.pickedupPControllerArr.add(TextEditingController());

    provider.weightControllerArr.add(TextEditingController());

    provider.jobNameArr[index].text = '';
    provider.customerNameArr[index].text = '';
    provider.customerAddressArr[index].text = '';
    provider.subrubControllerArr[index].text = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // objdriverjobitem.jobNumber.toString(),
                              "Job Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: FontName.interBold,
                              ),
                            ),
                            SizedBox(
                              width: 24,
                              child: RawMaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                fillColor: Colors.white,
                                // padding: const EdgeInsets.all(5),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: ThemeColor.themeGreenColor)),
                                // textColor: ThemeColor.themeGreenColor,
                                child: const Icon(
                                  Icons.close_sharp,
                                  size: 16,
                                  color: ThemeColor.themeGreenColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // padding:
                          //     const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Job Name",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  //  initialValue: objdriverjobitem.jobNumber.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: provider.jobNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                                /*ChipsChoice<int>.single(
                                    value: provider.selectedconsignmentidforjob,
                                    choiceItems: C2Choice.listFrom(
                                        source: provider.arrconsignmentstr,
                                        value: (i, v) => i,
                                        label: (i, v) => v),
                                    onChanged: (val) {
                                      //String
                                      //  value.onchangeBillingCustomer(val);
                                      // provider.selectedtruckid =
                                      //   val;
                                      //provider
                                      //  .onchangetrucktypefillltimesheet(
                                      // val);
                                      provider.jobNameArr[index].text =
                                          provider.arrconsignmentstr[val];
                                    },
                                  )*/
                              ),
                              const Text(
                                "Name of Customer ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  //initialValue: objdriverjobitem.customerDetails!.firstName.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  //controller:
                                  // provider.customerNameArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Address ",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  // initialValue: objdriverjobitem.customerAddress.toString(),
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  // controller:
                                  // provider.customerAddressArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //    ? null
                                  //   : "Please select subrub",
                                ),
                              ),
                              const Text(
                                "Subrub",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  readOnly: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  //  initialValue: objdriverjobitem.suburb.toString(),
                                  // controller:
                                  //   provider.subrubControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  // validator: (input) => input!.isNotEmpty
                                  //     ? null
                                  //     : "Please select subrub",
                                ),
                              ),
                              SizedBox(
                                // height: 90,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Arrive Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType: TextInputType.text,
                                              controller: provider
                                                  .arriveTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .arriveTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select arrive time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Depart Time",
                                            textAlign: TextAlign.left,
                                            style: FillTimeSheetCustomTS
                                                .tfTitleLabelTS,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .departTimeControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // setState(() {
                                                  provider
                                                      .departTimeControllerArr[
                                                  index]
                                                      .text =
                                                      pickedTime
                                                          .format(context);
                                                  provider.updateTime =
                                                      pickedTime
                                                          .format(context);
                                                  //   //set output time to TextField value.
                                                  // });
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                hintText: "--:-- --",
                                                suffixIcon: Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                ),
                                                suffixIconColor: Colors.grey,
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) => input!
                                                  .isNotEmpty
                                                  ? null
                                                  : "", //"Please select depart time",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Pickup",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.pickupControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter pickup",
                                ),
                              ),
                              const Text(
                                "Delivery",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.deliveryControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter delivery",
                                ),
                              ),
                              const Text(
                                "Reference No. / Load Description",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.refNumControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter ref no.",
                                ),
                              ),
                              const Text(
                                "Temp",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: provider.tempControllerArr[index],
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter temp",
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Delivered ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .deliveredPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 90,
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Picked Up ( C / L / P)",
                                      textAlign: TextAlign.left,
                                      style:
                                      FillTimeSheetCustomTS.tfTitleLabelTS,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupCControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupLControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              controller: provider
                                                  .pickedupPControllerArr[
                                              index],
                                              textInputAction:
                                              TextInputAction.next,
                                              readOnly: false,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {},
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: ThemeColor
                                                    .themeLightWhiteColor,
                                                isDense: true,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                // labelText: "Date",
                                              ),
                                              onSaved: (String? value) {},
                                              validator: (input) =>
                                              input!.isNotEmpty ? null : "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "Weights",
                                textAlign: TextAlign.left,
                                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  controller:
                                  provider.weightControllerArr[index],
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ThemeColor.themeLightWhiteColor,
                                    isDense: true,
                                    //contentPadding:
                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          ThemeColor.themeLightGrayColor),
                                    ),
                                  ),
                                  onSaved: (String? value) {},
                                  validator: (input) => input!.isNotEmpty
                                      ? null
                                      : "Please enter weights",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                            MaterialStateProperty.all(0),
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: Colors.grey)))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Clear",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                            color:
                                            ThemeColor.themeDarkGreyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ThemeColor.themeGreenColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6.0),
                                                    side: const BorderSide(
                                                        color: ThemeColor
                                                            .themeGreenColor)))),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();

                                            Navigator.of(context).pop();
                                          }
                                          // Navigator.of(context)
                                          //     .pushNamed(Routes.restDetails);
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontName.interBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void removeElementFromTFsArr(Lttechprovider provider, int index) {
    provider.jobNameArr.removeAt(index);
    provider.customerNameArr.removeAt(index);
    provider.customerAddressArr.removeAt(index);
    provider.subrubControllerArr.removeAt(index);
    provider.arriveTimeControllerArr.removeAt(index);
    provider.departTimeControllerArr.removeAt(index);
    provider.pickupControllerArr.removeAt(index);
    provider.deliveryControllerArr.removeAt(index);
    provider.refNumControllerArr.removeAt(index);
    provider.tempControllerArr.removeAt(index);
    provider.deliveredCControllerArr.removeAt(index);
    provider.deliveredLControllerArr.removeAt(index);
    provider.deliveredPControllerArr.removeAt(index);
    provider.pickedupCControllerArr.removeAt(index);
    provider.pickedupLControllerArr.removeAt(index);
    provider.pickedupPControllerArr.removeAt(index);
    provider.weightControllerArr.removeAt(index);
  }
}

void clearAllTimesheetTextfields(Lttechprovider provider) {
  provider.jobNameArr.clear();
  provider.customerNameArr.clear();
  provider.customerAddressArr.clear();

  provider.subrubControllerArr.clear();
  provider.arriveTimeControllerArr.clear();
  provider.departTimeControllerArr.clear();

  provider.pickupControllerArr.clear();
  provider.deliveryControllerArr.clear();
  provider.refNumControllerArr.clear();

  provider.tempControllerArr.clear();
  provider.deliveredCControllerArr.clear();
  provider.deliveredLControllerArr.clear();
  provider.deliveredPControllerArr.clear();

  provider.pickedupCControllerArr.clear();
  provider.pickedupLControllerArr.clear();
  provider.pickedupPControllerArr.clear();

  provider.weightControllerArr.clear();
}




