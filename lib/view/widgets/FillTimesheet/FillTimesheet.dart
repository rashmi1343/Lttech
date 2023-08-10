import 'package:chips_choice/chips_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lttechapp/utility/DateHelpers.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/StatefulWrapper.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

import '../../../presenter/Lttechprovider.dart';
import '../../../router/routes.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/MultiSelectChip.dart';
import '../../../utility/env.dart';
import '../DrawerWidget.dart';
import 'VehicleChecklist.dart';
import 'dart:io' show Platform;

class FillTimesheet extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  /*TextEditingController truckController = TextEditingController();
  TextEditingController trailorController = TextEditingController();
*/

  String? _email;

  final textFieldFocusNode = FocusNode();

  // var _items;
  // AddTimeSheetRequest objsubmitfilltimesheet = AddTimeSheetRequest();

  Future _getThingsOnStartup(BuildContext context) async {

  }

  final _multiSelectKey = GlobalKey<FormFieldState>();

  //late String trailerid = 'box (pig) trailer';
  String initialtimesheetdate =
  DateFormat("MMMM, dd, yyyy").format(DateTime.now());
  int pst = 0;

  @override
  Widget build(BuildContext context) {
    /* Future.delayed(Duration.zero,(){
      Provider.of<Lttechprovider>(context, listen: false).getfilltimesheetapi('44eef57e-8d41-4cae-a9fa-876983a6ea2c', '8c9c3fe8-4a7f-4861-80fd-c4065f0dd87b');
    });
*/

    SizeConfig().init(context);
    return StatefulWrapper(
        onInit: () {
          _getThingsOnStartup(context).then((value) async {
            print('Async done');
            //   await Future.delayed(Duration.zero, () {
            final provider = Provider.of<Lttechprovider>(context, listen: false);
            // Provider.of<Lttechprovider>(context, listen: false).getfilltimesheetapi('44eef57e-8d41-4cae-a9fa-876983a6ea2c', '8c9c3fe8-4a7f-4861-80fd-c4065f0dd87b');

            // provider.arrtruck = [];
            // provider.arrtrailer = [];
            provider.arrtruckreg = [];
            provider.arrtrailerreg = [];
            provider.arrtruckregstr = [];
            provider.arrvehiclechklist = [];
            provider.objitemfitnessdata = [];
            //   provider.getvehicletype('1');
            // provider.getvehicletype('2');

            provider.getvehicleregistered('1');

            provider.getchecklistapi("1",context);

            provider.addTimeSheetRequestObj.trailer = [];
            provider.fitnesschecklistpst = 0;
            pst = 0;

            //  _items = provider.objgetalltrailertype.data!
            //    .map((trucktrailer) => MultiSelectItem<truckData>(
            //  trucktrailer, trucktrailer.truckDetails.toString()))
            //.toList();
            //

            // new time sheet value
            print("createtimesheet:${provider.createtimesheet}");
            if (provider.createtimesheet == 0) {
              provider.timesheetdateController.text =
                  DateFormat("MMMM, dd, yyyy").format(DateTime.now());
              provider.startTimeController.text =
                  DateFormat("HH:mm").format(DateTime.now());

              provider.endTimeController.text = '';
              provider.endOdometerController.text = '';
              provider.startOdometerController.text = '';
              provider.restDetailsDataArr = [];
              print("isedittimesheet:${provider.isEditTimesheet}");
              /* if (!provider.isEditTimesheet) {
          provider.createtimesheet = provider.createtimesheet + 1;
        }*/
            }
            // });
          });

        },
        child: WillPopScope(
            onWillPop: () async => false,
            child:
            Consumer<Lttechprovider>(builder: (context, provider, child) {
              //dateController.text = value.filltimesheet.data.timesheetDate.toString();
              // to save in db
              //dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
              // to display on ui
              // Edit time sheet setting value

              return Scaffold(
                  backgroundColor: ThemeColor.themeLightWhiteColor,
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
                      //
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              alignment: Alignment.centerLeft,
                              icon: Image.asset(
                                  "assets/images/DashboardIcons/home.png",
                                  color: const Color(0xff999999),
                                  height: 25,
                                  width: 25),
                              onPressed: () {
                                Provider.of<Lttechprovider>(context,
                                    listen: false)
                                    .navigatetodashboard(context);
                              },
                            ),
                          ),
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
                                //"R",
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
                      builder: (context) => provider.isEditTimesheet
                          ? Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          alignment: Alignment.centerLeft,
                          icon: Image.asset(
                            "assets/images/AppBarIcon/backarrow.png",
                            color: const Color(0xff111111),
                            height: 24,
                            width: 12,
                          ),
                          onPressed: () {
                            Provider.of<Lttechprovider>(context,
                                listen: false)
                                .navigatetoListTimeSheet(context);
                          },
                        ),
                      )
                          : Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          alignment: Alignment.centerLeft,
                          icon: SvgPicture.asset(
                            "assets/images/DashboardIcons/drawericon.svg",
                            color: const Color(0xff111111),
                            height: 24,
                            width: 12,
                          ),
                          onPressed: () =>
                              Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                  ),
                  drawer: Drawer(
                    child: DrawerWidget(),
                  ),
                  body: provider.isLoading
                      ? Center(child: CircularProgressIndicator(color: ThemeColor.themeGreenColor))
                      : Stack(children: [
                    Container(
                      color: ThemeColor.themeLightWhiteColor,
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, bottom: 27, right: 154),
                          height: 29,
                          width: 203,
                          child:
                          provider.isEditTimesheet?
                          Text(
                            "Edit Timesheet",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: 'InterBold'),
                          ):
                          provider.isviewtimesheet?
                          Text(
                            "View Timesheet",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: 'InterBold'),
                          ):
                          Text(
                            "Fill Timesheet",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff000000),
                                fontFamily: 'InterBold'),
                          ),
                        ),
                        Expanded(
                            child: Form(
                              key: _formKey,
                              child: ListView(children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        blurRadius: 1.0,
                                      )
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: "Date",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children:  [

                                              TextSpan(
                                                  text:
                                                  provider.isviewtimesheet?'':
                                                  provider.isEditTimesheet?'':
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: TextFormField(
                                          autocorrect: false,
                                          keyboardType:
                                          TextInputType.datetime,
                                          // initialValue: initialtimesheetdate,
                                          controller: provider
                                              .timesheetdateController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,

                                          //set it true, so that user will not able to edit text

                                          onTap: () async {
                                            if(provider.isEditTimesheet) {
                                              print("on tap edit mode not allowed");
                                            }
                                            else if(provider.isviewtimesheet) {
                                              print("on tap view mode not allowed");
                                            }
                                            else {
                                              DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: //DateTime(2000),
                                                  DateTime.now(),
                                                  lastDate: DateTime.now());
                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                provider
                                                    .timesheetdateController
                                                    .text =
                                                    formattedDate; //set output date to TextField value.

                                                if (provider.isEditTimesheet) {

                                                  provider
                                                      .updatetimesheetrequestObj
                                                      .timesheetdate =
                                                      DateFormat(
                                                          'yyyy-MM-dd')
                                                          .format(pickedDate);
                                                } else {
                                                  provider
                                                      .addTimeSheetRequestObj
                                                      .timesheetdate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickedDate);
                                                }

                                              }
                                            }
                                          },
                                          decoration:
                                          provider.isviewtimesheet?
                                          InputDecoration(
                                            filled: true,
                                            fillColor: ThemeColor
                                                .themeLightWhiteColor,
                                            isDense: true,
                                            //contentPadding:
                                            // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                          )
                                              :provider.isEditTimesheet?
                                          InputDecoration(
                                            filled: true,
                                            fillColor: ThemeColor
                                                .themeLightWhiteColor,
                                            isDense: true,
                                            //contentPadding:
                                            // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                          )
                                              :
                                          InputDecoration(
                                            filled: true,
                                            fillColor: ThemeColor
                                                .themeLightWhiteColor,
                                            isDense: true,
                                            //contentPadding:
                                            // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            suffixIcon:
                                            Icon(
                                              Icons.calendar_month,
                                              size: 20,
                                            ),
                                            suffixIconColor: Colors.grey,
                                          ),
                                          onSaved: (String? value) {
                                            _email = value;
                                          },
                                          validator: (input) =>
                                          input!.isNotEmpty
                                              ? null
                                              : "Please select date",
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Start Time",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children:  [
                                              TextSpan(
                                                  text:  provider.isviewtimesheet?'':
                                                  provider.isEditTimesheet?'':
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: TextFormField(
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          controller:
                                          provider.startTimeController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          //set it true, so that user will not able to edit text
                                          onTap: () async {

                                            if(provider.isviewtimesheet) {
                                              print("view mode");
                                            }
                                            else if(provider.isEditTimesheet) {
                                              print("edit mode");
                                            }else {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // setState(() {
                                                provider.startTimeController
                                                    .text =
                                                    pickedTime.to24hours();
                                                //   .format(context);
                                                //set output time to TextField value.
                                                // });
                                              }
                                            }
                                          },
                                          decoration: const InputDecoration(
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
                                            // labelText: "Date",
                                            suffixIcon: Icon(
                                              Icons.access_time,
                                              size: 20,
                                            ),
                                            suffixIconColor: Colors.grey,
                                          ),
                                          onSaved: (String? value) {
                                            _email = value;
                                          },
                                          validator: (input) =>
                                          input!.isNotEmpty
                                              ? null
                                              : "Please select time",
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "End Time",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children: provider.isEditTimesheet
                                                ? const [
                                              TextSpan(
                                                  text: ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]
                                                : []),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: TextFormField(
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          controller:
                                          provider.endTimeController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          //set it true, so that user will not able to edit text
                                          onTap: () async {

                                            if(!provider.isviewtimesheet) {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // setState(() {
                                                //  endTimeController.text = pickedTime.format(context).to;
                                                provider.endTimeController
                                                    .text =
                                                    pickedTime.to24hours();
                                                // DateTime parsedTime = DateTime.parse(endTimeController.text.toString().);

                                                //set output time to TextField value.
                                                // });
                                              }
                                            }
                                          },
                                          decoration: const InputDecoration(
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
                                            // labelText: "Date",
                                            suffixIcon: Icon(
                                              Icons.access_time,
                                              size: 20,
                                            ),
                                            suffixIconColor: Colors.grey,
                                          ),
                                          onSaved: (String? value) {
                                            _email = value;
                                          },
                                          validator: (input) =>
                                          input!.isNotEmpty
                                              ? null
                                              : "Please select time",
                                        ),
                                      ),
                                      const Text(
                                        "Log Time",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: FontName.interMedium,
                                          color: ThemeColor.themeGreenColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Start Odometer",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children:  [
                                              TextSpan(
                                                  text: provider.isviewtimesheet?'':
                                                  provider.isEditTimesheet?'':
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: TextFormField(
                                          autocorrect: false,
                                          keyboardType: provider.isviewtimesheet?TextInputType.none:provider.isEditTimesheet?TextInputType.none:TextInputType.number,
                                          controller: provider
                                              .startOdometerController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: provider.isviewtimesheet?true:false,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: ThemeColor
                                                .themeLightWhiteColor,
                                            isDense: true,

                                            //contentPadding:
                                            // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                          onSaved: (String? value) {
                                            _email = value;
                                          },
                                          validator: (input) => input!
                                              .isNotEmpty
                                              ? null
                                              : "Please add start odometer",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "End Odometer",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children: provider.isEditTimesheet
                                                ? const [
                                              TextSpan(
                                                  text: ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]
                                                : []),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: TextFormField(
                                          autocorrect: false,
                                          keyboardType: provider.isviewtimesheet?TextInputType.none:TextInputType.number,
                                          controller:
                                          provider.endOdometerController,
                                          readOnly: provider.isviewtimesheet?true:false,
                                          textInputAction:
                                          TextInputAction.next,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: ThemeColor
                                                .themeLightWhiteColor,
                                            isDense: true,
                                            //contentPadding:
                                            // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                          onSaved: (String? value) {
                                            _email = value;
                                          },
                                          validator: (input) =>
                                          input!.isNotEmpty
                                              ? null
                                              : "Please add end odometer",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Vehicle Registration No.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: FontName.interBold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Vehicle",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children:  [
                                              TextSpan(
                                                  text: provider.isviewtimesheet?'':
                                                  provider.isEditTimesheet?'':
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            color: ThemeColor
                                                .themeLightWhiteColor),
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: provider.arrtruckregstr
                                            .length ==
                                            0
                                            ? Container()
                                            : /*ChipsChoice<int>.single(
                                                    value: provider
                                                        .selectedtruckid,
                                                    choiceItems:
                                                        C2Choice.listFrom(
                                                            source: provider
                                                                .arrtruckregstr,
                                                            value: (i, v) => i,
                                                            label: (i, v) => v),
                                                    onChanged: (val) {
                                                      //String
                                                      //  value.onchangeBillingCustomer(val);
                                                      provider.selectedtruckid =
                                                          val;
                                                      provider
                                                          .onchangetrucktypefillltimesheet(
                                                              val);
                                                    },
                                                  )*/
                                        provider.isviewtimesheet?Container(
                                            child:
                                            Center(child:
                                            Text(
                                                provider.selectedtruckstr,
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .themeGreenColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                    'InterMedium')))

                                        ):
                                        DropdownSearch<String>(
                                            popupProps: PopupProps.menu(
                                              //modalBottomSheet
                                              showSearchBox:  true,
                                              showSelectedItems: true,
                                              searchDelay: const Duration(
                                                  milliseconds: 1),
                                              searchFieldProps:
                                              const TextFieldProps(
                                                decoration: InputDecoration(
                                                  labelText:
                                                  "Select Vehicle Registration No",
                                                ),
                                              ),
                                            ),
                                            items: provider
                                                .arrtruckregstr,

                                            // onChanged: print,
                                            onChanged: (selectedvalue) {
                                              print(
                                                  "selected vehicle reg:$selectedvalue");
                                              provider.selectedtruckstr = selectedvalue.toString();


                                              //  }
                                            },
                                            selectedItem: provider.isEditTimesheet?provider.selectedtruckstr:"Select Vehicle Registration No"
                                        ),
                                      ),

                                      /*TextFormField(
                                      autocorrect: false,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: truckController,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            ThemeColor.themeLightWhiteColor,
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
                                      onSaved: (String? value) {
                                        _email = value;
                                      },
                                      validator: (input) => input!.isNotEmpty
                                          ? null
                                          : "Please enter truck no.",
                                    ),*/
                                      /*  DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              items: provider
                                                  .objgetalltrucktype.data
                                               //     .objgetalltrailertype.data
                                                  ?.map((itemone) {
                                                return new DropdownMenuItem(
                                                    child: Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          //item['truck_details'],    //Names that the api dropdown contains
                                                          itemone.truckDetails
                                                              .toString(),
                                                          style:
                                                          FillTimeSheetCustomTS
                                                              .tfTitleLabelTS,
                                                        )),
                                                    // value: item['CountryID'].toString()       //Id that has to be passed that the dropdown has.....
                                                    value: itemone.truckDetails
                                                        .toString()
                                                  //e.g   India (Name)    and   its   ID (55fgf5f6frf56f) somethimg like that....
                                                );
                                              }).toList(),
                                              onChanged: (String? strval) {
                                                //   Provider.value.trailerid = value.toString();
                                                Provider.of<Lttechprovider>(
                                                    context,
                                                    listen: false)
                                                    .onchangetrucktype(
                                                    strval.toString());
                                                provider.strtrucktype = strval!;
                                                print("truckid:" +
                                                    provider.strtrucktype);
                                                 },
                                              // value: trailerid,
                                              value: provider.strtrucktype),
                                        ))*/
                                      /*const Text(
                                    "Trailor",
                                    textAlign: TextAlign.left,
                                    style: FillTimeSheetCustomTS.tfTitleLabelTS,
                                  ),*/
                                      /* Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    child: TextFormField(
                                      autocorrect: false,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: trailorController,
                                      textInputAction: TextInputAction.done,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            ThemeColor.themeLightWhiteColor,
                                        isDense: true,
                                        // //contentPadding:
                                        //     const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                      onSaved: (String? value) {
                                        _email = value;
                                      },
                                      validator: (input) => input!.isNotEmpty
                                          ? null
                                          : "Please enter trailor no.",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),*/

                                      RichText(
                                        text: TextSpan(
                                            text: "Trailer",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                            children:  [
                                              TextSpan(
                                                  text: provider.isviewtimesheet?'':
                                                  provider.isEditTimesheet?'':
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ))
                                            ]),
                                      ),

                                      provider.isviewtimesheet?
                                      Container(child:Text(
                                          provider
                                              .arrdisplayselectedtrailer
                                              .join(" , "),
                                          style: TextStyle(
                                              color: ThemeColor
                                                  .themeGreenColor,
                                              fontSize: 14,
                                              fontFamily:
                                              'InterMedium'))):
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            color: ThemeColor
                                                .themeLightWhiteColor),
                                        width:
                                        MediaQuery.of(context).size.width,
                                        height: provider.isviewtimesheet?100:170,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          //   crossAxisAlignment: CrossAxisAlignment.center,
                                          children:
                                          [
                                            Flexible(
                                              child:
                                              ElevatedButton(
                                                  child: Text(
                                                      "Select Trailers",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily:
                                                          'InterMedium')),
                                                  onPressed: () =>

                                                      _showTrailerDialog(
                                                          context, provider)

                                              ),

                                            ),
                                            Text(
                                                provider
                                                    .arrdisplayselectedtrailer
                                                    .join(" , "),
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .themeGreenColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                    'InterMedium')),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),



                                      /*  Container(
                                            child:
                                            Column(
                                                children:[
                                                  provider.selectedindexidchecklisttype2==0?
                                                  createinitialfitnesschklist(context, "Add",provider):
                                                  createinitialfitnesschklist(context, "Pending Approval", provider),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  provider.slectedindexchecklisttype1==0?
                                                  createinitialvehiclechklist(context, "Add", provider):
                                                  createinitialvehiclechklist(context, "Pending Approval", provider)
                                                ]
                                            )
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),*/
                                      Container(
                                        height: 50,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
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
                                            final startOdometer = provider
                                                .startOdometerController
                                                .text
                                                .isNotEmpty
                                                ? int.parse(provider
                                                .startOdometerController
                                                .text)
                                                : 0;
                                            final endOdometer = provider
                                                .endOdometerController
                                                .text
                                                .isNotEmpty
                                                ? int.parse(provider
                                                .endOdometerController
                                                .text)
                                                : 0;


                                            if(provider.isviewtimesheet) {
                                              Provider.of<Lttechprovider>(
                                                  context,
                                                  listen: false)
                                                  .navigatetoJobdetail(
                                                  context);
                                            }

                                            //Edit Timesheet condition
                                            else if (provider.isEditTimesheet) {


                                              if(provider.endTimeController.text.isEmpty)
                                              {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Please Enter End Hour",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                    ThemeColor
                                                        .themeGreenColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                              else if (endOdometer==0) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Please Enter End Odometer",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                    ThemeColor
                                                        .themeGreenColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }

                                              else {
                                                var strthour = provider
                                                    .startTimeController.text
                                                    .split(":");
                                                var endhour = provider
                                                    .endTimeController.text
                                                    .split(":");


                                                if (int.parse(endhour[0]) <
                                                    int.parse(strthour[0])) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "End Hour Should be Greater then Start Hour",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                      ThemeColor
                                                          .themeGreenColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                } else if (endOdometer <=
                                                    startOdometer) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "End Odometer Should be Greater then Start Odometer",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                      ThemeColor
                                                          .themeGreenColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                                else {
                                                  print(
                                                      "pickupdate:${provider
                                                          .pickupdatefortimesheetjob}");

                                                  provider
                                                      .updatetimesheetrequestObj
                                                      .starttime =
                                                      provider
                                                          .startTimeController
                                                          .text
                                                          .trim();
                                                  provider
                                                      .updatetimesheetrequestObj
                                                      .endtime =
                                                      provider
                                                          .endTimeController
                                                          .text
                                                          .trim();

                                                  provider
                                                      .updatetimesheetrequestObj
                                                      .endodometer =
                                                      provider
                                                          .endOdometerController
                                                          .text
                                                          .trim();

                                                  print(
                                                      "update_endtime:${provider
                                                          .updatetimesheetrequestObj
                                                          .endtime}");
                                                  print(
                                                      "update_starttime:${provider
                                                          .updatetimesheetrequestObj
                                                          .starttime}");

                                                  Provider.of<Lttechprovider>(
                                                      context,
                                                      listen: false)
                                                      .navigatetoJobdetail(
                                                      context);
                                                }
                                              }
                                            }
                                            // create time sheet condition
                                            else {
                                              if (provider
                                                  .startOdometerController
                                                  .text
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Please Enter Start Odometer",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                    ThemeColor
                                                        .themeGreenColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else if (provider
                                                  .arrstrselectedtrailer!
                                                  .length ==
                                                  0) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Please Select a Trailer",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                    ThemeColor
                                                        .themeGreenColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                //Navigator.of(context).pushNamed(Routes.listtimesheet);
                                                print(
                                                    "timesheetdate:${provider.timesheetdateController.text}");
                                                print(
                                                    "startodo:${provider.startOdometerController.text}");
                                                print(
                                                    "starttime:${provider.startTimeController.text}");
                                                print(
                                                    "endodo:${provider.endOdometerController.text}");
                                                print(
                                                    "endtime:${provider.endTimeController.text}");

                                                provider.pickupdatefortimesheetjob =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(
                                                        DateTime.now());

                                                print(
                                                    "pickupdate:${provider.pickupdatefortimesheetjob}");
                                                //print("timesheetdatefordb:"+provider
                                                //  .addTimeSheetRequestObj
                                                //.timesheetdate);
                                                print(
                                                    "timesheetdatefordb:${DateTime.now().toIso8601String()}");

                                                provider.addTimeSheetRequestObj
                                                    .timesheetid =
                                                    provider.gettimesheetid();

                                                provider.addTimeSheetRequestObj
                                                    .companyid =
                                                    Environement.companyID;
                                                //  provider
                                                //    .addTimeSheetRequestObj
                                                //  .timesheetdate = DateTime
                                                // .now()
                                                // .toIso8601String();

                                                var dateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());

                                                print("timesheet_Date_z:"+dateFormatted.toString());
                                                provider.addTimeSheetRequestObj.timesheetdate = dateFormatted;


                                                provider.addTimeSheetRequestObj
                                                    .driverId =
                                                    Environement.driverID;

                                                provider.addTimeSheetRequestObj
                                                    .drivermobile =
                                                '9786565657';
                                                provider.addTimeSheetRequestObj
                                                    .starttime =
                                                    provider
                                                        .startTimeController
                                                        .text;

                                                if (provider.endTimeController
                                                    .text.isEmpty) {
                                                  provider
                                                      .addTimeSheetRequestObj
                                                      .endtime = "00:00:00";
                                                } else {
                                                  provider.addTimeSheetRequestObj
                                                      .endtime =
                                                      provider
                                                          .endTimeController
                                                          .text;
                                                }
                                                provider.addTimeSheetRequestObj
                                                    .startodometer =
                                                    provider
                                                        .startOdometerController
                                                        .text
                                                        .toString();

                                                provider.addTimeSheetRequestObj
                                                    .endodometer =
                                                    provider
                                                        .endOdometerController
                                                        .text
                                                        .toString();
                                                provider.addTimeSheetRequestObj.truck = provider.selectedtruckstr;
                                                print(
                                                    'FillTimeSheetRequestObj: ${provider.addTimeSheetRequestObj.toJson()}');

                                                /*provider.addTimeSheetRequestObj
                                                        .endtime =
                                                        provider.endTimeController.text
                                                            .toString();*/
                                                // provider.addTimeSheetRequestObj
                                                //   .endtime = "00:00:00";

                                                if(Environement.istimesheetcreated) {
                                                  Provider.of<Lttechprovider>(
                                                      context,
                                                      listen: false)
                                                      .navigatetoJobdetail(
                                                      context);
                                                }else {
                                                  Provider.of<Lttechprovider>(
                                                      context, listen: false)
                                                      .addTimeSheetApiRequest(
                                                      context);
                                                }
                                                /* Provider.of<Lttechprovider>(
                                                          context,
                                                          listen: false)
                                                      .navigatetoJobdetail(
                                                          context);*/
                                              }
                                            }
                                          },
                                          child:
                                          provider.isviewtimesheet?
                                          Text(
                                            'Next',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: FontName.interBold,
                                            ),
                                          ):
                                          Text(
                                            'Save & Next',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: FontName.interBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Provider.of<Lttechprovider>(
                                                context,
                                                listen: false)
                                                .navigatetodashboard(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.transparent,
                                            foregroundColor: ThemeColor
                                                .themeLightGrayColor,
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            'Skip',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                              FontName.interRegular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ))
                      ]),
                    ),
                  ]));
            })));
  }

/*
  List<truckData?> setinitialvalue(Lttechprovider val) {

    List<truckData?> arrvalue =[];
    for(int i=1;i<val.arrselectedtrailer.length;i++){
      arrvalue.add(val.arrselectedtrailer[i]);
    }

    return arrvalue;

  }*/
}

List<String> selectedReportList = [];

_showTrailerDialog(BuildContext context, Lttechprovider provider) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        //Here we will build the content of the dialog
        return AlertDialog(
          title: Text("Trailer",
              style: TextStyle(
                  color: ThemeColor.themeGreenColor,
                  fontSize: 14,
                  fontFamily: 'InterMedium')),
          content: MultiSelectChip(
            provider.arrtrailerreg,
            onSelectionChanged: (selectedList) {
              selectedReportList = selectedList;
              provider.notifyListeners();
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Confirm"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

/*
Widget createinitialfitnesschklist(BuildContext context, String message, Lttechprovider value) {

  return  Container(
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
*/

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
