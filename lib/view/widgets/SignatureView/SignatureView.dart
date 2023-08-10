import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../entity/ApiRequests/AddGeoLocationRequest.dart';
import '../../../presenter/Lttechprovider.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/SizeConfig.dart';
import '../../../utility/StatefulWrapper.dart';
import '../../../utility/appbarWidget.dart';
import '../../../utility/env.dart';

class lltechSignatureView extends StatelessWidget {
  lltechSignatureView({super.key, required int index});
  late String signbase64data = '';

  var _decodedImage = '';
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late SignatureView _signatureView;
  late Uint8List imageBytes = Uint8List(0);
  late Uint8List consignmentSignImageBytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Future<bool> _onWillPop() async {
      print("back called");
      var provider = Provider.of<Lttechprovider>(context, listen: false);
      provider.isConsignmentDetail == true
          ? Navigator.pop(context)
          : provider.navigatetoJobdetail(context);

      return true;
    }

    var signprovider = Provider.of<Lttechprovider>(context, listen: false);
    signprovider.checkLocationEnabled();
    bool isLocationEnabled = signprovider.isLocationEnabled;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StatefulWrapper(
        onInit: () {
          signprovider.isError = false;

          if (signprovider.istimesheetsignscreenfirsttime) {
            print("Sign screen open first time");

            signprovider.setEditTimesheet = false;
            signprovider.isviewtimesheet = false;
          } else if (signprovider.isEditTimesheet) {
            signprovider.isSuccess = false;
            String signature =
                // "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";
                // signprovider.getTimesheetByIdResponse.data!.signature ?? "";
                signprovider.getTimesheetByIdResponse.data?.signature ?? "";
            print("signature.length:${signature.length}");

            ApiCounter.editimageBytes = Base64Decoder().convert(signature);
            imageBytes = Base64Decoder().convert(signature);
          } else if (signprovider.isviewtimesheet) {
            signprovider.isSuccess = false;
            signprovider.istimesheetsignscreenfirsttime = false;
            signprovider.setEditTimesheet = false;
            String signature =
                // "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";
                // signprovider.getTimesheetByIdResponse.data!.signature ?? "";
                signprovider.getTimesheetByIdResponse.data?.signature ?? "";
            print("signature.length:${signature.length}");

            ApiCounter.editimageBytes = Base64Decoder().convert(signature);
            imageBytes = Base64Decoder().convert(signature);
          }
          signprovider.getCurrentPosition(context);
          signprovider.setClearButtonDisabled(false);
          // signprovider.isDeliveredLocationOngit a
          //     ? signprovider.showLocationAlertDialog(context)
          //     : null;
          _signatureView = SignatureView(
            // canvas color
            backgroundColor: Colors.white30,

            penStyle: Paint()
              // pen color
              ..color = Color.fromARGB(255, 9, 150, 84)
              // type of pen point circular or rounded
              ..strokeCap = StrokeCap.round
              // pen pointer width
              ..strokeWidth = 5.0,
            // data of the canvas
            onSigned: (data) {
              print("On change $data");
              if (!signprovider.isEditTimesheet) {
                imageBytes = Uint8List(640);
                imageBytes = ApiCounter.editimageBytes;
              } else if (!signprovider.isConsignmentDetail) {
                consignmentSignImageBytes = Uint8List(640);
              } else {
                imageBytes = Uint8List(640);
                imageBytes = ApiCounter.editimageBytes;
              }
            },
          );
        },
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Consumer<Lttechprovider>(builder: (context, value, child) {
              return Scaffold(
                  key: _scaffoldKey,
                  //  appBar: commonAppBar('/JobdetailView'),
                  appBar: AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      backgroundColor: Color(0xffFAFAFA),
                      toolbarHeight: 80,
                      elevation: 0,
                      centerTitle: false,
                      toolbarOpacity: 0.5,
                      title: Transform(
                          transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              "assets/images/AppBarIcon/LogoAppBar@2x.png",
                              height: 33,
                              width: 124,
                            ),
                          )),
                      actions: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(right: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xff0AAC19),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28)),
                              ),
                              child: Center(
                                child: Text(
                                  // "R",
                                  Environement.initialloginname.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Color(0xffFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      leading: Builder(
                        builder: (context) => Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: value.isConsignmentDetail
                              ? IconButton(
                                  alignment: Alignment.centerLeft,
                                  icon: Image.asset(
                                    "assets/images/AppBarIcon/backarrow.png",
                                    color: const Color(0xff111111),
                                    height: 24,
                                    width: 12,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Navigator.of(context)
                                    //     .pushNamedAndRemoveUntil(
                                    //         "/ConsignmentDetails",
                                    //         (Route<dynamic> route) => false);
                                  },
                                )
                              : IconButton(
                                  alignment: Alignment.centerLeft,
                                  icon: Image.asset(
                                    "assets/images/AppBarIcon/backarrow.png",
                                    color: const Color(0xff111111),
                                    height: 24,
                                    width: 12,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            "/JobdetailView",
                                            (Route<dynamic> route) => false);
                                  },
                                ),
                        ),
                      )),
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Color(0xffFAFAFA),
                  body: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 18, top: 32, bottom: 27, right: 154),
                        height: 29,
                        width: 203,
                        child: RichText(
                          text: TextSpan(
                              text: "Signature",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              children: [
                                TextSpan(
                                    text: signprovider.isviewtimesheet
                                        ? ''
                                        : signprovider.isEditTimesheet
                                            ? ''
                                            : ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ))
                              ]),
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
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                value.isConsignmentDetail
                                    ? Container()
                                    : Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 30, top: 10),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  "I certify that I am presenting myself as fit for duty\nand understand my obligations in relation to\nfatigue management.",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'InterRegular',
                                                      fontSize: 14,
                                                      color:
                                                          Color(0xff000000))),
                                            ))
                                      ]),
                                Container(
                                    margin: EdgeInsets.only(top: 25),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          value.isConsignmentDetail
                                              ? Container()
                                              : Flexible(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child:
                                                          Text("Signature"))),
                                          value.isConsignmentDetail
                                              ? Container()
                                              : value.isEditTimesheet
                                                  ? Flexible(
                                                      child: Container(
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      0xffFAFAFA),
                                                                  /*boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],*/
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xffD4D4D4),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  bottom: 10,
                                                                  right: 20,
                                                                  top: 5),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: ApiCounter
                                                                      .editimageBytes
                                                                      .length ==
                                                                  0
                                                              ? /*Center(
                                                    child:
                                                    CircularProgressIndicator())*/
                                                              Container()
                                                              : Image.memory(
                                                                  ApiCounter
                                                                      .editimageBytes,
                                                                  // width: 250,
                                                                  // height: 250,
                                                                  // fit: BoxFit.contain,
                                                                )),
                                                    )
                                                  : value.isviewtimesheet
                                                      ? Flexible(
                                                          child: Container(
                                                              height: 150,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          0xffFAFAFA),
                                                                      /*boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],*/
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Color(
                                                                            0xffD4D4D4),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              5))),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      bottom:
                                                                          10,
                                                                      right: 20,
                                                                      top: 5),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: ApiCounter
                                                                          .editimageBytes
                                                                          .length ==
                                                                      0
                                                                  ? /*Center(
                                                    child:
                                                    CircularProgressIndicator())*/
                                                                  Container()
                                                                  : Image
                                                                      .memory(
                                                                      ApiCounter
                                                                          .editimageBytes,
                                                                      // width: 250,
                                                                      // height: 250,
                                                                      // fit: BoxFit.contain,
                                                                    )),
                                                        )
                                                      : Container(
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      0xffFAFAFA),
                                                                  /*boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],*/
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xffD4D4D4),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  bottom: 10,
                                                                  right: 20,
                                                                  top: 5),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child:
                                                              _signatureView),
                                          Flexible(
                                              child: value.isConsignmentDetail
                                                  ? Container(
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffFAFAFA),
                                                          /*boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],*/
                                                          border: Border.all(
                                                            color: Color(
                                                                0xffD4D4D4),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          bottom: 10,
                                                          right: 20,
                                                          top: 5),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: _signatureView)
                                                  : value.isEditTimesheet
                                                      ? Container(
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      0xffFAFAFA),
                                                                  /*boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffEEEEEE),
                                                  blurRadius: 3.0,
                                                ),
                                              ],*/
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xffD4D4D4),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  bottom: 10,
                                                                  right: 20,
                                                                  top: 5),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: _signatureView)
                                                      : Container()),
                                        ])),
                                value.isviewtimesheet
                                    ? Container()
                                    : Flexible(
                                        child: Container(
                                            width: width,
                                            height: height * 0.060,
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 20,
                                                right: 20),
                                            child: ElevatedButton(
                                                onPressed: value.isSignClear
                                                    ? null
                                                    : () {
                                                        print("clear sign");
                                                        _signatureView.clear();
                                                        //  createWidget(1);
                                                      },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(value
                                                              .isSignClear
                                                          ? Colors.grey
                                                          : Color(0xff0AAC19)),
                                                ),
                                                child: Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                      fontFamily: 'InterBold',
                                                      fontSize: 16,
                                                      color: Color(0xffffffff)),
                                                )))),
                                value.isConsignmentDetail
                                    ? Flexible(
                                        child: Container(
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 20,
                                            right: 20),
                                        child: RoundedLoadingButton(
                                            height: height * 0.060,
                                            width: width,
                                            borderRadius: 5,
                                            color: Color(0xff0AAC19),
                                            successColor: Color(0xff0AAC19),
                                            successIcon: Icons.check_circle,
                                            failedIcon: Icons.error_outlined,
                                            resetAfterDuration: true,
                                            resetDuration: Duration(seconds: 3),
                                            controller: _btnController,
                                            onPressed: () async {
                                              // final signatureView=_scaffoldKey.currentState;

                                              // final signatureBase64=await signatureView?.exportBase64Image();
                                              if (_signatureView.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Sign before submitting",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 13.0);
                                                // value.locationEnabledDialog(
                                                //     context);
                                              } else {
                                                //   checkLocationAndCallApi(value,context);

                                                //  }
                                                if (value
                                                    .isDeliveredLocationOn) {
                                                  print("Location enabled");

                                                  // signprovider
                                                  //     .checkLocationEnabled();
                                                  // PermissionStatus status =
                                                  // await Permission.location.request();
                                                  // if(status.isDenied){
                                                  //   bool showrationale=await Permission.location.shouldShowRequestRationale;
                                                  //   if(showrationale){
                                                  //     requestLocationPermissions(context);
                                                  //   }else{
                                                  //     requestLocationPermissions(context);
                                                  //
                                                  //   }
                                                  // }else{
                                                  value.setClearButtonDisabled(
                                                      true);
                                                  var base64data =
                                                      _signatureView
                                                          .exportBase64Image();
                                                  print(
                                                      "Generated base64data: $base64data");

                                                  base64data
                                                      .then(
                                                    (value) => checkvalidation(
                                                      value,
                                                      _signatureView,
                                                      context,
                                                      Provider.of<
                                                              Lttechprovider>(
                                                          context,
                                                          listen: false),
                                                      index,
                                                    ),
                                                  )
                                                      .catchError((error) {
                                                    print('Caught $error');
                                                  });
                                                } else {
                                                  print("Location disabled");
                                                  value.showLocationAlertDialog(
                                                      context);
                                                  // Fluttertoast.showToast(
                                                  //     msg:
                                                  //         "Please Enable Location",
                                                  //     toastLength:
                                                  //         Toast.LENGTH_SHORT,
                                                  //     gravity:
                                                  //         ToastGravity.BOTTOM,
                                                  //     timeInSecForIosWeb: 1,
                                                  //     backgroundColor:
                                                  //         Colors.red,
                                                  //     textColor: Colors.white,
                                                  //     fontSize: 13.0);
                                                }
                                              }
                                            },
                                            child: Text('Submit',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        FontName.interBold))),
                                      ))
                                    : Flexible(
                                        child: Container(
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 20,
                                            right: 20),
                                        child: RoundedLoadingButton(
                                            height: height * 0.060,
                                            width: width,
                                            borderRadius: 5,
                                            color: Color(0xff0AAC19),
                                            successColor: Color(0xff0AAC19),
                                            successIcon: Icons.check_circle,
                                            failedIcon: Icons.error_outlined,
                                            resetAfterDuration: true,
                                            resetDuration: Duration(seconds: 3),
                                            controller: _btnController,
                                            onPressed: () {
                                              if (value.isviewtimesheet) {
                                                value.navigatetoListTimeSheet(
                                                    context);
                                              } else {
                                                var base64data = _signatureView
                                                    .exportBase64Image();
                                                base64data
                                                    .then((value) =>
                                                        //print("base64"+value.toString())
                                                        // signbase64data = value.toString()
                                                        checkvalidation(
                                                            value,
                                                            _signatureView,
                                                            context,
                                                            Provider.of<
                                                                    Lttechprovider>(
                                                                context,
                                                                listen: false),
                                                            index))
                                                    .catchError((error) {
                                                  print('Caught $error');
                                                });
                                              }
                                            },
                                            child: value.isviewtimesheet
                                                ? Text('Back',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            FontName.interBold))
                                                : Text('Submit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: FontName
                                                            .interBold))),
                                      )),
                                value.isConsignmentDetail
                                    ? Container()
                                    : SizedBox(
                                        height: height * 0.060,
                                        width: width, //
                                        child: Center(
                                          child: value.isLoading
                                              ? Text("Processing...",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'InterRegular',
                                                      fontSize: 14,
                                                      color: Color(0xff0AAC19)))
                                              : value.isError
                                                  ? Text(
                                                      "Something went wrong, Please try again",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'InterRegular',
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xff0AAC19)))
                                                  : value.isSuccess
                                                      ? Text(
                                                          // '${value.addTimesheetResponse.data?.success ?? ""}')
                                                          "Time Sheet Submitted Successfully",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'InterRegular',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff0AAC19)))
                                                      : Text(
                                                          //"Some thing Went Wrong Please Try Again",
                                                          "",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'InterRegular',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff0AAC19))),
                                        )),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
            })));
  }

  void checkvalidation(String? str64data, SignatureView sv,
      BuildContext context, Lttechprovider lp, int index) {
    if (imageBytes.length == 0) {
      Fluttertoast.showToast(
          msg: "Signature is Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (lp.isConsignmentDetail) {
        signbase64data = str64data!.split(',').last;
        print("signbase64data:$signbase64data");
        lp.setClearButtonDisabled(true);
        lp.isDeliveredLocationOn = true;
        lp.setDeliveredLocation(
            lp.currentPosition.latitude, lp.currentPosition.longitude);

        lp.signConsignmentRequestObj.signature = signbase64data;
        // lp.signConsignmentRequestObj.signature =
        //     ApiCounter.consignmentSignImageBytes.toString();

        lp.signConsignmentRequestObj.endLatitude =
            lp.deliveredLatitude.toString();
        //  lp.currentPosition.latitude.toString();
        lp.signConsignmentRequestObj.endLongitude =
            lp.deliveredLongitude.toString();
        // lp.currentPosition.longitude.toString();
        lp.signConsignmentRequestObj.signatureDate = DateTime.now();
        lp.signConsignmentRequestObj.status = "2";

        lp.signConsignmentRequest(lp.signConsignmentRequestObj,
            lp.consignmentByIdresponse.data!.consignmentId.toString(), context);

//add geoLocation
        print("index:${index}");
        lp.isPdfFileSignGenerated = true;
        lp.isDeliveredConsignment = true;
        lp.setsignaturebutton(true);

        //  if (lp.addconsignmentGeoDetailWidgetArr.isNotEmpty) {
        int geoDetailIndex = 0;
        var consignmentAddGeoDetailObj = GeoDetail();
      } else if (lp.isEditTimesheet || lp.istimesheetsignscreenfirsttime) {
        /* Future<Uint8List?> _bytes = sv.exportBytes();
        _bytes.then((value) => ApiCounter.editimageBytes = value!);*/
        /* lp.updatetimesheetrequestObj.signature =
            ApiCounter.editimageBytes.toString();
     */
        print("update time sheet");
        print("str64data length:$str64data");
        signbase64data = str64data!.split(',').last;
        print("signbase64data:$signbase64data");
        lp.updatetimesheetrequestObj.signature = signbase64data;
        if (sv.isEmpty) {
          lp.updatetimesheetrequestObj.signature =
              lp.getTimesheetByIdResponse.data?.signature.toString();
        } else {
          lp.updatetimesheetrequestObj.signature = signbase64data;
        }
        lp.updatetimesheetrequestObj.drivermobile = "9870156733";
        //  lp.updatetimesheetrequestObj.jobDetails=[];
        //  lp.updatetimesheetrequestObj.restDetails=[];
        print(
            'updateTimesheetRequestObj:${lp.updatetimesheetrequestObj.toJson()}');
        Provider.of<Lttechprovider>(context, listen: false)
            .updateTimeSheetApiRequest(context);
      } else {
        /* Future<Uint8List?> _bytes = sv.exportBytes();
        _bytes.then((value) => ApiCounter.editimageBytes = value!);*/
        print("add time sheet");
        print("str64data length:$str64data");
        signbase64data = str64data!.split(',').last;
        print("signbase64data_Create:$signbase64data");
        lp.addTimeSheetRequestObj.signature = signbase64data;
        //  lp.addTimeSheetRequestObj.signature = [];
        print("Rest detail:" + lp.restDetailsDataArr.length.toString());
        print("job detail:" +
            lp.addTimeSheetRequestObj.jobDetails.length.toString());
        print('AddTimeSheetRequestObj: ${lp.addTimeSheetRequestObj.toJson()}');

        /* Provider.of<Lttechprovider>(context, listen: false)
            .addTimeSheetApiRequest(context);*/
      }
    }
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  String convertUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  Uint8List convertStringToUint8List(String? str) {
    final List<int>? codeUnits = str?.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits!);

    return unit8List;
  }

  Future<void> requestLocationPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      var base64data = _signatureView.exportBase64Image();
      print("Generated base64data: $base64data");

      base64data
          .then(
        (value) => checkvalidation(
          value,
          _signatureView,
          context,
          Provider.of<Lttechprovider>(context, listen: false),
          index,
        ),
      )
          .catchError((error) {
        print('Caught $error');
      });
    } else {
      Fluttertoast.showToast(
          msg: "Location is Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
    }
  }

  Future<void> checkLocationAndCallApi(
      Lttechprovider value, BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission permissionResult =
          await Geolocator.requestPermission();
      if (permissionResult == LocationPermission.whileInUse ||
          permissionResult == LocationPermission.always) {
        value.isLocationEnabled = true;
        value.setUpdateView = true;
        //api call
        var base64data = _signatureView.exportBase64Image();
        base64data
            .then((value) =>
                //print("base64"+value.toString())
                // signbase64data = value.toString()
                checkvalidation(value, _signatureView, context,
                    Provider.of<Lttechprovider>(context, listen: false), index))
            .catchError((error) {
          print('Caught $error');
        });
      } else {
        value.isLocationEnabled = false;
        value.setUpdateView = true;
      }
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      value.isLocationEnabled = true;
      value.setUpdateView = true;
      //api call
      var base64data = _signatureView.exportBase64Image();
      base64data
          .then((value) =>
              //print("base64"+value.toString())
              // signbase64data = value.toString()
              checkvalidation(value, _signatureView, context,
                  Provider.of<Lttechprovider>(context, listen: false), index))
          .catchError((error) {
        print('Caught $error');
      });
    } else {
      value.isLocationEnabled = false;
      value.setUpdateView = true;
    }
  }
}
