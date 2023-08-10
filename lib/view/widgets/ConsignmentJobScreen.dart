import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:intl/intl.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/appbarWidget.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../entity/GetAllConsignmentResponse.dart';
import '../../router/routes.dart';
import '../../utility/Constant/endpoints.dart';
import '../../utility/StatefulWrapper.dart';
import '../../utility/env.dart';

enum ConsignmentFilterOptions { all, tomorrow, sevenDays, pickDateRange }

class ConsignmentJobScreen extends StatelessWidget {
  ConsignmentJobScreen({super.key});

  List<String> itemList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  String _searchText = '';
  var appBarHeight = AppBar().preferredSize.height;
  ScrollController consignmentscrollcontroller = ScrollController();
  ScrollController bookedconsignmentscrollcontroller = ScrollController();
  ScrollController confirmedconsignmentscrollcontroller = ScrollController();
  ScrollController deliveredconsignmentscrollcontroller = ScrollController();
  var _filterPopupMenuItemIndex = 0;
  var radius = 12.0;
  BuildContext? _context;

  String consignmentTypestatus = '';
  String pageSize = '';

  List<AllConsignmentsRow> rows = [];
  ConsignmentFilterOptions? selectedFilterOption;

  Future _getThingsOnStartup(BuildContext context) async {
    consignmentscrollcontroller = ScrollController()
      ..addListener(handleScrolling);
    bookedconsignmentscrollcontroller = ScrollController()
      ..addListener(bookedhandleScrolling);
    confirmedconsignmentscrollcontroller = ScrollController()
      ..addListener(confirmedhandleScrolling);
    deliveredconsignmentscrollcontroller = ScrollController()
      ..addListener(deliveredhandleScrolling);
    final provider = Provider.of<Lttechprovider>(context, listen: false);

    provider.consignmentSearchController.addListener(
      () {
        provider.getConsignmentSearchText(
            provider.consignmentSearchController.text);
      },
    );

    await Future.delayed(Duration.zero, () {
      // provider.allpageNum = provider.allpageNum + 1;
      // print("All PageNum calc:${provider.allpageNum + 1}");
      // print("All PageNum:${provider.allpageNum}");
      // provider.bookedpageNum = provider.bookedpageNum + 1;
      // provider.confirmedpageNum = provider.confirmedpageNum + 1;
      // provider.deliveredpageNum = provider.deliveredpageNum + 1;

      provider.getAllConsignmentRequest(
          provider.allpageNum, consignmentTypestatus, "10");
    });
    // provider.setUpdateView = true;
    //setupRowData();
    print("First time setupRowData called");
  }

  Future<void> handleScrolling() async {
    // print(
    //     "extentAfter ::::: ${consignmentscrollcontroller.position.extentAfter}");

    // if (consignmentscrollcontroller.position.extentAfter <= 0) {
    final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    final offset = consignmentscrollcontroller.offset;
    final minOffset = consignmentscrollcontroller.position.minScrollExtent;
    final maxOffset = consignmentscrollcontroller.position.maxScrollExtent;
    final isOutOfRange = consignmentscrollcontroller.position.outOfRange;

    final hasReachedTheEnd = offset >= maxOffset && !isOutOfRange;

    final hasReachedTheStart = offset <= minOffset && !isOutOfRange;

    final isScrolling = maxOffset > offset && minOffset < offset;

    if (isScrolling) {
      // print('isScrolling');
    } else if (hasReachedTheStart) {
      // print('hasReachedTheStart');
    } else if (hasReachedTheEnd) {
      // print('hasReachedTheEnd');
    } else {
      // print('No Data found');
    }
  }

  Future<void> confirmedhandleScrolling() async {
    // print(
    //     "extentAfter ::::: ${consignmentscrollcontroller.position.extentAfter}");

    // if (consignmentscrollcontroller.position.extentAfter <= 0) {
    final provider = Provider.of<Lttechprovider>(_context!, listen: false);

    final confirmedoffset = confirmedconsignmentscrollcontroller.offset;
    final confirmedminOffset =
        confirmedconsignmentscrollcontroller.position.minScrollExtent;
    final confirmedmaxOffset =
        confirmedconsignmentscrollcontroller.position.maxScrollExtent;
    final confirmedisOutOfRange =
        confirmedconsignmentscrollcontroller.position.outOfRange;

    final confirmedhasReachedTheEnd =
        confirmedoffset >= confirmedmaxOffset && !confirmedisOutOfRange;

    final confirmedhasReachedTheStart =
        confirmedoffset <= confirmedminOffset && !confirmedisOutOfRange;

    final confirmedisScrolling = confirmedmaxOffset > confirmedoffset &&
        confirmedminOffset < confirmedoffset;

    if (confirmedisScrolling) {
      // print('isScrolling');
    } else if (confirmedhasReachedTheStart) {
      // print('hasReachedTheStart');
    } else if (confirmedhasReachedTheEnd) {
      // print('hasReachedTheEnd');
    } else {
      // print('No Data found');
    }

    //}
    // if (consignmentscrollcontroller.position.maxScrollExtent ==
    //     consignmentscrollcontroller.position.pixels) {
    //   print(
    //       'end: ${consignmentscrollcontroller.offset}, ${consignmentscrollcontroller.position.maxScrollExtent}');
    //   final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    //   final rowarr =
    //       provider.allConsignmenttObj.data!.rows; // Getting data from api
    //   if (rowarr.isNotEmpty) {
    //     print('pageNum: $pageNum');
    //    // loadNextData(_context!);
    //   }
    // }
  }

