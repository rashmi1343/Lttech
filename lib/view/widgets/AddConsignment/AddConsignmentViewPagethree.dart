import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/StatefulWrapper.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:provider/provider.dart';

import '../../../entity/StatesResponse.dart';
import '../../../utility/CustomTextStyle.dart';

class AddConsignmentViewPagethree extends StatelessWidget {
  AddConsignmentViewPagethree({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoAddConsignmentTwo(context);

      return true;
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    return StatefulWrapper(
      onInit: () async {
        final provider = Provider.of<Lttechprovider>(context, listen: false);

        // Provider.of<Lttechprovider>(context, listen: false)
        //     .getAllCountriesRequest("1");
        // Provider.of<Lttechprovider>(context, listen: false)
        //     .getAllStatesRequest("1");

        //Page 3
        if (provider.isConsignmentEdit) {
          await provider.getdeliverycustomerpstbyid(
              provider.consignmentByIdresponse.data!.deliveryName.toString());

          provider.deliverycustomerNameController.text =
              provider.consignmentByIdresponse.data!.deliveryName.toString();
          provider.deliverycustomerAddressController.text =
              provider.consignmentByIdresponse.data!.deliveryAddres.toString();
          provider.deliverycustomerSuburbController.text =
              provider.consignmentByIdresponse.data!.deliverySuburb.toString();
          provider.deliverycustomerZipCodeController.text =
              provider.consignmentByIdresponse.data!.deliveryZipCode.toString();

          final deliverycountryid =
              provider.consignmentByIdresponse.data!.deliveryCountryId ?? -1;
          setDeliverySelectedCountry(provider, deliverycountryid);
          setDeliverySelectedState(
              provider,
              provider.consignmentByIdresponse.data!.deliveryStateId ?? -1,
              deliverycountryid);
          provider.setUpdateView = true;
        } else {
          // Setting intial value in add delivery add
          provider.selectedDeliveryCustomerName = "";
          provider.selectedCustomerDeliveryCountry = "";
          provider.selectedDeliveryCountryid = -1;
          provider.selectedDeliveryStateId = -1;
          provider.selectedCustomerDeliveryState = "";

          // await provider.particularcustomeralladdressbycustomeridRequest();
        }
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: commonAppBarforConsignment(
                "Step 3 of 6", 40, 60, context, '/AddConsigmentViewPagetwo'),
            body: Consumer<Lttechprovider>(builder: (context, value, child) {
              return Column(
                children: [
                  PreferredSize(
                      preferredSize: Size.square(1.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 0, top: 10, bottom: 20),
                            width: width * 0.44,
                            height: 2.4,
                            decoration: BoxDecoration(
                                color: ThemeColor.themeGreenColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: 0, right: 20, top: 10, bottom: 20),
                            width: width * 0.41,
                            height: 2.4,
                            decoration: BoxDecoration(
                                color: ThemeColor.themeLightGrayColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ))
                        ],
                      )),
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
                                //  mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Delivery Address Details",
                                      style: TextStyle(
                                          fontFamily: 'InterBold',
                                          fontSize: 16,
                                          color: Color(0xff000000)),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Customer Name",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  Flexible(
                                    child: value.arrcustomerstr.isEmpty
                                        ? Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: ThemeColor
                                                    .themeLightWhiteColor),
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                bottom: 10,
                                                right: 20,
                                                top: 5),
                                            alignment: Alignment.topLeft,
                                          )
                                        : Container(
                                            padding: EdgeInsets.only(left: 10),
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                left: 10,
                                                bottom: 10,
                                                right: 20,
                                                top: 5),
                                            alignment: Alignment.topLeft,
                                            child: DropdownSearch<String>(
                                                popupProps: PopupProps.menu(
                                                  //modalBottomSheet
                                                  fit: FlexFit.loose,
                                                  showSearchBox: value
                                                          .arrcustomerstr
                                                          .length >
                                                      3,
                                                  showSelectedItems: true,
                                                  searchDelay: const Duration(
                                                      milliseconds: 1),
                                                  searchFieldProps:
                                                      const TextFieldProps(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Search Customer Name",
                                                    ),
                                                  ),
                                                ),
                                                items: value.arrcustomerstr,

                                                // onChanged: print,
                                                onChanged: (selectedvalue) {
                                                  print(
                                                      "selected delivery customer:$selectedvalue");
                                                  int selectedvalueindex = 0;
                                                  value.ispickupclick = false;
                                                  value.isdeliveryclick = true;
                                                  print(
                                                      "arcustomerrow:${value.arcustomerrow.length}");
                                                  //  if(value.isConsignmentEdit) {
                                                  print(
                                                      "main customer id: ${value.consignmentByIdresponse!.data!.customerId}");

                                                  // getcustomerbillingid then pass to  value.getpickupcustomerpstbyid
                                                  selectedvalueindex = value
                                                      .getcustomerbillingidbycustomername(
                                                          selectedvalue!);

                                                  print(
                                                      "pstbillingid:$selectedvalueindex");
                                                  // value.getpickupcustomerpstbyid(value.selectedcustomerbillingid);

                                                  /* selectedvalueindex = value
                                                      .arcustomerrow.
                                                          indexWhere((
                                                          element) =>
                                                      element
                                                          .customerAddressId ==
                                                          value
                                                              .consignmentByIdresponse
                                                              .data!
                                                              .pickupCustomerId
                                                              .toString());

                                                      print(
                                                          "selectedvalueindex:$selectedvalueindex");
                                                      if (selectedvalueindex ==
                                                          -1) {
                                                        selectedvalueindex = 0;
                                                      }
                                                    }
                                                    else {
                                                      selectedvalueindex =0;
                                                    }*/
                                                  value
                                                          .selectedDeliveryCustomerName =
                                                      // selectedvalue.toString();
                                                      value
                                                          .arcustomerrow[
                                                              selectedvalueindex]
                                                          .customerCompanyName
                                                          .toString();

                                                  // value.onchangeBillingCustomer(
                                                  //     selectedvalueindex);
                                                  // value.getpickupcustomerpstbyid(
                                                  //   value.arrcustomerstr[
                                                  //     selectedvalueindex]);
                                                  //value.getpickupcustomerpstbyid(value.arcustomerrow[selectedvalueindex].customerAddressId.toString());
                                                  if (selectedvalueindex > -1) {
                                                    // print(
                                                    //   "Selected+address:${value.arcustomerrow[value.selectedpickupcustomerid].address}");
                                                    print(
                                                        "Selected+address:${value.arcustomerrow[selectedvalueindex].address}");

                                                    print(
                                                        "zipcode:${value.arcustomerrow[selectedvalueindex].zipCode}");
                                                    print(
                                                        "suburb:${value.arcustomerrow[selectedvalueindex].suburb}");

                                                    value.deliverycustomerAddressController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .address
                                                            .toString();

                                                    value.deliverycustomerSuburbController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .suburb
                                                            .toString();

                                                    value.deliverycustomerZipCodeController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .zipCode
                                                            .toString();

                                                    setDeliverySelectedCountry(
                                                        value,
                                                        value
                                                                .arcustomerrow[
                                                                    selectedvalueindex]
                                                                .countryId ??
                                                            -1);

                                                    setDeliverySelectedState(
                                                        value,
                                                        value
                                                                .arcustomerrow[
                                                                    selectedvalueindex]
                                                                .stateId ??
                                                            -1,
                                                        value
                                                                .arcustomerrow[
                                                                    selectedvalueindex]
                                                                .countryId ??
                                                            -1);

                                                    value.setUpdateView = true;
                                                  }
                                                  //  }
                                                },
                                                selectedItem: value
                                                        .isConsignmentEdit
                                                    ?
                                                    //value
                                                    //      .editCustomerBillingName
                                                    //    .toString()
                                                    value
                                                        .selectedDeliveryCustomerName
                                                    //        .isEmpty
                                                    : "Please select a name"
                                                //: value
                                                //  .selectedDeliveryCustomerName,
                                                ),
                                          ),
                                  ),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Address",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  Flexible(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              style: FillTimeSheetCustomTS
                                                  .tfTitleLabelTS,
                                              controller: value
                                                  .deliverycustomerAddressController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xffFAFAFA),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xffD4D4D4),
                                                      width: 1.0),
                                                ),
                                                // hintText:
                                                //     'Pitt St, Sydney NSW 2000, Australia',
                                              )))),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Suburb",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  Flexible(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              style: FillTimeSheetCustomTS
                                                  .tfTitleLabelTS,
                                              controller: value
                                                  .deliverycustomerSuburbController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xffFAFAFA),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xffD4D4D4),
                                                      width: 1.0),
                                                ),
                                                hintText: '',
                                              )))),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Zip Code",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  Flexible(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              style: FillTimeSheetCustomTS
                                                  .tfTitleLabelTS,
                                              controller: value
                                                  .deliverycustomerZipCodeController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xffFAFAFA),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xffD4D4D4),
                                                      width: 1.0),
                                                ),
                                                hintText: '',
                                              )))),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Country",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  value.arrcountriesid.isEmpty
                                      ? Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: ThemeColor
                                                  .themeLightWhiteColor),
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 10,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: DropdownSearch<String>(
                                            popupProps: PopupProps.menu(
                                              //modalBottomSheet
                                              fit: FlexFit.loose,
                                              showSearchBox:
                                                  value.arrcountriesid.length >
                                                      3,
                                              showSelectedItems: true,
                                              searchDelay: const Duration(
                                                  milliseconds: 1),
                                              searchFieldProps:
                                                  const TextFieldProps(
                                                decoration: InputDecoration(
                                                  labelText: "Search Country",
                                                ),
                                              ),
                                            ),
                                            items: value.arrcountriesid
                                                .map((e) =>
                                                    e.countryName.toString())
                                                .toList(),

                                            // onChanged: print,
                                            onChanged: (selectedvalue) {
                                              print(selectedvalue);

                                              value.selectedDeliveryStateId = 0;
                                              value.selectedCustomerDeliveryState =
                                                  "";
                                              value.deliverystatesdropdownValue =
                                                  null;
                                              value.selectedCustomerDeliveryCountry =
                                                  selectedvalue.toString();

                                              final selectedvalueindex = value
                                                  .arrcountriesid
                                                  .indexWhere((element) =>
                                                      element.countryName ==
                                                      selectedvalue);

                                              if (selectedvalueindex > -1) {
                                                value.selectedDeliveryCountryid =
                                                    value
                                                            .arrcountriesid[
                                                                selectedvalueindex]
                                                            .id ??
                                                        0;
                                                print(
                                                    "value.selectedDeliveryCountryid:${value.selectedDeliveryCountryid}");

                                                print(
                                                    "value.selectedCustomerDeliveryState:${value.selectedDeliveryStateId}, ${value.selectedCustomerDeliveryState},${value.deliverystatesdropdownValue}");
                                              }
                                              value.setUpdateView = true;
                                            },

                                            selectedItem: value
                                                    .isConsignmentEdit
                                                ? value
                                                    .deliverycountriesdropdownValue
                                                    .toString()
                                                : value.selectedCustomerDeliveryCountry
                                                        .isEmpty
                                                    ? "Select Country"
                                                    : value
                                                        .selectedCustomerDeliveryCountry,
                                          ),
                                        ),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 30),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "State",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'),
                                          children: const [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ]),
                                    ),
                                  )),
                                  Flexible(
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: ThemeColor
                                                .themeLightWhiteColor),
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            bottom: 10,
                                            right: 20,
                                            top: 5),
                                        alignment: Alignment.topLeft,
                                        child: getstatelist(
                                            value,
                                            value.selectedDeliveryCountryid,
                                            context)),
                                  ),
                                  Flexible(
                                      child: Container(
                                          width: width,
                                          height: height * 0.060,
                                          margin: EdgeInsets.only(
                                              top: 20,
                                              bottom: 20,
                                              left: 20,
                                              right: 20),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                print("save next");

                                                print(
                                                    "AddConsignmentPageThree Delivery Name:${value.selectedDeliveryCustomerName}");

                                                print(
                                                    "AddConsignmentPageThree Delivery Address:${value.deliverycustomerAddressController.text}");
                                                print(
                                                    "AddConsignmentPageThree Delivery Suburb:${value.deliverycustomerSuburbController.text}");
                                                print(
                                                    "AddConsignmentPageThree Delivery ZipCode:${value.deliverycustomerZipCodeController.text}");
                                                print(
                                                    "AddConsignmentPageThree Delivery Country id:${value.selectedDeliveryCountryid}");
                                                print(
                                                    "AddConsignmentPageThree Delivery State id:${value.selectedDeliveryStateId}");

                                                if (value
                                                        .selectedDeliveryCustomerName
                                                        .isEmpty ||
                                                    value
                                                        .deliverycustomerAddressController
                                                        .text
                                                        .isEmpty ||
                                                    value
                                                        .deliverycustomerSuburbController
                                                        .text
                                                        .isEmpty ||
                                                    value
                                                        .deliverycustomerZipCodeController
                                                        .text
                                                        .isEmpty ||
                                                    value.selectedDeliveryCountryid ==
                                                        -1 ||
                                                    value.selectedDeliveryStateId ==
                                                        -1) {
                                                  value.showCommonToast(
                                                      "Please fill all the details");
                                                } else {
                                                  Provider.of<Lttechprovider>(
                                                          context,
                                                          listen: false)
                                                      .navigatetoAddConsignmentFour(
                                                          context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xff0AAC19)),
                                              child: Text(
                                                'Next',
                                                style: TextStyle(
                                                    fontFamily: 'InterBold',
                                                    fontSize: 16,
                                                    color: Color(0xffffffff)),
                                              )))),
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              );
            })),
      ),
    );
  }

  void setDeliverySelectedState(
      Lttechprovider provider, int stateID, int selectedDeliveryCountryID) {
    List<StatesList> arrstatelist = provider.objgetallStates.data
        .where((element) => element.countryId == selectedDeliveryCountryID)
        .toList();
    print("selectedState List:${arrstatelist.map((e) => e.stateName)}");
    final selectedStateID =
        arrstatelist.indexWhere((element) => element.id == stateID);

    if (selectedStateID > -1) {
      if (provider.isConsignmentEdit) {
        provider.deliverystatesdropdownValue =
            arrstatelist[selectedStateID].stateName;
      } else {
        provider.selectedCustomerDeliveryState =
            arrstatelist[selectedStateID].stateName.toString();
      }
      provider.deliverystatesdropdownValue =
          arrstatelist[selectedStateID].stateName;
      provider.selectedDeliveryStateId = arrstatelist[selectedStateID].id ?? 0;
      print(
          "provider.Delivery deliverystatesdropdownValue:${provider.deliverystatesdropdownValue}");
    }
  }

  void setDeliverySelectedCountry(
      Lttechprovider provider, int selectedDeliveryCountryID) {
    final selectedCountryID = provider.arrcountriesid
        .indexWhere((element) => element.id == selectedDeliveryCountryID);

    if (selectedCountryID > -1) {
      if (provider.isConsignmentEdit) {
        provider.deliverycountriesdropdownValue =
            provider.arrcountriesid[selectedCountryID].countryName;
      } else {
        provider.selectedCustomerDeliveryCountry =
            provider.arrcountriesid[selectedCountryID].countryName.toString();
      }

      provider.selectedDeliveryCountryid =
          provider.arrcountriesid[selectedCountryID].id ?? 0;
      print(
          "provider.Delivery countriesdropdownValue:${provider.deliverycountriesdropdownValue}");
    }
  }

  /*dynamic widget to get state as per country id*/
  Widget getstatelist(
      Lttechprovider value, int selectedcountryid, BuildContext context) {
    List<StatesList> arrstatelist = value.objgetallStates.data
        .where((element) => element.countryId == selectedcountryid)
        .toList();

    print(
        "value.deliverystatesdropdownValue:${value.deliverystatesdropdownValue}");

    return Container(
      height: 50,
      alignment: Alignment.topLeft,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          //modalBottomSheet
          fit: FlexFit.loose,
          showSearchBox: arrstatelist.length > 3,
          showSelectedItems: true,
          searchDelay: const Duration(milliseconds: 1),
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              labelText: "Search State",
            ),
          ),
        ),
        items: arrstatelist.map((e) => e.stateName.toString()).toList(),

        // onChanged: print,
        onChanged: (selectedvalue) {
          print(selectedvalue);

          value.selectedCustomerDeliveryState = selectedvalue.toString();

          final selectedvalueindex = arrstatelist
              .indexWhere((element) => element.stateName == selectedvalue);

          if (selectedvalueindex > -1) {
            value.selectedDeliveryStateId =
                arrstatelist[selectedvalueindex].id ?? 0;
            print(
                "value.selectedDeliveryStateId:${value.selectedDeliveryStateId}");
          }
        },

        selectedItem: value.isConsignmentEdit
            ? (value.deliverystatesdropdownValue == null
                ? "Select State"
                : value.deliverystatesdropdownValue.toString())
            : value.selectedCustomerDeliveryState.isEmpty
                ? "Select State"
                : value.selectedCustomerDeliveryState,
      ),
    );

    // return DropdownButtonHideUnderline(
    //     child: DropdownButton(
    //   hint: value.statesdropdownValue == null
    //       ? Padding(
    //           padding: EdgeInsets.only(left: 5),
    //           child: Text(
    //             "Select State",
    //             style: FillTimeSheetCustomTS.tfTitleLabelTS,
    //           ))
    //       : Padding(
    //           padding: EdgeInsets.only(left: 5),
    //           child: Text(
    //             value.statesdropdownValue.toString(),
    //             style: FillTimeSheetCustomTS.tfTitleLabelTS,
    //           )),
    //   isExpanded: true,
    //   items: arrstatelist.map((cityOne) {
    //     return DropdownMenuItem(
    //       value: cityOne.stateName ?? "",
    //       child: Container(
    //         padding: EdgeInsets.only(left: 10),
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           cityOne.stateName.toString(),
    //           style: FillTimeSheetCustomTS.tfTitleLabelTS,
    //         ),
    //       ),
    //     );
    //   }).toList(),
    //   onChanged: (val) {
    //     if (val != "Select State") {
    //       Provider.of<Lttechprovider>(context, listen: false)
    //           .onchangeStates(val.toString());
    //     }

    //     print("Selected city is $val");
    //   },
    //   value: value.isConsignmentEdit
    //       ? value.statesdropdownValue
    //       : value.statesdropdownValue ?? "Select State",
    // ));
  }
/*dynamic widget to get customer name as per customer id*/
/*Widget getCustomerNameList(Lttechprovider value, BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          items: value.objgetCustomerList.data
              .map((objCustomerName) {
            return DropdownMenuItem(
              value:"${objCustomerName.firstName}  ${objCustomerName.lastName}",
              child: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "${objCustomerName.firstName}  ${objCustomerName.lastName}",
                  style: FillTimeSheetCustomTS.tfTitleLabelTS,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            value.customerListDropDownValue=val.toString();
            Provider.of<Lttechprovider>(context, listen: false)
                .onchangeCustomerList(val.toString());
            print("Selected Customer name $val");
          },
          value: value.customerListDropDownValue,
        ));
  }*/
}
