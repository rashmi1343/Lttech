import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:provider/provider.dart';

import '../../../presenter/Lttechprovider.dart';
import '../../../utility/ColorTheme.dart';
import '../../../utility/CustomTextStyle.dart';
import '../../../utility/SizeConfig.dart';
import '../../../utility/StatefulWrapper.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print("back called");
      Provider.of<Lttechprovider>(context, listen: false)
          .navigatetodashboard(context);
      return true;
    }

    SizeConfig().init(context);

    return StatefulWrapper(
        onInit: () {
          Provider.of<Lttechprovider>(context, listen: false)
              .getDriverProfileApiRequest(context);
        },
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                appBar: defaultAppBar(),
                body: SafeArea(
                  child: Consumer<Lttechprovider>(
                    builder: (context, provider, child) {
                      final driverData = provider.driverProfileResponseObj.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: Platform.isAndroid
                                ? const EdgeInsets.only(
                                    left: 12, top: 22, bottom: 9, right: 95)
                                : const EdgeInsets.only(
                                    left: 12, top: 5, bottom: 10),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff000000),
                                  fontFamily: 'InterBold'),
                            ),
                          ),
                          provider.isLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 150.0),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        ThemeColor.themeLightGrayColor,
                                    color: ThemeColor.themeGreenColor,
                                  ))
                              : Expanded(
                                  child: Container(
                                    height: Platform.isIOS
                                        ? null //SizeConfig.safeBlockVertical * 70
                                        : SizeConfig.safeBlockVertical * 74,
                                    // decoration: BoxDecoration(
                                    //   color: Color(0xffFFFFFF),
                                    //   boxShadow: const [
                                    //     BoxShadow(
                                    //       color: Color(0xffEEEEEE),
                                    //       blurRadius: 3.0,
                                    //     ),
                                    //   ],
                                    //   border: Border.all(
                                    //     color: Color(0xffEEEEEE),
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  Container(
                                                    height: 100,
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 60,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '${driverData?.firstName.toString()} ${driverData?.lastName.toString()}',
                                                          style: TextStyle(
                                                              fontSize: 24.0,
                                                              fontFamily: FontName
                                                                  .interBold),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Text(
                                                              '${driverData?.mobile.toString()}',
                                                              style: CustomTextStyle
                                                                  .textfieldTitleTextStyle,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 40,
                                                            height: 20,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                updateMobileNumber(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: ThemeColor
                                                                    .themeGreenColor,
                                                                size: 20.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '${driverData?.userName.toString()}',
                                                          style: CustomTextStyle
                                                              .textfieldTitleTextStyle,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                                _SingleSection(
                                                  title: "Driver Details",
                                                  children: [
                                                    _CustomListTile(
                                                      info:
                                                          '${driverData?.driverNumber.toString()}',
                                                      icon: Icons.person,
                                                      title: 'Driver Number',
                                                    ),
                                                    // _CustomListTile(
                                                    //   info: 'ABC Pvt Ltd.',
                                                    //   icon: Icons
                                                    //       .groups_2_rounded,
                                                    //   title: 'Company Name',
                                                    // ),
                                                    // _CustomListTile(
                                                    //   info: 'TFS 676',
                                                    //   icon:
                                                    //       Icons.local_shipping,
                                                    //   title:
                                                    //       'Truck Registration Number',
                                                    // ),
                                                    // _CustomListTile(
                                                    //   info: 'Mini Truck',
                                                    //   icon:
                                                    //       Icons.local_shipping,
                                                    //   title: 'Truck Type',
                                                    // ),
                                                    SizedBox(height: 8.0),
                                                  ],
                                                ),
                                                _SingleSection(
                                                  title:
                                                      "Emergency Contact Details",
                                                  children: [
                                                    _CustomListTile(
                                                      info:
                                                          '${driverData?.emergencyContactName.toString()}',
                                                      icon: Icons.person_2,
                                                      title: 'Name',
                                                    ),
                                                    _CustomListTile(
                                                      info:
                                                          '${driverData?.emergencyPhone.toString()}',
                                                      icon: Icons.phone,
                                                      title: 'Phone Number',
                                                    ),
                                                    _CustomListTile(
                                                      info:
                                                          '${driverData?.contactRelation.toString()}',
                                                      icon: Icons.favorite,
                                                      title: 'Relationship',
                                                    ),
                                                  ],
                                                ),
                                                _SingleSection(
                                                  title: "Address Details",
                                                  children: [
                                                    _CustomListTile(
                                                      info:
                                                          '${driverData?.address.toString()}, ${driverData?.suburb.toString()}, ${driverData?.zipCode.toString()}',
                                                      icon: Icons.home_work,
                                                      title: 'Address',
                                                    ),
                                                    _CustomListTile(
                                                      info: driverData
                                                                  ?.countryId ==
                                                              1
                                                          ? 'India'
                                                          : 'Australlia',
                                                      icon: Icons.language,
                                                      title: 'Country',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ))));
  }

  void updateMobileNumber(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(
              context,
              _key,
            ),
          );
        });
  }

  double t4Size = 14;

  dialogContent(BuildContext context, GlobalKey _key) {
    return SingleChildScrollView(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.3, sigmaY: 3.3),
        child: Dialog(
          insetPadding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          // backgroundColor: skyBlue,
          child: Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Update Mobile Number",
                    style: TextStyle(
                      fontFamily: FontName.interSemiBold,
                      fontSize: 16,
                      color: Color(0xff243444),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 10, top: 20),
                          child: IntlPhoneField(
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            decoration: const InputDecoration(
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              print(
                                  "Updated Phone Number${phone.completeNumber}");
                              Environement.updatedDriverMobileNo =
                                  phone.completeNumber;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 00.0, bottom: 4, left: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            //onPrimary: Colors.black,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: FontName.interMedium,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 00.0, bottom: 4, right: 30),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColor.themeGreenColor,
                            ),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontFamily: FontName.interMedium,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final String info;
  final IconData icon;
  // final Widget? trailing;
  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      // padding: EdgeInsets.all(5),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyle.textfieldTitleBlackTextStyle,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          Container(
            // height: 35,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: ThemeColor.themeDarkGreyColor,
                ),
                SizedBox(width: 5),
                Text(info,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontName.interRegular,
                      color: ThemeColor.themeDarkGreyColor,
                    )
                    // Color(0xff666666)),
                    ),
              ],
            ),
            //  ListTile(
            //   dense: true,
            //   visualDensity:
            //       VisualDensity(vertical: -4), //The values ranges from -4 to 4
            //   minLeadingWidth: 2,
            //   contentPadding: EdgeInsets.zero,
            //   title: Text(
            //     info,
            //     style: TextStyle(
            //         fontSize: 15,
            //         fontFamily: FontName.interRegular,
            //         color: Color(0xff666666)),
            //   ),
            //   leading: Icon(icon),
            //   // trailing: trailing,
            //   onTap: () {},
            // ),
          ),
          // Divider(),
        ],
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.screenWidth,
          // color: Color(0xffEEEEEE),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10.0, top: 10),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: FontName.interSemiBold,
                  color: Colors.black),
            ),
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 15.0, top: 5, right: 15, bottom: 5),
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
          // color: Colors.white,

          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