  Future<void> bookedhandleScrolling() async {
    // print(
    //     "extentAfter ::::: ${consignmentscrollcontroller.position.extentAfter}");

    // if (consignmentscrollcontroller.position.extentAfter <= 0) {
    final bookedoffset = bookedconsignmentscrollcontroller.offset;
    final bookedminOffset =
        bookedconsignmentscrollcontroller.position.minScrollExtent;
    final bookedmaxOffset =
        bookedconsignmentscrollcontroller.position.maxScrollExtent;
    final bookedisOutOfRange =
        bookedconsignmentscrollcontroller.position.outOfRange;

    final bookedhasReachedTheEnd =
        bookedoffset >= bookedmaxOffset && !bookedisOutOfRange;

    final bookedhasReachedTheStart =
        bookedoffset <= bookedminOffset && !bookedisOutOfRange;

    final bookedisScrolling =
        bookedmaxOffset > bookedoffset && bookedminOffset < bookedoffset;

    if (bookedisScrolling) {
      // print('isScrolling');
    } else if (bookedhasReachedTheStart) {
      // print('hasReachedTheStart');
    } else if (bookedhasReachedTheEnd) {
      // print('hasReachedTheEnd');
    } else {
      // print('No Data found');
    }
  }

  Future<void> deliveredhandleScrolling() async {
    // print(
    //     "extentAfter ::::: ${consignmentscrollcontroller.position.extentAfter}");

    // if (consignmentscrollcontroller.position.extentAfter <= 0) {
    final provider = Provider.of<Lttechprovider>(_context!, listen: false);

    final deliveredoffset = deliveredconsignmentscrollcontroller.offset;
    final deliveredminOffset =
        deliveredconsignmentscrollcontroller.position.minScrollExtent;
    final deliveredmaxOffset =
        deliveredconsignmentscrollcontroller.position.maxScrollExtent;
    final deliveredisOutOfRange =
        deliveredconsignmentscrollcontroller.position.outOfRange;

    final deliveredhasReachedTheEnd =
        deliveredoffset >= deliveredmaxOffset && !deliveredisOutOfRange;

    final deliveredhasReachedTheStart =
        deliveredoffset <= deliveredminOffset && !deliveredisOutOfRange;

    final deliveredisScrolling = deliveredmaxOffset > deliveredoffset &&
        deliveredminOffset < deliveredoffset;

    if (deliveredisScrolling) {
      // print('isScrolling');
    } else if (deliveredhasReachedTheStart) {
      // print('hasReachedTheStart');
    } else if (deliveredhasReachedTheEnd) {
      // print('hasReachedTheEnd');
    } else {
      // print('No Data found');
    }

    //}
    // if (consignmentscrollcontroller.position.maxScrollExtent ==
    //     consignmentscrollcontroller.position.pixels) {
    //   print(
    //       'end: ${consignmentscrollcontroller.offset}, ${consignmentscrollcontroller.position.maxScrollExtent}');
    //   final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    //   final rowarr =
    //       provider.allConsignmenttObj.data!.rows; // Getting data from api
    //   if (rowarr.isNotEmpty) {
    //     print('pageNum: $pageNum');
    //    // loadNextData(_context!);
    //   }
    // }
  }

  // loadNextData(BuildContext context) async {
  //   await Provider.of<Lttechprovider>(context, listen: false)
  //       .getAllConsignmentRequest( value.allpageNum, consignmentTypestatus, "10");
  //   await setupRowData();
  //   print("Second time setupRowData called");
  // }

  setupRowData() async {
    final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    final rowarr = provider.allConsignmenttObj.data!.rows;

    if (rowarr.isNotEmpty) {
      rows += rowarr;

      print("${rows.length}");
      provider.allpageNum = provider.allpageNum + 1;
    }
    provider.setUpdateView = true;
    // });
  }

