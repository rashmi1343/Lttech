import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/FillTimesheet.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../entity/ApiRequests/AddTimeSheetRequest.dart';
import '../../../entity/ApiRequests/Updatetimesheetrequest.dart';
import '../../../entity/GetTimeSheetByIdResponse.dart';
import '../../../utility/SizeConfig.dart';
import '../../../utility/StatefulWrapper.dart';

class RestDetails extends StatelessWidget {
  RestDetails({Key? key}) : super(key: key);

//   @override
//   _RestDetailsState createState() => _RestDetailsState();
// }

// class _RestDetailsState extends State<RestDetails> {
 // GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  late BuildContext _providerContext;
  final ScrollController _scrollController = ScrollController();

  final textFieldFocusNode = FocusNode();

  String? _email;
  int _childContainerindex = 0;

  void clearAllTextfields(Lttechprovider provider) {
    provider.descriptionControllersArr.clear();
    provider.startTimeControllersArr.clear();
    provider.endTimeControllersArr.clear();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  addrestdetailsdata(Lttechprovider provider, BuildContext context) {
    var restDetailsObj = RestDetail();
    restDetailsObj.description = provider.objdescriptionControllers.text;
   // restDetailsObj.startTime = reststarttime.toString();
   // restDetailsObj.endTime = restendtime.toString();

   // print("reststarttime:"+reststarttime.toString());
   // print("restendtime:"+restendtime.toString());
    restDetailsObj.startTime = reststarttimenew.toString();
    restDetailsObj.endTime = restendtimenew.toString();

    print("reststarttime:"+reststarttimenew.toString());
    print("restendtime:"+restendtimenew.toString());


    provider.restDetailsDataArr.add(restDetailsObj);
    provider.getTimesheetByIdResponse.data?.restdetails?.add(Restdetail(restId:'',timesheetId:provider.getTimesheetByIdResponse.data?.timesheetId,description: restDetailsObj.description,startTime:DateTime.parse(reststarttimenew.toString()),endTime:DateTime.parse(restendtimenew.toString())));

    if(provider.isEditTimesheet) {
      var objrestdetails = updateRestDetails();
      objrestdetails.restId = '';
      objrestdetails.description = provider.objdescriptionControllers.text;
      objrestdetails.startTime =reststarttimenew.toString();
      objrestdetails.endTime = reststarttimenew.toString();
      provider.updatearrestdetail.add(objrestdetails);
      provider.updatetimesheetrequestObj.restDetails?.add(objrestdetails);

      //provider.updatetimesheetrequestObj.restDetails = provider.updatearrestdetail;
    }else {
      provider.addTimeSheetRequestObj.restDetails = provider.restDetailsDataArr;
      print(
          'AddTimeSheetRequestObj: ${provider.addTimeSheetRequestObj.toJson()}');
    }
    provider.objdescriptionControllers.clear();
    provider.objstarttimeControllers.clear();
    provider.objendtimeControllers.clear();

    Provider.of<Lttechprovider>(context,
        listen: false)
        .navigatetoJobdetail(context);

  }

  getAllRestDetailsData(Lttechprovider provider, BuildContext context) {
    if (provider.noOfChildWidgetArr.isNotEmpty) {
      provider.restDetailsDataArr = [];
      for (var i = 0; i < provider.noOfChildWidgetArr.length; i++) {
        var description = provider.descriptionControllersArr[i].text;
        var starttime = provider.startTimeControllersArr[i].text;
        var endtime = provider.endTimeControllersArr[i].text;

        var restDetailsObj = RestDetail();
        restDetailsObj.description = description;
        restDetailsObj.startTime = starttime;
        restDetailsObj.endTime = endtime;

        provider.restDetailsDataArr.add(restDetailsObj);
      }
      provider.addTimeSheetRequestObj.restDetails = provider.restDetailsDataArr;
      print(
          'AddTimeSheetRequestObj: ${provider.addTimeSheetRequestObj.toJson()}');

      // API Calling to Create Timesheet:
      // provider.addTimeSheetApiRequest(provider.addTimeSheetRequestObj, context);
    } else {}
  }

  Future _addingInitialRestDetailsCard(
      BuildContext context, Lttechprovider provider) async {
    await Future.delayed(Duration.zero, () {
      addInitialData(
        context,
        provider,
      );
    });
  }

  addInitialData(BuildContext context, Lttechprovider provider) {
    if (provider.noOfChildWidgetArr.isEmpty) {
      provider.noOfChildWidgetArr.add(childView(context, provider));
      Provider.of<Lttechprovider>(context, listen: false)
          .updateRestDetailsIntialLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoJobdetail(context);

      return true;
    }

    _providerContext = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Adding intial job detail card
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (Provider.of<Lttechprovider>(context, listen: false)
    //       .addRestDetailsIntialLoaded) {
    //     print("Build Completed Rest Details");
    //     addInitialData(
    //         context, Provider.of<Lttechprovider>(context, listen: false));
    //   }
    // });

    return StatefulWrapper(
      onInit: () {
        _addingInitialRestDetailsCard(_providerContext,
            Provider.of<Lttechprovider>(context, listen: false));



      },
      child: WillPopScope(
        // onWillPop: Platform.isAndroid ? _onWillPop : null,
        onWillPop:
        null, // Adding null because on back press we want previous data.
        child: Scaffold(
          backgroundColor: ThemeColor.themeLightWhiteColor,
          appBar: commonAppBar('/JobdetailView', Provider.of<Lttechprovider>(context, listen: false)),
          body: Consumer<Lttechprovider>(
            builder: (context, value, child) {

              clearAllTextfields(value);
              return
                Container(
                color: ThemeColor.themeLightWhiteColor,
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Form(
                  // autovalidateMode: AutovalidateMode.always,
                 //key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          bottom: 25,
                        ),
                        child: const Text(
                          "Rest Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: Platform.isIOS
                              ? SizeConfig.safeBlockVertical * 75
                              : SizeConfig.safeBlockVertical * 74,
                          child:
                          //childView(context, value)
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child:
                            childView(context, value),
                          ),
                        ),
                      ),
                Expanded(
                  child: Align(
                    child:
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    ThemeColor.themeGreenColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(6.0),
                                        side: const BorderSide(
                                            color:
                                            ThemeColor.themeGreenColor)))),
                            onPressed: () {
                            //  if (_formKey.currentState!.validate()) {
                             //   _formKey.currentState!.save();
                                //   getAllRestDetailsData(value, context);

                              if(value.objdescriptionControllers.text.length==0 || value.objstarttimeControllers.text.length==0 || value.objendtimeControllers.text.length==0) {
                                Fluttertoast.showToast(
                                    msg: "Please fill all details",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color(0xff085196),
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                              else {
                                addrestdetailsdata(value, context);
                              }

                            },
                            child: const Text(
                              'Save & Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontName.interBold,
                              ),
                            ),
                          ),
                        ))),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     childView(context, value),
                      //     Align(
                      //       alignment: Alignment.bottomCenter,
                      //       child: Container(
                      //         height: 50,
                      //         width: MediaQuery.of(context).size.width,
                      //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      //         child: ElevatedButton(
                      //           style: ButtonStyle(
                      //               backgroundColor:
                      //                   MaterialStateProperty.all<Color>(
                      //                       ThemeColor.themeGreenColor),
                      //               shape: MaterialStateProperty.all<
                      //                       RoundedRectangleBorder>(
                      //                   RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(6.0),
                      //                       side: const BorderSide(
                      //                           color: ThemeColor
                      //                               .themeGreenColor)))),
                      //           onPressed: () {
                      //             if (_formKey.currentState!.validate()) {
                      //               _formKey.currentState!.save();
                      //               getAllRestDetailsData(value, context);
                      //             } else {
                      //               Fluttertoast.showToast(
                      //                   msg: "Please fill all details",
                      //                   toastLength: Toast.LENGTH_SHORT,
                      //                   gravity: ToastGravity.BOTTOM,
                      //                   timeInSecForIosWeb: 1,
                      //                   backgroundColor:
                      //                       const Color(0xff085196),
                      //                   textColor: Colors.white,
                      //                   fontSize: 14.0);
                      //             }
                      //           },
                      //           child: const Text(
                      //             'Save & Next',
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontFamily: FontName.interBold,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String ? reststarttime;
  String ? restendtime;

  String ? reststarttimenew;
  String ? restendtimenew;
  Widget childView(BuildContext context, Lttechprovider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: provider.noOfChildWidgetArr.length,
      itemBuilder: (BuildContext ctxt, int index) {
        _childContainerindex = index;

        // provider.descriptionControllersArr.add(TextEditingController());
        // provider.startTimeControllersArr.add(TextEditingController());
        //provider.endTimeControllersArr.add(TextEditingController());
        // provider.objdescriptionControllers.clear();
        //  provider.objstarttimeControllers.clear();
        //  provider.objendtimeControllers.clear();
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(
            bottom: 15,
          ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Description",
                    textAlign: TextAlign.left,
                    style: FillTimeSheetCustomTS.tfTitleLabelTS,
                  ),
                  SizedBox(
                    width: 30,
                    // child: addRemoveButtonWidget(index, context, provider),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: TextFormField(
                  key: Key(index.toString()),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  // controller: provider.descriptionControllersArr[index],
                  controller: provider.objdescriptionControllers,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: ThemeColor.themeLightWhiteColor,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ThemeColor.themeLightGrayColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ThemeColor.themeLightGrayColor),
                    ),
                  ),
                  onSaved: (String? value) {
                    //_email = value;
                  },
                  validator: (input) =>
                  input!.isNotEmpty ? null : "Please enter description",
                ),
              ),
              SizedBox(
                // height: 90,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Start Time",
                            textAlign: TextAlign.left,
                            style: FillTimeSheetCustomTS.tfTitleLabelTS,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.datetime,
                              //    controller:
                              //      provider.startTimeControllersArr[index],
                              controller: provider.objstarttimeControllers,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  //  provider.startTimeControllersArr[index].text =
                                  //    pickedTime.format(context);
                                  // reststarttime = pickedTime;
                                 // provider.objstarttimeControllers.text =   pickedTime.format(context);
                                  provider.objstarttimeControllers.text =   pickedTime.to24hours();
                                 //   provider.objstarttimeeditControllers.text = pickedTime.to24hour();
                                  DateTime now = DateTime.now();
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                                  //   DateTime parsedTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedTime);
                                  DateTime parsedTime = DateTime.parse(formattedDate+" "+pickedTime.to24hours());

                                  print("start time12:" +parsedTime.toIso8601String()+"Z");
                                  reststarttime = parsedTime.toIso8601String()+"Z";
                                  reststarttimenew = parsedTime.toIso8601String();
                                  //set output time to TextField value.
                                  provider.setUpdateView = true;
                                  // provider.notifyListeners();
                                }
                              },
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
                                hintText: "--:-- --",
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  size: 20,
                                ),
                                suffixIconColor: Colors.grey,
                              ),
                              onSaved: (String? value) {
                                _email = value;
                              },
                              validator: (input) => input!.isNotEmpty
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "End Time",
                            textAlign: TextAlign.left,
                            style: FillTimeSheetCustomTS.tfTitleLabelTS,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.datetime,
                              // controller: provider.endTimeControllersArr[index],
                              controller: provider.objendtimeControllers,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  // provider.endTimeControllersArr[index].text =
                                  //    pickedTime.format(context);
                                 // provider.objendtimeControllers.text = pickedTime.format(context);

                                 provider.objendtimeControllers.text = pickedTime.to24hours();

                                  DateTime now = DateTime. now();
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                                  //   DateTime parsedTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedTime);
                                  DateTime parsedTime = DateTime.parse(formattedDate+" "+pickedTime.to24hours());

                                  print("end time12:" +parsedTime.toIso8601String()+"Z");
                                  restendtime = parsedTime.toIso8601String()+"Z";
                                  restendtimenew = parsedTime.toIso8601String();
                                  //set output time to TextField value.
                                  provider.setUpdateView = true;

                                }
                              },
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
                                hintText: "--:-- --",
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  size: 20,
                                ),
                                suffixIconColor: Colors.grey,
                              ),
                              onSaved: (String? value) {
                                _email = value;
                              },
                              validator: (input) => input!.isNotEmpty
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
            ],
          ),
        );
      },
    );
  }

  String formatDateTimeFromUtc(dynamic time){
    try {
      return new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e){
      return new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateTime.now());
    }
  }

  RawMaterialButton addRemoveButtonWidget(
      int index, BuildContext context, Lttechprovider provider) {
    return RawMaterialButton(
      key: Key(index.toString()),
      elevation: 0,
      onPressed: () {

        //if (_formKey.currentState!.validate()) {
          // _formKey.currentState!.save();
          //   getAllRestDetailsData(value, context);
          //addrestdetailsdata(provider,context);
          if (index == 0) {
            provider.noOfChildWidgetArr.add(childView(context, provider));
            //   provider.objdescriptionControllers.text = '';
            //   provider.objstarttimeControllers.text = '';
            //   provider.objendtimeControllers.text = '';
          //  _formKey.currentState?.reset();
            _scrollToEnd();
          } else if (provider.noOfChildWidgetArr.length > 1) {
            provider.noOfChildWidgetArr.removeAt(index);
          }
          provider.setUpdateView = true;
          print(index);
       // } else {
          Fluttertoast.showToast(
              msg: "Please fill all details",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color(0xff085196),
              textColor: Colors.white,
              fontSize: 14.0);
        //}


      },
      fillColor: Colors.white,
      child: Icon(
        _childContainerindex > 0
            ? Icons.remove_circle_outline
            : Icons.add_circle_outline,
        size: 25,
        color: _childContainerindex > 0
            ? ThemeColor.red
            : ThemeColor.themeGreenColor,
      ),
    );
  }
}


extension TimeOfDayConverter on TimeOfDay {
  String to24hour() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}