import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lttechapp/entity/getalltimesheetresponse.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';

import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/DateHelpers.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/utility/StatefulWrapper.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:provider/provider.dart';

import '../../../entity/ApiRequests/DeleteTimesheetRequest.dart';
import '../../../router/routes.dart';
import '../../../utility/Constant/endpoints.dart';
import '../../../utility/env.dart';

enum FilterOptions {
  all,
  sevendays,
  onemonth,
  datebyrange,
}

class TimesheetList extends StatelessWidget {
  TimesheetList({super.key});

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  ScrollController scrollcontroller = ScrollController();

  String _searchText = '';
  var _filterPopupMenuItemIndex = 0;
  var radius = 12.0;
  FilterOptions? selectedFilterOption;

  bool _isSelectedDateVisible = false;

  var appBarHeight = AppBar().preferredSize.height;

  BuildContext? _context;
  var pageNum = 0;

  // var pageNum = 1;
  List<Rows> rows = [];

  Future _getThingsOnStartup(BuildContext context) async {
    scrollcontroller = ScrollController()..addListener(handleScrolling);
    final provider = Provider.of<Lttechprovider>(context, listen: false);
    // provider.arrstrselectedtrailer = [];

    provider.tsSearchController.addListener(
          () {
        provider.getTimesheetSearchText(provider.tsSearchController.text);
      },
    );

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    await Future.delayed(Duration.zero, () {
      pageNum = pageNum + 1;
      provider.getalltimesheetApiRequest(Environement.companyID, '', pageNum);
    });
    //setupRowData();
  }

