import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:provider/provider.dart';

import '../../../utility/StatefulWrapper.dart';

class AddConsignmentViewPagefive extends StatelessWidget {
  AddConsignmentViewPagefive({super.key});

  TextEditingController weightController = TextEditingController();
  var _email;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoAddConsignmentFour(context);

      return true;
    }

    SizeConfig().init(context);
    return StatefulWrapper(
        onInit: () {
          final provider = Provider.of<Lttechprovider>(context, listen: false);

           if(provider.isConsignmentEdit) {
            provider.chepController.text =
                provider.consignmentByIdresponse.data!.chep.toString();
            provider.loscomController.text =
                provider.consignmentByIdresponse.data!.loscom.toString();
            provider.plainController.text =
                provider.consignmentByIdresponse.data!.plain.toString();
          }
        },
        child:
        WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              appBar: commonAppBarforConsignment(
                "Step 5 of 6",
                40,
                60,
                context,
                '/AddConsignmentViewPagefour',
              ),
              body: Consumer<Lttechprovider>(builder: (context, value, child) {
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
                            width: width * 0.71,
                            height: 2.4,
                            decoration: BoxDecoration(
                                color: ThemeColor.themeGreenColor,
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 0, right: 20, top: 10, bottom: 20),
                                width: width * 0.15,
                                height: 2.4,
                                decoration: BoxDecoration(
                                    color: ThemeColor.themeLightGrayColor,
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                              ))
                        ],
                      ),
                    ),
                    value.isConsignmentEdit?      Container(
                      margin: const EdgeInsets.only(left: 20, top: 5, bottom: 27),
                      height: 29,
                      width: width,
                      child: Text(
                        "Edit Consignment",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff000000),
                            fontFamily: 'InterBold'),
                      ),
                    ):  Container(
                      margin: const EdgeInsets.only(left: 20, top: 5, bottom: 27),
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
                    Expanded(
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
                              child: value.isLoading
                                  ? Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 150.0),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                    ThemeColor.themeLightGrayColor,
                                    color: ThemeColor.themeGreenColor,
                                  ))
                                  : Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: const Text(
                                        "Equipment",
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
                                          text: "Chep",
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
                                    Container(
                                      margin:
                                      const EdgeInsets.only(bottom: 10),
                                      child: TextFormField(
                                        autocorrect: false,
                                        keyboardType:
                                        TextInputType.text,
                                        controller: value.chepController,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor:
                                          ThemeColor.themeLightWhiteColor,
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
                                        onSaved: (String? value) {},
                                        // validator: (input) => input!.isNotEmpty
                                        //     ? null
                                        //     : "Please enter Chep",
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Loscom",
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
                                        TextInputType.text,
                                        controller: value.loscomController,
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
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                          ),
                                        ),
                                        onSaved: (String? value) {},
                                        // validator: (input) => input!.isNotEmpty
                                        //     ? null
                                        //     : "Please enter Loscom",
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Plain",
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 0, 10),
                                      child: TextFormField(
                                        autocorrect: false,
                                        keyboardType:
                                        TextInputType.text,
                                        controller: value.plainController,
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
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ThemeColor
                                                    .themeLightGrayColor),
                                          ),
                                        ),
                                        onSaved: (String? value) {},
                                        // validator: (input) => input!.isNotEmpty
                                        //     ? null
                                        //     : "Please enter Plain",
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 46,
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
                                                print(
                                                    "AddConsignmentPageFive chep:${value.chepController.text}");

                                                print(
                                                    "AddConsignmentPageFive Loscom:${value.loscomController.text}");
                                                print(
                                                    "AddConsignmentPageFive Plain:${value.plainController.text}");
                                                Provider.of<Lttechprovider>(
                                                    context,
                                                    listen: false)
                                                    .navigatetoAddConsignmentSix(
                                                    context);
                                              },
                                              child: const Text(
                                                "Next",
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
}
