import 'package:flutter/material.dart';

import 'ColorTheme.dart';

class FontName {
  static const interLight = "InterLight";
  static const interMedium = "InterMedium";
  static const interRegular = "InterRegular";
  static const interSemiBold = "InterSemiBold";
  static const interBold = "InterBold";
}

class FillTimeSheetCustomTS {
  static const TextStyle tfTitleLabelTS = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: FontName.interRegular,
    color: ThemeColor.themeDarkGreyColor,
  );
}

class CustomTextStyle {
  static const TextStyle textfieldPlaceholderTextStyle =
      TextStyle(fontSize: 14, fontFamily: FontName.interRegular);

  static TextStyle textfieldTitleTextStyle = TextStyle(
      fontSize: 15,
      fontFamily: FontName.interSemiBold,
      color: Color(0xff666666));

  static TextStyle textfieldTitleBlackTextStyle = TextStyle(
      fontSize: 15, fontFamily: FontName.interSemiBold, color: Colors.black);

  static const TextStyle homedashboardlist = TextStyle(
      fontSize: 15,
      color: Color(0xff111111),
      fontWeight: FontWeight.normal,
      fontFamily: FontName.interSemiBold);
}
