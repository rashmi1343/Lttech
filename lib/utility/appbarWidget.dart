import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:provider/provider.dart';

import 'Constant/endpoints.dart';
import 'env.dart';

int index = 0;
PreferredSizeWidget defaultAppBar() {
  return AppBar(
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
                  //   "R",
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
              Navigator.pop(context);
            },
          ),
        ),
      ));
}

PreferredSizeWidget commonAppBar(String routeName, Lttechprovider provider) {
  return AppBar(
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
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                alignment: Alignment.centerLeft,
                icon: SvgPicture.asset(
                  "assets/images/AppBarIcon/magnifying-glass.svg",
                  color: const Color(0xff999999),
                  height: 18,
                  width: 18,
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
                  //"R",
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
              if (routeName == '/FillTimesheet') {

                if(!provider.isviewtimesheet) {

                provider.setEditTimesheet = true;
                if (provider.isEditTimesheet) {
                  ApiCounter.edittimesheetcounter = 0;
                }
              }
              }

              Navigator.of(context).pushNamedAndRemoveUntil(
                  routeName, (Route<dynamic> route) => false);
            },
          ),
        ),
      ));
}

PreferredSizeWidget commonAppBarWithoutSearchIcon(String routeName) {
  return AppBar(
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
                  //  "R",
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
                  routeName, (Route<dynamic> route) => false);
            },
          ),
        ),
      ));
}

PreferredSizeWidget commonAppBarforConsignment(String step, int width,
    int height, BuildContext context, String routeName) {
  return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Color(0xffFAFAFA),
      toolbarHeight: 80,
      elevation: 0,
      toolbarOpacity: 0.5,
      centerTitle: true,
      title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            step,
            style: TextStyle(
                fontSize: 14,
                color: Color(0xff000000),
                fontFamily: 'InterBold'),
          )),
      actions: <Widget>[
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                alignment: Alignment.centerLeft,
                icon: Image.asset("assets/images/DashboardIcons/home.png",
                    color: const Color(0xff999999), height: 25, width: 25),
                onPressed: () {
                  Provider.of<Lttechprovider>(context, listen: false)
                      .navigatetodashboard(context);
                },
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
                  //    "R",
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
              Navigator.pop(context);
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     routeName, (Route<dynamic> route) => false);
            },
          ),
        ),
      ));
}

Widget bottomappbar(BuildContext context) {
  return Container(
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
        currentIndex: index,
        backgroundColor: Color(0xffFFFFFF),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff999999),
        unselectedItemColor: Color(0xff999999),
        onTap: (index) {
          if (index == 0) {
            Provider.of<Lttechprovider>(context, listen: false)
                .navigatetodashboard(context);
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
            icon: Image.asset(
              "assets/images/DashboardIcons/home.png",
              color: const Color(0xff999999),
              height: 18,
              width: 20,
            ),
            label: 'Home',
            activeIcon: Image.asset(
              "assets/images/DashboardIcons/home.png",
              color: const Color(0xff999999),
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
          //     color: const Color(0xff0AAC19),
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
              color: const Color(0xff0AAC19),
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
              color: const Color(0xff0AAC19),
              height: 18,
              width: 20,
            ),
          ),
        ],
      ));
}
