import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/entity/StatesResponse.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';

import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/StatefulWrapper.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:provider/provider.dart';

import '../../../utility/CustomTextStyle.dart';

class AddConsignmentViewPagetwo extends StatelessWidget {
  AddConsignmentViewPagetwo({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoAddConsignmentOne(context);

      return true;
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    return StatefulWrapper(
      onInit: () async {
        final provider = Provider.of<Lttechprovider>(context, listen: false);
        provider.isconsignmentpageone = false;
        // Future.delayed(Duration.zero, () {

        print("arrcustomerstr: ${provider.arrcustomerstr.length}");
        print("arrcustomerrow: ${provider.arcustomerrow.length}");

        clearData(provider);
        await provider.getAllCountriesRequest("1");
        await provider.getAllStatesRequest("1");

        /* Provider.of<Lttechprovider>(context, listen: false)
              .particularcustomeralladdressbycustomeridRequest();*/
        //Provider.of<Lttechprovider>(context,listen:false).filtercustomerlistbyid();
        if (provider.isConsignmentEdit) {
          print(
              "consignmentByIdresponse.data!.pickupCustomerId:${provider.consignmentByIdresponse.data!.pickupCustomerId}");

          provider.getpickupcustomerpstbyid(provider
              .consignmentByIdresponse.data!.pickupCustomerId
              .toString());

          //Page 2
          provider.customerAddressController.text =
              provider.consignmentByIdresponse.data!.customerAddress.toString();
          provider.customerSuburbController.text =
              provider.consignmentByIdresponse.data!.suburb.toString();
          provider.customerZipCodeController.text =
              provider.consignmentByIdresponse.data!.zipCode.toString();

          final countryid =
              provider.consignmentByIdresponse.data!.countryId ?? -1;
          provider.setSelectedCountry(countryid);
          provider.setSelectedState(
              provider.consignmentByIdresponse.data!.stateId ?? -1, countryid);

          await provider.particularcustomeralladdressbycustomeridRequest();
          provider.setUpdateView = true;
        } else {
          await provider.particularcustomeralladdressbycustomeridRequest();
          // await provider.customercompanyAddressRequest();
        }

        // });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: commonAppBarforConsignment(
                "Step 2 of 6", 40, 60, context, '/AddConsignment'),
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
                            width: width * 0.31,
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
                            width: width * 0.67,
                            height: 2.4,
                            decoration: BoxDecoration(
                                color: ThemeColor.themeLightGrayColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ))
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 27),
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
                                      "Pickup Address Details",
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
                                                      "selected pickup customer:$selectedvalue");
                                                  int selectedvalueindex = 0;
                                                  value.ispickupclick = true;
                                                  value.isdeliveryclick = false;
                                                  print(
                                                      "arcustomerrow:${value.arcustomerrow.length}");
                                                  //  if(value.isConsignmentEdit) {
                                                  print(
                                                      "main customer id: ${value.consignmentByIdresponse.data!.customerId}");

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
                                                          .selectedPickupCustomerName =
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

                                                    print(
                                                        "Country:${value.arcustomerrow[selectedvalueindex].countryId}");
                                                    print(
                                                        "State:${value.arcustomerrow[selectedvalueindex].stateId}");

                                                    value.customerAddressController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .address
                                                            .toString();
                                                    value.customerSuburbController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .suburb
                                                            .toString();
                                                    value.customerZipCodeController
                                                            .text =
                                                        value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .zipCode
                                                            .toString();

                                                    value.setSelectedCountry(value
                                                            .arcustomerrow[
                                                                selectedvalueindex]
                                                            .countryId ??
                                                        -1);

