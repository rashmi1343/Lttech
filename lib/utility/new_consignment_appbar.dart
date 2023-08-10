import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/utility/ColorTheme.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';

PreferredSizeWidget newAssignmntAppbar(int pagenumber,int progressstep) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: Color(0xffFAFAFA),
    centerTitle: true,
    toolbarHeight: 100,
    elevation: 0,
    toolbarOpacity: 0.5,
    title: Transform(
        transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            "Step ${pagenumber} of 6",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'InterRegular',
                color: Color(0xff000000)),
          ),
        )),
    actions: <Widget>[
      Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: Image.asset(
                "assets/images/DashboardIcons/home.png",
                color: const Color(0xff999999),
                height: 18,
                width: 20,
              ),
              onPressed: () {},
            ),
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
                "R",
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
            Navigator.pop(context);
          },
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(2.0),
      child: Container(
        margin: EdgeInsets.only(left: 18, right: 19),
        child: StepProgressIndicator(
          mainAxisAlignment: MainAxisAlignment.center,
          totalSteps: 96,
          currentStep: progressstep,
          size: 3,
          padding: 0,

          selectedColor: ThemeColor.themeGreenColor,
          unselectedColor: ThemeColor.themeLightGrayColor,
          roundedEdges: Radius.circular(5),
          selectedGradientColor: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              ThemeColor.themeGreenColor,
              ThemeColor.themeGreenColor
            ],
          ),
          unselectedGradientColor: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              ThemeColor.themeLightGrayColor,
              ThemeColor.themeLightGrayColor
            ],
          ),
        ),
      ),


    ),
  );
}