  Future<void> handleScrolling() async {
    // print("extentAfter ::::: ${scrollcontroller.position.extentAfter}");

    final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    final offset = scrollcontroller.offset;
    final minOffset = scrollcontroller.position.minScrollExtent;
    final maxOffset = scrollcontroller.position.maxScrollExtent;
    final isOutOfRange = scrollcontroller.position.outOfRange;

    final hasReachedTheEnd = offset >= maxOffset && !isOutOfRange;
    final hasReachedTheStart = offset <= minOffset && !isOutOfRange;
    final isScrolling = maxOffset > offset && minOffset < offset;

    // if (isScrolling) {
    //   print('isScrolling');
    // } else if (hasReachedTheStart) {
    //   print('hasReachedTheStart');
    // } else if (hasReachedTheEnd) {
    //   print('hasReachedTheEnd');
    // } else {
    //   print('No Data found');
    // }

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

  // void handleScrolling() {
  //   if (scrollcontroller.offset == scrollcontroller.position.maxScrollExtent) {
  //     print(
  //         'end: ${scrollcontroller.offset}, ${scrollcontroller.position.maxScrollExtent}');
  //     final provider = Provider.of<Lttechprovider>(_context!, listen: false);
  //     final rowarr =
  //         provider.alltimesheet.data?.rows ?? []; // Getting data from api
  //     if (rowarr.isNotEmpty) {
  //       print('pageNum: $pageNum');
  //       loadNextData(_context!);
  //     }
  //     // if (provider.isError == false) {
  //     // print(rowarr.length);
  //
  //     // }
  //   }
  // }

  // getFilteredData(FilterOptions selectedFilter) {
  //   final provider = Provider.of<Lttechprovider>(_context!, listen: false);
  //   var now = DateTime.now();
  //   var weekAgo = now.subtract(const Duration(days: 7));
  //   var onemonthAgo = DateTime(now.year, now.month - 1, now.day);
  //   // var oneYearAgo = DateTime(now.year - 1, now.month, now.day);
  //   provider.timesheetRowDataArr =
  //       Provider.of<Lttechprovider>(_context!, listen: false);

  //  var data = provider.timesheetRowDataArr.where((x) => DateTime.parse(x.timesheetDate)
  //       .isAfter(
  //           selectedFilter == FilterOptions.sevendays ? weekAgo : onemonthAgo));
  //   print(data.map((e) => e.timesheetId));
  // }

  loadNextData(BuildContext context) async {
    // await Provider.of<Lttechprovider>(context, listen: false)
    //     .getalltimesheetApiRequest(
    //         '85121810-512e-4366-95dd-4d660cffa206', '', pageNum);
    // await setupRowData();
  }

  setupRowData() async {
    // await Future.delayed(Duration.zero, () {
    final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    final rowarr = provider.alltimesheet.data?.rows ?? [];

    //// print('rowarr.length:${rowarr.length}');
    // print('rows.length:${rows.length}');
    if (rowarr.isNotEmpty) {
      rows += rowarr;
      print(rows.length);
      pageNum += 1;
    }
    provider.setUpdateView = true;
    // });
  }

  Future navigateToFillTime(
      BuildContext context, Lttechprovider provider) async {
    provider.navigatetofilltimesheet(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _context = context;

    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);

      return true;
    } //

    return StatefulWrapper(
      onInit: () async {
        await _getThingsOnStartup(context).then((value) {
          print('Async done');

          final provider =
          Provider.of<Lttechprovider>(_context!, listen: false);

          provider.changeTimesheetSearchString("");
          provider.setupTimesheetSearchBar(true);

          provider.filteredTimesheetRowDataArr = [];
          provider.isFilterEnabled = false;

          // print('init pageNum: $pageNum');
          // pageNum += 1;
        });
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer<Lttechprovider>(
          builder: (context, provider, child) {
            // final rowarr = provider.alltimesheet.data.rows;
            // rows = rowarr;
            return Scaffold(
              resizeToAvoidBottomInset: true,
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
                          icon: provider.timesheetSearchbarToggle
                              ? Icon(
                            Icons.search,
                            color: Colors.black,
                          )
                              : Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            provider.timesheetSearchToggle();
                            Provider.of<Lttechprovider>(_context!,
                                listen: false)
                                .isFilterEnabled = false;

                            if (provider.timesheetSearchbarToggle) {
                              // on Search Close button
                              provider.changeTimesheetSearchString("");
                              provider.tsSearchController.text = '';
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
                              Environement.initialloginname,
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
                          Provider.of<Lttechprovider>(context, listen: false)
                              .navigatetodashboard(context);
                        },
                      ),
                    ),
                  )),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  AnimatedContainer(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    transform: Matrix4.translationValues(
                        0, // provider.timesheetSearchbarToggle
                        // ? MediaQuery.of(context).size.width
                        provider.timesheetSearchbarToggle
                            ? -kToolbarHeight *
                            0.9 //MediaQuery.of(context).size.width
                            : 0,
                        0),
                    duration: Duration(milliseconds: 650),
                    height: provider.timesheetSearchbarToggle
                        ? 0
                        : kToolbarHeight * 0.9,
                    child: Visibility(
                      visible: !provider.timesheetSearchbarToggle,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                            primary: Color(0xff0AAC19),
                          ),
                        ),
                        child: TextField(
                          autocorrect: false,
                          controller: provider.tsSearchController,
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
                                .changeTimesheetSearchString(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: Platform.isAndroid
                            ? const EdgeInsets.only(
                            left: 12, top: 22, bottom: 9)
                            : const EdgeInsets.only(
                            left: 12, top: 12, bottom: 9),
                        height: 29,
                        width: 217,
                        child: Text(
                          "Timesheet",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff000000),
                              fontFamily: 'InterBold'),
                        ),
                      ),
                      Spacer(),
                      Stack(
                        children: <Widget>[
                          Theme(
                            data: Theme.of(context).copyWith(
                                highlightColor: ThemeColor.themeGreenColor
                                    .withOpacity(0.3)),
                            child: PopupMenuButton(
                              icon: Icon(
                                Icons.filter_alt,
                                color: ThemeColor.themeDarkGreyColor,
                              ),
                              initialValue: selectedFilterOption,
                              onSelected: (value) {
                                selectedFilterOption = value;
                                _onMenuFilterItemSelected(value);
                              },
                              //
                              offset: Offset(0.0, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                ),
                              ),
                              itemBuilder: (ctx) => [
                                _filterPopupMenuItem('All', Icons.list_rounded,
                                    FilterOptions.all.index),
                                _filterPopupMenuItem(
                                    'Last 7 Days',
                                    Icons.calendar_today_outlined,
                                    FilterOptions.sevendays.index),
                                _filterPopupMenuItem(
                                    'Last 1 month',
                                    Icons.calendar_month,
                                    FilterOptions.onemonth.index),
                                _filterPopupMenuItem(
                                    'Pick date range',
                                    Icons.date_range_outlined,
                                    FilterOptions.datebyrange.index),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 12,
                            child: provider.isFilterEnabled
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
                        margin: const EdgeInsets.only(bottom: 9, right: 5),
                        child: IconButton(
                          onPressed: () {
                            /* Provider.of<Lttechprovider>(context,
                                listen: false)
                                .navigatetoAddTimeSheet(context);
                          */
                            // time sheet  created for day as difference found for date in last
                            if (totaldatezero > 0) {
                              print(
                                  "totaldatezero:" + totaldatezero.toString());
                              print("createtimesheet:" +
                                  provider.createtimesheet.toString());

                              provider.createtimesheet = 0;
                              provider.setEditTimesheet = false;
                              // provider.isEditTimesheet = false;
                              provider.arrselectedtrailer = [];
                              provider.arrstrselectedtrailer = [];
                              provider.arrdisplayselectedtrailer = [];
                              provider.arrtruck = [];
                              provider.arrtruckid = [];

                              provider.arrtrailer = [];
                              provider.arrtrailerid = [];

                              Provider.of<Lttechprovider>(context,
                                  listen: false)
                                  .navigatetofilltimesheet(context);
                            } else if (totaldatezero == 0) {
                              Fluttertoast.showToast(
                                  msg: "Time Sheet Already Created",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: ThemeColor.themeGreenColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(totaldatezero<0) {
                              print("createtimesheet:" +
                                  provider.createtimesheet.toString());

                              provider.createtimesheet = 0;
                              provider.setEditTimesheet = false;
                              // provider.isEditTimesheet = false;
                              provider.arrselectedtrailer = [];
                              provider.arrstrselectedtrailer = [];
                              provider.arrdisplayselectedtrailer = [];
                              provider.arrtruck = [];
                              provider.arrtruckid = [];

                              provider.arrtrailer = [];
                              provider.arrtrailerid = [];

                              Provider.of<Lttechprovider>(context,
                                  listen: false)
                                  .navigatetofilltimesheet(context);
                            }
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
                  Visibility(
                    visible: _isSelectedDateVisible,
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
                            text: "Selected Date Range: ",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: 'InterMedium'),
                            children: [
                              TextSpan(
                                  text: provider.selectedfilterdaterange,
                                  style: TextStyle(
                                      color: ThemeColor.themeGreenColor,
                                      fontSize: 13,
                                      fontFamily: 'InterMedium'))
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: provider.isLoading
                                ? Center(
                                child: CircularProgressIndicator(
                                  color: ThemeColor.themeGreenColor,
                                ))
                                : provider.isFilterEnabled
                                ? provider.filteredTimesheetRowDataArr
                                .isNotEmpty
                                ? timesheetListWidget(provider)
                                : Center(
                              child: Text('No Timesheet Found',
                                  style: TextStyle(
                                    color: ThemeColor
                                        .themeGreenColor,
                                    fontFamily:
                                    FontName.interMedium,
                                    fontSize: 15,
                                  )),
                            )
                                : provider.timesheetRowDataArr != null
                                ? timesheetListWidget(provider)
                                : Center(
                              child: Text('No Timesheet Found',
                                  style: TextStyle(
                                    color: ThemeColor
                                        .themeGreenColor,
                                    fontFamily:
                                    FontName.interMedium,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        pageNum == 1
                            ? Container()
                            : IconButton(
                          onPressed: () {
                            if (pageNum > 0) {
                              pageNum--;
                              print("previouspageNum:$pageNum");

                              provider.notifyListeners();
                              provider.getalltimesheetApiRequest(
                                  Environement.companyID, '', pageNum);
                              provider.setUpdateView = true;
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 13,
                          ),
                        ),
                        Text(
                          "Page ${pageNum}",
                          style: TextStyle(
                              color: ThemeColor.themeDarkGreyColor,
                              fontSize: 14,
                              fontFamily: 'InterMedium'),
                        ),
                        provider.timesheetRowDataArr!.isEmpty
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
                            if (pageNum != 0) {
                              pageNum++;
                              print("nextpageNum:$pageNum");
                              provider.notifyListeners();
                              provider.getalltimesheetApiRequest(
                                  Environement.companyID, '', pageNum);

                              provider.setUpdateView = true;
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
                  ), //
                ],
              ),
              bottomNavigationBar: bottomappbar(context),
            );
          },
        ),
      ),
    );
  }

  Widget timesheetListWidget(Lttechprovider provider) {
    return SizedBox(
        height: Platform.isIOS
            ? SizeConfig.safeBlockVertical * 61
            : SizeConfig.safeBlockVertical * 74,
        child: provider.timesheetRowDataArr!.isEmpty
            ? Center(
          child: Text('No Timesheet Found',
              style: TextStyle(
                color: ThemeColor.themeGreenColor,
                fontFamily: FontName.interMedium,
                fontSize: 15,
              )),
        )
            : ListView.builder(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.manual,
          controller: scrollcontroller,
          shrinkWrap: true,
          itemCount: //rows.length,
          provider.isFilterEnabled
              ? provider.filteredTimesheetRowDataArr
              .length // alltimesheet.data.rows
              : (provider.timesheetRowDataArr ?? []).length,
          itemBuilder: (BuildContext context, int index) {
            return timesheetListing(
              provider,
              context,
              provider.isFilterEnabled
                  ? provider.filteredTimesheetRowDataArr[index]
              // alltimesheet.data.rows
                  : provider.timesheetRowDataArr![index],
              // alltimesheet.data.rows[index],
            );
          },
        ));
  }

  PopupMenuItem _filterPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: FilterOptions.values[position],
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            iconData,
            size: 22,
            color: ThemeColor.themeGreenColor,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style:
            TextStyle(color: ThemeColor.themeDarkGreyColor, fontSize: 15),
          ),
          // Spacer(),
          // Icon(Icons.check, size: 16, color: ThemeColor.themeGreenColor),
        ],
      ),
    );
  }

  _onMenuFilterItemSelected(value) {
    print("Selected value: ${describeEnum(value)}");

    final provider = Provider.of<Lttechprovider>(_context!, listen: false);
    _isSelectedDateVisible = false;
    if (value == FilterOptions.all) {
      provider.isFilterEnabled = false;
      provider.setUpdateView = true;
    } else if (value == FilterOptions.datebyrange) {
      provider.filteredTimesheetRowDataArr = [];
      _isSelectedDateVisible = true;
      provider.pickDateByRange(_context!);
    } else {
      provider.isFilterEnabled = true;
      provider.getTimesheetFilteredData(value);
    }
  }

  // Widget childWidget(BuildContext context, Rows row) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(
  //           right: 12,
  //           left: 12,
  //         ),
  //         width: double.infinity,
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.only(
  //                     top: 5,
  //                   ),
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     "Frozen Delivery",
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         color: Color(0xff000000),
  //                         fontFamily: FontName.interSemiBold),
  //                   ),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(top: 7, left: 14),
  //                   height: 20,
  //                   // width: 68,
  //                   padding: EdgeInsets.all(1),
  //                   decoration: BoxDecoration(
  //                       color: Color(0xffD4EDDA),
  //                       borderRadius: BorderRadius.all(Radius.circular(3))),
  //                   child: const Text(
  //                     "In Progress",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontFamily: 'InterRegular',
  //                       fontSize: 12,
  //                       color: Color(0xff155724),
  //                     ),
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 Container(
  //                   height: 30,
  //                   child: IconButton(
  //                     padding: EdgeInsets.only(top: 0, left: 25),
  //                     icon: Image.asset(
  //                       "assets/images/ConsignmentIcon/rightarrow.png",
  //                       height: 18,
  //                       width: 18,
  //                       color: Color(0xff0AAC19),
  //                     ),
  //                     onPressed: () => {},
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               // alignment: Alignment.centerLeft,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Container(
  //                     padding: EdgeInsets.only(
  //                       bottom: 5,
  //                       top: 5,
  //                     ),
  //                     child: Text(
  //                       "SA Frozen Delivery Level 14/70 Pitt St, Sydney NSW 2000, Australia",
  //                       style: TextStyle(
  //                           fontSize: 14,
  //                           color: Color(0xff000000),
  //                           height: 1.3,
  //                           fontFamily: FontName.interMedium),
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.only(
  //                       bottom: 10,
  //                     ),
  //                     child: Text(
  //                       "20 Jan, 2022",
  //                       style: TextStyle(
  //                           fontSize: 13,
  //                           color: Color(0xff666666),
  //                           fontFamily: FontName.interRegular),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void deleteTimesheetDialog(
      Lttechprovider provider, BuildContext context, Rows row) {
    provider.isLoading
        ? Center(
        child: CircularProgressIndicator(
          color: ThemeColor.themeGreenColor,
        ))
        : showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SizedBox(
            height: Platform.isAndroid ? 100.0 : null,
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: Platform.isAndroid ? 300.0 : 234,
                ),
                title: Text(
                  "Confirmation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontName.interSemiBold,
                    fontSize: 17,
                    color: Color(0xff243444),
                  ),
                ),
                content: Column(
                  children: [
                    Text(
                      "Are you sure you want to delete the timesheet?",
                      style: TextStyle(
                        fontFamily: FontName.interMedium,
                        fontSize: 13,
                        color: Color(0xff243444),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              //onPrimary: Colors.black,
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontFamily: FontName.interMedium,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              var deleteTimesheetRequestObj =
                              DeleteTimesheetRequest(id: [row.timeId]);

                              print(deleteTimesheetRequestObj.toJson());

                              provider.deleteTimesheet(
                                  deleteTimesheetRequestObj, row.companyId);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColor.themeGreenColor,
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: FontName.interMedium,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  int timesheetdatediff = 1;
  int totaldatezero = 1;

  Widget timesheetListing(
      Lttechprovider provider, BuildContext context, Rows row) {

    if(row.restdetails.length>0) {
      provider.calculatebreaktime(row.restdetails, row);
    }
    var timesheetdate = row.timesheetDate.split("T");

    print("one:"+timesheetdate[0].toString());
    print("two:"+timesheetdate[1].toString());
    //var actualtimesheetdate = DateTime.parse(row.timesheetDate);
    var actualtimesheetdate = DateTime.parse(timesheetdate[0]);
    row.timesheetDateString =
        Jiffy.parse(actualtimesheetdate.toLocal().toString())
        // .yMMMMEEEEd,
            .yMMMMd;
    // .yMMMMdjm,
    print("converteddate:" + actualtimesheetdate.toIso8601String());
    print("currentdate:" + DateTime.now().toIso8601String());

    DateTime date1 =
    DateTime.parse(DateFormat('yyyy-MM-dd').format(actualtimesheetdate));
    DateTime date2 =
    DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if (totaldatezero > 0) {
      timesheetdatediff = provider.daysBetween(date1, date2);
      print("diffdate:" + timesheetdatediff.toString());
      row.datediff = timesheetdatediff;

      // timesheet will be created
      if (row.datediff! > 0) {
        totaldatezero = totaldatezero + 1;
      } else {
        totaldatezero = row.datediff!;
      }
    }

    return Column(
      children: [
        Container(
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
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      row.timesheetId,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff0AAC19),
                          fontFamily: FontName.interSemiBold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3, left: 10),
                    padding:
                    EdgeInsets.only(top: 3, left: 5, right: 5, bottom: 3),
                    decoration: row.status == "Approved"
                        ? BoxDecoration(
                        color: Color(0xffD4EDDA),
                        borderRadius: BorderRadius.all(Radius.circular(3)))
                        : BoxDecoration(
                        color: Color(0xffF8D7DA),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: row.status == "Approved"
                        ? Text(
                      row.status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 12,
                        color: row.status == "Approved"
                            ? Color(0xff155724)
                            : Color(0xff842029),
                      ),
                    )
                        : Text(
                      // "In Progress",
                      "Rejected",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 12,
                        color: Color(0xff842029),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                      height: 30,
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
                                        fontSize: 12,
                                        color: Color(0xff666666),
                                      )),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    //   padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                    //   textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)
                                  ),
                                  onPressed: () {
                                    print('Edit Button Pressed');
                                    ApiCounter.edittimesheetcounter = 0;
                                    provider.createtimesheet = 1;
                                    provider.setSelectedTimesheetCompanyID =
                                        row.companyId;
                                    provider.setSelectedTimesheetID = row
                                        .timeId; // Setting selected timesheet company id and timesheetid
                                    provider.setEditTimesheet =
                                    true; // Setting isEditTimesheet value, to check edit mode.
                                    provider.isviewtimesheet=false;
                                    provider.updatetimesheetrequestObj
                                        .timesheetdate =
                                        DateFormat("yyyy-MM-dd")
                                            .format(actualtimesheetdate);
                                    /*  provider.pickupdatefortimesheetjob =  DateFormat("yyyy-MM-dd")
                                          .format(actualtimesheetdate);*/
                                    //  provider.updatetimesheetrequestObj.timesheetdate =
                                    //    DateFormat("dd-MM-yyy")
                                    //      .format(actualtimesheetdate.addDays(1));
                                    // }
                                    provider.arrtrailer = [];


                                    navigateToFillTime(context, provider);
                                  })),
                          PopupMenuItem(
                              value: 'View',
                              child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  label: Text('View',
                                      style: TextStyle(
                                        fontFamily: 'InterRegular',
                                        fontSize: 12,
                                        color: Color(0xff666666),
                                      )),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    //   padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                    //   textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)
                                  ),
                                  onPressed: () {
                                    ApiCounter.edittimesheetcounter = 0;
                                    provider.createtimesheet = 1;
                                    provider.setSelectedTimesheetCompanyID =
                                        row.companyId;
                                    provider.setSelectedTimesheetID = row
                                        .timeId; // Setting selected timesheet company id and timesheetid
                                    provider.isviewtimesheet = true;
                                    provider.setEditTimesheet = false;
                                    provider.updatetimesheetrequestObj
                                        .timesheetdate =
                                        DateFormat("yyyy-MM-dd")
                                            .format(actualtimesheetdate);
                                    /*  provider.pickupdatefortimesheetjob =  DateFormat("yyyy-MM-dd")
                                          .format(actualtimesheetdate);*/
                                    //  provider.updatetimesheetrequestObj.timesheetdate =
                                    //    DateFormat("dd-MM-yyy")
                                    //      .format(actualtimesheetdate.addDays(1));
                                    // }
                                    provider.arrtrailer = [];


                                    navigateToFillTime(context, provider);
                                  }))
                        ],
                        onSelected: (String value) {
                          print('Clicked on popup menu item : $value');
                          if(value.contains("edit")) {
                            print('Edit Button Pressed');
                            ApiCounter.edittimesheetcounter = 0;
                            provider.createtimesheet = 1;
                            provider.setSelectedTimesheetCompanyID =
                                row.companyId;
                            provider.setSelectedTimesheetID = row
                                .timeId; // Setting selected timesheet company id and timesheetid
                            provider.setEditTimesheet =
                            true; // Setting isEditTimesheet value, to check edit mode.
                            provider.isviewtimesheet=false;
                            provider.updatetimesheetrequestObj
                                .timesheetdate =
                                DateFormat("yyyy-MM-dd")
                                    .format(actualtimesheetdate);
                            /*  provider.pickupdatefortimesheetjob =  DateFormat("yyyy-MM-dd")
                                          .format(actualtimesheetdate);*/
                            //  provider.updatetimesheetrequestObj.timesheetdate =
                            //    DateFormat("dd-MM-yyy")
                            //      .format(actualtimesheetdate.addDays(1));
                            // }
                            provider.arrtrailer = [];


                            navigateToFillTime(context, provider);
                          }
                          else if(value.contains("View")) {
                            print('View Button Pressed');
                            ApiCounter.edittimesheetcounter = 0;
                            provider.createtimesheet = 1;
                            provider.setSelectedTimesheetCompanyID =
                                row.companyId;
                            provider.setSelectedTimesheetID = row
                                .timeId; // Setting selected timesheet company id and timesheetid
                            provider.isviewtimesheet = true;
                            provider.setEditTimesheet = false;
                            provider.updatetimesheetrequestObj
                                .timesheetdate =
                                DateFormat("yyyy-MM-dd")
                                    .format(actualtimesheetdate);
                            /*  provider.pickupdatefortimesheetjob =  DateFormat("yyyy-MM-dd")
                                          .format(actualtimesheetdate);*/
                            //  provider.updatetimesheetrequestObj.timesheetdate =
                            //    DateFormat("dd-MM-yyy")
                            //      .format(actualtimesheetdate.addDays(1));
                            // }
                            provider.arrtrailer = [];


                            navigateToFillTime(context, provider);
                          }
                        },
                      )),
                ],
              ),
              Container(
                // alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        row.timesheetDateString ?? "",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff666666),
                            fontFamily: FontName.interRegular),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            "Start Time",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: FontName.interSemiBold),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            "Finish Time",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontFamily: FontName.interSemiBold),
                          ),
                        ),
                        Spacer(),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                "Break Time",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                    fontFamily: FontName.interSemiBold),
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  child: Text(
                                    //  row.startTime,
                                    DateFormat.jm().format(DateFormat("hh:mm")
                                        .parse(row.startTime)),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff666666),
                                        fontFamily: FontName.interRegular),
                                  ),
                                ))),
                        Spacer(),
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  child: row.endTime == ""
                                      ? Text(
                                    "--:--",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff666666),
                                        fontFamily:
                                        FontName.interRegular),
                                  )
                                      : row.endTime == "00:00:00"
                                      ? Text(
                                    "00:00:00",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff666666),
                                        fontFamily:
                                        FontName.interRegular),
                                  )
                                      : Text(
                                    DateFormat.jm().format(
                                        DateFormat("hh:mm")
                                            .parse(row.endTime)),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff666666),
                                        fontFamily:
                                        FontName.interRegular),
                                  ),
                                ))),
                        Spacer(),
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  child: Text(
                                    row.totalbreaktime != null
                                        ? row.totalbreaktime.toString()
                                        : "--:--",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff666666),
                                        fontFamily: FontName.interRegular),
                                  ),
                                )))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
