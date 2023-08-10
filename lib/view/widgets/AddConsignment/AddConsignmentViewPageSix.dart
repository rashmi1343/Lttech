import 'dart:async';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/entity/ApiRequests/AddConsignmentRequest.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../entity/ApiRequests/UpdateConsignmentrequest.dart';
import '../../../entity/trucktyperesponse.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/PDFViewerFromUrl.dart';
import '../../../utility/StatefulWrapper.dart';

String getFileName(String _path) {
  String fileName = path.basename(_path);
  print("fileName:$fileName");

  return fileName;
}

class AddConsignmentViewPageSix extends StatelessWidget {
  AddConsignmentViewPageSix({super.key});

  final _formKey = GlobalKey<FormState>();
  List<TruckData> vehicleTypeArr = [];
  String docUrl = '';
  String fileName = '';

  String fileext = path.split('/').last;

  setVehicleTypeDropDown(BuildContext context) {
    final provider = Provider.of<Lttechprovider>(context, listen: false);

    // final vehicleTypeArr = provider.vehicleTypeArr;

    print(vehicleTypeArr.map((e) => e.truckDetails));

    print(provider.vehicleDropdownSelectedValue?.truckDetails);

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      height: 50,
      alignment: Alignment.topLeft,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          //modalBottomSheet
          fit: FlexFit.loose,
          // showSearchBox: true,
          showSelectedItems: true,
          // searchDelay: const Duration(milliseconds: 1),
          // searchFieldProps: const TextFieldProps(
          //   decoration: InputDecoration(
          //     labelText: "Truck Type",
          //   ),
          // ),
        ),
        items: vehicleTypeArr.map((e) => e.truckDetails.toString()).toList(),

