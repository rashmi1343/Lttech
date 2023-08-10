import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:lttechapp/utility/env.dart';

import 'package:provider/provider.dart';

import '../../entity/ApiRequests/SubmitDriverFitnessRequest.dart';
import '../../utility/StatefulWrapper.dart';


class FitnessCheckList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var lltechprovider = Provider.of<Lttechprovider>(context,
        listen: false);
    Future<bool> _onWillPop() async {
      print("back called");
      lltechprovider
      // .navigatetofilltimesheet(context);
          .navigatetoJobdetail(context);
      return true;
    }
    return
      StatefulWrapper(
          onInit: () {

            print("Init called of fitnesschecklist");
            lltechprovider.objdriverfitnessdata.checklisttype='2';
            lltechprovider.objdriverfitnessdata.timesheetid = lltechprovider.slectedTimesheetID;
            lltechprovider.objdriverfitnessdata.companyid = Environement.companyID;
            lltechprovider.objdriverfitnessdata.driverid = Environement.driverID;
            lltechprovider.objdriverfitnessdata.checklistdate =  DateFormat("yyyy-MM-dd")
                .format(DateTime.now());
            lltechprovider.objitemfitnessdata = [];



          },
          child:
          WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Color(0xffFAFAFA),
               // appBar: commonAppBar( '/FillTimesheet',Provider.of<Lttechprovider>(context, listen: false)),
                appBar: commonAppBar('/JobdetailView', Provider.of<Lttechprovider>(context, listen: false)),
                body: Consumer<Lttechprovider>(builder: (context, value, child) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 18, top: 32, bottom: 27, right: 154),
                        height: 29,
                        width: 203,
                        child: Text(
                          "Fitness Checklist",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff000000),
                              fontFamily: 'InterBold'),
                        ),
                      ),
                      Expanded(
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
                                  child: getfitnesslist(value, context)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 18, bottom: 45, right: 19, top: 30),
                        height: 46,
                        width: 336,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              value.isviewtimesheet?
                              MaterialStateProperty
                                  .resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states
                                      .contains(MaterialState.pressed)) {
                                    return Color(0xffD4D4D4);
                                  }
                                  return Color(0xffD4D4D4);
                                },
                              )
                                  :
                              MaterialStateProperty
                                  .resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states
                                      .contains(MaterialState.pressed)) {
                                    return Color(0xff8d8d8d12);
                                  }
                                  return Color(0xff0AAC19);
                                },
                              ),
                            ),
                            onPressed: () {
                              /*  Provider.of<Lttechprovider>(context,
                                  listen: false)
                                  .navigatetofilltimesheet(context);
                            */

                              if(!value.isviewtimesheet) {
                                print('value.arrfitnesschklist:${value
                                    .arrfitnesschklist.length}');
                                value.arrfitnesschklist.forEach((element) {
                                  print('fitnessdata:${element
                                      .toJson()}::Yes${element
                                      .isYes}::No${element.isNo}');

                                  driverfitnessdata objdriverfitness = driverfitnessdata(
                                      checklistid: element.id,
                                      checklistname: element.checklistName,
                                      checklist_value: element.isYes
                                          ? 1
                                          : 0);

                                  value.objitemfitnessdata.add(
                                      objdriverfitness);
                                });

                                value.objdriverfitnessdata.checklistvalue =
                                    value.objitemfitnessdata;
                                print('objdriverfitnessdata:${value
                                    .objdriverfitnessdata.toJson()}');

                                value.submitdriverfitnessprovider(
                                    '2', context);
                              }

                            },
                            child: const Text(
                              "Save & Next",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'InterSemiBold',
                              ),
                            )),
                      )
                    ],
                  );
                })),
          ));
  }





  Widget getfitnesslist(Lttechprovider value, BuildContext context) {

    //  value.fitnesschecklistpst = value.fitnesschecklistpst +1;
    //  print("fitnesschecklistpst: "+value.fitnesschecklistpst.toString());

    return Column(
        key: UniqueKey(),
        //  children: value.arrfitnesschklist.map((e) => value.createfitnesschecklistitem(context,e)).toList());
        children: value.arrfitnesschklist.map((e) => value.createfitnesschecklistitem(context,e)).toList());
  }




}
