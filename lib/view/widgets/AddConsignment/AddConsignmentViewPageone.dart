import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/entity/CustomerCompanyAddressResponse.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/Constant/endpoints.dart';
import 'package:lttechapp/utility/DateHelpers.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/StatefulWrapper.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:provider/provider.dart';

class AddConsignmentViewPageone extends StatelessWidget {
  AddConsignmentViewPageone({super.key});

  final _popupBuilderKey = GlobalKey<DropdownSearchState<String>>();

  final _formKey = GlobalKey<FormState>();
  int tag = 1;
  BuildContext? _context;
  //CustomCustomerBillingAddressDetail? customCustomerBillingAddressDetail;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _context = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoConsignmentJob(context);
      ApiCounter.consignmentgetcustomerallcounter = 0;
      return true;
    }

    return StatefulWrapper(
      onInit: () async {
        // Future.delayed(Duration.zero, () async {
        final provider = Provider.of<Lttechprovider>(context, listen: false);
        provider.selected_billing_address = "";
        await provider.getvehicletype('');
        provider.updateconsignmentDetailArr = [];
        provider.isconsignmentpageone = true;
        // provider.initiallistvalue = 0;
        if (provider.isConsignmentEdit) {
          //Call getConsignmentById APi
          //  Provider.of<Lttechprovider>(context, listen: false)
          //    .getAllCustomerRequest();

          if (ApiCounter.consignmentgetcustomerallcounter == 0) {
            // Provider.of<Lttechprovider>(context, listen: false)
            //   .getAllManifestRequest();
            await provider.getAllCustomerRequest();

            ApiCounter.consignmentgetcustomerallcounter =
                ApiCounter.consignmentgetcustomerallcounter + 1;
          }
          await provider.consignmentByIdRequest(
              provider.selectedConsignmentId, _context);
          // Provider.of<Lttechprovider>(context, listen: false)
          //  .getAllManifestRequest();

          provider.manifestNumberdropdownValue =
              provider.consignmentByIdresponse.data!.manifestNumber.toString();

          /*provider.getBillingCustomerNameByIdOnEdit(
                provider.billingCustomerid.toString());*/

          // ApiCounter.consignmentgetcustomerallcounter =
          //   ApiCounter.consignmentgetcustomerallcounter + 1;
        } else {
          provider.clearConsignmentText();

// Setting by default today date in booked date, user can change it.
          String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
          provider.bookedDateController.text =
              todayDate; // For by deafult showing booked date
          provider.consignmentbookdate = DateFormat('yyyy-MM-dd', 'en-US')
              .format(DateTime.now()); // For add APi

          provider.newConsignmentId = provider.getConsignmentJobId();
        }

        if (ApiCounter.consignmentgetcustomerallcounter == 0) {
          // Provider.of<Lttechprovider>(context, listen: false)
          //   .getAllManifestRequest();
          await provider.getAllCustomerRequest();

          ApiCounter.consignmentgetcustomerallcounter =
              ApiCounter.consignmentgetcustomerallcounter + 1;
        }
        // });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: commonAppBarforConsignment(
                "Step 1 of 6", 20, 80, context, '/ConsignmentJob'),
            body: Provider.of<Lttechprovider>(context, listen: false).isError
                ? Container(
                    child: Center(
                        child: Text("Some thing went wrong, Please try again",
                            style: TextStyle(
                                color: ThemeColor.themeGreenColor,
                                fontSize: 16,
                                fontFamily: 'InterMedium'))))
                : Consumer<Lttechprovider>(builder: (context, value, child) {
                    if (value.isConsignmentEdit) {
                      //Page 1
                      if (ApiCounter.consignmenteditcounterui == 0) {
                        print("counter:${ApiCounter.consignmenteditcounterui}");
                        /*value.jobNumberController.text =
                    value.consignmentByIdresponse.data!.jobNumber.toString();*/

                        print(
                            "JobNumber Edit:${value.jobNumberController.text}");
                        // DateTime? bookedEditDate = value.consignmentByIdresponse.data!
                        //   .bookedDate;

                        /*value.instructionController.text = value
                    .consignmentByIdresponse.data!.specialInstruction
                    .toString();*/

                        /* value.manifestController.text = value
                    .consignmentByIdresponse.data!.manifestNumber
                    .toString();*/

                        // //Page 4
                        // value.noOfItemControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].noOfItems.toString();
                        // value.palletsControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].pallets.toString();
                        // value.spacesControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].spaces.toString();
                        // value.weightControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].weight.toString();
                        // value.jobTempControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].jobTemp.toString();
                        // value.recipientRefNoControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].recipientNo.toString();
                        // value.senderRefNoControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].sendersNo.toString();
                        // value.equipmentControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].equipment.toString();
                        // value.freightDescriptionControllersArr[0].text=value.consignmentByIdresponse.data!.consignmentDetails[0].freightDesc.toString();

                        //Page 5
                        // value.arrcustomermenuItems.add("test");
                        ApiCounter.consignmenteditcounterui =
                            ApiCounter.consignmenteditcounterui + 1;
                      }
                    } /*else {
                value.clearConsignmentText();
              }*/
                    return Column(children: [
                      PreferredSize(
                          preferredSize: Size.square(1.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 0, top: 10, bottom: 20),
                                decoration: BoxDecoration(
                                    color: ThemeColor.themeGreenColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                width: width * 0.18,
                                height: 2.4,
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    left: 0, right: 20, top: 10, bottom: 20),
                                decoration: BoxDecoration(
                                    color: ThemeColor.themeLightGrayColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                width: width * 0.80,
                                height: 2.4,
                              ))
                            ],
                          )),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 20, top: 5, bottom: 27),
                        height: 29,
                        width: width,
                        child: value.isConsignmentEdit
                            ? Text(
                                "Edit Consignment",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontFamily: 'InterBold'),
                              )
                            : Text(
                                "Add New Consignment",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff000000),
                                    fontFamily: 'InterBold'),
                              ),
                      ),
                      value.isLoading || value.isError
                          ? Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 150.0),
                              child: CircularProgressIndicator(
                                backgroundColor: ThemeColor.themeLightGrayColor,
                                color: ThemeColor.themeGreenColor,
                              ))
                          : Expanded(
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
                                child: CustomScrollView(
                                  slivers: [
                                    SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 21,
                                                    bottom: 18),
                                                child: Text(
                                                  "Job Header",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff000000),
                                                      fontFamily: 'InterBold'),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 8,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "Job Number",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterRegular'),
                                                      children: const [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ]),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: ThemeColor
                                                              .themeLightGrayColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: ThemeColor
                                                          .themeGreyColor),
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 10,
                                                      right: 20,
                                                      top: 5),
                                                  child: value.isConsignmentEdit
                                                      ? TextFormField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'InterRegular'),
                                                          enabled: false,
                                                          initialValue: value
                                                              .jobNumberController
                                                              .text,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .only(
                                                                        start:
                                                                            10.0),
                                                          ),
                                                        )
                                                      : TextFormField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'InterRegular'),
                                                          enabled: false,
                                                          initialValue: value
                                                              .newConsignmentId,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .only(
                                                                        start:
                                                                            10.0),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "Booked Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterRegular'),
                                                      children: const [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 5, 19, 10),
                                                child: TextFormField(
                                                  autocorrect: false,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  controller: value
                                                      .bookedDateController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  readOnly: true,
                                                  //set it true, so that user will not able to edit text
                                                  onTap: () async {
                                                    DateTime? bookedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime
                                                          .now(), //DateTime(2100),
                                                    );

                                                    if (bookedDate != null) {
                                                      print(bookedDate);

                                                      String formattedDate =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  bookedDate);

                                                      String
                                                          formattedprocessbookDate =
                                                          //  DateFormat(
                                                          //    'yyyy-MM-ddTHH:mm:ssZ',
                                                          //  'en-US')
                                                          DateFormat(
                                                                  'yyyy-MM-dd',
                                                                  'en-US')
                                                              .format(
                                                                  bookedDate);
                                                      print(
                                                          formattedprocessbookDate);
                                                      value.bookedDateController
                                                              .text =
                                                          formattedDate; //set output date to TextField value.

                                                      print(
                                                          "formattedbooktime: $formattedprocessbookDate"
                                                          //"Z");
                                                          );
                                                      value.consignmentbookdate =
                                                          formattedprocessbookDate;
                                                      //+//"Z";
                                                    } else {}
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    filled: true,
                                                    fillColor: ThemeColor
                                                        .themeLightWhiteColor,
                                                    isDense: true,
                                                    //contentPadding:
                                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                    suffixIconColor:
                                                        Colors.grey,
                                                  ),
                                                  onSaved: (String? value) {},
                                                  validator: (input) => input!
                                                          .isNotEmpty
                                                      ? null
                                                      : "This Field is required",
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "Pickup Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterRegular'),
                                                      children: const [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 5, 19, 10),
                                                child: TextFormField(
                                                  autocorrect: false,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  controller: value
                                                      .pickUpDateController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  readOnly: true,
                                                  //set it true, so that user will not able to edit text
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime.now()
                                                          .add(Duration(
                                                              days:
                                                                  1)), //DateTime(2100),
                                                    );

                                                    if (pickedDate != null) {
                                                      print(pickedDate);

                                                      String formattedpickDate =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  pickedDate);

                                                      String
                                                          formattedprocesspickDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              //'THH:mm:ssZ',
                                                              //'en-US')
                                                              .format(
                                                                  pickedDate);
                                                      print(
                                                          formattedprocesspickDate);
                                                      value.pickUpDateController
                                                              .text =
                                                          formattedpickDate; //set output date to TextField value.

                                                      print(
                                                          "formattedpicktime: $formattedprocesspickDate");
                                                      //+
                                                      //"Z");
                                                      value.consignmentpickupdate =
                                                          formattedprocesspickDate;
                                                      //+
                                                      //"Z";
                                                    } else {}
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    filled: true,
                                                    fillColor: ThemeColor
                                                        .themeLightWhiteColor,
                                                    isDense: true,
                                                    //contentPadding:
                                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                    suffixIconColor:
                                                        Colors.grey,
                                                  ),
                                                  onSaved: (String? value) {},
                                                  validator: (input) => input!
                                                          .isNotEmpty
                                                      ? null
                                                      : "This Field is required",
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "Delivery Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterRegular'),
                                                      children: const [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 5, 19, 10),
                                                child: TextFormField(
                                                  autocorrect: false,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  controller: value
                                                      .deliveryDateController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  readOnly: true,
                                                  //set it true, so that user will not able to edit text
                                                  onTap: () async {
                                                    DateTime? deliveryDate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 1)),
                                                            firstDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days:
                                                                        1)), // DateTime.now(),
                                                            //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2100));

                                                    if (deliveryDate != null) {
                                                      print(deliveryDate);

                                                      String
                                                          formatteddeliveryDate =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  deliveryDate);

                                                      String
                                                          formattedprocessdeliveryDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              //'THH:mm:ssZ',
                                                              //'en-US')
                                                              .format(
                                                                  deliveryDate);
                                                      print(
                                                          formattedprocessdeliveryDate);
                                                      value.deliveryDateController
                                                              .text =
                                                          formatteddeliveryDate; //set output date to TextField value.

                                                      print(
                                                          "formattedpicktime: $formattedprocessdeliveryDate");
                                                      //+
                                                      //"Z");
                                                      value.consignmentdeliverydate =
                                                          formattedprocessdeliveryDate;
                                                      //+
                                                      //"Z";
                                                    } else {}
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    filled: true,
                                                    fillColor: ThemeColor
                                                        .themeLightWhiteColor,
                                                    isDense: true,
                                                    //contentPadding:
                                                    // const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                    suffixIconColor:
                                                        Colors.grey,
                                                  ),
                                                  onSaved: (String? value) {},
                                                  validator: (input) => input!
                                                          .isNotEmpty
                                                      ? null
                                                      : "This Field is required",
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: "Special Instruction",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        18, 5, 19, 10),
                                                child: TextFormField(
                                                  autocorrect: false,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: value
                                                      .instructionController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      const InputDecoration(
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
                                                  onSaved: (String? v) {},
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: Text(
                                                  "Manifest Number",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff666666),
                                                      fontFamily:
                                                          'InterRegular'),
                                                ),
                                              ),
                                              // Flexible(
                                              //   child: Container(
                                              //     height: 50,
                                              //     decoration: BoxDecoration(
                                              //         border: Border.all(
                                              //             color: ThemeColor
                                              //                 .themeLightGrayColor),
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 5),
                                              //         color: ThemeColor
                                              //             .themeLightWhiteColor),
                                              //     margin: EdgeInsets.only(
                                              //         left: 20,
                                              //         bottom: 10,
                                              //         right: 20,
                                              //         top: 5),
                                              //     alignment: Alignment.topLeft,
                                              //     child:
                                              //         DropdownButtonHideUnderline(
                                              //       child: DropdownButton(
                                              //         isExpanded: true,
                                              //         items: value
                                              //             .objgetallmanifestlist
                                              //             .data!
                                              //             .rows
                                              //             .map((item) {
                                              //           return DropdownMenuItem(
                                              //               value: item
                                              //                   .manifestNumber
                                              //                   .toString(),
                                              //               child: Container(
                                              //                   padding: EdgeInsets
                                              //                       .only(
                                              //                           left:
                                              //                               10),
                                              //                   alignment: Alignment
                                              //                       .centerLeft,
                                              //                   child: Text(
                                              //                     //Names that the api dropdown contains
                                              //                     item.manifestNumber
                                              //                         .toString(),
                                              //                     style: FillTimeSheetCustomTS
                                              //                         .tfTitleLabelTS,
                                              //                   ))
                                              //               //e.g   India (Name)    and   its   ID (55fgf5f6frf56f) somethimg like that....
                                              //               );
                                              //         }).toList(),
                                              //         onChanged:
                                              //             (String? strval) {
                                              //           value.manifestNumberdropdownValue =
                                              //               strval.toString();
                                              //           Provider.of<Lttechprovider>(
                                              //                   context,
                                              //                   listen: false)
                                              //               .onchangeManifestNumber(
                                              //                   strval
                                              //                       .toString());
                                              //         },
                                              //         hint: value
                                              //                 .manifestNumberdropdownValue
                                              //                 .isEmpty
                                              //             ? Text("")
                                              //             : Text(value
                                              //                 .manifestNumberdropdownValue),
                                              //         value: value
                                              //                 .manifestNumberdropdownValue
                                              //                 .isEmpty
                                              //             ? null
                                              //             : value
                                              //                 .manifestNumberdropdownValue,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),

                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                height: 50,
                                                // decoration: BoxDecoration(
                                                //     border: Border.all(
                                                //         color: ThemeColor
                                                //             .themeDarkGreyColor),
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             5),
                                                //     color: ThemeColor
                                                //         .themeLightWhiteColor),
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    bottom: 10,
                                                    right: 20,
                                                    top: 5),
                                                alignment: Alignment.topLeft,
                                                child: value.isConsignmentEdit &&
                                                        value
                                                            .manifestNumberdropdownValue
                                                            .isNotEmpty &&
                                                        value.manifestNumberdropdownValue !=
                                                            'null'
                                                    ? Container(
                                                        padding: EdgeInsets.only(
                                                            left: 10),
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: ThemeColor
                                                                    .themeDarkGreyColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: ThemeColor
                                                                .themeLightWhiteColor),
                                                        // margin: EdgeInsets.only(
                                                        //     left: 10,
                                                        //     bottom: 10,
                                                        //     right: 20,
                                                        //     top: 5),
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(value.manifestNumberdropdownValue))
                                                    : DropdownSearch<String>(
                                                        clearButtonProps:
                                                            ClearButtonProps(
                                                                isVisible: value
                                                                            .manifestNumberdropdownValue
                                                                            .isNotEmpty &&
                                                                        value.manifestNumberdropdownValue !=
                                                                            'null'
                                                                    ? true
                                                                    : false,
                                                                onPressed: () {
                                                                  value.manifestNumberdropdownValue =
                                                                      '';
                                                                  print(
                                                                      ' value.manifestNumberdropdownValue:${value.manifestNumberdropdownValue}');
                                                                  value.setUpdateView =
                                                                      true;
                                                                }),
                                                        popupProps:
                                                            PopupProps.menu(
                                                          //modalBottomSheet
                                                          fit: FlexFit.loose,
                                                          showSearchBox: value
                                                                  .objgetallmanifestlist
                                                                  .data!
                                                                  .rows
                                                                  .length >
                                                              3,
                                                          showSelectedItems:
                                                              true,
                                                          searchDelay:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1),
                                                          searchFieldProps:
                                                              const TextFieldProps(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Search Manifest Number",
                                                            ),
                                                          ),
                                                          // disabledItemFn: (String s) =>
                                                          //     s.startsWith('I'),
                                                        ),
                                                        items: value
                                                            .objgetallmanifestlist
                                                            .data!
                                                            .rows
                                                            .map((e) => e
                                                                .manifestNumber
                                                                .toString())
                                                            .toList(),

                                                        // onChanged: print,
                                                        onChanged:
                                                            (selectedvalue) {
                                                          selectedvalue ??= '';

                                                          print(
                                                              "selectedvalue:$selectedvalue");
                                                          value.manifestNumberdropdownValue =
                                                              selectedvalue
                                                                  .toString();

                                                          Provider.of<Lttechprovider>(
                                                                  context,
                                                                  listen: false)
                                                              .onchangeManifestNumber(
                                                                  selectedvalue
                                                                      .toString());
                                                        },
                                                        selectedItem: value
                                                                    .manifestNumberdropdownValue !=
                                                                'null'
                                                            ? value
                                                                .manifestNumberdropdownValue
                                                            : "",
                                                      ),
                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: "Billing Customer",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff666666),
                                                        fontFamily:
                                                            'InterRegular'),
                                                    children: const [
                                                      TextSpan(
                                                          text: ' *',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                height: 50,
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    bottom: 10,
                                                    right: 20,
                                                    top: 5),
                                                alignment: Alignment.topLeft,
                                                child: DropdownSearch<String>(
                                                  validator: (v) => v == null
                                                      ? "required field"
                                                      : null,
                                                  // clearButtonProps:
                                                  //     ClearButtonProps(
                                                  //         isVisible: value
                                                  //                 .selectedBillingCustomer
                                                  //                 .isNotEmpty
                                                  //             ? true
                                                  //             : false,
                                                  //         onPressed: () {
                                                  //           value.selectedBillingCustomer =
                                                  //               '';
                                                  //           print(
                                                  //               ' value.selectedBillingCustomer:${value.selectedBillingCustomer}');
                                                  //           value.setUpdateView =
                                                  //               true;
                                                  //         }),
                                                  popupProps: PopupProps.menu(
                                                    //modalBottomSheet
                                                    fit: FlexFit.loose,
                                                    showSearchBox: value
                                                            .arrcustomermenuItems
                                                            .length >
                                                        3,
                                                    showSelectedItems: true,
                                                    searchDelay: const Duration(
                                                        milliseconds: 1),
                                                    searchFieldProps:
                                                        const TextFieldProps(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Select Billing Customer",
                                                        labelText:
                                                            "Search Billing Customer",
                                                        filled: true,
                                                      ),
                                                    ),
                                                    // disabledItemFn: (String s) =>
                                                    //     s.startsWith('I'),
                                                  ),
                                                  items: value
                                                      .arrcustomermenuItems,

                                                  // onChanged: print,
                                                  onChanged: (selectedvalue) {
                                                    // _popupBuilderKey
                                                    //     .currentState
                                                    //     ?.clear();

                                                    clearSelectedBillingAddress(
                                                        value);

                                                    print(selectedvalue);
                                                    selectedvalue ??=
                                                        ''; // if null than assign '';

                                                    value.selectedBillingCustomer =
                                                        selectedvalue
                                                            .toString();
                                                    final selectedvalueindex = value
                                                        .arrcustomermenuItems
                                                        .indexWhere((element) =>
                                                            element ==
                                                            value
                                                                .selectedBillingCustomer);

                                                    if (selectedvalueindex >
                                                        -1) {
                                                      value.onchangeBillingCustomer(
                                                          selectedvalueindex);
                                                    }
                                                  },
                                                  selectedItem:
                                                      // value
                                                      //         .isConsignmentEdit
                                                      //     ? value
                                                      //         .editCustomerBillingName
                                                      //         .toString()
                                                      // :
                                                      value
                                                          .selectedBillingCustomer,
                                                ),
                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    top: 18,
                                                    bottom: 7),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: "Billing Address",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterRegular'),
                                                      children: const [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                      ]),
                                                ),
                                              ),

                                              Flexible(
                                                  child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ThemeColor
                                                                  .themeLightGrayColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: ThemeColor
                                                              .themeLightWhiteColor),
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          bottom: 10,
                                                          right: 20,
                                                          top: 5),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child:
                                                          /*getCustomerAddressList(
                                                    value)*/
                                                          value
                                                                  .isConsignmentEdit
                                                              ? value.arrcustomercompanyaddressstr
                                                                      .isEmpty
                                                                  ? Container()
                                                                  : DropdownSearch<
                                                                          String>(
                                                                      key:
                                                                          _popupBuilderKey,
                                                                      popupProps:
                                                                          PopupProps
                                                                              .menu(
                                                                        //modalBottomSheet
                                                                        fit: FlexFit
                                                                            .loose,
                                                                        showSearchBox:
                                                                            value.arrcustomercompanyaddressstr.length >
                                                                                3,

                                                                        showSelectedItems:
                                                                            true,
                                                                        searchDelay:
                                                                            const Duration(milliseconds: 1),
                                                                        searchFieldProps:
                                                                            const TextFieldProps(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                "Search Billing Address",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      items: value
                                                                          .arrcustomercompanyaddressstr,

                                                                      // onChanged: print,
                                                                      onChanged:
                                                                          (selectedvalue) {
                                                                        print(
                                                                            "selected address:$selectedvalue");
                                                                        if (selectedvalue !=
                                                                            "Select Billing Address") {
                                                                          value.selected_billing_address =
                                                                              selectedvalue.toString();
                                                                          final selectedvalueindex = value.arrcustomercompanyaddress.indexWhere((element) =>
                                                                              element.custvalue ==
                                                                              value.selected_billing_address);

                                                                          print(
                                                                              "selected_Value_index:$selectedvalueindex");
                                                                          print(
                                                                              "billing_Address_id:${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}");
                                                                          print(
                                                                              "cust value:${value.arrcustomercompanyaddress[selectedvalueindex].custvalue}");
                                                                          print(
                                                                              "id_to_pass_to_api:${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}_${value.arrcustomercompanyaddress[selectedvalueindex].address}");
                                                                          // value.billingCustomerid = value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId.toString()+"_"+value.arrcustomercompanyaddress[selectedvalueindex].address.toString();
                                                                          value.billingaddressid =
                                                                              "${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}_${value.arrcustomercompanyaddress[selectedvalueindex].address}";
                                                                        }
                                                                      },
                                                                      selectedItem: value
                                                                              .isConsignmentEdit
                                                                          ?
                                                                          //value
                                                                          //      .editCustomerBillingName
                                                                          //    .toString()
                                                                          //value.selectedPickupCustomerName
                                                                          //  .isEmpty
                                                                          value.selected_billing_address
                                                                          : "Please select a billing Address"
                                                                      // ? "Please select a name"
                                                                      //: value
                                                                      //   .selectedPickupCustomerName,
                                                                      )

                                                              /*ChipsChoice<
                                                                      int>.single(
                                                                      value: value
                                                                          .selectedcustomerbillingaddressid,
                                                                      /* options: ChipsChoiceOption.listFrom<int, String>(
                                                    source: options,
                                                    value: (i, v) => i,
                                                    label: (i, v) => v,
                                                  ),*/
                                                                      choiceItems: C2Choice.listFrom(
                                                                          source: value
                                                                              .arrcustomercompanyaddressstr,
                                                                          value: (i, v) =>
                                                                              i,
                                                                          label: (i, v) =>
                                                                              v),
                                                                      onChanged:
                                                                          (val) {
                                                                        //String
                                                                        // value.onchangeBillingCustomer(
                                                                        //     val);
                                                                        print(
                                                                            "selectedcustomerbillingaddressid:${value.selectedcustomerbillingaddressid}");
                                                                        print(
                                                                            "billingcustomer");
                                                                        ApiCounter
                                                                            .consignmentbillingaddress = 0;
                                                                        // value
                                                                        //     .notifyListeners();
                                                                        value.setUpdateView =
                                                                            true;
                                                                      },
                                                                    )*/
                                                              : value.maincustomerid.isNotEmpty
                                                                  ?
                                                                  //ApiCounter.consignmentbillingaddress == 0
                                                                  //     ?
                                                                  getCustomerbillingAddresslist(value)
                                                                  : Container()
                                                      // : Container(),
                                                      )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 18,
                                                    bottom: 45,
                                                    right: 19,
                                                    top: 30),
                                                height: 46,
                                                width: 353,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed)) {
                                                            return Color(
                                                                0xff8d8d8d12);
                                                          }
                                                          return ThemeColor
                                                              .themeGreenColor;
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _formKey.currentState!
                                                            .save();
                                                        print(
                                                            "AddConsignmentPageOne JobNumber:${value.jobNumberController.text}");
                                                        print(
                                                            "AddConsignmentPageOne BookedDate:${value.bookedDateController.text}");
                                                        print(
                                                            "AddConsignmentPageOne PickUpDate:${value.pickUpDateController.text}");
                                                        print(
                                                            "AddConsignmentPageOne DeliveryDate:${value.deliveryDateController.text}");
                                                        print(
                                                            "AddConsignmentPageOne SpecialInstruction:${value.instructionController.text}");
                                                        print(
                                                            "AddConsignmentPageOne ManifestNumber:${value.manifestNumberdropdownValue}");
                                                        print(
                                                            "AddConsignmentPageOne Billing Customer Name:${value.billingcustomerdropdownValue}");
                                                        print(
                                                            "AddConsignmentPageOne Billing Address:${value.billingcustomerAddressdropdownValue}");
                                                        print(
                                                            "AddConsignmentPageOne Billing Address id:${value.selectedcustomerid}");

                                                        if ((value
                                                                .selectedBillingCustomer)
                                                            .isEmpty) {
                                                          value.showCommonToast(
                                                              "Please select billing customer");
                                                        } else if (value
                                                            .selected_billing_address
                                                            .isEmpty) {
                                                          value.showCommonToast(
                                                              "Please select billing address");
                                                        } else {
                                                          value
                                                              .navigatetoAddConsignmentTwo(
                                                                  context);
                                                        }

                                                        // Provider.of<Lttechprovider>(
                                                        //         context,
                                                        //         listen: false)
                                                        //     .navigatetoAddConsignmentTwo(
                                                        //         context);
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Next",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'InterBold',
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                    ]);
                  })),
      ),
    );
  }

  clearSelectedBillingAddress(Lttechprovider value) {
    value.billingaddressid = "";
    value.selected_billing_address = "";
    _popupBuilderKey.currentState?.changeSelectedItem(
        "Select Billing Address"); // Changing placeholder text of billing addrss dropdown selection
  }

  /*dynamic Widget to get customer billing address as per customer id  */

  Widget getCustomerbillingAddresslist(Lttechprovider value) {
    try {
      print("arrlen:${value.arrcustomercompanyaddress.length}");
      print("return_customerid:${value.maincustomerid}");

      List<CustomCustomerBillingAddressDetail> arrcustomeraddresslistbycustid =
          value.arrcustomercompanyaddress
              .where((element) => element.customerId == value.maincustomerid)
              .toList();
      print(
          "selected_arrcustomercompanyaddress:${arrcustomeraddresslistbycustid.length}");

      value.billingCustomerid = value.maincustomerid;
      // ApiCounter.consignmentbillingaddress =  ApiCounter.consignmentbillingaddress+1;
      return
          // value.selected_billing_address.isEmpty
          //     ? Container(
          //         padding: EdgeInsets.only(left: 10),
          //         alignment: Alignment.centerLeft,
          //         child: Text(""),
          //       )
          //     :
          Container(
        padding: EdgeInsets.only(left: 10),
        // height: 50,
        // margin: EdgeInsets.only(left: 10, bottom: 10, right: 20, top: 5),
        // alignment: Alignment.topLeft,
        child: DropdownSearch<String>(
            key: _popupBuilderKey,
            validator: (v) => v == null ? "required field" : null,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(),
            ),
            popupProps: PopupProps.menu(
              fit: FlexFit.loose,
              showSearchBox: value.arrcustomercompanyaddressstr.length > 3,
              showSelectedItems: true,
              searchDelay: const Duration(milliseconds: 1),
              searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                  labelText: "Search Billing Address",
                  filled: true,
                ),
              ),
            ),
            items: value.arrcustomercompanyaddressstr,
            onChanged: (selectedvalue) {
              print(selectedvalue);
              selectedvalue ??= ''; // if null than assign '';

              if (selectedvalue != "Select Billing Address") {
                value.selected_billing_address = selectedvalue.toString();
                final selectedvalueindex = value.arrcustomercompanyaddress
                    .indexWhere((element) =>
                        element.custvalue == value.selected_billing_address);

                print("selected_Value_index:$selectedvalueindex");
                print(
                    "billing_Address_id:${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}");
                print(
                    "cust value:${value.arrcustomercompanyaddress[selectedvalueindex].custvalue}");
                print(
                    "id_to_pass_to_api:${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}_${value.arrcustomercompanyaddress[selectedvalueindex].address}");
                // value.billingCustomerid = value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId.toString()+"_"+value.arrcustomercompanyaddress[selectedvalueindex].address.toString();
                value.billingaddressid =
                    "${value.arrcustomercompanyaddress[selectedvalueindex].customerBillingId}_${value.arrcustomercompanyaddress[selectedvalueindex].address}";
              }
            },
            selectedItem: value.selected_billing_address.isEmpty
                ? "Select Billing Address"
                : value.selected_billing_address),
      );
    } catch (e) {
      print("AddConsignmentViewPageone_getCustomerAddressList $e");
      rethrow;
    }
  }

  /*dynamic widget to get customer address as per customer id*/
  /* Widget getCustomerAddressList(Lttechprovider value) {
    try {
      print("arrlen:${value.arrcustomercompanyaddress.length}");
      print("return_customerid:${value.maincustomerid}");
      List<CustomCustomerBillingAddressDetail> arrcustomeraddresslistbycustid =
      value.arrcustomercompanyaddress
          .where((element) => element.customerId == value.maincustomerid)
          .toList();
      return Autocomplete<CustomCustomerBillingAddressDetail>(
          initialValue: TextEditingValue(text: value.selected_billing_address),
          optionsBuilder: (TextEditingValue textEditingValue) {
            return arrcustomeraddresslistbycustid
                .where((CustomCustomerBillingAddressDetail pcr) => pcr.address
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
                .toList();
          },
          displayStringForOption: (CustomCustomerBillingAddressDetail option) =>
              option.custvalue.toString(),
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return Container(
              margin: EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                style: FillTimeSheetCustomTS.tfTitleLabelTS,
                onTap: () {},
              ),
            );
          },
          onSelected: (CustomCustomerBillingAddressDetail selection) {
            print('Selected: ${selection.custvalue}');
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<CustomCustomerBillingAddressDetail>
              onSelected,
              Iterable<CustomCustomerBillingAddressDetail> options) {
            return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  child: Card(
                    elevation: 5,
                    child: Container(
                        width: 340,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final CustomCustomerBillingAddressDetail option =
                              options.elementAt(index);

                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        option.custvalue.toString(),
                                        style: FillTimeSheetCustomTS
                                            .tfTitleLabelTS,
                                      )),
                                ),
                              );
                            })),
                  ),
                ));
          });

      //   DropdownButtonHideUnderline(
      //     child: DropdownButton(
      //   isExpanded: true,
      //
      //   // hint: customCustomerBillingAddressDetail == null
      //   //     ? Text(" Select Billing Address",style: FillTimeSheetCustomTS.tfTitleLabelTS,)
      //   //     : Text(customCustomerBillingAddressDetail
      //   //     ?.custvalue ??
      //   //     ""),
      //   items: arrcustomeraddresslistbycustid.map((objAddress) {
      //     return DropdownMenuItem(
      //       //    value:"${objAddress.customerName} - ${objAddress.address}",
      //       value: "${objAddress.custvalue}",
      //       child: Container(
      //         padding: EdgeInsets.only(left: 10),
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           //   "${objAddress.customerName} - ${objAddress.address}",
      //           "${objAddress.custvalue}",
      //           style: FillTimeSheetCustomTS.tfTitleLabelTS,
      //         ),
      //       ),
      //     );
      //   }).toList(),
      //   onChanged: (val) {
      //     value.billingcustomerAddressdropdownValue = val.toString();
      //     // Provider.of<Lttechprovider>(context, listen: false)
      //     //   .onchangeBillingAddress(val.toString());
      //     print("Selected billing address is $val");
      //   },
      //   value: value.billingcustomerAddressdropdownValue,
      // ));
    } catch (e) {
      print("AddConsignmentViewPageone_getCustomerAddressList $e");
      rethrow;
    }
  }*/
}