  var selectedConsignmentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    _context = context;
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);
      return true;
    }

    return StatefulWrapper(
      onInit: () async {
        await _getThingsOnStartup(context).then((value) {
          print('Async done');

          final provider =
              Provider.of<Lttechprovider>(_context!, listen: false);
          // provider.allpageNum = 1;
          // provider.bookedpageNum = 1;
          // provider.confirmedpageNum = 1;
          // provider.deliveredpageNum = 1;

          provider.changeConsignmentSearchString("");
          provider.setupConsignmentListSearchBar(true);

          // print('init pageNum: $pageNum');
          //  pageNum = pageNum + 1;
          //  print('init pageNum: $pageNum');

          provider.isConsignmentFilterEnabled = false;
        });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer<Lttechprovider>(builder: (context, value, child) {
          selectedConsignmentTabIndex = value.selectedTab;
          //    print("selectedConsignmentTabIndex:$selectedConsignmentTabIndex");

          final deliveredConsignments = value.consignmentRowDataArr!
              .where((element) => element.status == "2")
              .toList();

          //    print("deliveredConsignments:${deliveredConsignments.length}");

          final confirmedConsignments = value.consignmentRowDataArr!
              .where((element) => element.status == "1")
              .toList();

          //  print("confirmedConsignments:${confirmedConsignments.length}");

          final bookedConsignments = value.consignmentRowDataArr!
              .where((element) => element.status == "0")
              .toList();

          //  print("bookedConsignments:${bookedConsignments.length}");
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffFAFAFA),
              appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  backgroundColor: Color(0xffFAFAFA),
                  toolbarHeight: 80,
                  elevation: 0,
                  centerTitle: false,
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
                        IconButton(
                          alignment: Alignment.centerLeft,
                          icon: value.consignmentSearchbarToggle
                              ? Icon(
                                  Icons.search,
                                  color: Colors.black,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            value.consignmentListSearchToggle();
                            Provider.of<Lttechprovider>(_context!,
                                    listen: false)
                                .isConsignmentFilterEnabled = false;
                            if (value.consignmentSearchbarToggle) {
                              // on Search Close button
                              value.changeConsignmentSearchString("");
                              value.consignmentSearchController.text = '';
                            }
                          },
                        ),
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
                        icon: Image.asset(
                          "assets/images/AppBarIcon/backarrow.png",
                          color: const Color(0xff111111),
                          height: 24,
                          width: 12,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.dashboard,
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                  )),
              body: Column(
                children: [
                  AnimatedContainer(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    transform: Matrix4.translationValues(
                        0, // provider.timesheetSearchbarToggle
                        // ? MediaQuery.of(context).size.width
                        value.consignmentSearchbarToggle
                            ? -kToolbarHeight *
                                0.9 //MediaQuery.of(context).size.width
                            : 0,
                        0),
                    duration: Duration(milliseconds: 650),
                    height: value.consignmentSearchbarToggle
                        ? 0
                        : kToolbarHeight * 0.9,
                    decoration: BoxDecoration(),
                    child: Visibility(
                      visible: !value.consignmentSearchbarToggle,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Color(0xff0AAC19),
                              ),
                        ),
                        child: TextField(
                          autocorrect: false,
                          controller: value.consignmentSearchController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff0AAC19), width: 1.5),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: EdgeInsets.only(top: 15),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff999999), width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          onChanged: (value) {
                            Provider.of<Lttechprovider>(context, listen: false)
                                .changeConsignmentSearchString(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: Platform.isAndroid
                            ? const EdgeInsets.only(
                                left: 12,
                                top: 10,
                                bottom: 9,
                              )
                            : const EdgeInsets.only(
                                left: 12, top: 10, bottom: 9),
                        height: 29,
                        width: 217,
                        child: Text(
                          "Consignment/ Job",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff000000),
                              fontFamily: 'InterBold'),
                        ),
                      ),
                      Spacer(),
                      Stack(
                        children: <Widget>[
                          PopupMenuButton(
                            icon: Icon(
                              Icons.filter_alt,
                              color: ThemeColor.themeDarkGreyColor,
                            ),
                            initialValue: selectedFilterOption,
                            onSelected: (val) {
                              selectedFilterOption = val;

                              _onConsignmentFilterItemSelected(
                                  val, context, value);
                            },
                            offset: Offset(0.0, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                            ),
                            itemBuilder: (ctx) => [
                              _filterPopupMenuItem('All', Icons.list,
                                  ConsignmentFilterOptions.all.index),
                              _filterPopupMenuItem(
                                  'Tomorrow',
                                  Icons.calendar_today_outlined,
                                  ConsignmentFilterOptions.tomorrow.index),
                              _filterPopupMenuItem(
                                  'Within 7 Days',
                                  Icons.calendar_month,
                                  ConsignmentFilterOptions.sevenDays.index),
                              _filterPopupMenuItem(
                                  'Pick date range',
                                  Icons.date_range,
                                  ConsignmentFilterOptions.pickDateRange.index),
                            ],
                          ),
                          Positioned(
                            right: 5,
                            top: 12,
                            child: value.isConsignmentFilterEnabled == true
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    width: radius / 2,
                                    height: radius / 2,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, bottom: 9, right: 5),
                        child: IconButton(
                          onPressed: () {
                            value.isConsignmentEdit = false;
                            Provider.of<Lttechprovider>(context, listen: false)
                                .navigatetoAddConsignmentOne(context);
                          },
                          icon: Image.asset(
                            "assets/images/ConsignmentIcon/add.png",
                            height: 24,
                            width: 24,
                          ),
                          color: Color(0xff0AAC19),
                        ),
                      )
                    ],
                  ),
                  DefaultTabController(
                    length: 4,
                    initialIndex: selectedConsignmentTabIndex,
                    child: TabBar(
                      isScrollable: true,
                      // indicator: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(5), // Creates border
                      //     color: ThemeColor.themeGreenColor),
                      indicatorColor: Colors.transparent,
                      labelPadding: EdgeInsets.only(left: 5, right: 5),
                      tabs: [
                        selectedConsignmentTabIndex == 0
                            ? Container(
                                width: 58,
                                height: 30,
                                alignment: Alignment.center,
                                color: ThemeColor.themeGreenColor,
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Colors.white),
                                ))
                            : Container(
                                width: 58,
                                height: 30,
                                alignment: Alignment.center,
                                color: Color(0xffF3F3F3),
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Color(0xff999999)),
                                )),
                        selectedConsignmentTabIndex == 1
                            ? Container(
                                width: 77,
                                height: 30,
                                alignment: Alignment.center,
                                color: ThemeColor.themeGreenColor,
                                child: Text(
                                  "Booked",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Colors.white),
                                ))
                            : Container(
                                width: 77,
                                height: 30,
                                alignment: Alignment.center,
                                color: Color(0xffF3F3F3),
                                child: Text(
                                  "Booked",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Color(0xff999999)),
                                )),
                        selectedConsignmentTabIndex == 2
                            ? Container(
                                width: 89,
                                height: 30,
                                alignment: Alignment.center,
                                color: ThemeColor.themeGreenColor,
                                child: Text(
                                  "Confirmed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Colors.white),
                                ))
                            : Container(
                                width: 89,
                                height: 30,
                                alignment: Alignment.center,
                                color: Color(0xffF3F3F3),
                                child: Text(
                                  "Confirmed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Color(0xff999999)),
                                )),
                        selectedConsignmentTabIndex == 3
                            ? Container(
                                width: 81,
                                height: 30,
                                alignment: Alignment.center,
                                color: ThemeColor.themeGreenColor,
                                child: Text(
                                  "Delivered",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Colors.white),
                                ))
                            : Container(
                                width: 81,
                                height: 30,
                                alignment: Alignment.center,
                                color: Color(0xffF3F3F3),
                                child: Text(
                                  "Delivered",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'InterRegular',
                                      color: Color(0xff999999)),
                                )),
                      ],
                      onTap: (index) {
                        value.selectConsignmentTab(index);
                        index == 0
                            ? value.getAllConsignmentRequest(
                                value.allpageNum, consignmentTypestatus, "10")
                            : index == 1
                                ? value.getAllConsignmentRequest(
                                    value.bookedpageNum, "0", "")
                                : index == 2
                                    ? value.getAllConsignmentRequest(
                                        value.confirmedpageNum, "1", "")
                                    : index == 3
                                        ? value.getAllConsignmentRequest(
                                            value.deliveredpageNum, "2", "10")
                                        : value.getAllConsignmentRequest(
                                            value.allpageNum,
                                            consignmentTypestatus,
                                            "10");
                        print("selected consignment tab index:$index");
                      },
                      // onTap: null,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 5, 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value.isConsignmentFilterEnabled
                          ? "Total Consignments: ${value.filteredConsignmentRowDataArr.length}"
                          : "Total Consignments: ${selectedConsignmentTabIndex == 0 ? value.consignmentRowDataArr?.length ?? [] : selectedConsignmentTabIndex == 1 ? bookedConsignments.length : selectedConsignmentTabIndex == 2 ? confirmedConsignments.length : selectedConsignmentTabIndex == 3 ? deliveredConsignments.length : 0}",
                      style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'InterSemiBold'),
                    ),
                  ),
                  Expanded(
                      child: PageView(
                    //  physics: NeverScrollableScrollPhysics(),
                    controller: PageController(
                        initialPage: selectedConsignmentTabIndex),
                    //  controller: value.pageController,
                    allowImplicitScrolling: true,
                    onPageChanged: (index) {
                      value.selectConsignmentTab(index);
                      print(
                          "selected consignment tab change with pageview:$index");
                    },
                    children: [
                      selectedConsignmentTabIndex == 0
                          ? Container(
                              height: Platform.isIOS
                                  ? SizeConfig.safeBlockVertical * 75
                                  : SizeConfig.safeBlockVertical * 74,
                              // color: selectedConsignmentTab == 0
                              //     ? Colors.green
                              //     : Colors.grey,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: value.isDatevisible,
                                    child: Container(
                                      margin: Platform.isAndroid
                                          ? const EdgeInsets.only(
                                              left: 19,
                                            )
                                          : const EdgeInsets.only(
                                              left: 19,
                                            ),
                                      height: 29,
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                            text: "Selected Date Range :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'InterMedium'),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      ' ${value.formatSelectedStartDate}-${value.formatSelectedEndDate}',
                                                  style: TextStyle(
                                                      color: ThemeColor
                                                          .themeGreenColor,
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'InterMedium'))
                                            ]),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 11,
                                  ),
                                  value.isLoading
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(top: 150.0),
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                ThemeColor.themeLightGrayColor,
                                            color: ThemeColor.themeGreenColor,
                                          ))
                                      : Expanded(
                                          child: Container(
                                            height: Platform.isIOS
                                                ? null //SizeConfig.safeBlockVertical * 70
                                                : SizeConfig.safeBlockVertical *
                                                    74,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: CustomScrollView(
                                                    slivers: [
                                                      SliverFillRemaining(
                                                        hasScrollBody: false,
                                                        child: Container(
                                                          height: Platform.isIOS
                                                              ? SizeConfig
                                                                      .safeBlockVertical *
                                                                  48
                                                              : SizeConfig
                                                                      .safeBlockVertical *
                                                                  53,
                                                          // ? SizeConfig.safeBlockVertical *
                                                          //     57
                                                          // : SizeConfig
                                                          //         .safeBlockVertical *
                                                          //     60,
                                                          child: value
                                                                  .consignmentRowDataArr!
                                                                  .isEmpty
                                                              ? Center(
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                        "No data available!",
                                                                        style: TextStyle(
                                                                            color: ThemeColor
                                                                                .themeGreenColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'InterMedium')),
                                                                  ),
                                                                )
                                                              : ListView
                                                                  .builder(
                                                                      keyboardDismissBehavior:
                                                                          ScrollViewKeyboardDismissBehavior
                                                                              .manual,
                                                                      controller:
                                                                          consignmentscrollcontroller,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: //rows.length,
                                                                          value.isConsignmentFilterEnabled
                                                                              ? value
                                                                                  .filteredConsignmentRowDataArr.length
                                                                              : value
                                                                                  .consignmentRowDataArr!.length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        return consignmetsheetlisting(
                                                                          value,
                                                                          context,
                                                                          value.isConsignmentFilterEnabled
                                                                              ? value.filteredConsignmentRowDataArr[index]
                                                                              : value.consignmentRowDataArr![index],
                                                                        );
                                                                      }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      value.allpageNum == 1
                                                          ? Container()
                                                          : IconButton(
                                                              onPressed: () {
                                                                if (value
                                                                        .allpageNum >
                                                                    0) {
                                                                  value
                                                                      .allpageNum--;
                                                                  print(
                                                                      "previouspageNum:${value.allpageNum}");
                                                                  // value
                                                                  //     .notifyListeners();
                                                                  value.getAllConsignmentRequest(
                                                                      value
                                                                          .allpageNum,
                                                                      consignmentTypestatus,
                                                                      "10");
                                                                  value.setUpdateView =
                                                                      true;
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_back_ios_new,
                                                                color: Colors
                                                                    .black,
                                                                size: 13,
                                                              ),
                                                            ),
                                                      Text(
                                                        "Page ${value.allpageNum}",
                                                        style: TextStyle(
                                                            color: ThemeColor
                                                                .themeDarkGreyColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'InterMedium'),
                                                      ),
                                                      value.consignmentRowDataArr!
                                                              .isEmpty
                                                          ? IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 13,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              onPressed: () {
                                                                if (value
                                                                        .allpageNum !=
                                                                    0) {
                                                                  value
                                                                      .allpageNum++;
                                                                  print(
                                                                      "nextpageNum:${value.allpageNum}");
                                                                  // value
                                                                  //     .notifyListeners();
                                                                  value.getAllConsignmentRequest(
                                                                      value
                                                                          .allpageNum,
                                                                      consignmentTypestatus,
                                                                      "10");

                                                                  value.setUpdateView =
                                                                      true;
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 13,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ))
                          : selectedConsignmentTabIndex == 1
                              ? Container(
                                  height: Platform.isIOS
                                      ? SizeConfig.safeBlockVertical * 75
                                      : SizeConfig.safeBlockVertical * 74,
                                  // color: selectedConsignmentTab == 0
                                  //     ? Colors.green
                                  //     : Colors.grey,
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: value.isDatevisible,
                                        child: Container(
                                          margin: Platform.isAndroid
                                              ? const EdgeInsets.only(
                                                  left: 19,
                                                )
                                              : const EdgeInsets.only(
                                                  left: 19,
                                                ),
                                          height: 29,
                                          width: double.infinity,
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Selected Date Range :",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily: 'InterMedium'),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          ' ${value.formatSelectedStartDate}-${value.formatSelectedEndDate}',
                                                      style: TextStyle(
                                                          color: ThemeColor
                                                              .themeGreenColor,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'InterMedium'))
                                                ]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 11,
                                      ),
                                      value.isLoading
                                          ? Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  top: 150.0),
                                              child: CircularProgressIndicator(
                                                backgroundColor: ThemeColor
                                                    .themeLightGrayColor,
                                                color:
                                                    ThemeColor.themeGreenColor,
                                              ))
                                          : Expanded(
                                              child: Container(
                                                height: Platform.isIOS
                                                    ? null //SizeConfig.safeBlockVertical * 70
                                                    : SizeConfig
                                                            .safeBlockVertical *
                                                        74,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: CustomScrollView(
                                                        slivers: [
                                                          SliverFillRemaining(
                                                            hasScrollBody:
                                                                false,
                                                            child: Container(
                                                              height: Platform
                                                                      .isIOS
                                                                  ? SizeConfig
                                                                          .safeBlockVertical *
                                                                      48
                                                                  : SizeConfig
                                                                          .safeBlockVertical *
                                                                      53,
                                                              // ? SizeConfig
                                                              //         .safeBlockVertical *
                                                              //     57
                                                              // : SizeConfig
                                                              //         .safeBlockVertical *
                                                              //     60,
                                                              child: bookedConsignments
                                                                      .isEmpty
                                                                  ? Center(
                                                                      child:
                                                                          Container(
                                                                        child: Text(
                                                                            "No data available!",
                                                                            style: TextStyle(
                                                                                color: ThemeColor.themeGreenColor,
                                                                                fontSize: 16,
                                                                                fontFamily: 'InterMedium')),
                                                                      ),
                                                                    )
                                                                  : ListView.builder(
                                                                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                                                      controller: bookedconsignmentscrollcontroller,
                                                                      shrinkWrap: true,
                                                                      itemCount: //rows.length,
                                                                          value.isConsignmentFilterEnabled ? value.filteredConsignmentRowDataArr.length : bookedConsignments.length,
                                                                      itemBuilder: (BuildContext context, int index) {
                                                                        return consignmetsheetlisting(
                                                                          value,
                                                                          context,
                                                                          value.isConsignmentFilterEnabled
                                                                              ? value.filteredConsignmentRowDataArr[index]
                                                                              : bookedConsignments[index],
                                                                        );
                                                                      }),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          value.bookedpageNum ==
                                                                  1
                                                              ? Container()
                                                              : IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (value
                                                                            .bookedpageNum >
                                                                        0) {
                                                                      value
                                                                          .bookedpageNum--;
                                                                      print(
                                                                          "previouspageNum:${value.bookedpageNum}");
                                                                      // value
                                                                      //     .notifyListeners();
                                                                      value.getAllConsignmentRequest(
                                                                          value
                                                                              .bookedpageNum,
                                                                          consignmentTypestatus,
                                                                          "10");
                                                                      value.setUpdateView =
                                                                          true;
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_back_ios_new,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 13,
                                                                  ),
                                                                ),
                                                          Text(
                                                            "Page ${value.bookedpageNum}",
                                                            style: TextStyle(
                                                                color: ThemeColor
                                                                    .themeDarkGreyColor,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'InterMedium'),
                                                          ),
                                                          value.consignmentRowDataArr!
                                                                  .isEmpty
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 13,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                )
                                                              : IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (value
                                                                            .bookedpageNum !=
                                                                        0) {
                                                                      value
                                                                          .bookedpageNum++;
                                                                      print(
                                                                          "nextpageNum:${value.bookedpageNum}");
                                                                      // value
                                                                      //     .notifyListeners();
                                                                      value.getAllConsignmentRequest(
                                                                          value
                                                                              .bookedpageNum,
                                                                          consignmentTypestatus,
                                                                          "10");

                                                                      value.setUpdateView =
                                                                          true;
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 13,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ))
                              : selectedConsignmentTabIndex == 2
                                  ? Container(
                                      height: Platform.isIOS
                                          ? SizeConfig.safeBlockVertical * 75
                                          : SizeConfig.safeBlockVertical * 74,
                                      // color: selectedConsignmentTab == 0
                                      //     ? Colors.green
                                      //     : Colors.grey,
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: value.isDatevisible,
                                            child: Container(
                                              margin: Platform.isAndroid
                                                  ? const EdgeInsets.only(
                                                      left: 19,
                                                    )
                                                  : const EdgeInsets.only(
                                                      left: 19,
                                                    ),
                                              height: 29,
                                              width: double.infinity,
                                              child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        "Selected Date Range :",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'InterMedium'),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              ' ${value.formatSelectedStartDate}-${value.formatSelectedEndDate}',
                                                          style: TextStyle(
                                                              color: ThemeColor
                                                                  .themeGreenColor,
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'InterMedium'))
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 11,
                                          ),
                                          value.isLoading
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(
                                                      top: 150.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor: ThemeColor
                                                        .themeLightGrayColor,
                                                    color: ThemeColor
                                                        .themeGreenColor,
                                                  ))
                                              : Expanded(
                                                  child: Container(
                                                    height: Platform.isIOS
                                                        ? null //SizeConfig.safeBlockVertical * 70
                                                        : SizeConfig
                                                                .safeBlockVertical *
                                                            74,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              CustomScrollView(
                                                            slivers: [
                                                              SliverFillRemaining(
                                                                hasScrollBody:
                                                                    false,
                                                                child:
                                                                    Container(
                                                                  height: Platform
                                                                          .isIOS
                                                                      ? SizeConfig
                                                                              .safeBlockVertical *
                                                                          48
                                                                      : SizeConfig
                                                                              .safeBlockVertical *
                                                                          53,
                                                                  // ? SizeConfig
                                                                  //         .safeBlockVertical *
                                                                  //     57
                                                                  // : SizeConfig
                                                                  //         .safeBlockVertical *
                                                                  //     60,
                                                                  child: confirmedConsignments
                                                                          .isEmpty
                                                                      ? Center(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text("No data available!", style: TextStyle(color: ThemeColor.themeGreenColor, fontSize: 16, fontFamily: 'InterMedium')),
                                                                          ),
                                                                        )
                                                                      : ListView.builder(
                                                                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                                                          controller: confirmedconsignmentscrollcontroller,
                                                                          shrinkWrap: true,
                                                                          itemCount: //rows.length,
                                                                              value.isConsignmentFilterEnabled ? value.filteredConsignmentRowDataArr.length : confirmedConsignments!.length,
                                                                          itemBuilder: (BuildContext context, int index) {
                                                                            return consignmetsheetlisting(
                                                                              value,
                                                                              context,
                                                                              value.isConsignmentFilterEnabled ? value.filteredConsignmentRowDataArr[index] : confirmedConsignments[index],
                                                                            );
                                                                          }),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        confirmedConsignments
                                                                .isEmpty
                                                            ? Center(
                                                                child:
                                                                    Container(),
                                                              )
                                                            : Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    value.confirmedpageNum ==
                                                                            1
                                                                        ? Container()
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (value.confirmedpageNum > 0) {
                                                                                value.confirmedpageNum--;
                                                                                print("previouspageNum:${value.confirmedpageNum}");
                                                                                // value.notifyListeners();
                                                                                value.getAllConsignmentRequest(value.confirmedpageNum, consignmentTypestatus, "10");
                                                                                value.setUpdateView = true;
                                                                              }
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.arrow_back_ios_new,
                                                                              color: Colors.black,
                                                                              size: 13,
                                                                            ),
                                                                          ),
                                                                    Text(
                                                                      "Page ${value.confirmedpageNum}",
                                                                      style: TextStyle(
                                                                          color: ThemeColor
                                                                              .themeDarkGreyColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'InterMedium'),
                                                                    ),
                                                                    value.consignmentRowDataArr!
                                                                            .isEmpty
                                                                        ? IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                Icon(
                                                                              Icons.arrow_forward_ios,
                                                                              size: 13,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          )
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (value.confirmedpageNum != 0) {
                                                                                value.confirmedpageNum++;
                                                                                print("nextpageNum:${value.confirmedpageNum}");
                                                                                // value.notifyListeners();
                                                                                value.getAllConsignmentRequest(value.confirmedpageNum, consignmentTypestatus, "10");

                                                                                value.setUpdateView = true;
                                                                              }
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.arrow_forward_ios,
                                                                              size: 13,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ))
                                  : selectedConsignmentTabIndex == 3
                                      ? Container(
                                          height: Platform.isIOS
                                              ? SizeConfig.safeBlockVertical *
                                                  75
                                              : SizeConfig.safeBlockVertical *
                                                  74,
                                          // color: selectedConsignmentTab == 0
                                          //     ? Colors.green
                                          //     : Colors.grey,
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: value.isDatevisible,
                                                child: Container(
                                                  margin: Platform.isAndroid
                                                      ? const EdgeInsets.only(
                                                          left: 19,
                                                        )
                                                      : const EdgeInsets.only(
                                                          left: 19,
                                                        ),
                                                  height: 29,
                                                  width: double.infinity,
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            "Selected Date Range :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'InterMedium'),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  ' ${value.formatSelectedStartDate}-${value.formatSelectedEndDate}',
                                                              style: TextStyle(
                                                                  color: ThemeColor
                                                                      .themeGreenColor,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'InterMedium'))
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 11,
                                              ),
                                              value.isLoading
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 150.0),
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor: ThemeColor
                                                            .themeLightGrayColor,
                                                        color: ThemeColor
                                                            .themeGreenColor,
                                                      ))
                                                  : Expanded(
                                                      child: Container(
                                                        height: Platform.isIOS
                                                            ? null //SizeConfig.safeBlockVertical * 70
                                                            : SizeConfig
                                                                    .safeBlockVertical *
                                                                74,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  CustomScrollView(
                                                                slivers: [
                                                                  SliverFillRemaining(
                                                                    hasScrollBody:
                                                                        false,
                                                                    child:
                                                                        Container(
                                                                      height: Platform
                                                                              .isIOS
                                                                          ? SizeConfig.safeBlockVertical *
                                                                              48
                                                                          : SizeConfig.safeBlockVertical *
                                                                              53,
                                                                      // ? SizeConfig.safeBlockVertical *
                                                                      //     57
                                                                      // : SizeConfig.safeBlockVertical *
                                                                      //     60,
                                                                      child: deliveredConsignments
                                                                              .isEmpty
                                                                          ? Center(
                                                                              child: Container(
                                                                                child: Text("No data available!", style: TextStyle(color: ThemeColor.themeGreenColor, fontSize: 16, fontFamily: 'InterMedium')),
                                                                              ),
                                                                            )
                                                                          : ListView.builder(
                                                                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                                                              controller: deliveredconsignmentscrollcontroller,
                                                                              shrinkWrap: true,
                                                                              itemCount: //rows.length,
                                                                                  value.isConsignmentFilterEnabled ? value.filteredConsignmentRowDataArr.length : deliveredConsignments!.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                return consignmetsheetlisting(
                                                                                  value,
                                                                                  context,
                                                                                  value.isConsignmentFilterEnabled ? value.filteredConsignmentRowDataArr[index] : deliveredConsignments[index],
                                                                                );
                                                                              }),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            deliveredConsignments
                                                                    .isEmpty
                                                                ? Center(
                                                                    child:
                                                                        Container(),
                                                                  )
                                                                : Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <Widget>[
                                                                        value.deliveredpageNum ==
                                                                                1
                                                                            ? Container()
                                                                            : IconButton(
                                                                                onPressed: () {
                                                                                  if (value.deliveredpageNum > 0) {
                                                                                    value.deliveredpageNum--;
                                                                                    print("previouspageNum:${value.deliveredpageNum}");
                                                                                    // value.notifyListeners();
                                                                                    value.getAllConsignmentRequest(value.deliveredpageNum, consignmentTypestatus, "10");
                                                                                    value.setUpdateView = true;
                                                                                  }
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.arrow_back_ios_new,
                                                                                  color: Colors.black,
                                                                                  size: 13,
                                                                                ),
                                                                              ),
                                                                        Text(
                                                                          "Page ${value.deliveredpageNum}",
                                                                          style: TextStyle(
                                                                              color: ThemeColor.themeDarkGreyColor,
                                                                              fontSize: 14,
                                                                              fontFamily: 'InterMedium'),
                                                                        ),
                                                                        value.consignmentRowDataArr!.isEmpty
                                                                            ? IconButton(
                                                                                onPressed: () {},
                                                                                icon: Icon(
                                                                                  Icons.arrow_forward_ios,
                                                                                  size: 13,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              )
                                                                            : IconButton(
                                                                                onPressed: () {
                                                                                  if (value.deliveredpageNum != 0) {
                                                                                    value.deliveredpageNum++;
                                                                                    print("nextpageNum:${value.deliveredpageNum}");
                                                                                    // value.notifyListeners();
                                                                                    value.getAllConsignmentRequest(value.deliveredpageNum, consignmentTypestatus, "10");

                                                                                    value.setUpdateView = true;
                                                                                  }
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.arrow_forward_ios,
                                                                                  size: 13,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ))
                                      : Container()
                    ],
                  )),
                ],
              ),
              bottomNavigationBar: bottomappbar(context));
        }),
      ),
    );
  }

  PopupMenuItem _filterPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: ConsignmentFilterOptions.values[position],
      child: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: ThemeColor.themeGreenColor,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(
                color: ThemeColor.themeDarkGreyColor,
                fontSize: 15,
                fontFamily: 'InterRegular'),
          ),
        ],
      ),
    );
  }

  _onConsignmentFilterItemSelected(
      val, BuildContext context, Lttechprovider value) {
    print("Selected value: ${describeEnum(val)}");

    Provider.of<Lttechprovider>(_context!, listen: false)
        .isConsignmentFilterEnabled = true;

    if (val == ConsignmentFilterOptions.all) {
      value.setDateRangeVisibility = false;
      value.isConsignmentFilterEnabled = false;
      value.setUpdateView = true;
    } else if (val == ConsignmentFilterOptions.sevenDays) {
      Provider.of<Lttechprovider>(_context!, listen: false)
          .filterListForSevenDays(_context!);
    } else if (val == ConsignmentFilterOptions.pickDateRange) {
      Provider.of<Lttechprovider>(_context!, listen: false)
          .getConsignmentDateRangeFilteredData(_context!);
      value.setDateRangeVisibility = true;
    } else {
      Provider.of<Lttechprovider>(_context!, listen: false)
          .getConsignmentFilteredData(val);
    }
  }

  Widget consignmetsheetlisting(Lttechprovider value, BuildContext context,
      AllConsignmentsRow allConsignmentsRow) {
    DateTime? bookeddate = allConsignmentsRow.bookedDate;
    var formatBookedDate =
        DateFormat.yMMMMd().format(bookeddate ?? DateTime.now());
    // print(
    //     "formatBookedDate:$formatBookedDate");
    DateTime? pickupdate = allConsignmentsRow.pickupDate;
    var formatPickUpDate =
        DateFormat.yMMMMd().format(pickupdate ?? DateTime.now());
    // print(
    //     "formatPickUpDate:$formatPickUpDate");
    DateTime? deliverydate = allConsignmentsRow.deliveryDate;
    var formatDeliveryDate =
        DateFormat.yMMMMd().format(deliverydate ?? DateTime.now());
    // print(
    //     "formatDeliveryDate:$formatDeliveryDate");
    var consignmentId = allConsignmentsRow.consignmentId.toString();

    // print(
    //     "consignmentId:$consignmentId");
    return Column(
      children: [
        Container(
          height: Platform.isIOS ? null : SizeConfig.safeBlockVertical * 31,
          width: double.infinity,
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
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 21),
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      //  "#DIGH0003H",
                      allConsignmentsRow.jobNumber.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'InterSemiBold',
                          color: Color(0xff0AAC19)),
                    ),
                  ),
                  // status of consignment-0-Booked, 1- Confirmed, 2-Delivered
                  allConsignmentsRow.status == "1"
                      ? Container(
                          margin: EdgeInsets.only(top: 10, left: 14),
                          height: 20,
                          width: 70,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              color: Color(0xfffeebf0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          child: const Text(
                            "Confirmed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'InterSemiBold',
                              fontSize: 12,
                              color: Color(0xffda496c),
                            ),
                          ),
                        )
                      : allConsignmentsRow.status == "2"
                          ? Container(
                              margin: EdgeInsets.only(top: 10, left: 14),
                              height: 20,
                              width: 62,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: Color(0xffe0f7f4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              child: const Text(
                                "Delivered",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'InterSemiBold',
                                  fontSize: 12,
                                  color: Color(0xff1ebb8c),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 10, left: 14),
                              height: 20,
                              width: 55,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: Color(0xfffef7e0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              child: const Text(
                                "Booked",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'InterSemiBold',
                                  fontSize: 12,
                                  color: Color(0xffe58c33),
                                ),
                              ),
                            ),
                  Spacer(),
                  allConsignmentsRow.status == "2"
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 0, right: 10, top: 10),
                          child: PopupMenuButton(
                            padding: EdgeInsets.only(left: 15),
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                  value: 'edit',
                                  child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.edit,
                                        color: ThemeColor.themeGreenColor,
                                        size: 20.0,
                                      ),
                                      label: Text('Edit',
                                          style: TextStyle(
                                            fontFamily: 'InterRegular',
                                            fontSize: 13,
                                            color: Colors.black,
                                          )),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      onPressed: () {
                                        print('Edit Button Pressed');
                                        value.isConsignmentEdit = true;

                                        ApiCounter.consignmenteditcounterui = 0;
                                        ApiCounter
                                            .consignmentgetcustomerallcounter = 0;

                                        value.maincustomerid =
                                            allConsignmentsRow.customerId
                                                .toString();
                                        //  value
                                        //     .allConsignmenttObj
                                        //     .data!
                                        //     .rows[index]
                                        //     .customerId
                                        //     .toString();

                                        value.selectedConsignmentId =
                                            allConsignmentsRow.consignmentId
                                                .toString();
                                        // value.allConsignmenttObj.data!.rows[index]
                                        //     .consignmentId
                                        //     .toString();
                                        print(allConsignmentsRow.consignmentId
                                            .toString());

                                        value.jobNumberController.text =
                                            allConsignmentsRow.jobNumber
                                                .toString();
                                        // value
                                        //     .allConsignmenttObj
                                        //     .data!
                                        //     .rows[index]
                                        //     .jobNumber
                                        //     .toString();

                                        DateTime? bookedEditDate =
                                            allConsignmentsRow.bookedDate;
                                        // value
                                        //     .allConsignmenttObj
                                        //     .data!
                                        //     .rows[index]
                                        //     .bookedDate;

                                        String formattedBookedEditDate =
                                            DateFormat('dd/MM/yyyy')
                                                .format(bookedEditDate!);

                                        // in case date not edited again so to avoid null value to pass in edit api of consignment
                                        String formattedprocessbookDate =
                                            DateFormat('yyyy-MM-dd', 'en-US')
                                                .format(bookedEditDate);
                                        value.consignmentbookdate =
                                            formattedprocessbookDate;
                                        // DateTime? pickedEditDate = value.consignmentByIdresponse.data!
                                        //   .pickupDate;
                                        DateTime? pickedEditDate =
                                            allConsignmentsRow.pickupDate;
                                        // value.allConsignmenttObj.data!.rows[index]
                                        //     .pickupDate;
                                        String formattedPickedEditDate =
                                            DateFormat('dd/MM/yyyy')
                                                .format(pickedEditDate!);
                                        // DateTime? deliveryEditDate = value.consignmentByIdresponse.data!
                                        //   .deliveryDate;
                                        // in case date not edited again so to avoid null value to pass in edit api of consignment
                                        String formattedprocesspickedDate =
                                            DateFormat('yyyy-MM-dd', 'en-US')
                                                .format(pickedEditDate);
                                        value.consignmentpickupdate =
                                            formattedprocesspickedDate;

                                        DateTime? deliveryEditDate =
                                            allConsignmentsRow.deliveryDate;

                                        String formattedDeliveryEditDate =
                                            DateFormat('dd/MM/yyyy').format(
                                                deliveryEditDate!); // for showing date in textfield

                                        // in case date not edited again so to avoid null value to pass in edit api of consignment
                                        String formattedprocessdeliveryDate =
                                            DateFormat('yyyy-MM-dd', 'en-US')
                                                .format(deliveryEditDate);
                                        value.consignmentdeliverydate =
                                            formattedprocessdeliveryDate;

                                        value.bookedDateController.text =
                                            formattedBookedEditDate;
                                        value.pickUpDateController.text =
                                            formattedPickedEditDate;
                                        value.deliveryDateController.text =
                                            formattedDeliveryEditDate;

                                        value.instructionController.text =
                                            // value
                                            //     .allConsignmenttObj
                                            //     .data!
                                            //     .rows[index]
                                            //     .specialInstruction
                                            //     .toString();
                                            allConsignmentsRow
                                                .specialInstruction
                                                .toString();

                                        value.manifestController.text =
                                            allConsignmentsRow.manifestNumber
                                                .toString();
                                        // value
                                        //     .allConsignmenttObj
                                        //     .data!
                                        //     .rows[index]
                                        //     .manifestNumber
                                        //     .toString();
                                        value.billingCustomerid =
                                            allConsignmentsRow.billingCustomer
                                                .toString();
                                        // value.allConsignmenttObj.data!.rows[index]
                                        //     .billingCustomer
                                        //     .toString();
                                        value.pickupCustomerbillingid =
                                            allConsignmentsRow.pickupcustomerid
                                                .toString();
                                        // value
                                        //     .allConsignmenttObj
                                        //     .data!
                                        //     .rows[index]
                                        //     .pickupcustomerid
                                        //     .toString();
                                        value.deliverycustomerbillingid =
                                            allConsignmentsRow.deliveryName
                                                .toString();
                                        // value.allConsignmenttObj.data!.rows[index]
                                        //     .deliveryName
                                        //     .toString();

                                        value.selected_billing_address =
                                            allConsignmentsRow.billingAddress
                                                .toString();
                                        // value.allConsignmenttObj.data!.rows[index]
                                        //     .billingAddress
                                        //     .toString();
                                        //Navigate to Consignment Screen One
                                        Provider.of<Lttechprovider>(context,
                                                listen: false)
                                            .navigatetoAddConsignmentOne(
                                                context);
                                        // Navigator.pop(context);
                                      })),
                            ],
                            onSelected: (String value) {
                              print('Clicked on popup menu item : $value');
                            },
                          ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 21, top: 3),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${allConsignmentsRow.customerDetails?.firstName ?? ""} ${allConsignmentsRow.customerDetails?.lastName ?? ""}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontFamily: 'InterSemiBold'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 21),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff0AAC19)),
                            ),
                            Dash(
                                direction: Axis.vertical,
                                length: 36,
                                dashLength: 5,
                                dashColor: Color(0xff0AAC19)),
                            Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Color(0xff0AAC19))),
                              child: Container(
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 9, top: 12),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                allConsignmentsRow.customerAddress.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                    fontFamily: 'InterMedium'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 9, top: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatPickUpDate,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff666666),
                                    fontFamily: 'InterRegular'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 9, top: 11),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                allConsignmentsRow.deliveryAddres.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                    fontFamily: 'InterMedium'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 9, top: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatDeliveryDate,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff666666),
                                    fontFamily: 'InterRegular'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 21),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image.asset(
                                  "assets/images/ConsignmentIcon/add.png",
                                  height: 14,
                                  width: 14,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: "Upload Additional Docs",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'InterSemiBold',
                                  color: Color(0xff0AAC19)),
                            ),
                          ],
                        ),
                      )),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                    child: IconButton(
                      icon: Image.asset(
                        "assets/images/ConsignmentIcon/rightarrow.png",
                        height: 20,
                        width: 20,
                        color: Color(0xff0AAC19),
                      ),
                      onPressed: () {
                        Environement.indexPstConsignmentListing = index;
                        Environement.consignmentId = consignmentId;

                        Provider.of<Lttechprovider>(context, listen: false)
                            .navigatetoConsignmentDetails(
                                context,
                                Environement.indexPstConsignmentListing,
                                Environement.consignmentId);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
