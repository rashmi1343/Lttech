
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/FillTimesheet.dart';
import 'package:lttechapp/view/widgets/FillTimesheet/RestDetails.dart';
import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/AddTimeSheetRequest.dart';
import '../../../entity/ApiRequests/Updatetimesheetrequest.dart';
import '../../../entity/GetTimeSheetByIdResponse.dart';
import '../../../presenter/Lttechprovider.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/SizeConfig.dart';
import '../../../utility/StatefulWrapper.dart';
import '../../../utility/appbarWidget.dart';
import '../../../utility/env.dart';
import 'dart:io' show Platform;


class EditRestDetails extends StatelessWidget {

  final int indexrestdetail;
  final Restdetail? restdetail;

  EditRestDetails({
    required this.indexrestdetail,
    required this.restdetail,
  });

  //static final _formKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  late BuildContext _providerContext;

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
      provider.noOfChildWidgetArr.add(childViewedit(context, provider, Environement.restdetail));
      Provider.of<Lttechprovider>(context, listen: false)
          .updateRestDetailsIntialLoaded = true;
    }
  }
  double width=0.0;
  double height = 0.0;
  int cntcounter=0;
  late  TextEditingController objdescriptioneditControllers;
  late  TextEditingController objstarttimeeditControllers;
  late  TextEditingController objendtimeeditControllers;

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetoJobdetail(context);

      return true;
    }
    _providerContext = context;



    return StatefulWrapper(
      onInit: () {

        objdescriptioneditControllers = TextEditingController();
        objstarttimeeditControllers = TextEditingController();
        objendtimeeditControllers = TextEditingController();



        _addingInitialRestDetailsCard(_providerContext,
            Provider.of<Lttechprovider>(context, listen: false));

        /*width = MediaQuery.of(context).size.width;
        height = MediaQuery.of(context).size.height;
        print("width:"+width.toString());
        print("height:"+height.toString());*/

        print("position:"+indexrestdetail.toString());
        var dt = SizeConfig.safeBlockVertical * 74;
        print("sizeconfig:"+dt.toString());

      },
      child: WillPopScope(
        // onWillPop: Platform.isAndroid ? _onWillPop : null,
        onWillPop:
        null, // Adding null because on back press we want previous data.
        child: Scaffold(
          backgroundColor: ThemeColor.themeLightWhiteColor,
          appBar: commonAppBar('/JobdetailView',Provider.of<Lttechprovider>(context, listen: false)),
          body: Consumer<Lttechprovider>(

            builder: (context, value, child) {
              clearrestdetailview(value);
              return Container(
                color: ThemeColor.themeLightWhiteColor,
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Form(
                  // autovalidateMode: AutovalidateMode.always,
                  //    key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            /* SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              child:  childViewedit(context, value,Environement.restdetail),
                            )*/
                            childViewedit(context, value,Environement.restdetail)
                        ),
                      ),
                      Expanded(
                          child:
                          Align(
                            // alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 50,
                              width: double.infinity,
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
                                  /*  if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                //   getAllRestDetailsData(value, context);
                                // addrestdetailsdata(value,context);
                                updaterestdetail(Environement.indexrestdetail, value,context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill all details",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color(0xff085196),
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }*/
                                  updaterestdetail(Environement.indexrestdetail, value,context);
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontName.interBold,
                                  ),
                                ),
                              ),
                            ),
                          )),
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


  void clearrestdetailview(Lttechprovider provider) {
    objdescriptioneditControllers.clear();
    objstarttimeeditControllers.clear();
    objendtimeeditControllers.clear();
  }

  String ? reststartedittime ='';
  String ? restendedittime ='';
  bool isstarttimeupdated=false;
  bool isendtimeupdated=false;
  String ? restresettime = '';
  String ? restresetendtime = '';
  //final _textformKey = GlobalKey<FormState>();
  Widget childViewedit(BuildContext context, Lttechprovider provider, Restdetail? restdetail) {


    print("childviewedit called:"+provider.noOfChildWidgetArr.length.toString());
    objdescriptioneditControllers.text = Environement.restdetail!.description.toString();

    if(isstarttimeupdated) {

      print("isstarttimeupdated:"+isstarttimeupdated.toString()+restresettime.toString());

      List<String> splitedstartresttime = restresettime.toString().split(" ");
      //provider.objstarttimeeditControllers.text = restresettime.toString();
      List<String> processstartresttime =splitedstartresttime[1].split(".");
      objstarttimeeditControllers.text = processstartresttime[0];
    }else {

      List<String> strstarttime =   Environement.restdetail!.startTime.toString().split(" ");
      objstarttimeeditControllers.text =
        //  Environement.restdetail!.startTime.toString();
      strstarttime[1].split(".").first;
      // DateFormat.jm().format(
      //   DateTime.parse(Environement.restdetail!.startTime.toString()));

      print("isstarttimeupdated:"+isstarttimeupdated.toString()+objstarttimeeditControllers.text);

    }

    if(isendtimeupdated) {
      print("isendtimeupdated:"+isendtimeupdated.toString()+restresetendtime.toString());

      List<String> splitedendresttime = restresetendtime.toString().split(" ");
      List<String> processendresttime = splitedendresttime[1].split(".");
      objendtimeeditControllers.text = processendresttime[0];
      //provider.objendtimeeditControllers.text =
      //  restresetendtime.toString();
    }else {
      List<String> strendtime =   Environement.restdetail!.endTime.toString().split(" ");

      objendtimeeditControllers.text = strendtime[1].split(".").first;
      print("isendtimeupdated:"+isendtimeupdated.toString()+objendtimeeditControllers.text);
    }




    objdescriptioneditControllers.selection =
        TextSelection.collapsed(offset: objdescriptioneditControllers.text.length);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: provider.noOfChildWidgetArr.length,
      itemBuilder: (BuildContext ctxt, int index) {
        // _childContainerindex = index;

        // provider.descriptionControllersArr.add(TextEditingController());
        // provider.startTimeControllersArr.add(TextEditingController());
        //provider.endTimeControllersArr.add(TextEditingController());

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
                  //key: Key(index.toString()),
                  //  key: _textformKey,
                  autocorrect: false,

                  keyboardType: TextInputType.text,
                  // controller: provider.descriptionControllersArr[index],
                  controller: objdescriptioneditControllers,
                  onFieldSubmitted: (_) => FocusScope.of(ctxt).nextFocus(),
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
                width: double.infinity,
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
                              key: Key(index.toString()),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              //   initialValue: DateFormat.jm().format(DateTime.parse(Environement.restdetail!.startTime.toString())),
                              //    controller:
                              //      provider.startTimeControllersArr[index],
                              controller: objstarttimeeditControllers,
                              textInputAction: TextInputAction.next,

                              // readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  //  provider.startTimeControllersArr[index].text =
                                  //    pickedTime.format(context);
                                  objstarttimeeditControllers.text =  pickedTime.format(context);
                                  print("inside picketime");
                                  // provider.objstarttimeeditControllers.text =  pickedTime.to24hours();
                                  restresettime =  pickedTime.format(context);
                                  DateTime now = DateTime.now();
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                  DateTime parsedTime = DateTime.parse(formattedDate+" "+pickedTime.to24hours());
                                  restresettime = parsedTime.toString();
                                  print("startedittime12:" +parsedTime.toIso8601String()+"Z");
                                  //set output time to TextField value.
                                  reststartedittime = parsedTime.toIso8601String()+"Z";
                                  provider.setUpdateView = true;
                                  isstarttimeupdated =true;
                                  provider.notifyListeners();
                                }
                                else {
                                  isstarttimeupdated = false;
                                }
                                //  provider.objstarttimeeditControllers.text =  pickedTime!.to24hours();

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
                                //  _email = value;
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
                              controller: objendtimeeditControllers,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: ctxt,
                                );

                                if (pickedTime != null) {
                                  // provider.endTimeControllersArr[index].text =
                                  //    pickedTime.format(context);
                                  // provider.objendtimeeditControllers.text = pickedTime.to24hours();
                                  objendtimeeditControllers.text =  pickedTime.format(context);
                                  restresetendtime = pickedTime.format(context);
                                  DateTime now = DateTime. now();
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                  DateTime parsedTime = DateTime.parse(formattedDate+" "+pickedTime.to24hours());
                                  restresetendtime = parsedTime.toString();
                                  print("startedittime12:" +parsedTime.toIso8601String()+"Z");
                                  //set output time to TextField value.
                                  restendedittime = parsedTime.toIso8601String()+"Z";
                                  //set output time to TextField value.
                                  provider.setUpdateView = true;
                                  isendtimeupdated = true;
                                }
                                else {
                                  isendtimeupdated = false;
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
                                // _email = value;
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

  void updaterestdetail(int indexrestdetail, Lttechprovider value,BuildContext context) {

    print("index:"+indexrestdetail.toString());

    if(value.restDetailsDataArr.length>0) {
      value.restDetailsDataArr[indexrestdetail].description =
          objdescriptioneditControllers.text;
      //  value.restDetailsDataArr[indexrestdetail].startTime =
      // objstarttimeeditControllers.text;
      //value.restDetailsDataArr[indexrestdetail].endTime =
      //objendtimeeditControllers.text;

      value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail].description = objdescriptioneditControllers.text;
      value.updatetimesheetrequestObj.restDetails?[indexrestdetail].description = objdescriptioneditControllers.text;

      if(isstarttimeupdated) {
        value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail]
            .startTime = DateTime.parse(reststartedittime.toString());
        value.restDetailsDataArr[indexrestdetail].startTime =reststartedittime;
        value.updatetimesheetrequestObj.restDetails?[indexrestdetail].startTime = reststartedittime;

      }
      if(isendtimeupdated) {
        value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail]
            .endTime = DateTime.parse(restendedittime.toString());
        value.restDetailsDataArr[indexrestdetail].endTime =
        //objendtimeeditControllers.text;
        restendedittime;
        value.updatetimesheetrequestObj.restDetails?[indexrestdetail].endTime = restendedittime;
      }
      value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail].restId = value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail].restId;
      value.getTimesheetByIdResponse.data?.restdetails?[indexrestdetail].timesheetId = value.getTimesheetByIdResponse.data?.timesheetId;

      if(value.isEditTimesheet) {
        var objrestdetails = updateRestDetails();
        objrestdetails.restId = '';
        objrestdetails.description =  value.restDetailsDataArr[indexrestdetail].description;
        objrestdetails.startTime =value.restDetailsDataArr[indexrestdetail].startTime;
        objrestdetails.endTime =  value.restDetailsDataArr[indexrestdetail].endTime;
        value.updatearrestdetail.add(objrestdetails);
        //  value.updatetimesheetrequestObj.restDetails = value.updatearrestdetail;
        //value.updatetimesheetrequestObj.restDetails = value.getTimesheetByIdResponse.data?.restdetails;
      }

      Provider.of<Lttechprovider>(context,
          listen: false)
          .navigatetoJobdetail(context);
    }
    else{
      print("empty");
      if(!value.isEditTimesheet) {
        var restDetailsObj = RestDetail();
        restDetailsObj.description = objdescriptioneditControllers.text;
        restDetailsObj.startTime = objstarttimeeditControllers.text;
        restDetailsObj.endTime = objendtimeeditControllers.text;
        value.restDetailsDataArr.add(restDetailsObj);
        value.getTimesheetByIdResponse.data?.restdetails?.add(Restdetail(
            restId: '',
            timesheetId: value.getTimesheetByIdResponse.data?.timesheetId,
            description: restDetailsObj.description,
            startTime: DateTime.parse(reststartedittime.toString()),
            endTime: DateTime.parse(restendedittime.toString())));
        value.addTimeSheetRequestObj.restDetails = value.restDetailsDataArr;
      }
      else {
        var objrestdetails = updateRestDetails();
        objrestdetails.restId = '';
        objrestdetails.description =  objdescriptioneditControllers.text;
        objrestdetails.startTime =  objstarttimeeditControllers.text;
        objrestdetails.endTime = objendtimeeditControllers.text;
        value.updatearrestdetail.add(objrestdetails);
        value.updatetimesheetrequestObj.restDetails = value.updatearrestdetail;
      }
      Provider.of<Lttechprovider>(context,
          listen: false)
          .navigatetoJobdetail(context);

    }
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
  int _childContainerindex = 0;
  RawMaterialButton addRemoveButtonWidget(
      int index, BuildContext context, Lttechprovider provider) {
    return RawMaterialButton(
      key: Key(index.toString()),
      elevation: 0,
      onPressed: () {

        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          //   getAllRestDetailsData(value, context);
          //addrestdetailsdata(provider,context);
          if (index == 0) {
            Restdetail restdetail = Restdetail();
            provider.noOfChildWidgetArr.add(childViewedit(context, provider,restdetail));
            _scrollToEnd();
          } else if (provider.noOfChildWidgetArr.length > 1) {
            provider.noOfChildWidgetArr.removeAt(index);
          }
          provider.setUpdateView = true;
          print(index);
        } else {
          Fluttertoast.showToast(
              msg: "Please fill all details",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color(0xff085196),
              textColor: Colors.white,
              fontSize: 14.0);
        }


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