        // onChanged: print,
        onChanged: (selectedvalue) {
          final selectedvalueindex = vehicleTypeArr
              .indexWhere((element) => element.truckDetails == selectedvalue);

          provider.vehicleDropdownSelectedValue =
              vehicleTypeArr[selectedvalueindex];

          provider.updatetimesheetrequestObj.truck =
              provider.vehicleDropdownSelectedValue?.truckId.toString();
          print(provider.updatetimesheetrequestObj.truck.toString());
        },
        selectedItem:
            provider.vehicleDropdownSelectedValue?.truckDetails != null
                ? provider.vehicleDropdownSelectedValue?.truckDetails.toString()
                : "Please select vehicle type",
      ),
    );
    // return Container(
    //   height: 50,
    //   width: MediaQuery.of(context).size.width,
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Color(0xffD4D4D4),
    //     ),
    //     borderRadius: BorderRadius.all(Radius.circular(5)),
    //     color: Color(0xffFAFAFA),
    //   ),
    //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    //   margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
    //   child: vehicleTypeArr.isNotEmpty
    //       ? DropdownButton(
    //           isExpanded: true,
    //           value: provider.vehicleDropdownSelectedValue,
    //           hint: provider.vehicleDropdownSelectedValue == null
    //               ? Text("Select Vehicle Type")
    //               : Text(provider.vehicleDropdownSelectedValue?.truckDetails ??
    //                   ""),
    //           // Down Arrow Icon
    //           icon: const Icon(Icons.keyboard_arrow_down),
    //           underline: SizedBox(),
    //           items: vehicleTypeArr.map((vehicle) {
    //             return DropdownMenuItem<TruckData>(
    //               value: vehicle,
    //               child: Text(
    //                 vehicle.truckDetails ?? "",
    //                 style: TextStyle(
    //                     fontSize: 15,
    //                     color: Colors.black,
    //                     height: 1,
    //                     fontFamily: FontName.interRegular),
    //               ), //value of item
    //             );
    //           }).toList(),
    //           onChanged: (value) {
    //             provider.vehicleDropdownSelectedValue = value;
    //             print(
    //                 provider.vehicleDropdownSelectedValue?.truckDetails ?? "");
    //             provider.setUpdateView = true;
    //           },
    //         )
    //       : SizedBox(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoAddConsignmentFive(context);

      return true;
    }

    return StatefulWrapper(
        onInit: () {
          final value = Provider.of<Lttechprovider>(context, listen: false);
          vehicleTypeArr = value.vehicleTypeArr;

          if (value.isConsignmentEdit) {
            if (value.consignmentByIdresponse.data!.truckDetails.isNotEmpty) {
              final truckDetails =
                  value.consignmentByIdresponse.data!.truckDetails[0];

              docUrl = truckDetails.document
                  .toString(); // Getting already uploaded doc url in edit

              fileName =
                  docUrl.split(Platform.pathSeparator).last; // my_image.jpg

              print("docUrl:$docUrl");
              value.truckNumberController.text =
                  truckDetails.truckNumber.toString();

              var truckDataObj = TruckData();

              final selectedvalueindex = vehicleTypeArr.indexWhere(
                  (element) => element.truckId == truckDetails.truckType);
              truckDataObj.truckDetails = selectedvalueindex > -1
                  ? vehicleTypeArr[selectedvalueindex].truckDetails
                  : "Please select vehicle type";

              value.vehicleDropdownSelectedValue = truckDataObj;
            }
          } else {
            value.vehicleDropdownSelectedValue = null;
          }
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              appBar: commonAppBarforConsignment("Step 6 of 6", 60, 60, context,
                  '/AddConsignmentViewPagefive'),
              body: Consumer<Lttechprovider>(builder: (context, value, child) {
                //Page 6

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PreferredSize(
                      preferredSize: Size.square(1.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 0, top: 10, bottom: 20),
                            width: width * 0.9,
                            height: 2.4,
                            decoration: BoxDecoration(
                                color: ThemeColor.themeGreenColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ],
                      ),
                    ),
                    value.isConsignmentEdit
                        ? Container(
                            margin: const EdgeInsets.only(
                                left: 20, top: 5, bottom: 27),
                            height: 29,
                            width: width,
                            child: Text(
                              "Edit Consignment",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff000000),
                                  fontFamily: 'InterBold'),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                                left: 20, top: 5, bottom: 27),
                            height: 29,
                            width: width,
                            child: Text(
                              "Add New Consignment",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff000000),
                                  fontFamily: 'InterBold'),
                            ),
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
                              padding: const EdgeInsets.all(20),
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
                                            child: const Text(
                                              "Document",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontFamily: FontName.interBold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 15, bottom: 5),
                                            child: RichText(
                                              text: TextSpan(
                                                text: "Vehicle Type",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff666666),
                                                    fontFamily: 'InterRegular'),
                                                // children: const [
                                                //   TextSpan(
                                                //       text: ' *',
                                                //       style: TextStyle(
                                                //         color: Colors.red,
                                                //         fontSize: 14,
                                                //         fontWeight: FontWeight.w500,
                                                //       ))
                                                // ]
                                              ),
                                            ),
                                          ),
                                          setVehicleTypeDropDown(context),
                                          // Flexible(
                                          //     child: Container(
                                          //   height: 50,
                                          //   decoration: BoxDecoration(
                                          //       border: Border.all(
                                          //           color: ThemeColor
                                          //               .themeLightGrayColor),
                                          //       borderRadius:
                                          //           BorderRadius.circular(5),
                                          //       color: ThemeColor
                                          //           .themeLightWhiteColor),
                                          //   margin: EdgeInsets.only(
                                          //       bottom: 10, top: 5),
                                          //   alignment: Alignment.topLeft,
                                          //   child:
                                          //   DropdownButtonHideUnderline(
                                          //     child: DropdownButton(
                                          //         isExpanded: true,
                                          //         items: value.vehicleTypeArr
                                          //             // value
                                          //             //     .objgetalltrucktype
                                          //             //     .data?
                                          //             .map((item) {
                                          //           return DropdownMenuItem(
                                          //               value: item.truckDetails
                                          //                   .toString(),
                                          //               child: Padding(
                                          //                   padding:
                                          //                       EdgeInsets.only(
                                          //                           left: 10),
                                          //                   child: Text(
                                          //                     //item['truck_details'],    //Names that the api dropdown contains
                                          //                     item.truckDetails
                                          //                         .toString(),
                                          //                     style: FillTimeSheetCustomTS
                                          //                         .tfTitleLabelTS,
                                          //                   ))
                                          //               //e.g   India (Name)    and   its   ID (55fgf5f6frf56f) somethimg like that....
                                          //               );
                                          //         }).toList(),
                                          //         onChanged: (String? strval) {
                                          //           print(strval);
                                          //           //   Provider.value.trailerid = value.toString();
                                          //           Provider.of<Lttechprovider>(
                                          //                   context,
                                          //                   listen: false)
                                          //               .onchangetrucktype(
                                          //                   strval.toString());
                                          //           //value.trailerid = strval!;
                                          //           print(
                                          //               "truckid:${value.strtrucktype}");
                                          //         },
                                          //         // value: trailerid,
                                          //         hint: value
                                          //                 .strtrucktype.isEmpty
                                          //             ? Text(
                                          //                 "\tSelect vehicle type")
                                          //             : Text(
                                          //                 value.strtrucktype),
                                          //         value:
                                          //             value.strtrucktype.isEmpty
                                          //                 ? null
                                          //                 : value.strtrucktype),
                                          //   ),
                                          // )),
                                          RichText(
                                            text: TextSpan(
                                              text: "Vehicle Number",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff666666),
                                                  fontFamily: 'InterRegular'),
                                              // children: const [
                                              //   TextSpan(
                                              //       text: ' *',
                                              //       style: TextStyle(
                                              //         color: Colors.red,
                                              //         fontSize: 14,
                                              //         fontWeight: FontWeight.w500,
                                              //       ))
                                              // ]
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 15),
                                            child: TextFormField(
                                              autocorrect: false,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller:
                                                  value.truckNumberController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
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
                                              ),
                                              onSaved: (String? value) {},
                                              // validator: (input) => input!.isNotEmpty
                                              //     ? null
                                              //     : "PPlease enter Vehicle Number",
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "Upload Document",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff666666),
                                                  fontFamily: 'InterRegular'),
                                              // children: const [
                                              //   TextSpan(
                                              //       text: ' *',
                                              //       style: TextStyle(
                                              //         color: Colors.red,
                                              //         fontSize: 14,
                                              //         fontWeight: FontWeight.w500,
                                              //       ))
                                              // ]
                                            ),
                                          ),
                                          Container(
                                            height: 80,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xffD4D4D4),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color(0xffFAFAFA),
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 13),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xffFAFAFA),
                                                foregroundColor: ThemeColor
                                                    .themeLightGrayColor,
                                                elevation: 0,
                                              ),
                                              onPressed: () {
                                                // Provider.of<Lttechprovider>(context,
                                                //         listen: false)
                                                //     .uploadDocApiRequest(context);
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
                                          Text(
                                            "Uploaded Document",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontFamily: FontName.interMedium,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final docurl =
                                                          Endpoints.docbaseurl +
                                                              docUrl;
                                                      print(path
                                                          .extension(docUrl));
                                                      if (path.extension(
                                                                  docUrl) ==
                                                              ".jpeg" ||
                                                          path.extension(
                                                                  docUrl) ==
                                                              ".png") {
                                                        final imageProvider =
                                                            Image.network(
                                                                    docurl)
                                                                .image;
                                                        showImageViewer(context,
                                                            imageProvider,
                                                            onViewerDismissed:
                                                                () {
                                                          print("dismissed");
                                                        });
                                                      } else if (path.extension(
                                                              docUrl) ==
                                                          ".pdf") {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute<
                                                              dynamic>(
                                                            builder: (_) =>
                                                                PDFViewerFromUrl(
                                                              url: docurl,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        value.uploadedFilename
                                                                .isNotEmpty
                                                            ? // in Add Consignment Mode
                                                            path.extension(value
                                                                        .uploadedFilename) ==
                                                                    '.pdf'
                                                                ? Image.asset(
                                                                    "assets/images/pdf_icon.png",
                                                                    height: 37,
                                                                    width: 27,
                                                                    color: Color(
                                                                        0xffFE5100),
                                                                  )
                                                                : path.extension(value
                                                                            .uploadedFilename) ==
                                                                        '.docx'
                                                                    ? Image
                                                                        .asset(
                                                                        "assets/images/docx_icon.png",
                                                                        height:
                                                                            37,
                                                                        width:
                                                                            27,
                                                                        color: Color(
                                                                            0xff4A8AFB),
                                                                      )
                                                                    : path.extension(value.uploadedFilename) == '.jpeg' ||
                                                                            path.extension(value.uploadedFilename) ==
                                                                                '.png'
                                                                        ? SvgPicture
                                                                            .asset(
                                                                            "assets/images/jpeg.svg",
                                                                            height:
                                                                                37,
                                                                            width:
                                                                                27,
                                                                            color:
                                                                                Color(0xff4A8AFB),
                                                                          )
                                                                        : SizedBox()
                                                            : path.extension(
                                                                        // In Edit Consignment Mode
                                                                        docUrl) ==
                                                                    '.pdf'
                                                                ? Image.asset(
                                                                    "assets/images/pdf_icon.png",
                                                                    height: 37,
                                                                    width: 27,
                                                                    color: Color(
                                                                        0xffFE5100),
                                                                  )
                                                                : path.extension(
                                                                            docUrl) ==
                                                                        '.docx'
                                                                    ? Image
                                                                        .asset(
                                                                        "assets/images/docx_icon.png",
                                                                        height:
                                                                            37,
                                                                        width:
                                                                            27,
                                                                        color: Color(
                                                                            0xff4A8AFB),
                                                                      )
                                                                    : path.extension(docUrl) == '.jpeg' ||
                                                                            path.extension(docUrl) == '.png'
                                                                        ? SvgPicture.asset(
                                                                            "assets/images/jpeg.svg",
                                                                            height:
                                                                                37,
                                                                            width:
                                                                                27,
                                                                            color:
                                                                                Color(0xff4A8AFB),
                                                                          )
                                                                        : SizedBox(),
                                                        SizedBox(
                                                          width: 28,
                                                        ),
                                                        Text(
                                                          value.uploadedFilename
                                                                  .isNotEmpty
                                                              ? value
                                                                  .uploadedFilename
                                                              : fileName,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontFamily: FontName
                                                                .interRegular,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                          child: docUrl
                                                                      .isNotEmpty ||
                                                                  value
                                                                      .uploadedFilename
                                                                      .isNotEmpty
                                                              ? Icon(
                                                                  Icons
                                                                      .remove_red_eye_outlined,
                                                                  size: 25,
                                                                )
                                                              : null,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          value.isConsignmentEdit
                                              ? Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 46,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      ThemeColor
                                                                          .themeGreenColor),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      side: const BorderSide(
                                                                          color: ThemeColor.themeGreenColor)))),
                                                          onPressed: () {
                                                            value.updateConsignmentRequestObj
                                                                    .companyId =
                                                                //  "85121810-512e-4366-95dd-4d660cffa206";
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .companyId
                                                                    .toString();
                                                            //AddConsignmentPageOne
                                                            value.updateConsignmentRequestObj
                                                                    .jobNumber =
                                                                value
                                                                    .jobNumberController
                                                                    .text;
                                                            /*value.updateConsignmentRequestObj
                                                      .bookedDate =
                                                      value.bookedDateController
                                                          .text;
                                                  */
                                                            value.updateConsignmentRequestObj
                                                                    .bookedDate =
                                                                '${DateTime.parse(value.consignmentbookdate ?? "").toIso8601String()}Z';

                                                            /* value.updateConsignmentRequestObj
                                                      .pickupDate =
                                                      value.pickUpDateController
                                                          .text;*/
                                                            value.updateConsignmentRequestObj
                                                                    .pickupDate =
                                                                '${DateTime.parse(value.consignmentpickupdate ?? "").toIso8601String()}Z';

                                                            /*value.updateConsignmentRequestObj
                                                      .deliveryDate =
                                                      value
                                                          .deliveryDateController
                                                          .text; */

                                                            value.updateConsignmentRequestObj
                                                                    .deliveryDate =
                                                                // value.consignmentdeliverydate ??
                                                                //     "";
                                                                '${DateTime.parse(value.consignmentdeliverydate ?? "").toIso8601String()}Z';
                                                            print(
                                                                "${value.consignmentdeliverydate}, ${DateTime.parse(value.consignmentdeliverydate ?? "").toIso8601String()}Z");

                                                            value.updateConsignmentRequestObj
                                                                    .specialInstruction =
                                                                value
                                                                    .instructionController
                                                                    .text;

                                                            value.updateConsignmentRequestObj
                                                                    .manifestNumber =
                                                                value
                                                                    .manifestNumberdropdownValue;

                                                            value.updateConsignmentRequestObj
                                                                    .billingCustomer =
                                                                value
                                                                    .billingCustomerid
                                                                    .toString();
                                                            // value
                                                            //     .billingcustomerdropdownValue;

                                                            value.updateConsignmentRequestObj
                                                                    .billingAddress =
                                                                value
                                                                    .billingcustomerAddressdropdownValue;

                                                            if (value
                                                                    .selectedcustomerbillingaddressid !=
                                                                0) {
                                                              value.selectedcustomerbillingaddressid =
                                                                  0;
                                                            } else {
                                                              value.updateConsignmentRequestObj
                                                                      .billingAddressId =
                                                                  //value.selectedcustomerbillingaddressid
                                                                  value
                                                                          .arrcustomercompanyaddress[value
                                                                              .selectedcustomerbillingaddressid]
                                                                          .customerBillingId ??
                                                                      value
                                                                          .consignmentByIdresponse
                                                                          .data!
                                                                          .billingAddressId;
                                                            }
                                                            //AddConsignmentPageTwo
                                                            value.updateConsignmentRequestObj
                                                                    .customerId =
                                                                value
                                                                    .maincustomerid;
                                                            value.updateConsignmentRequestObj
                                                                    .customerAddress =
                                                                value
                                                                    .customerAddressController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .suburb =
                                                                value
                                                                    .customerSuburbController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .zipCode =
                                                                value
                                                                    .customerZipCodeController
                                                                    .text;

                                                            value.updateConsignmentRequestObj
                                                                    .countryId =
                                                                value
                                                                    .selectedcountryid;
                                                            //.toString();
                                                            value.updateConsignmentRequestObj
                                                                    .stateId =
                                                                value
                                                                    .selectedStateId;
                                                            //.toString();

                                                            //AddConsignmentPageThree
                                                            value.updateConsignmentRequestObj
                                                                    .deliveryName =
                                                                // value
                                                                //   .deliverycustomerNameController
                                                                // .text;
                                                                value
                                                                    .deliverycustomerbillingid
                                                                    .toString();

                                                            value.updateConsignmentRequestObj
                                                                    .deliveryAddres =
                                                                value
                                                                    .deliverycustomerAddressController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .deliverySuburb =
                                                                value
                                                                    .deliverycustomerSuburbController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .deliveryZipCode =
                                                                value
                                                                    .deliverycustomerZipCodeController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .deliveryCountryId =
                                                                value
                                                                    .selectedDeliveryCountryid;
                                                            //.toString();
                                                            value.updateConsignmentRequestObj
                                                                    .deliveryStateId =
                                                                value
                                                                    .selectedDeliveryStateId;
                                                            //.toString();

                                                            //AddConsignmentFive
                                                            value.updateConsignmentRequestObj
                                                                    .chep =
                                                                value
                                                                    .chepController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .loscom =
                                                                value
                                                                    .loscomController
                                                                    .text;
                                                            value.updateConsignmentRequestObj
                                                                    .plain =
                                                                value
                                                                    .plainController
                                                                    .text;

                                                            //AddConsignmentPageSix

                                                            List<TruckDetail>
                                                                updateTruckDetailArr =
                                                                [];
                                                            var updateTruckDetailObj =
                                                                TruckDetail();

                                                            updateTruckDetailObj
                                                                .document = [
                                                              value
                                                                  .uploadedFilename
                                                            ];
                                                            updateTruckDetailObj
                                                                .truckDetails = value
                                                                    .updatetimesheetrequestObj
                                                                    .truck ??
                                                                (value
                                                                        .consignmentByIdresponse
                                                                        .data!
                                                                        .truckDetails
                                                                        .isNotEmpty
                                                                    ? value
                                                                        .consignmentByIdresponse
                                                                        .data
                                                                        ?.truckDetails[
                                                                            0]
                                                                        .truckType
                                                                    : "");

                                                            updateTruckDetailObj
                                                                .truckDocumentId = (value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .truckDetails
                                                                    .isNotEmpty
                                                                ? value
                                                                    .consignmentByIdresponse
                                                                    .data
                                                                    ?.truckDetails[
                                                                        0]
                                                                    .truckDocumentId
                                                                : "");

                                                            updateTruckDetailObj
                                                                    .truckNumber =
                                                                value
                                                                    .truckNumberController
                                                                    .text;
                                                            //  updateTruckDetailObj.truckDetails =
                                                            // "Truck123";

                                                            print(
                                                                "truck Details:${updateTruckDetailObj.toJson()}");
                                                            updateTruckDetailArr
                                                                .add(
                                                                    updateTruckDetailObj);

                                                            value.updateConsignmentRequestObj
                                                                    .truckDetails =
                                                                updateTruckDetailArr;

                                                            //Driver Details
                                                            value.updateConsignmentRequestObj
                                                                    .driverId =
                                                                // "bc5be7d4-03e9-4569-9642-a73e9616c3f6";
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .driverId
                                                                    .toString();
                                                            value.updateConsignmentRequestObj
                                                                    .driverMobileNumber =
                                                                //   1234567890;
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .driverMobileNumber
                                                                    .toString();
                                                            value.updateConsignmentRequestObj
                                                                    .consignmentId =
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .consignmentId
                                                                    .toString();

                                                            value.updateConsignmentRequestObj
                                                                    .totalItems =
                                                                value
                                                                    .updateConsignmentRequestObj
                                                                    .consignmentDetails
                                                                    ?.map((value) =>
                                                                        value
                                                                            .noOfItems ??
                                                                        0)
                                                                    .reduce((x,
                                                                            y) =>
                                                                        x + y);
                                                            value.updateConsignmentRequestObj
                                                                    .totalPallets =
                                                                value
                                                                    .updateConsignmentRequestObj
                                                                    .consignmentDetails
                                                                    ?.map((value) =>
                                                                        value
                                                                            .pallets ??
                                                                        0)
                                                                    .reduce((x,
                                                                            y) =>
                                                                        x + y);
                                                            value.updateConsignmentRequestObj
                                                                    .totalSpaces =
                                                                value
                                                                    .updateConsignmentRequestObj
                                                                    .consignmentDetails
                                                                    ?.map((value) =>
                                                                        value
                                                                            .spaces ??
                                                                        0)
                                                                    .reduce((x,
                                                                            y) =>
                                                                        x + y);

                                                            value.updateConsignmentRequestObj
                                                                    .totalWeight =
                                                                value
                                                                    .updateConsignmentRequestObj
                                                                    .consignmentDetails
                                                                    ?.map((value) =>
                                                                        value
                                                                            .weight ??
                                                                        0)
                                                                    .reduce((x,
                                                                            y) =>
                                                                        x + y);

                                                            value.updateConsignmentRequestObj
                                                                    .pickupCustomerId =
                                                                //value
                                                                //  .consignmentByIdresponse
                                                                // .data!
                                                                // .pickupCustomerId;
                                                                value
                                                                    .pickupCustomerbillingid
                                                                    .toString();
                                                            value.updateConsignmentRequestObj
                                                                    .customerPickupDetails =
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .customerPickupDetails;
                                                            value.updateConsignmentRequestObj
                                                                    .customerDeliveryDetails =
                                                                value
                                                                    .consignmentByIdresponse
                                                                    .data!
                                                                    .customerDeliveryDetails;

                                                            // print(
                                                            //     "consignmentdetailsarr_fnl${value.updateconsignmentDetailArr.length}");

                                                            print(
                                                                'UpdateConsignmentRequestObj: ${value.updateConsignmentRequestObj.toJson()}');

                                                            value
                                                                .addConsignmentDialog(
                                                                    context,
                                                                    value);
                                                          },
                                                          child: const Text(
                                                            "Update",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  FontName
                                                                      .interBold,
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 46,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      ThemeColor
                                                                          .themeGreenColor),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      side: const BorderSide(
                                                                          color: ThemeColor.themeGreenColor)))),
                                                          onPressed: () {
                                                            value.addConsignmentRequestObj
                                                                    .companyId =
                                                                //  "85121810-512e-4366-95dd-4d660cffa206";
                                                                // "6aadad12-7270-48b4-9ff2-9bfea9454885";
                                                                Environement
                                                                    .companyID;
                                                            value
                                                                .jobNumberController
                                                                .text;
                                                            //AddConsignmentPageOne
                                                            value.addConsignmentRequestObj
                                                                    .jobNumber =
                                                                value
                                                                    .jobNumberController
                                                                    .text;
                                                            /*value.updateConsignmentRequestObj
                                                      .bookedDate =
                                                      value.bookedDateController
                                                          .text;
                                                  */
                                                            value.addConsignmentRequestObj
                                                                    .bookedDate =
                                                                value
                                                                    .consignmentbookdate;

                                                            /* value.updateConsignmentRequestObj
                                                      .pickupDate =
                                                      value.pickUpDateController
                                                          .text;*/
                                                            value.addConsignmentRequestObj
                                                                    .pickupDate =
                                                                value
                                                                    .consignmentpickupdate;

                                                            /*value.updateConsignmentRequestObj
                                                      .deliveryDate =
                                                      value
                                                          .deliveryDateController
                                                          .text; */
                                                            value.addConsignmentRequestObj
                                                                    .deliveryDate =
                                                                value
                                                                    .consignmentdeliverydate;

                                                            value.addConsignmentRequestObj
                                                                    .specialInstruction =
                                                                value
                                                                    .instructionController
                                                                    .text;

                                                            value.addConsignmentRequestObj
                                                                    .manifestNumber =
                                                                value
                                                                    .manifestNumberdropdownValue;

                                                            value.addConsignmentRequestObj
                                                                    .billingCustomer =
                                                                value
                                                                    .billingCustomerid
                                                                    .toString();
                                                            // value
                                                            //     .billingcustomerdropdownValue;

                                                            value.addConsignmentRequestObj
                                                                    .pickupCustomerId =
                                                                //  value
                                                                //    .selectedpickupcustomerid
                                                                value
                                                                    .pickupCustomerbillingid
                                                                    .toString();
                                                            // value
                                                            //     .consignmentByIdresponse
                                                            //     .data!
                                                            //     .pickupCustomerId;

                                                            value.addConsignmentRequestObj
                                                                    .billingAddress =
                                                                value
                                                                    .billingcustomerAddressdropdownValue;

                                                            value.addConsignmentRequestObj
                                                                    .billingAddressId =
                                                                value
                                                                    .billingaddressid // .selectedcustomerid
                                                                    .toString();

                                                            //AddConsignmentPageTwo
                                                            value.addConsignmentRequestObj
                                                                    .customerId =
                                                                value
                                                                    .maincustomerid;
                                                            value.addConsignmentRequestObj
                                                                    .customerAddress =
                                                                value
                                                                    .customerAddressController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .suburb =
                                                                value
                                                                    .customerSuburbController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .zipCode =
                                                                value
                                                                    .customerZipCodeController
                                                                    .text;

                                                            value.addConsignmentRequestObj
                                                                    .countryId =
                                                                value
                                                                    .selectedcountryid
                                                                    .toString();
                                                            value.addConsignmentRequestObj
                                                                    .stateId =
                                                                value
                                                                    .selectedStateId
                                                                    .toString();

                                                            //AddConsignmentPageThree
                                                            value.addConsignmentRequestObj
                                                                    .deliveryName =
                                                                // value
                                                                //   .selecteddeliverycustomerid
                                                                value
                                                                    .deliverycustomerbillingid
                                                                    .toString();
                                                            // value
                                                            //     .consignmentByIdresponse
                                                            //     .data!
                                                            //     .pickupCustomerId;

                                                            value.addConsignmentRequestObj
                                                                    .deliveryAddres =
                                                                value
                                                                    .deliverycustomerAddressController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .deliverySuburb =
                                                                value
                                                                    .deliverycustomerSuburbController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .deliveryZipCode =
                                                                value
                                                                    .deliverycustomerZipCodeController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .deliveryCountryId =
                                                                value
                                                                    .selectedDeliveryCountryid
                                                                    .toString();
                                                            value.addConsignmentRequestObj
                                                                    .deliveryStateId =
                                                                value
                                                                    .selectedDeliveryStateId
                                                                    .toString();

                                                            //AddConsignmentFive
                                                            value.addConsignmentRequestObj
                                                                    .chep =
                                                                value
                                                                    .chepController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .loscom =
                                                                value
                                                                    .loscomController
                                                                    .text;
                                                            value.addConsignmentRequestObj
                                                                    .plain =
                                                                value
                                                                    .plainController
                                                                    .text;

                                                            //AddConsignmentPageSix

                                                            List<AddTruckDetail>
                                                                truckDetailArr =
                                                                [];
                                                            var truckDetailObj =
                                                                AddTruckDetail();

                                                            truckDetailObj
                                                                    .document =
                                                                value
                                                                    .uploadedFilename;
                                                            truckDetailObj
                                                                .truckDocumentId = "";

                                                            truckDetailObj
                                                                    .truckNumber =
                                                                value
                                                                    .truckNumberController
                                                                    .text;
                                                            truckDetailObj
                                                                .truckDetails = value
                                                                    .vehicleDropdownSelectedValue
                                                                    ?.truckId ??
                                                                "";
                                                            // value.strtrucktype; //"f1014de4-ac2d-4671-bd89-d146e2f46dee" trucktype id

                                                            print(
                                                                "truck Details:${truckDetailObj.toJson()}");
                                                            truckDetailArr.add(
                                                                truckDetailObj);

                                                            value.addConsignmentRequestObj
                                                                    .truckDetails =
                                                                truckDetailArr;

                                                            //Driver Details
                                                            value.addConsignmentRequestObj
                                                                    .driverId =
                                                                //  "bc5be7d4-03e9-4569-9642-a73e9616c3f6";
                                                                //  "f35a9d1f-a2a3-423d-a56f-6e585881b3c9";
                                                                Environement
                                                                    .driverID;
                                                            value.addConsignmentRequestObj
                                                                    .driverMobileNumber =
                                                                "1234567890";
                                                            //    value.addConsignmentRequestObj.consignmentDetails = value.updateconsignmentDetailArr;

                                                            print(
                                                                'AddConsignmentRequestObj: ${value.addConsignmentRequestObj.toJson()}');

                                                            value
                                                                .addConsignmentDialog(
                                                                    context,
                                                                    value);
                                                          },
                                                          child: const Text(
                                                            "Submit",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  FontName
                                                                      .interBold,
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                );
              })),
        ));
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }
}
