import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';

int _selectedIndex = 0;
Widget bottomappbar(Lttechprovider value, BuildContext context) {
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
        backgroundColor: Color(0xffFFFFFF),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff999999),
        unselectedItemColor: Color(0xff999999),
        onTap: (index) {
          if (index == 0) {
            value.navigatetodashboard(context);
          } else if (index == 1) {
            value.navigatetosettings(context);
          } else if (index == 2) {
            value.navigatetoprofile(context);
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
