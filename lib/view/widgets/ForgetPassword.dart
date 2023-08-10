import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utility/ColorTheme.dart';
import '../../utility/StatefulWrapper.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  TextEditingController emailController =
      // TextEditingController(text: 'sedaxo7225@nmaller.com');
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    navigateAfterSuccess(bool value) {
      final provider = Provider.of<Lttechprovider>(context, listen: false);
      if (value) {
        provider.showCommonToast("Link sent on your email to change password");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        provider.showCommonToast(
            "Something went wrong, please try again with vaild email address");
      }
    }

    return StatefulWrapper(
        onInit: () {},
        child: Scaffold(
            resizeToAvoidBottomInset: true,
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
                      )),
                )),
            body: Consumer<Lttechprovider>(builder: (context, value, child) {
              return Container(
                  child: SingleChildScrollView(
                physics: ScrollPhysics(),
                //   key:_formKey,
                // padding: const EdgeInsets.all(8.0),
                child: value.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 150.0),
                        child: CircularProgressIndicator(
                          backgroundColor: ThemeColor.themeLightGrayColor,
                          color: ThemeColor.themeGreenColor,
                        ))
                    : Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Image.asset(
                                  'assets/images/LoginIcon/login_imge.png',
                                  fit: BoxFit.fitWidth)),
                          SizedBox(height: 5.0),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10, right: 20),
                              child: Text(
                                'Forgot Your Password?',
                                style: TextStyle(
                                    fontFamily: 'InterBold',
                                    fontSize: 28,
                                    color: Colors.black),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: TextFormField(
                                    controller: emailController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (emailController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Please Enter Email Address",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                ThemeColor.themeGreenColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else if (!RegExp(r'\S+@\S+\.\S+')
                                          .hasMatch(emailController.text)) {
                                        //return "Please Enter a Valid Email";
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Enter a Valid Email Address",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                ThemeColor.themeGreenColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        var authresponse =
                                            Provider.of<Lttechprovider>(context,
                                                    listen: false)
                                                .forgetPasswordApiRequest(
                                                    emailController.text);

                                        authresponse.then((value) =>
                                            navigateAfterSuccess(value));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ThemeColor.themeGreenColor,
                                        textStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    child: Text('Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily:
                                                FontName.interSemiBold)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Enter your username or email address and we will send you instruction on how to create a new password.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontFamily: FontName.interMedium),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ));
            })));
  }
}
