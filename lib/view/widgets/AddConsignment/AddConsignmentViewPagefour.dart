import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:lttechapp/utility/env.dart';
import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/AddConsignmentRequest.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/StatefulWrapper.dart';

class AddConsignmentViewPagefour extends StatelessWidget {
  AddConsignmentViewPagefour({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _addformKey = GlobalKey<FormState>();
  final _textformKey = GlobalKey<FormState>();
  late BuildContext _providerContext;
  final ScrollController _scrollController = ScrollController();
  int _childContainerindex = 0;

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future _addingInitialJobDetailsCard(
      BuildContext context, Lttechprovider provider) async {
    provider
        .clearAddConsignmentFourArrData(); // Removing all textfields arr data on initial.
    await Future.delayed(Duration.zero, () {
      addInitialData(
        context,
        provider,
      );
    });
  }

  addInitialData(BuildContext context, Lttechprovider provider) {
    if (provider.addNCFourNoOfChildWidgetArr.isEmpty) {
      provider.addNCFourNoOfChildWidgetArr.add(childView(context, provider));
      Provider.of<Lttechprovider>(context, listen: false)
          .updateNCFourIntialLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Lttechprovider>(context, listen: false);
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoAddConsignmentThree(context);

      return true;
    }

    _providerContext = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);

    return StatefulWrapper(
      onInit: () {
        provider.processinitialConsignmentjobdata();
        _addingInitialJobDetailsCard(_providerContext,
            Provider.of<Lttechprovider>(context, listen: false));
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: commonAppBarforConsignment(
                "Step 4 of 6", 40, 60, context, '/AddConsignmentViewPagethree'),
            body: Consumer<Lttechprovider>(builder: (context, provider, child) {
              return
                  // SingleChildScrollView(
                  //   controller: _scrollController,
                  //   child:
                  Form(
                key: _textformKey,
                child: Column(
                  children: [
                    PreferredSize(
                        preferredSize: Size.square(1.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 0, top: 10, bottom: 20),
                              width: width * 0.57,
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
                              width: width * 0.28,
                              height: 2.4,
                              decoration: BoxDecoration(
                                  color: ThemeColor.themeLightGrayColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ))
                          ],
                        )),
                    provider.isConsignmentEdit
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
                    provider.isLoading
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 150.0),
                            child: CircularProgressIndicator(
                              backgroundColor: ThemeColor.themeLightGrayColor,
                              color: ThemeColor.themeGreenColor,
                            ))
                        : provider.isConsignmentEdit
                            //For job detail consignment listing on edit consignment
                            ? Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: consignmentEditDetailsListing(
                                        context, provider)),
                              )
                            : Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: Platform.isIOS
                                      ? SizeConfig.safeBlockVertical * 75
                                      : SizeConfig.safeBlockVertical * 74,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: childView(context, provider),
                                  ),
                                ),
                              ),
                    provider.isConsignmentEdit
                        ? Align(
                            //  alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    print("update next");

                                    //   provider.getUpdateConsignmentDetails();

                                    Provider.of<Lttechprovider>(context,
                                            listen: false)
                                        .navigatetoAddConsignmentFive(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff0AAC19)),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        fontFamily: 'InterBold',
                                        fontSize: 16,
                                        color: Color(0xffffffff)),
                                  )),
                            ),
                          )
                        : Align(
                            //  alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    print("save next");
                                    //  createWidget(1);
                                    //lltechSignatureView();
                                    //  Provider.of<Lttechprovider>(context, listen: false).navigatetosignatureview(context);

                                    if (!provider.isConsignmentEdit) {
                                      getConsignmentDetails(provider);
                                    }
                                    Provider.of<Lttechprovider>(context,
                                            listen: false)
                                        .navigatetoAddConsignmentFive(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff0AAC19)),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        fontFamily: 'InterBold',
                                        fontSize: 16,
                                        color: Color(0xffffffff)),
                                  )),
                            ),
                          ),
                  ],
                ),
                // ),
              );
            })),
      ),
    );
  }

  getConsignmentDetails(Lttechprovider provider) {
    if (provider.addNCFourNoOfChildWidgetArr.isNotEmpty) {
      List<AddConsignmentDetail> consignmentDetailArr = [];
      for (var i = 0; i < provider.addNCFourNoOfChildWidgetArr.length; i++) {
        var consignmentDetailObj = AddConsignmentDetail();

        consignmentDetailObj.noOfItems =
            provider.noOfItemControllersArr[i].text.isNotEmpty
                ? provider.noOfItemControllersArr[i].text
                : "0";

        consignmentDetailObj.pallets =
            provider.palletsControllersArr[i].text.isNotEmpty
                ? provider.palletsControllersArr[i].text
                : "0";

        consignmentDetailObj.weight =
            provider.weightControllersArr[i].text.isNotEmpty
                ? provider.weightControllersArr[i].text
                : "0";

        consignmentDetailObj.spaces =
            provider.spacesControllersArr[i].text.isNotEmpty
                ? provider.spacesControllersArr[i].text
                : "0";

        consignmentDetailObj.jobTemp =
            provider.jobTempControllersArr[i].text.isNotEmpty
                ? provider.jobTempControllersArr[i].text
                : "0";

        consignmentDetailObj.recipientNo =
            provider.recipientRefNoControllersArr[i].text;
        consignmentDetailObj.sendersNo =
            provider.senderRefNoControllersArr[i].text;
        consignmentDetailObj.equipment =
            provider.equipmentControllersArr[i].text;
        consignmentDetailObj.freightDesc =
            provider.freightDescriptionControllersArr[i].text;

        consignmentDetailArr.add(consignmentDetailObj);

        print("Consignment Details Page four:${consignmentDetailObj.toJson()}");

        provider.addConsignmentRequestObj.consignmentDetails =
            consignmentDetailArr;
      }

      final consignmentDetail =
          provider.addConsignmentRequestObj.consignmentDetails ?? [];

      provider.addConsignmentRequestObj.totalItems =
          "${consignmentDetail.map((value) => int.parse(value.noOfItems ?? "")).reduce((x, y) => x + y)}";
      // }
      provider.addConsignmentRequestObj.totalPallets =
          "${consignmentDetail.map((value) => int.parse(value.pallets ?? "")).reduce((x, y) => x + y)}";
      provider.addConsignmentRequestObj.totalSpaces =
          "${consignmentDetail.map((value) => int.parse(value.spaces ?? "")).reduce((x, y) => x + y)}";

      provider.addConsignmentRequestObj.totalWeight =
          "${consignmentDetail.map((value) => int.parse(value.weight ?? "")).reduce((x, y) => x + y)}";

      FocusManager.instance.primaryFocus?.unfocus(); // Hiding Keyboard

      print(
          'AddConsignmentRequest totalItems: ${provider.addConsignmentRequestObj.totalItems}');

      print(
          'AddConsignmentRequest totalPallets: ${provider.addConsignmentRequestObj.totalPallets}');
      print(
          'AddConsignmentRequest totalSpaces: ${provider.addConsignmentRequestObj.totalSpaces}');
      print(
          'AddConsignmentRequest totalWeight: ${provider.addConsignmentRequestObj.totalWeight}');
      // }
    } else {}
  }

  Widget childView(BuildContext context, Lttechprovider provider) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print(provider.addNCFourNoOfChildWidgetArr.length);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: provider.addNCFourNoOfChildWidgetArr.length,
      itemBuilder: (BuildContext ctxt, int index) {
        _childContainerindex = index;

        provider.noOfItemControllersArr.add(TextEditingController());
        provider.palletsControllersArr.add(TextEditingController());
        provider.spacesControllersArr.add(TextEditingController());

        provider.weightControllersArr.add(TextEditingController());
        provider.jobTempControllersArr.add(TextEditingController());
        provider.recipientRefNoControllersArr.add(TextEditingController());

        provider.senderRefNoControllersArr.add(TextEditingController());
        provider.equipmentControllersArr.add(TextEditingController());
        provider.freightDescriptionControllersArr.add(TextEditingController());

        return Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
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
          width: double.infinity,

          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 20),
                width: width,
                child: Text(
                  "Job Details",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontFamily: 'InterBold'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "No of Items",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              controller:
                                  provider.noOfItemControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter no. of items",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Pallets",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              controller: provider.palletsControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Pallets",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Spaces",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              controller: provider.spacesControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Spaces",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Weight (KG)",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              controller: provider.weightControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Weight (KG)",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Job Temp",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              controller: provider.jobTempControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Job Temp",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Recipient Ref No.",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              controller:
                                  provider.recipientRefNoControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Recipient Ref No.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Senders Ref No.",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              controller:
                                  provider.senderRefNoControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Senders Ref No.",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Equipment",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                  fontFamily: 'InterRegular'),
                              // children: const [
                              //   TextSpan(
                              //       text: '*',
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ))
                              // ]
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              controller:
                                  provider.equipmentControllersArr[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: ThemeColor.themeLightWhiteColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColor.themeLightGrayColor),
                                ),
                              ),
                              onSaved: (String? value) {
                                //_email = value;
                              },
                              // validator: (input) => input!.isNotEmpty
                              //     ? null
                              //     : "Please enter Equipment",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Freight Description",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff666666),
                            fontFamily: 'InterRegular'),
                        // children: const [
                        //   TextSpan(
                        //       text: '*',
                        //       style: TextStyle(
                        //         color: Colors.red,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w500,
                        //       ))
                        // ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: TextFormField(
                        key: Key(index.toString()),
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        controller:
                            provider.freightDescriptionControllersArr[index],
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: ThemeColor.themeLightWhiteColor,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeColor.themeLightGrayColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeColor.themeLightGrayColor),
                          ),
                        ),
                        onSaved: (String? value) {
                          //_email = value;
                        },
                        // validator: (input) => input!.isNotEmpty
                        //     ? null
                        //     : "Please enter Freight Description",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: addRemoveButtonWidget(index, context, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton addRemoveButtonWidget(
      int index, BuildContext context, Lttechprovider provider) {
    return ElevatedButton.icon(
      key: Key(index.toString()),
      icon: Icon(
        _childContainerindex > 0
            ? Icons.remove_circle_outline
            : Icons.add_circle_outline,
        size: 18,
        color: _childContainerindex > 0
            ? ThemeColor.red
            : ThemeColor.themeGreenColor,
      ),
      onPressed: () {
        if (index == 0) {
          provider.addNCFourNoOfChildWidgetArr
              .add(childView(context, provider));
          _scrollToEnd();
        } else if (provider.addNCFourNoOfChildWidgetArr.length > 1) {
          provider.addNCFourNoOfChildWidgetArr.removeAt(index);
        }
        provider.setUpdateView = true;
        print(index);
      },
      label: Text(
        _childContainerindex > 0
            ? 'Remove Job Details'
            : 'Add More Job Details',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: FontName.interMedium,
          fontSize: 16,
          color: _childContainerindex > 0
              ? ThemeColor.red
              : ThemeColor.themeGreenColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _childContainerindex > 0
            ? ThemeColor.red
            : ThemeColor.themeGreenColor,
        elevation: 0,
      ),
    );
  }

  //For Adding job detail in Edit Consignment
  addNewjobdetailDialog(
      int index, BuildContext context, Lttechprovider provider) {
    provider.clearAddConsignmentOnEdit();
    double width = MediaQuery.of(context).size.width;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 18.0,
                    ),
                    margin: EdgeInsets.only(top: 13.0, right: 8.0),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffEEEEEE),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _addformKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //  mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, bottom: 5),
                              alignment: Alignment.center,
                              child: Text(
                                "Add Job Detail",
                                style: TextStyle(
                                    fontFamily: 'InterBold',
                                    fontSize: 16,
                                    color: Color(0xff000000)),
                                textAlign: TextAlign.left,
                              ),
                            )),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "No of Items",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: 'InterRegular'),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 10, top: 10),
                                      alignment: Alignment.topLeft,
                                      child: Text("Pallets",
                                          style: TextStyle(
                                              fontFamily: 'InterRegular',
                                              fontSize: 14,
                                              color: Color(0xff666666)))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          bottom: 10,
                                          right: 5,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: provider.itemsController,
                                          // controller: provider.noOfItemControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          )))),
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          bottom: 10,
                                          right: 20,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              provider.palletsController,
                                          // provider.palletsControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          ))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Spaces",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: 'InterRegular'),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 10, top: 10),
                                      alignment: Alignment.topLeft,
                                      child: Text("Weight (KG)",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          bottom: 10,
                                          right: 5,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: provider.spacesController,
                                          // controller: provider.spacesControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          )))),
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          bottom: 10,
                                          right: 20,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              provider.weighttController,
                                          // provider.weightControllerArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          ))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Job Temp",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: 'InterRegular'),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 10, top: 10),
                                      alignment: Alignment.topLeft,
                                      child: Text("Recipient Ref No",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                              fontFamily: 'InterRegular'))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          bottom: 10,
                                          right: 5,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller:
                                              provider.jobTempController,
                                          // provider.jobTempControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          )))),
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          bottom: 10,
                                          right: 20,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller:
                                              provider.recipientRefController,
                                          // provider.recipientRefNoControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          ))))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Senders Ref No",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: 'InterRegular'),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 10, top: 10),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Equipment",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff666666),
                                            fontFamily: 'InterRegular'),
                                      )))
                            ]),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          bottom: 10,
                                          right: 5,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller:
                                              provider.sendersRefController,
                                          //   provider.senderRefNoControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          )))),
                              Expanded(
                                  child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          bottom: 10,
                                          right: 20,
                                          top: 5),
                                      alignment: Alignment.topLeft,
                                      child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller:
                                              provider.equipmentController,
                                          // provider.equipmentControllersArr[index],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xffFAFAFA),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeColor
                                                      .themeLightGrayColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffD4D4D4),
                                                  width: 1.0),
                                            ),
                                            hintText: '',
                                          ))))
                            ]),
                            Flexible(
                                child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 20),
                                    alignment: Alignment.topLeft,
                                    child: Text("Freight Description",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff666666),
                                            fontFamily: 'InterRegular')))),
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
                                        keyboardType: TextInputType.text,
                                        controller:
                                            provider.freightDescController,
                                        // provider.freightDescriptionControllersArr[index],
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xffFAFAFA),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffD4D4D4),
                                                width: 1.0),
                                          ),
                                          hintText: '',
                                        )))),
                            Flexible(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.060,
                                    margin: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 20,
                                        right: 20),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          print("add job detail");
                                          provider.addJobDetailConsignmentArr(
                                              index);
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff0AAC19)),
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              fontFamily: 'InterBold',
                                              fontSize: 16,
                                              color: Color(0xffffffff)),
                                        )))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: ThemeColor.themeGreenColor,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// Dialog box for editing job detail on selected index
  Future editDetailsDialog(
      BuildContext context, Lttechprovider provider, int index) async {
    provider.noOfItemControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].noOfItems
        .toString();
    provider.palletsControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].pallets
        .toString();
    provider.spacesControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].spaces
        .toString();
    provider.weightControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].weight
        .toString();
    provider.jobTempControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].jobTemp
        .toString();
    provider.recipientRefNoControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].recipientNo
        .toString();
    provider.senderRefNoControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].sendersNo
        .toString();
    provider.equipmentControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].equipment
        .toString();
    provider.freightDescriptionControllersArr[index].text = provider
        .consignmentByIdresponse.data!.consignmentDetails[index].freightDesc
        .toString();

    await Future.delayed(Duration.zero, () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 18.0,
                      ),
                      margin: EdgeInsets.only(top: 13.0, right: 8.0),
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffEEEEEE),
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: Container(
                                  margin: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit Job Detail",
                                    style: TextStyle(
                                        fontFamily: 'InterBold',
                                        fontSize: 16,
                                        color: Color(0xff000000)),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "No of Items",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff666666),
                                          fontFamily: 'InterRegular'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 10, top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text("Pallets",
                                              style: TextStyle(
                                                  fontFamily: 'InterRegular',
                                                  fontSize: 14,
                                                  color: Color(0xff666666)))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 5,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              onChanged: (val) {
                                                print(val);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: provider
                                                      .noOfItemControllersArr[
                                                  index],
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
                                                hintText: '',
                                              )))),
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: provider
                                                  .palletsControllersArr[index],
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
                                                hintText: '',
                                              ))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Spaces",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff666666),
                                          fontFamily: 'InterRegular'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 10, top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text("Weight (KG)",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff666666),
                                                  fontFamily: 'InterRegular'))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 5,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: provider
                                                  .spacesControllersArr[index],
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
                                                hintText: '',
                                              )))),
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: provider
                                                  .weightControllersArr[index],
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
                                                hintText: '',
                                              ))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Job Temp",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff666666),
                                          fontFamily: 'InterRegular'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 10, top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text("Recipient Ref No",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff666666),
                                                  fontFamily: 'InterRegular'))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 5,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: provider
                                                  .jobTempControllersArr[index],
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
                                                hintText: '',
                                              )))),
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: provider
                                                      .recipientRefNoControllersArr[
                                                  index],
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
                                                hintText: '',
                                              ))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Senders Ref No",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff666666),
                                          fontFamily: 'InterRegular'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 10, top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Equipment",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular'),
                                          )))
                                ]),
                                Row(children: [
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 5,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: provider
                                                      .senderRefNoControllersArr[
                                                  index],
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
                                                hintText: '',
                                              )))),
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              bottom: 10,
                                              right: 20,
                                              top: 5),
                                          alignment: Alignment.topLeft,
                                          child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: provider
                                                      .equipmentControllersArr[
                                                  index],
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
                                                hintText: '',
                                              ))))
                                ]),
                                Flexible(
                                    child: Container(
                                        margin:
                                            EdgeInsets.only(left: 20, top: 20),
                                        alignment: Alignment.topLeft,
                                        child: Text("Freight Description",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff666666),
                                                fontFamily: 'InterRegular')))),
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
                                            keyboardType: TextInputType.text,
                                            controller: provider
                                                    .freightDescriptionControllersArr[
                                                index],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xffFAFAFA),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeColor
                                                        .themeLightGrayColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffD4D4D4),
                                                    width: 1.0),
                                              ),
                                              hintText: '',
                                            )))),
                                Flexible(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.060,
                                        margin: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 20,
                                            right: 20),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              print("update edit");
                                              provider
                                                  .updateConsignmentArr(index);
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xff0AAC19)),
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                  fontFamily: 'InterBold',
                                                  fontSize: 16,
                                                  color: Color(0xffffffff)),
                                            )))),
                              ],
                            ),
                          )),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: ThemeColor.themeGreenColor,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }

