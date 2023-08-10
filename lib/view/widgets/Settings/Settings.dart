import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lttechapp/utility/appbarWidget.dart';
import 'package:provider/provider.dart';

import '../../../presenter/Lttechprovider.dart';
import '../../../utility/CustomTextStyle.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(),
      body: Consumer<Lttechprovider>(
        builder: (context, provider, child) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListView(
                children: [
                  Container(
                    margin: Platform.isAndroid
                        ? const EdgeInsets.only(
                            left: 12, top: 22, bottom: 9, right: 95)
                        : const EdgeInsets.only(
                            left: 12, top: 12, bottom: 9, right: 90),
                    height: 29,
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff000000),
                          fontFamily: 'InterBold'),
                    ),
                  ),
                  _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_none_rounded,
                    trailing: Switch(
                        activeColor: Color(0xff0AAC19),
                        value: _value,
                        onChanged: (value) {
                          _value = value;
                          provider.setUpdateView = true;
                        }),
                  ),
                  _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 10,
      title: Text(
        title,
        style: CustomTextStyle.textfieldTitleTextStyle,
      ),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
    );
  }
}
