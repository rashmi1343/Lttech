import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/SubmitVehicleFitnessRequest.dart';
import '../../../entity/FitnessVehicleChecklistApiResponse.dart';
import '../../../presenter/Lttechprovider.dart';
import '../../../router/routes.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/StatefulWrapper.dart';
import '../../../utility/appbarWidget.dart';
import '../../../utility/env.dart';

// vehicle
class VehicleChecklist extends StatelessWidget {
  VehicleChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    var providervalue = Provider.of<Lttechprovider>(context, listen: false);
    // print(
    //     'providervalue.vehicleChecklistDataArr: ${providervalue.vehicleChecklistDataArr}');
    Future<bool> onWillPop() async {
      print("back called");
      //Provider.of<Lttechprovider>(context, listen: false)
      providervalue
      //  .navigatetofilltimesheet(context);
          .navigatetoJobdetail(context);
      return true;
    }

    return
      StatefulWrapper(
          onInit: () {

            // Provider.of<Lttechprovider>(context, listen: false).getchecklistapi("2");
            providervalue.isallselect = [];
            providervalue.objvehiclefitnessdata.timesheetid = providervalue.slectedTimesheetID;

            providervalue.objvehiclefitnessdata.driverid = Environement.driverID;
            providervalue.objvehiclefitnessdata.companyid = Environement.companyID;
            providervalue.objvehiclefitnessdata.checklisttype = '1';
            providervalue.objvehiclefitnessdata.checklistdate = DateFormat("yyyy-MM-dd")
                .format(DateTime.now());
            providervalue.objvehiclefitnessdata.checklistvalue = [];

            providervalue.arrvehiclechklist.forEach((element) {

              List<subcategoriesdata> arrsubcat = [];
              if(element.subcategories.isEmpty) {
                arrsubcat = [];
              }else {
                element.subcategories.forEach((element) {
                  arrsubcat.add(subcategoriesdata(id: element.id,
                      checklistname: element.checklistname,
                      checklistvalue: element.checklistvalue));
                });
              }
              providervalue.isallselect.add(false);
              providervalue.objvehiclefitnessdata.checklistvalue.add(vehiclefitnessdata(checklistid: element.id, checklistname: element.checklistName, subcategories: arrsubcat,description: element.description.toString()));
            });
          },
          child:
          WillPopScope(
            onWillPop: onWillPop,
            child: Scaffold(
              backgroundColor: ThemeColor.themeLightWhiteColor,
           //   appBar: commonAppBar('/FillTimesheet', providervalue),
             appBar: commonAppBar('/JobdetailView', providervalue),
              body:
              Consumer<Lttechprovider>(builder: (context, providervalue, child) {
                return SingleChildScrollView(
                  child: Container(
                      color: ThemeColor.themeLightWhiteColor,
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 10,
                              bottom: 25,
                            ),
                            child: const Text(
                              "Vehicle Checklist",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 2.0,
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children:  <Widget>[
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontName.interSemiBold,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(DateFormat(
                                        "MMMM, dd, yyyy")
                                        .format(
                                        DateTime.now()),
                                        style: TextStyle(
                                            fontFamily:
                                            'InterMedium',
                                            fontSize: 15,
                                            color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children:  <Widget>[
                                    Text(
                                      'Truck Registration',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontName.interSemiBold,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),

                                    Text(
                                      //'21 BH 2345 AA',
                                      providervalue.selectedtruckstr.toString(),
                                      style: TextStyle(
                                        color: ThemeColor.themeDarkGreyColor,
                                        fontSize: 13,
                                        fontFamily: FontName.interRegular,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children:  <Widget>[
                                    Text(
                                      'Trailer',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: FontName.interSemiBold,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),

                                    Text(providervalue.arrdisplayselectedtrailer!
                                        .join(" , "),
                                      style: TextStyle(
                                        color: ThemeColor.themeDarkGreyColor,
                                        fontSize: 13,
                                        fontFamily: FontName.interRegular,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: providervalue.isvisible,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 2.0,
                                        )
                                      ],
                                      color: const Color(0xffFFF3CD),
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "This checklist is used to complete a vehicle inspection \nthat meets maintenance management standard \n4 criteria (4).\n\nIf the Vehicle is fulfill our conditions then you can \nchoose select all option and if Vehicle is facing any \nissue then we will contact to you.",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff856404),
                                            fontFamily: FontName.interRegular,
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: IconButton(
                                        //     onPressed: () {
                                        //       isvisible = false;
                                        //     },
                                        //     icon: Image.asset(
                                        //       "assets/images/VehicleScreenIcons/close.png",
                                        //       height: 40,
                                        //       width: 40,
                                        //     ),
                                        //     color: Color(0xff856404),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                            ),
                            child: CheckboxListTile(
                              visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0)),
                              // contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              checkColor: Colors.white,
                              activeColor: ThemeColor.themeGreenColor,
                              title: Transform.translate(
                                offset: const Offset(-15, 0),
                                child: const Text(
                                  'Select All',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: FontName.interMedium,
                                  ),
                                ),
                              ),
                              value: providervalue.selectAllCheckBox,
                              onChanged: (val) {
                                if(!providervalue.isviewtimesheet) {
                                  providervalue.isSelectAllCheckBox = val!;
                                  print("root select");

                                  // set all true;
                                  setall(providervalue);
                                }
                              },
                            ),
                          ),
                          /*ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: providervalue.vehicleChecklistDataArr.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = providervalue.vehicleChecklistDataArr[index];
                        List? items = (item['checklist'] as List?)!;
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 2.0,
                              )
                            ],
                            color: Colors.white,
                          ),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: Key(index.toString()),
                              iconColor: ThemeColor.themeGreenColor,
                              collapsedIconColor: ThemeColor.themeDarkGreyColor,
                              title: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 15,
                                minLeadingWidth: 0,
                                leading: Image.asset(
                                  providervalue.vehicleimages[index],
                                  height: 22,
                                  width: 28,
                                ),
                                title: Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    color: item['isExpanded'] as bool == true
                                        ? ThemeColor.themeGreenColor
                                        : Colors.black,
                                    fontSize: 16,
                                    fontFamily: FontName.interSemiBold,
                                  ),
                                ),
                              ),
                              onExpansionChanged: (bool expanding) {
                                item['isExpanded'] = expanding;
                                providervalue.isTileExpended = expanding;
                              },
                              children: <Widget>[
                                const Divider(
                                  color: ThemeColor.themeLightGrayColor,
                                  height: 1,
                                ),
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Checkbox(
                                            visualDensity: const VisualDensity(
                                                horizontal: 0, vertical: -3),
                                            checkColor: Colors.white,
                                            activeColor:
                                                ThemeColor.themeGreenColor,
                                            value: item["selectAllCheckBox"]
                                                as bool,
                                            onChanged: (val) {
                                              // setState(() {
                                              for (var i = 0;
                                                  i < items.length;
                                                  i++) {
                                                items[i]["value"] = val;
                                                // providervalue
                                                //         .checklistOptionArr[i]
                                                //     ["value"] = !providervalue
                                                //         .checklistOptionArr[i]
                                                //     ["value"];
                                                // providervalue
                                                //         .vehicleChecklistDataArr[i]
                                                //     [
                                                //     "selectAllCheckBox"] = val!;

                                                providervalue
                                                        .isChildCheckedBoxSelected =
                                                    val!;

                                                for (var j = 0;
                                                    j <
                                                        providervalue
                                                            .checklistOptionArr
                                                            .length;
                                                    j++) {
                                                  providervalue
                                                              .checklistOptionArr[
                                                          j]["value"] =
                                                      providervalue
                                                          .childCheckedBoxSelected;
                                                }

                                                if (item["selectAllCheckBox"]
                                                            as bool ==
                                                        true &&
                                                    items[i]["value"] ==
                                                        true) {}
                                              }
                                              // _selectAllCheckBox = val!;
                                              item["selectAllCheckBox"] = val!;
                                              // });

                                              print(item["selectAllCheckBox"]);
                                            },
                                          ),
                                          const Text(
                                            'Select All',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: FontName.interMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor:
                                                      const Color(0xffFFF3CD),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                    10,
                                                  )),
                                                  elevation: 10,
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            color: Color(
                                                                0xffFFF3CD),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 0.0,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: const Text(
                                                            "This checklist is used to complete a vehicle inspection that meets maintenance management standard 4 criteria (4).\n\nIf the Vehicle is fulfill our conditions then you can choose select all option and if Vehicle is facing any issue then we will contact to you.",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0xff856404),
                                                              fontFamily: FontName
                                                                  .interRegular,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color:
                                                ThemeColor.themeDarkGreyColor,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor:
                                                ThemeColor.themeLightGrayColor,
                                            elevation: 0,
                                          ),
                                          label: const Text(
                                            "Examples of faults",
                                            style: TextStyle(
                                              color:
                                                  ThemeColor.themeDarkGreyColor,
                                              fontFamily: FontName.interRegular,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...childListWidget(items, item, providervalue),
                              ],
                            ),
                          ),
                        );
                      },
                    ),*/
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: providervalue.arrvehiclechklist.length,
                            itemCount:providervalue.objvehiclefitnessdata.checklistvalue.length,
                            itemBuilder: (BuildContext context, int index) {
                              // var item = providervalue.arrvehiclechklist[index];

                              providervalue.objvehiclefitnessdata.checklistvalue[index].isallselect = false;

                              var item =  providervalue.objvehiclefitnessdata.checklistvalue[index];

                              //  List? items = (item['checklist'] as List?)!;

                              List items = item.subcategories as List;

                              return Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(2.0),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 2.0,
                                    )
                                  ],
                                  color: Colors.white,
                                ),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    key: Key(index.toString()),
                                    iconColor: ThemeColor.themeGreenColor,
                                    collapsedIconColor: ThemeColor.themeDarkGreyColor,
                                    title: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 15,
                                      minLeadingWidth: 0,
                                      leading: Image.asset(
                                        providervalue.vehicleimages[index],
                                        height: 22,
                                        width: 28,
                                      ),
                                      title: Text(
                                        // item['name'] as String,
                                        item.checklistname,
                                        style: TextStyle(
                                          color:
                                          //item['isExpanded'] as bool == true
                                          item.isExpanded
                                              ? ThemeColor.themeGreenColor
                                              : Colors.black,
                                          fontSize: 16,
                                          fontFamily: FontName.interSemiBold,
                                        ),
                                      ),
                                    ),
                                    onExpansionChanged: (bool expanding) {
                                      // item['isExpanded'] = expanding;
                                      item.isExpanded = expanding;
                                      providervalue.isTileExpended = expanding;
                                    },
                                    children: <Widget>[
                                      const Divider(
                                        color: ThemeColor.themeLightGrayColor,
                                        height: 1,
                                      ),
                                      Container(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Checkbox(
                                                  visualDensity: const VisualDensity(
                                                      horizontal: 0, vertical: -3),
                                                  checkColor: Colors.white,
                                                  activeColor:
                                                  ThemeColor.themeGreenColor,
                                                  //value: item["selectAllCheckBox"]
                                                  //as bool,
                                                  value: providervalue.isallselect[index],
                                                  onChanged: (val) {

                                                    if(!providervalue.isviewtimesheet) {
                                                      print("item select:"+index.toString());

                                                      if(providervalue.isallselect[index]) {
                                                        providervalue
                                                            .isallselect[index] =
                                                        false;
                                                      }else{
                                                        providervalue
                                                            .isallselect[index] =
                                                        true;
                                                      }

                                                      for (var i = 0;
                                                      i < items.length;
                                                      i++) {

                                                        if(items[i].checklistvalue) {
                                                          items[i].checklistvalue = false;
                                                          issetall = false;
                                                        }
                                                        else {
                                                          items[i].checklistvalue = true;
                                                          issetall= true;
                                                        }
                                                      }
                                                      providervalue.notifyListeners();
                                                      // _selectAllCheckBox = val!;
                                                      // item["selectAllCheckBox"] = val!;
                                                      // });
                                                      // item.isall = val!;
                                                      //print(item["selectAllCheckBox"]);
                                                      // print(item.isall);
                                                    }
                                                  },
                                                ),
                                                const Text(
                                                  'Select All',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: FontName.interMedium,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            item.description!=null?
                                            Container(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                        const Color(0xffFFF3CD),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            )),
                                                        elevation: 10,
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          children: <Widget>[
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                const BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      10)),
                                                                  color: Color(
                                                                      0xffFFF3CD),
                                                                ),
                                                                margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                  top: 0.0,
                                                                ),
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: /*const Text(
                                                                  "This checklist is used to complete a vehicle inspection that meets maintenance management standard 4 criteria (4).\n\nIf the Vehicle is fulfill our conditions then you can choose select all option and if Vehicle is facing any issue then we will contact to you.",
                                                                  textAlign: TextAlign
                                                                      .justify,
                                                                  style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Color(
                                                                        0xff856404),
                                                                    fontFamily: FontName
                                                                        .interRegular,
                                                                  ),
                                                                ),*/
                                                                Html(data:item.description),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  size: 16,
                                                  color:
                                                  ThemeColor.themeDarkGreyColor,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  foregroundColor:
                                                  ThemeColor.themeLightGrayColor,
                                                  elevation: 0,
                                                ),
                                                label: const Text(
                                                  "Examples of faults",
                                                  style: TextStyle(
                                                    color:
                                                    ThemeColor.themeDarkGreyColor,
                                                    fontFamily: FontName.interRegular,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ):Container(),
                                          ],
                                        ),
                                      ),
                                      //...childListWidget(items, item, providervalue),
                                      ...childListWidgettwo(items,item,providervalue),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      ThemeColor.themeGreenColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                          side: const BorderSide(
                                              color: ThemeColor.themeGreenColor)))),
                              onPressed: () {
                                ////   Fluttertoast.showToast(
                                //       msg: "Please select all options",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: const Color(0xff085196),
                                //       textColor: Colors.white,
                                //       fontSize: 14.0);
                                // Navigator.of(context).pushNamed(Routes.fillTimesheet);
                                if(!providervalue.isviewtimesheet) {
                                  print('vehicle_chklist:${ providervalue.objvehiclefitnessdata.toJson()}');

                                  providervalue.submitvehiclefitnessprovider('2',context);
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
                          ),
                        ],
                      )),
                );
              }),
            ),
          ));
  }

  List<Widget> childListWidget(List<dynamic>? items, Map<String, Object> item,
      Lttechprovider providervalue) {
    return List.generate(items!.length, (i) {
      return Container(
        padding: EdgeInsets.zero,
        child: CheckboxListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
          checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.white,
          activeColor: ThemeColor.themeGreenColor,
          title: Transform.translate(
            offset: const Offset(-15, 0),
            child: Text(
              items[i]['name'],
              style: const TextStyle(
                color: ThemeColor.themeDarkGreyColor,
                fontSize: 14,
                fontFamily: FontName.interRegular,
              ),
            ),
          ),
          value: items[i]['value'],
          onChanged: (val) {
            // setState(() {
            items[i]['value'] = val!;
            providervalue.isChildCheckedBoxSelected = val;
            //// });
          },
        ),
      );
    });
  }


  List<Widget> childListWidgettwo(List<dynamic>? items, vehiclefitnessdata item,
      Lttechprovider providervalue) {
    return List.generate(items!.length, (i) {
      return Container(
        padding: EdgeInsets.zero,
        child: CheckboxListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
          checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.white,
          activeColor: ThemeColor.themeGreenColor,
          title: Transform.translate(
            offset: const Offset(-15, 0),
            child: Text(
              //  items[i]['name'],
              item.subcategories[i].checklistname,
              style: const TextStyle(
                color: ThemeColor.themeDarkGreyColor,
                fontSize: 14,
                fontFamily: FontName.interRegular,
              ),
            ),
          ),
          // value: items[i]['value'],
          value:item.subcategories[i].checklistvalue,
          onChanged: (val) {
            // setState(() {
            //  items[i]['value'] = val!;
            if(!providervalue.isviewtimesheet) {
              item.subcategories[i].checklistvalue = val!;
              providervalue.isChildCheckedBoxSelected = val!;
              //submititem[i].checklistvalue = val!;
              //// });
              print('item:${item.subcategories[i].checklistvalue}');
              //print("item.subcategories[i].checklistvalue:"+item.subcategories[i].checklistvalue.toString());
              providervalue.notifyListeners();
            }
          },
        ),
      );
    });
  }


  bool issetall=false;
  bool setall(Lttechprovider providervalue) {
    //providervalue.objvehiclefitnessdata.arrvehiclefitnessdata
    var idx=0;
    providervalue.objvehiclefitnessdata.checklistvalue.forEach((element) {
      element.subcategories.forEach((element) {

        if(element.checklistvalue) {
          issetall = false;
          element.checklistvalue=false;
          providervalue.isallselect[idx] = false;
        }else {
          element.checklistvalue=true;

          issetall=true;
          providervalue.isallselect[idx] = true;
        }

      });
      idx = idx +1;

    });
    return issetall;
  }
}
