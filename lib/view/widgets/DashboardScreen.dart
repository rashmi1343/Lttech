import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';

import 'package:provider/provider.dart';

import '../../utility/StatefulWrapper.dart';
import '../../utility/env.dart';
import 'DrawerWidget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final provider = Provider.of<Lttechprovider>(context, listen: false);
    return StatefulWrapper(
        onInit: () {
          Provider.of<Lttechprovider>(context, listen: false).isloginsuccess =
              false;
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffFAFAFA),
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Color(0xffFAFAFA),
                toolbarHeight: 80,
                centerTitle: false,
                elevation: 0,
                toolbarOpacity: 0.5,
                title: Transform(
                    transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "assets/images/AppBarIcon/LogoAppBar@2x.png",
                        height: 33,
                        width: 124,
                      ),
                    )),
                actions: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(right: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xff0AAC19),
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                        ),
                        child: Center(
                          child: Text(
                            // "R",
                            Environement.initialloginname.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'InterRegular',
                                color: Color(0xffFFFFFF)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                leading: Builder(
                  builder: (context) => Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      icon: SvgPicture.asset(
                        "assets/images/DashboardIcons/drawericon.svg",
                        color: const Color(0xff111111),
                        height: 24,
                        width: 12,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ),
              drawer: Drawer(
                child: DrawerWidget(),
              ),
              body: Column(
                children: [
                  provider.arrcompanylist.length > 1
                      ? Container(
                          height: 80,
                          margin: EdgeInsets.only(
                              left: 20, bottom: 10, right: 25, top: 20),
                          alignment: Alignment.topLeft,
                          child: DropdownSearch<String>(

                              /*dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select Company",
                              hintText: "Driver Company",
                            ),
                          ),*/

                              popupProps: PopupProps.menu(
                                //modalBottomSheet
                                fit: FlexFit.loose,
                                constraints: BoxConstraints.tightFor(),
                                showSearchBox: Provider.of<Lttechprovider>(
                                            context,
                                            listen: false)
                                        .arrcompanylist
                                        .length >
                                    3,
                                showSelectedItems: true,
                                searchDelay: const Duration(milliseconds: 1),
                                searchFieldProps: const TextFieldProps(
                                  decoration: InputDecoration(
                                    labelText: "Search Company",
                                  ),
                                ),
                                // disabledItemFn: (String s) =>
                                //     s.startsWith('I'),
                              ),
                              items: Provider.of<Lttechprovider>(context,
                                      listen: false)
                                  .arrcompanylist,

                              // onChanged: print,
                              onChanged: (selectedvalue) {
                                // if(Provider.of<Lttechprovider>(context, listen: false).isloginsuccess) {
                                print(selectedvalue);
                                Provider.of<Lttechprovider>(context,
                                            listen: false)
                                        .selectedcompanystr =
                                    selectedvalue.toString();
                                final selectedvalueindex =
                                    Provider.of<Lttechprovider>(context,
                                            listen: false)
                                        .arrcompanylist
                                        .indexWhere((element) =>
                                            element ==
                                            Provider.of<Lttechprovider>(context,
                                                    listen: false)
                                                .selectedcompanystr);

                                Provider.of<Lttechprovider>(context,
                                        listen: false)
                                    .onchangecompanyselection(
                                        selectedvalueindex, context);
                                //}
                              },
                              selectedItem: Provider.of<Lttechprovider>(context,
                                          listen: false)
                                      .selectedcompanystr
                                      .isEmpty
                                  ? "Please Select a Company"
                                  : Provider.of<Lttechprovider>(context,
                                          listen: false)
                                      .selectedcompanystr),
                        )
                      : Container(),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 18, top: 5, bottom: 15),
                    child: Text(
                      "Choose Service",
                      style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff000000),
                          fontFamily: 'InterBold'),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: Platform.isIOS
                          ? SizeConfig.safeBlockVertical * 75
                          : SizeConfig.safeBlockVertical * 74,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(
                              top: 20, left: 18, right: 19, bottom: 17),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 17,
                            childAspectRatio: 1,
                            crossAxisSpacing: 18.0,
                            mainAxisExtent: 125,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: index == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        Provider.of<Lttechprovider>(context,
                                                listen: false)
                                            .navigatetoFaultReporting(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 162,
                                        height: 125,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xffEEEEEE)),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0xffB4B4B4),
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                          color: const Color(0xffFFFFFF),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Image.asset(
                                              "assets/images/DashboardIcons/reportingicon@3x.png",
                                              color: const Color(0xff666666),
                                              height: 48,
                                              width: 81,
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Fault Reporting",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff666666),
                                                      fontFamily:
                                                          'InterSemiBold'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : index == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            Provider.of<Lttechprovider>(context,
                                                    listen: false)
                                                .navigatetoConsignmentJob(
                                                    context);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 162,
                                            height: 125,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      const Color(0xffEEEEEE)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffB4B4B4),
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                              color: const Color(0xffFFFFFF),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 24,
                                                ),
                                                Image.asset(
                                                  "assets/images/DashboardIcons/consignment@2x.png",
                                                  color:
                                                      const Color(0xff666666),
                                                  height: 58,
                                                  width: 100,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Consignment/ Job",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff666666),
                                                          fontFamily:
                                                              'InterSemiBold'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : index == 2
                                          ? GestureDetector(
                                              onTap: () {
                                                Provider.of<Lttechprovider>(
                                                        context,
                                                        listen: false)
                                                    .navigatetoListTimeSheet(
                                                        context);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 162,
                                                height: 125,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: const Color(
                                                          0xffEEEEEE)),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color(0xffB4B4B4),
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                  color:
                                                      const Color(0xffFFFFFF),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Image.asset(
                                                      "assets/images/DashboardIcons/timesheeticon@3x.png",
                                                      color: const Color(
                                                          0xff666666),
                                                      height: 48,
                                                      width: 81,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Timesheet",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xff666666),
                                                              fontFamily:
                                                                  'InterSemiBold'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : index == 3
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Provider.of<Lttechprovider>(
                                                            context,
                                                            listen: false)
                                                        .navigatetoDocManager(
                                                            context);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 162,
                                                    height: 125,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: const Color(
                                                              0xffEEEEEE)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0xffB4B4B4),
                                                          blurRadius: 1.0,
                                                        ),
                                                      ],
                                                      color: const Color(
                                                          0xffFFFFFF),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 24,
                                                        ),
                                                        Image.asset(
                                                          "assets/images/DashboardIcons/docmanager@3x.png",
                                                          color: const Color(
                                                              0xff666666),
                                                          height: 48,
                                                          width: 81,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Doc Manager",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xff666666),
                                                                  fontFamily:
                                                                      'InterSemiBold'),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffece9e9),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Color(0xffFFFFFF),
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: ThemeColor.themeGreenColor,
                    unselectedItemColor: Color(0xff999999),
                    onTap: (index) {
                      if (index == 0) {
                        // Provider.of<Lttechprovider>(context, listen: false)
                        //     .navigatetodashboard(context);
                      }
                      // else if (index == 1) {
                      //   // Provider.of<Lttechprovider>(context, listen: false)
                      //   //     .navigatetolocation(context);
                      // }
                      else if (index == 1) {
                        Provider.of<Lttechprovider>(context, listen: false)
                            .navigatetosettings(context);
                      } else if (index == 2) {
                        Provider.of<Lttechprovider>(context, listen: false)
                            .navigatetoprofile(context);
                      }
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/DashboardIcons/homeicon.svg",
                          color: const Color(0xff999999),
                          height: 18,
                          width: 20,
                        ),
                        label: 'Home',
                        activeIcon: SvgPicture.asset(
                          "assets/images/DashboardIcons/homeicon.svg",
                          color: ThemeColor.themeGreenColor,
                          height: 18,
                          width: 20,
                        ),
                      ),
                      // BottomNavigationBarItem(
                      //   icon: Image.asset(
                      //     "assets/images/DashboardIcons/location@3x.png",
                      //     color: const Color(0xff999999),
                      //     height: 18,
                      //     width: 20,
                      //   ),
                      //   label: 'Location',
                      //   activeIcon: Image.asset(
                      //     "assets/images/DashboardIcons/location@3x.png",
                      //     color: ThemeColor.themeGreenColor,
                      //     height: 18,
                      //     width: 20,
                      //   ),
                      // ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/images/DashboardIcons/setting@3x.png",
                          color: const Color(0xff999999),
                          height: 18,
                          width: 20,
                        ),
                        label: 'Settings',
                        activeIcon: Image.asset(
                          "assets/images/DashboardIcons/setting@3x.png",
                          color: ThemeColor.themeGreenColor,
                          height: 18,
                          width: 20,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          "assets/images/DashboardIcons/profile@3x.png",
                          color: const Color(0xff999999),
                          height: 18,
                          width: 20,
                        ),
                        label: 'My Profile',
                        activeIcon: Image.asset(
                          "assets/images/DashboardIcons/profile@3x.png",
                          color: ThemeColor.themeGreenColor,
                          height: 18,
                          width: 20,
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
