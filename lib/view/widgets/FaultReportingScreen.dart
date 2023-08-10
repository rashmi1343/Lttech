import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/RestDetails.dart';

import 'package:provider/provider.dart';

import '../../entity/ApiRequests/FaultReportingRequest.dart';
import '../../entity/trucktyperesponse.dart';
import '../../utility/CustomTextStyle.dart';
import '../../utility/StatefulWrapper.dart';

enum LevelOfFault {
  none(""),
  minor("Minor"),
  major("Major"),
  serious("Serious");

  const LevelOfFault(this.value);
  final String value;
}

class FaultReportingScreen extends StatelessWidget {
  FaultReportingScreen({super.key});

  String faultType = LevelOfFault.none.value;
  // TruckData? vehicleDropdownSelectedValue;

  getVehicleType(BuildContext context) async {
    final provider = Provider.of<Lttechprovider>(context, listen: false);
    provider.vehicleDropdownSelectedValue = null;
    await provider.getvehicletype('');
  }

  setVehicleTypeDropDown(BuildContext context) {
    final provider = Provider.of<Lttechprovider>(context, listen: false);
    final vehicleTypeArr = provider.vehicleTypeArr;

    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffD4D4D4),
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xffFAFAFA),
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: const EdgeInsets.fromLTRB(0, 5, 15, 10),
      child: vehicleTypeArr.isNotEmpty
          ? DropdownButton(
              isExpanded: true,
              value: provider.vehicleDropdownSelectedValue,
              hint: provider.vehicleDropdownSelectedValue == null
                  ? Text("Select Vehicle Type")
                  : Text(provider.vehicleDropdownSelectedValue?.truckDetails ??
                      ""),
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: SizedBox(),
              items: vehicleTypeArr.map((vehicle) {
                return DropdownMenuItem<TruckData>(
                  value: vehicle,
                  child: Text(
                    vehicle.truckDetails ?? "",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        height: 1,
                        fontFamily: FontName.interRegular),
                  ), //value of item
                );
              }).toList(),
              onChanged: (value) {
                provider.vehicleDropdownSelectedValue = value;
                provider.setUpdateView = true;
              },
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);
      return true;
    }

    SizeConfig().init(context);
    final provider = Provider.of<Lttechprovider>(context, listen: false);
    return StatefulWrapper(
      onInit: () {
        getVehicleType(context);
        provider.clearFaultReportingText();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xffFAFAFA),
            appBar: commonAppBarWithoutSearchIcon('/Dashboard'),
            body: Consumer<Lttechprovider>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    Container(
                      margin: Platform.isAndroid
                          ? const EdgeInsets.only(
                              left: 12, top: 10, bottom: 9, right: 145)
                          : const EdgeInsets.only(
                              left: 12, top: 10, bottom: 9, right: 145),
                      height: 29,
                      width: 217,
                      child: Text(
                        "Fault Reporting",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff000000),
                            fontFamily: 'InterBold'),
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    value.isLoading
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 150.0),
                            child: CircularProgressIndicator(
                              backgroundColor: ThemeColor.themeLightGrayColor,
                              color: ThemeColor.themeGreenColor,
                            ))
                        : Expanded(
                            child: Container(
                              height: Platform.isIOS
                                  ? null //SizeConfig.safeBlockVertical * 70
                                  : SizeConfig.safeBlockVertical * 74,
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
                              child: CustomScrollView(
                                slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18, top: 8, bottom: 7),
                                          child: Text(
                                            "Date",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      18, 5, 17, 10),
                                              width:
                                                  SizeConfig.screenWidth * 0.66,
                                              child: TextFormField(
                                                autocorrect: false,

                                                controller:
                                                    value.DateController,
                                                textInputAction:
                                                    TextInputAction.next,
                                                readOnly: true,
                                                //set it true, so that user will not able to edit text
                                                onTap: () async {
                                                  final daysBeforeToday =
                                                      DateTime.now().subtract(
                                                          Duration(days: 30));
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate:
                                                        daysBeforeToday, //DateTime(2000),
                                                    //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime.now(),
                                                  );

                                                  if (pickedDate != null) {
                                                    print(pickedDate);
                                                    String formattedDate =
                                                        DateFormat(
                                                                'd MMM, yyyy')
                                                            .format(pickedDate);

                                                    value.faultReportSelectedDate =
                                                        DateFormat('yyyy-MM-d')
                                                            .format(pickedDate)
                                                            .toString();

                                                    print(value
                                                        .faultReportSelectedDate);

                                                    value.DateController.text =
                                                        formattedDate; //set output date to TextField value.
                                                  } else {}
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  hintText: "XX XXX,XXXX",
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
                                                  suffixIcon: Icon(
                                                    Icons.calendar_month,
                                                    size: 20,
                                                  ),
                                                  suffixIconColor: Colors.grey,
                                                ),
                                                onSaved: (String? value) {},
                                                validator: (input) => input!
                                                        .isNotEmpty
                                                    ? null
                                                    : "This Field is required",
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 10,
                                                  right: 10),
                                              width: SizeConfig.screenWidth *
                                                  0.28, //98,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                autocorrect: false,

                                                controller:
                                                    value.timeinputController,
                                                textInputAction:
                                                    TextInputAction.next,
                                                readOnly: true,
                                                //set it true, so that user will not able to edit text
                                                onTap: () async {
                                                  TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    context: context,
                                                  );
                                                  if (pickedTime != null) {
                                                    String formattedTime =
                                                        pickedTime.format(
                                                            context); //output 10:51 PM
                                                    print(
                                                        pickedTime.to24hour());

                                                    value.faultReportSelectedTime =
                                                        pickedTime.to24hour();

                                                    value.timeinputController
                                                            .text =
                                                        formattedTime; //set the value of text field.
                                                  } else {
                                                    print(
                                                        "Time is not selected");
                                                  }
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "HH:MM",
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: ThemeColor
                                                          .themeDarkestGrayColor,
                                                      fontFamily:
                                                          "InterRegular"),
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
                                                ),
                                                onSaved: (String? value) {},
                                                validator: (input) => input!
                                                        .isNotEmpty
                                                    ? null
                                                    : "This Field is required",
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18, top: 8, bottom: 7),
                                          child: Text(
                                            "Vehicle Registration Number",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 5, 19, 10),
                                          child: TextFormField(
                                            autocorrect: false,
                                            keyboardType: TextInputType.text,
                                            controller: value
                                                .VehicleRegistrationNoController,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: const InputDecoration(
                                              hintText: "XX0XX",
                                              filled: true,
                                              fillColor: ThemeColor
                                                  .themeLightWhiteColor,
                                              isDense: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                              ),
                                            ),
                                            onSaved: (String? v) {},
                                            validator: (input) =>
                                                input!.isNotEmpty
                                                    ? null
                                                    : "This Field is required",
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18, top: 8, bottom: 7),
                                          child: Text(
                                            "Vehicle Type",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 18),
                                          child:
                                              setVehicleTypeDropDown(context),
                                        ),
                                        //   Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: [
                                        //       SizedBox(
                                        //           width: 130,
                                        //           height: 42,
                                        //           child: ElevatedButton(
                                        //               style: ElevatedButton
                                        //                   .styleFrom(
                                        //                 backgroundColor: value
                                        //                     .primeMoverStatusColor,
                                        //                 foregroundColor: value
                                        //                             .primeMoverStatusColor ==
                                        //                         ThemeColor
                                        //                             .themeGreenColor
                                        //                     ? Colors.white
                                        //                     : ThemeColor
                                        //                         .themeDarkestGrayColor,
                                        //                 shape:
                                        //                     RoundedRectangleBorder(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(5),
                                        //                   side: BorderSide(
                                        //                       width: 1,
                                        //                       color: value.primeMoverStatusColor ==
                                        //                               ThemeColor
                                        //                                   .themeGreenColor
                                        //                           ? ThemeColor
                                        //                               .themeGreenColor
                                        //                           : ThemeColor
                                        //                               .themeDarkestGrayColor),
                                        //                 ),
                                        //               ),
                                        //               onPressed: () {
                                        //                 if (!value
                                        //                     .isprimeMoverbuttonEnabled) {
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeGreenColor;
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 } else {
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 }
                                        //               },
                                        //               child: Text(
                                        //                 "Prime Mover",
                                        //                 style: TextStyle(
                                        //                   fontSize: 15,
                                        //                   fontFamily:
                                        //                       'InterRegular',
                                        //                 ),
                                        //               ))),
                                        //       const SizedBox(
                                        //         width: 11,
                                        //       ),
                                        //       SizedBox(
                                        //           width: 90,
                                        //           height: 42,
                                        //           child: ElevatedButton(
                                        //               style: ElevatedButton
                                        //                   .styleFrom(
                                        //                 backgroundColor: value
                                        //                     .trailerStatusColor,
                                        //                 foregroundColor: value
                                        //                             .trailerStatusColor ==
                                        //                         ThemeColor
                                        //                             .themeGreenColor
                                        //                     ? Colors.white
                                        //                     : ThemeColor
                                        //                         .themeDarkestGrayColor,
                                        //                 shape:
                                        //                     RoundedRectangleBorder(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(5),
                                        //                   side: BorderSide(
                                        //                       width: 1,
                                        //                       color: value.trailerStatusColor ==
                                        //                               ThemeColor
                                        //                                   .themeGreenColor
                                        //                           ? ThemeColor
                                        //                               .themeGreenColor
                                        //                           : ThemeColor
                                        //                               .themeDarkestGrayColor),
                                        //                 ),
                                        //               ),
                                        //               onPressed: () {
                                        //                 if (!value
                                        //                     .istrailerbuttonEnabled) {
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeGreenColor;
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 } else {
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 }
                                        //               },
                                        //               child: Text(
                                        //                 "Trailer",
                                        //                 style: TextStyle(
                                        //                   fontSize: 15,
                                        //                   fontFamily:
                                        //                       'InterRegular',
                                        //                 ),
                                        //               ))),
                                        //       const SizedBox(
                                        //         width: 11,
                                        //       ),
                                        //       SizedBox(
                                        //           width: 112,
                                        //           height: 42,
                                        //           child: ElevatedButton(
                                        //               style: ElevatedButton
                                        //                   .styleFrom(
                                        //                 backgroundColor: value
                                        //                     .dollyStatusColor,
                                        //                 foregroundColor: value
                                        //                             .dollyStatusColor ==
                                        //                         ThemeColor
                                        //                             .themeGreenColor
                                        //                     ? Colors.white
                                        //                     : ThemeColor
                                        //                         .themeDarkestGrayColor,
                                        //                 shape:
                                        //                     RoundedRectangleBorder(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(5),
                                        //                   side: BorderSide(
                                        //                       width: 1,
                                        //                       color: value.dollyStatusColor ==
                                        //                               ThemeColor
                                        //                                   .themeGreenColor
                                        //                           ? ThemeColor
                                        //                               .themeGreenColor
                                        //                           : ThemeColor
                                        //                               .themeDarkestGrayColor),
                                        //                 ),
                                        //               ),
                                        //               onPressed: () {
                                        //                 if (!value
                                        //                     .isdollyrbuttonEnabled) {
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeGreenColor;
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 } else {
                                        //                   value.dollyStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.trailerStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                   value.primeMoverStatusColor =
                                        //                       ThemeColor
                                        //                           .themeLightColor;
                                        //                 }
                                        //               },
                                        //               child: Text(
                                        //                 "Dolly",
                                        //                 style: TextStyle(
                                        //                   fontSize: 15,
                                        //                   fontFamily:
                                        //                       'InterRegular',
                                        //                 ),
                                        //               ))),
                                        //     ],
                                        //   ),
                                        // ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18, top: 15, bottom: 7),
                                          child: Text(
                                            "Nature of Fault",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Container(
                                          height: 95,
                                          margin: const EdgeInsets.only(
                                              left: 18,
                                              top: 7,
                                              bottom: 7,
                                              right: 19),
                                          child: TextField(
                                              autofocus: false,
                                              expands: true,
                                              maxLines: null,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                decorationThickness: 0,
                                              ),
                                              controller:
                                                  value.NatureOfFaultController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Color(0xffFAFAFA),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ThemeColor
                                                          .themeLightGrayColor),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xffD4D4D4),
                                                      width: 1.0),
                                                ),
                                              )),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18,
                                              top: 14,
                                              bottom: 7,
                                              right: 10),
                                          child: Text(
                                            "Level Of Fault",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 18),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.28, //110,
                                                  height: 42,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: value
                                                            .minorStatusColor,
                                                        foregroundColor: value
                                                                    .minorStatusColor ==
                                                                ThemeColor
                                                                    .themeGreenColor
                                                            ? Colors.white
                                                            : ThemeColor
                                                                .themeDarkestGrayColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: value.minorStatusColor ==
                                                                      ThemeColor
                                                                          .themeGreenColor
                                                                  ? ThemeColor
                                                                      .themeGreenColor
                                                                  : ThemeColor
                                                                      .themeDarkestGrayColor),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        faultType = LevelOfFault
                                                            .minor.value;
                                                        if (!value
                                                            .isMinorbuttonEnabled) {
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        } else {
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        }
                                                      },
                                                      child: Text(
                                                        "Minor",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'InterRegular',
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 11,
                                              ),
                                              SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.28, //110,
                                                  height: 42,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: value
                                                            .majorStatusColor,
                                                        foregroundColor: value
                                                                    .majorStatusColor ==
                                                                ThemeColor
                                                                    .themeGreenColor
                                                            ? Colors.white
                                                            : ThemeColor
                                                                .themeDarkestGrayColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: value.majorStatusColor ==
                                                                      ThemeColor
                                                                          .themeGreenColor
                                                                  ? ThemeColor
                                                                      .themeGreenColor
                                                                  : ThemeColor
                                                                      .themeDarkestGrayColor),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        faultType = LevelOfFault
                                                            .major.value;
                                                        if (!value
                                                            .isMajorbuttonEnabled) {
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        } else {
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        }
                                                      },
                                                      child: Text(
                                                        "Major",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'InterRegular',
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 11,
                                              ),
                                              SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.28, //110,
                                                  height: 42,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: value
                                                            .seriousStatusColor,
                                                        foregroundColor: value
                                                                    .seriousStatusColor ==
                                                                ThemeColor
                                                                    .themeGreenColor
                                                            ? Colors.white
                                                            : ThemeColor
                                                                .themeDarkestGrayColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: value.seriousStatusColor ==
                                                                      ThemeColor
                                                                          .themeGreenColor
                                                                  ? ThemeColor
                                                                      .themeGreenColor
                                                                  : ThemeColor
                                                                      .themeDarkestGrayColor),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        faultType = LevelOfFault
                                                            .serious.value;
                                                        if (!value
                                                            .isSeriousbuttonEnabled) {
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        } else {
                                                          value.seriousStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                          value.majorStatusColor =
                                                              ThemeColor
                                                                  .themeGreenColor;
                                                          value.minorStatusColor =
                                                              ThemeColor
                                                                  .themeLightColor;
                                                        }
                                                      },
                                                      child: Text(
                                                        "Serious",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'InterRegular',
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 18, top: 19, bottom: 7),
                                          child: Text(
                                            "Upload Image (Jpg,png,jpeg,pdf)",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xffD4D4D4),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xffFAFAFA),
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              18, 10, 19, 13),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffFAFAFA),
                                              foregroundColor: ThemeColor
                                                  .themeLightGrayColor,
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              value.pickFiles();
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/browse_file_icon.png",
                                                  width: 28,
                                                  height: 22,
                                                  color: ThemeColor
                                                      .themeDarkGreyColor,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ), // icon
                                                Text(
                                                  "Browse files",
                                                  textAlign: TextAlign.center,
                                                  style: FillTimeSheetCustomTS
                                                      .tfTitleLabelTS,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 46,
                                              margin: EdgeInsets.only(
                                                  left: 18,
                                                  right: 19,
                                                  bottom: 10,
                                                  top: 8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              ThemeColor
                                                                  .themeGreenColor),
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
                                                    callFaultReportingApi(
                                                        value, context);
                                                    // Fluttertoast.showToast(
                                                    //     msg:
                                                    //         "Fault Report Submitted",
                                                    //     toastLength:
                                                    //         Toast.LENGTH_SHORT,
                                                    //     gravity:
                                                    //         ToastGravity.CENTER,
                                                    //     timeInSecForIosWeb: 1,
                                                    //     backgroundColor:
                                                    //         ThemeColor
                                                    //             .themeGreenColor,
                                                    //     textColor: Colors.white,
                                                    //     fontSize: 16.0);
                                                    // Provider.of<Lttechprovider>(
                                                    //         context,
                                                    //         listen: false)
                                                    //     .navigatetodashboard(
                                                    //         context);
                                                  },
                                                  child: const Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          FontName.interBold,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
            bottomNavigationBar: bottomappbar(context)),
      ),
    );
  }

  callFaultReportingApi(Lttechprovider provider, BuildContext context) {
    var faultReportingRequestObj = FaultReportingRequest();

    faultReportingRequestObj.companyid = Environement.companyID;
    faultReportingRequestObj.driverid = Environement.driverID;
    faultReportingRequestObj.reportdate = provider.faultReportSelectedDate;
    faultReportingRequestObj.reporttime = provider.faultReportSelectedTime;

    faultReportingRequestObj.vehicletype =
        provider.vehicleDropdownSelectedValue?.truckId ?? "";
    faultReportingRequestObj.vehiclenumber =
        provider.VehicleRegistrationNoController.text;

    faultReportingRequestObj.reportcontent =
        provider.NatureOfFaultController.text;
    faultReportingRequestObj.faultlevel = faultType;
    faultReportingRequestObj.attachment = provider.uploadedFilename;
    print("attachment:${faultReportingRequestObj.attachment}");

    final isValidated = validateData(faultReportingRequestObj);

    // it should be blank
    if (isValidated.isEmpty) {
      print(faultReportingRequestObj.toJson());
      provider.addFaultReportApiRequest(faultReportingRequestObj, context);
    } else {
      Fluttertoast.showToast(
          msg: isValidated,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColor.themeGreenColor,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  String validateData(FaultReportingRequest faultReportingRequestObj) {
    String validateMsg = '';

    if (faultReportingRequestObj.reportdate.toString().isEmpty ||
        faultReportingRequestObj.reportdate == null) {
      return validateMsg = 'Please select date';
    } else if (faultReportingRequestObj.reporttime.toString().isEmpty ||
        faultReportingRequestObj.reporttime == null) {
      return validateMsg = 'Please select time';
    } else if (faultReportingRequestObj.vehiclenumber.toString().isEmpty ||
        faultReportingRequestObj.vehiclenumber == null) {
      return validateMsg = 'Please enter vehicle registration number';
    } else if (faultReportingRequestObj.vehicletype.toString().isEmpty ||
        faultReportingRequestObj.vehicletype == null) {
      return validateMsg = 'Please select vehicle type';
    } else if (faultReportingRequestObj.reportcontent.toString().isEmpty ||
        faultReportingRequestObj.reportcontent == null) {
      return validateMsg = 'Please enter nature of fault';
    } else if (faultReportingRequestObj.faultlevel.toString().isEmpty ||
        faultReportingRequestObj.faultlevel == null) {
      return validateMsg = 'Please select level of fault';
    } else if (faultReportingRequestObj.attachment.toString().isEmpty ||
        faultReportingRequestObj.attachment == null) {
      return validateMsg = 'Please select image';
    }
    return validateMsg;
  }
}
