import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/ColorTheme.dart';
import 'package:lttechapp/utility/env.dart';

import 'package:provider/provider.dart';

import '../../utility/CustomTextStyle.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Consumer<Lttechprovider>(builder: (context, value, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 170.0,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/AppBarIcon/LogoAppBar@2x.png",
                      height: 38,
                      width: 150,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '${Environement.driverfirstname.toString()} ${Environement.driverlastname.toString()}',
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: FontName.interBold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '${Environement.driverselectedCompany.toString()}',
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 14.0,
                                fontFamily: FontName.interBold),
                          ),
                        )
                      ],
                    ),
                  ]),
                ],
              ),
            )),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () {
            Provider.of<Lttechprovider>(context, listen: false)
                .navigatetodashboard(context);
          },
          leading: SvgPicture.asset(
            "assets/images/DrawerIcons/dashboard.svg",
            color: ThemeColor.themeGreenColor,
            height: 24,
            width: 12,
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontFamily: 'InterMedium'),
          ),
        ),
        ListTile(
          onTap: () {
            Provider.of<Lttechprovider>(context, listen: false)
                .navigatetoConsignmentJob(context);
          },
          leading: SvgPicture.asset(
            "assets/images/DrawerIcons/consignment.svg",
            color: ThemeColor.themeGreenColor,
            height: 24,
            width: 12,
          ),
          title: Text(
            'Consignments',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontFamily: 'InterMedium'),
          ),
        ),
        ListTile(
          onTap: () {
            Provider.of<Lttechprovider>(context, listen: false)
                .navigatetoListTimeSheet(context);
          },
          leading: SvgPicture.asset(
            "assets/images/DrawerIcons/Timesheet.svg",
            color: ThemeColor.themeGreenColor,
            height: 24,
            width: 12,
          ),
          title: Text(
            'Timesheet',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontFamily: 'InterMedium'),
          ),
        ),
        ListTile(
          onTap: () {
            value.logoutcontent(context);
          },
          leading: SvgPicture.asset(
            "assets/images/DrawerIcons/log_out.svg",
            color: ThemeColor.themeGreenColor,
            height: 24,
            width: 12,
          ),
          title: Text(
            'Logout',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontFamily: 'InterMedium'),
          ),
        ),
      ]);
    }));
  }
}