//Job details listing in Edit consignment
  Widget consignmentEditDetailsListing(
      BuildContext context, Lttechprovider provider) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              key: Key(index.toString()),
              icon: Icon(
                Icons.add_circle_outline,
                size: 18,
                color: ThemeColor.themeGreenColor,
              ),
              onPressed: () {
                addNewjobdetailDialog(index, context, provider);
                provider.setUpdateView = true;
                print(index);
              },
              label: Text(
                'Add More Job Details',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: FontName.interMedium,
                  fontSize: 16,
                  color: ThemeColor.themeGreenColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: ThemeColor.themeGreenColor,
                elevation: 0,
              ),
            )),
        Expanded(
          child: Container(
            height: Platform.isIOS
                ? null //SizeConfig.safeBlockVertical * 70
                : SizeConfig.safeBlockVertical * 70,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    height: Platform.isIOS
                        ? SizeConfig.safeBlockVertical * 57
                        : SizeConfig.safeBlockVertical * 60,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: provider.consignmentByIdresponse.data
                                ?.consignmentDetails.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          provider.noOfItemControllersArr
                              .add(TextEditingController());
                          provider.palletsControllersArr
                              .add(TextEditingController());
                          provider.spacesControllersArr
                              .add(TextEditingController());
                          provider.weightControllersArr
                              .add(TextEditingController());
                          provider.jobTempControllersArr
                              .add(TextEditingController());
                          provider.recipientRefNoControllersArr
                              .add(TextEditingController());
                          provider.senderRefNoControllersArr
                              .add(TextEditingController());
                          provider.equipmentControllersArr
                              .add(TextEditingController());
                          provider.freightDescriptionControllersArr
                              .add(TextEditingController());
                          /*  if(provider.initiallistvalue==0) {
                            provider.updateconsignmentDetailArr.add(
                                ConsignmentDetails(
                                    consignmentDetailsId: provider
                                        .consignmentByIdresponse.data
                                        ?.consignmentDetails[index]
                                        .consignmentDetailsId,
                                    noOfItems: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].noOfItems,
                                    freightDesc: provider
                                        .consignmentByIdresponse.data
                                        ?.consignmentDetails[index].freightDesc,
                                    pallets: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].pallets,
                                    spaces: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].spaces,
                                    weight: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].weight,
                                    jobTemp: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].jobTemp,
                                    recipientNo: provider
                                        .consignmentByIdresponse.data
                                        ?.consignmentDetails[index].recipientNo,
                                    sendersNo: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].sendersNo,
                                    equipment: provider.consignmentByIdresponse
                                        .data
                                        ?.consignmentDetails[index].equipment));

                          }*/
                          var jobdetailindex = index + 1;

                          return Container(
                            margin: EdgeInsets.all(10),
                            height: Platform.isIOS
                                ? null
                                : SizeConfig.safeBlockVertical * 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xffEEEEEE),
                                  blurRadius: 3.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ThemeColor.themeLightGrayColor,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Container(
                                      margin: EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        " $jobdetailindex. Job Detail",
                                        style: TextStyle(
                                          fontFamily: 'InterBold',
                                          fontSize: 16,
                                          color: ThemeColor.themeGreenColor,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                                    GestureDetector(
                                      onTap: () {
                                        print('Edit Button Pressed');
                                        print("edit dialog call :" +
                                            index.toString());
                                        print("item len: " +
                                            provider
                                                .noOfItemControllersArr.length
                                                .toString());

                                        editDetailsDialog(
                                            context, provider, index);
                                      },
                                      child: Container(
                                        width: 40,
                                        margin: EdgeInsets.only(
                                            left: 0,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Icon(
                                          Icons.edit,
                                          color: ThemeColor.themeGreenColor,
                                          size: 20.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 18, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "No of Items",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        (provider
                                                    .consignmentByIdresponse
                                                    .data!
                                                    .consignmentDetails[index]
                                                    .noOfItems ??
                                                0)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Freight Description",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Platform.isAndroid
                                          ? Text(
                                              provider
                                                      .consignmentByIdresponse
                                                      .data!
                                                      .consignmentDetails[index]
                                                      .freightDesc ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff000000),
                                                  fontFamily: 'InterRegular'),
                                            )
                                          : Flexible(
                                              // For iOS
                                              flex: 1,
                                              child: Text(
                                                provider
                                                        .consignmentByIdresponse
                                                        .data!
                                                        .consignmentDetails[
                                                            index]
                                                        .freightDesc ??
                                                    "",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff000000),
                                                    fontFamily: 'InterRegular'),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Pallets",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        (provider
                                                    .consignmentByIdresponse
                                                    .data!
                                                    .consignmentDetails[index]
                                                    .pallets ??
                                                0)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Spaces",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        (provider
                                                    .consignmentByIdresponse
                                                    .data!
                                                    .consignmentDetails[index]
                                                    .spaces ??
                                                0)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Weight(KG)",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        (provider
                                                    .consignmentByIdresponse
                                                    .data!
                                                    .consignmentDetails[index]
                                                    .weight ??
                                                0)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Job Temp",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        provider
                                                .consignmentByIdresponse
                                                .data!
                                                .consignmentDetails[index]
                                                .jobTemp ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Recipient Ref No.",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        provider
                                                .consignmentByIdresponse
                                                .data!
                                                .consignmentDetails[index]
                                                .recipientNo ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Senders Ref No.",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        provider
                                                .consignmentByIdresponse
                                                .data!
                                                .consignmentDetails[index]
                                                .sendersNo ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 10, right: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Equipment",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                              fontFamily: 'InterMedium'),
                                        ),
                                      ),
                                      Text(
                                        provider
                                                .consignmentByIdresponse
                                                .data!
                                                .consignmentDetails[index]
                                                .equipment ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                            fontFamily: 'InterRegular'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