                                                    value.setSelectedState(
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
                                                        .selectedPickupCustomerName
                                                    //  .isEmpty
                                                    : value.defaultcustomername
                                                // ? "Please select a name"
                                                //: value
                                                //   .selectedPickupCustomerName,
                                                ),
                                          ),
                                  ),
                                  // Container(
                                  //     height: 50,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: ThemeColor
                                  //                 .themeLightGrayColor),
                                  //         borderRadius:
                                  //             BorderRadius.circular(5),
                                  //         color: ThemeColor
                                  //             .themeLightWhiteColor),
                                  //     margin: EdgeInsets.only(
                                  //         left: 20,
                                  //         bottom: 10,
                                  //         right: 20,
                                  //         top: 5),
                                  //     alignment: Alignment.topLeft,
                                  //     child:

                                  //         /* Autocomplete<
                                  //         ParticularCustomerRow>(
                                  //     initialValue: TextEditingValue(
                                  //         text: value
                                  //             .editPickUpCustomerNameOnEdit),
                                  //     optionsBuilder: (TextEditingValue
                                  //         textEditingValue) {
                                  //       return value.arcustomerrow
                                  //           .where((ParticularCustomerRow
                                  //                   pcr) =>
                                  //               pcr.customerCompanyName
                                  //                   .toString()
                                  //                   .toLowerCase()
                                  //                   .startsWith(
                                  //                       textEditingValue
                                  //                           .text
                                  //                           .toLowerCase()))
                                  //           .toList();
                                  //     },
                                  //     displayStringForOption:
                                  //         (ParticularCustomerRow option) =>
                                  //             option.customerCompanyName
                                  //                 .toString(),
                                  //     fieldViewBuilder: (BuildContext context,
                                  //         TextEditingController fieldTextEditingController,
                                  //         FocusNode fieldFocusNode,
                                  //         VoidCallback onFieldSubmitted) {
                                  //       return Container(
                                  //         margin:
                                  //             EdgeInsets.only(left: 10),
                                  //         child: TextFormField(
                                  //           controller:
                                  //               fieldTextEditingController,
                                  //           focusNode: fieldFocusNode,
                                  //           decoration: InputDecoration(
                                  //             border: InputBorder.none,
                                  //           ),
                                  //           onFieldSubmitted:
                                  //               (String value) {
                                  //             onFieldSubmitted();
                                  //           },
                                  //           style: FillTimeSheetCustomTS
                                  //               .tfTitleLabelTS,
                                  //           onTap: () {},
                                  //         ),
                                  //       );
                                  //     },
                                  //     onSelected: (ParticularCustomerRow selection) {
                                  //       print(
                                  //           'Selected: ${selection.customerCompanyName}- ${selection.address}');
                                  //       value.customerNameController
                                  //               .text =
                                  //           selection
                                  //               .customerCompanyName
                                  //               .toString();
                                  //       value.customerAddressController
                                  //               .text =
                                  //           selection.address
                                  //               .toString();
                                  //       value.customerSuburbController
                                  //               .text =
                                  //           selection.suburb.toString();
                                  //       value.customerZipCodeController
                                  //               .text =
                                  //           selection.zipCode
                                  //               .toString();
                                  //     },
                                  //     optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<ParticularCustomerRow> onSelected, Iterable<ParticularCustomerRow> options) {
                                  //       return Align(
                                  //           alignment:
                                  //               Alignment.topLeft,
                                  //           child: Material(
                                  //               child:
                                  //             Card(
                                  //               elevation: 5,
                                  //               child: Container(
                                  //                   width: 340,
                                  //                   height: 250,
                                  //                   decoration:
                                  //                       BoxDecoration(
                                  //                     color:
                                  //                         Colors.white,
                                  //                   ),
                                  //                   child: ListView
                                  //                       .builder(
                                  //                           padding:
                                  //                               EdgeInsets.all(
                                  //                                   10.0),
                                  //                           itemCount:
                                  //                               options
                                  //                                   .length,
                                  //                           itemBuilder:
                                  //                               (BuildContext
                                  //                                       context,
                                  //                                   int index) {
                                  //                             final ParticularCustomerRow
                                  //                                 option =
                                  //                                 options
                                  //                                     .elementAt(index);

                                  //                             return GestureDetector(
                                  //                               onTap:
                                  //                                   () {
                                  //                                 onSelected(
                                  //                                     option);
                                  //                               },
                                  //                               child:
                                  //                                   ListTile(
                                  //                                 title: Padding(
                                  //                                     padding: EdgeInsets.only(left: 5),
                                  //                                     child: Text(
                                  //                                       option.customerCompanyName.toString(),
                                  //                                       style: FillTimeSheetCustomTS.tfTitleLabelTS,
                                  //                                     )),
                                  //                               ),
                                  //                             );
                                  //                           })),
                                  //             ),
                                  //           ));
                                  //     })*/
                                  //   ChipsChoice<int>.single(
                                  // value: value
                                  //     .selectedpickupcustomerid,
                                  // /* options: ChipsChoiceOption.listFrom<int, String>(
                                  //     source: options,
                                  //     value: (i, v) => i,
                                  //     label: (i, v) => v,
                                  //   ),*/
                                  // choiceItems: C2Choice.listFrom(
                                  //     source:
                                  //         value.arrcustomerstr,
                                  //     value: (i, v) => i,
                                  //     label: (i, v) => v),
                                  // onChanged: (val) {
                                  //   //String
                                  //   //  value.onchangeBillingCustomer(val);
                                  //   print("pickupcustomer" +
                                  //       val.toString());

                                  //   if (val > 0) {
                                  //     print(
                                  //         "arr data: ${value.arcustomerrow}");
                                  //     print("Selected+address:" +
                                  //         value
                                  //             .arcustomerrow[value
                                  //                 .selectedpickupcustomerid]
                                  //             .address
                                  //             .toString());
                                  //     value.customerAddressController
                                  //             .text =
                                  //         value
                                  //             .arcustomerrow[value
                                  //                 .selectedpickupcustomerid]
                                  //             .address
                                  //             .toString();
                                  //     value.customerSuburbController
                                  //             .text =
                                  //         value
                                  //             .arcustomerrow[value
                                  //                 .selectedpickupcustomerid]
                                  //             .suburb
                                  //             .toString();
                                  //     value.customerZipCodeController
                                  //             .text =
                                  //         value
                                  //             .arcustomerrow[value
                                  //                 .selectedpickupcustomerid]
                                  //             .zipCode
                                  //             .toString();
                                  //   } else {
                                  //     print("Selected+address:" +
                                  //         value.arcustomerrow[val]
                                  //             .address
                                  //             .toString());
                                  //     print(
                                  //         "arr data: ${value.arcustomerrow.map((e) => e.address)}");
                                  //     value.customerAddressController
                                  //             .text =
                                  //         value.arcustomerrow[val]
                                  //             .address
                                  //             .toString();
                                  //     value.customerSuburbController
                                  //             .text =
                                  //         value.arcustomerrow[val]
                                  //             .suburb
                                  //             .toString();
                                  //     value.customerZipCodeController
                                  //             .text =
                                  //         value.arcustomerrow[val]
                                  //             .zipCode
                                  //             .toString();
                                  //   }
                                  //   },
                                  // ))),

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
                                                  .customerAddressController,
                                              decoration: InputDecoration(
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
                                                  .customerSuburbController,
                                              decoration: InputDecoration(
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
                                                  .customerZipCodeController,
                                              decoration: InputDecoration(
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

                                              value.selectedPickupCustomerCountry =
                                                  selectedvalue.toString();

                                              final selectedvalueindex = value
                                                  .arrcountriesid
                                                  .indexWhere((element) =>
                                                      element.countryName ==
                                                      selectedvalue);

                                              if (selectedvalueindex > -1) {
                                                value.selectedcountryid = value
                                                        .arrcountriesid[
                                                            selectedvalueindex]
                                                        .id ??
                                                    0;
                                                print(
                                                    "value.selectedcountryid:${value.selectedcountryid}");
                                                value.setUpdateView = true;
                                              }
                                            },

                                            selectedItem: value
                                                    .isConsignmentEdit
                                                ? value.countriesdropdownValue
                                                    .toString()
                                                : value.selectedPickupCustomerCountry
                                                        .isEmpty
                                                    ? "Select Country"
                                                    : value
                                                        .selectedPickupCustomerCountry,
                                          ),
                                        ),
                                  // Flexible(
                                  //     child: Container(
                                  //         height: 50,
                                  //         decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //                 color: ThemeColor
                                  //                     .themeLightGrayColor),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(5),
                                  //             color: ThemeColor
                                  //                 .themeLightWhiteColor),
                                  //         margin: EdgeInsets.only(
                                  //             left: 20,
                                  //             bottom: 10,
                                  //             right: 20,
                                  //             top: 5),
                                  //         alignment: Alignment.topLeft,
                                  //         child: DropdownButtonHideUnderline(
                                  //           child: DropdownButton(
                                  //             isExpanded: true,
                                  //             items: value
                                  //                 //.objgetallCountries.data
                                  //                 .arrcountriesid
                                  //                 .map((item) {
                                  //               var countryid =
                                  //                   item.id.toString();
                                  //               return DropdownMenuItem(
                                  //                   value: item.countryName
                                  //                       .toString(),
                                  //                   child: Container(
                                  //                       padding:
                                  //                           EdgeInsets.only(
                                  //                               left: 10),
                                  //                       alignment: Alignment
                                  //                           .centerLeft,
                                  //                       child: Text(
                                  //                         //Names that the api dropdown contains
                                  //                         item.countryName
                                  //                             .toString(),
                                  //                         style:
                                  //                             FillTimeSheetCustomTS
                                  //                                 .tfTitleLabelTS,
                                  //                       ))
                                  //                   //e.g   India (Name)    and   its   ID (55fgf5f6frf56f) somethimg like that....
                                  //                   );
                                  //             }).toList(),
                                  //             onChanged: (String? strval) {
                                  //               value.countriesdropdownValue =
                                  //                   strval.toString();

                                  //               if (strval !=
                                  //                   "Select Country") {
                                  //                 value.statesdropdownValue =
                                  //                     null;
                                  //                 Provider.of<Lttechprovider>(
                                  //                         context,
                                  //                         listen: false)
                                  //                     .onchangeCountries(
                                  //                         strval.toString());
                                  //               }
                                  //             },
                                  //             value: value.isConsignmentEdit
                                  //                 ? value.countriesdropdownValue
                                  //                 : value.countriesdropdownValue ??
                                  //                     "Select Country",
                                  //           ),
                                  //         ))),

                                  Flexible(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 30),
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
                                                BorderRadius.circular(5),
                                            color: ThemeColor
                                                .themeLightWhiteColor),
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            bottom: 10,
                                            right: 20,
                                            top: 5),
                                        alignment: Alignment.topLeft,
                                        child: getstatelist(value,
                                            value.selectedcountryid, context)),
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
                                                    "AddConsignmentPageTwo Customer Name:${value.customerNameController.text}");
                                                print(
                                                    "AddConsignmentPageTwo Customer Id:${value.maincustomerid}");
                                                print(
                                                    "AddConsignmentPageTwo Customer Address:${value.customerAddressController.text}");
                                                print(
                                                    "AddConsignmentPageTwo Suburb:${value.customerSuburbController.text}");
                                                print(
                                                    "AddConsignmentPageTwo ZipCode:${value.customerZipCodeController.text}");
                                                print(
                                                    "AddConsignmentPageTwo Country id:${value.selectedcountryid}");
                                                print(
                                                    "AddConsignmentPageTwo State id:${value.selectedStateId}");

                                                if (value.customerAddressController.text.isEmpty ||
                                                    value
                                                        .customerSuburbController
                                                        .text
                                                        .isEmpty ||
                                                    value
                                                        .customerZipCodeController
                                                        .text
                                                        .isEmpty ||
                                                    value.selectedcountryid ==
                                                        -1 ||
                                                    value.selectedStateId ==
                                                        -1) {
                                                  value.showCommonToast(
                                                      "Please fill all the details");
                                                } else {
                                                  value
                                                      .navigatetoAddConsignmentThree(
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

  clearData(Lttechprovider value) {
    value.defaultcustomername = "";
    value.customerAddressController.text = "";
    value.customerSuburbController.text = "";
    value.customerZipCodeController.text = "";
    value.selectedcountryid = -1;
    value.selectedStateId = -1;
  }
  // void setSelectedState(
  //     Lttechprovider provider, int stateID, int selectedCountryID) {
  //   List<StatesList> arrstatelist = provider.objgetallStates.data
  //       .where((element) => element.countryId == selectedCountryID)
  //       .toList();
  //   print("selectedState List:${arrstatelist.map((e) => e.stateName)}");
  //   final selectedStateID =
  //       arrstatelist.indexWhere((element) => element.id == stateID);
  //   print("selectedStateID:$selectedStateID");
  //   if (selectedStateID > -1) {
  //     if (provider.isConsignmentEdit) {
  //       provider.statesdropdownValue = arrstatelist[selectedStateID].stateName;
  //     } else {
  //       provider.selectedPickupCustomerState =
  //           arrstatelist[selectedStateID].stateName.toString();
  //     }

  //     provider.selectedStateId = arrstatelist[selectedStateID].id ?? 0;
  //     print(
  //         "provider.statesdropdownValue for edit:${provider.statesdropdownValue}");
  //     print(
  //         "provider.selectedPickupCustomerState:${provider.selectedPickupCustomerState}");

  //     // provider.setUpdateView = true;
  //   }
  // }

  // void setSelectedCountry(Lttechprovider provider, int countryID) {
  //   final selectedCountryID = provider.arrcountriesid
  //       .indexWhere((element) => element.id == countryID);
  //   if (selectedCountryID > -1) {
  //     if (provider.isConsignmentEdit) {
  //       provider.countriesdropdownValue =
  //           provider.arrcountriesid[selectedCountryID].countryName;
  //     } else {
  //       provider.selectedPickupCustomerCountry =
  //           provider.arrcountriesid[selectedCountryID].countryName.toString();
  //     }
  //     provider.selectedcountryid =
  //         provider.arrcountriesid[selectedCountryID].id ?? 0;
  //     print(
  //         "provider.countriesdropdownValue:${provider.countriesdropdownValue}");
  //     // provider.setUpdateView = true;
  //   }
  // }

  /*dynamic widget to get state as per country id*/
  Widget getstatelist(
      Lttechprovider value, int selectedcountryid, BuildContext context) {
    List<StatesList> arrstatelist = value.objgetallStates.data
        .where((element) => element.countryId == selectedcountryid)
        .toList();

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

          value.selectedPickupCustomerState = selectedvalue.toString();

          final selectedvalueindex = arrstatelist
              .indexWhere((element) => element.stateName == selectedvalue);

          if (selectedvalueindex > -1) {
            value.selectedStateId = arrstatelist[selectedvalueindex].id ?? 0;
            print("value.selectedStateId:${value.selectedStateId}");
          }
        },

        selectedItem: value.isConsignmentEdit
            ? value.statesdropdownValue.toString()
            : value.selectedPickupCustomerState.isEmpty
                ? "Select State"
                : value.selectedPickupCustomerState,
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
