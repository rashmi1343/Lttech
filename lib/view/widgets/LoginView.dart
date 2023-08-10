import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/CustomTextStyle.dart';
import 'package:lttechapp/utility/env.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../data/shared_preferences/helper.dart';
import '../../utility/ColorTheme.dart';
import '../../utility/StatefulWrapper.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController usernameController =
      //// TextEditingController(text: 'wadoke3940@edulena.com');
      // TextEditingController(text: 'sedaxo7225@nmaller.com');
      TextEditingController(text: '');

  // TextEditingController(text: 'yiyegix157@quipas.com'); // Mac John
  TextEditingController
      pwdController = //TextEditingController(text: 'Test@123');
      // TextEditingController(text: 'Bwit@123');
      TextEditingController(text: '');

  //  TextEditingController usernameController = TextEditingController();
  // TextEditingController pwdController = TextEditingController();

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isCheckedRememberMe = false;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // usernameController.text = '';
    // pwdController.text = '';
    //ApiCounter.loginuicounter = ApiCounter.loginuicounter +1;
    // FocusScope.of(context).unfocus();
    return StatefulWrapper(
      onInit: () async {
        final provider = Provider.of<Lttechprovider>(context, listen: false);

        isCheckedRememberMe = provider.isrem;
        usernameController.text = provider.username;
        pwdController.text = provider.password;

        print("isrem:" + isCheckedRememberMe.toString());
        print("username:" + usernameController.text.toString());
        print("password:" + pwdController.text.toString());

        isCheckedRememberMe = Environement.isremuser;
        usernameController.text = Environement.remusername;
        pwdController.text = Environement.remuserpwd;

        print("isrem_bg:" + isCheckedRememberMe.toString());
        print("username_bg:" + usernameController.text.toString());
        print("password_bg:" + pwdController.text.toString());

        // usernameController.text = provider.username.isNotEmpty
        //     ? provider.username
        //     : "sedaxo7225@nmaller.com";
        // pwdController.text =
        //     provider.password.isNotEmpty ? provider.password : "Bwit@123";

        // for logout to display in initial login view
        provider.arrcompanylist = [];
        provider.isloginsuccess = false;
      },
      child: Scaffold(
        body: Consumer<Lttechprovider>(builder: (context, value, child) {
          print("one 1244");

          return Center(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                //   key:_formKey,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Image.asset(
                            'assets/images/LoginIcon/login_imge.png',
                            fit: BoxFit.fitWidth)),
                    SizedBox(height: 5.0),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Welcome,',
                          style: TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 36,
                              color: Color(0xff0AAC19)),
                          textAlign: TextAlign.left,
                        )),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Sign in to Continue',
                          style: TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 24,
                              color: Color(0xff575757)),
                          textAlign: TextAlign.left,
                        )),

                    SizedBox(height: 20.0),
                    value.isloginsuccess
                        ? Container()
                        : TextFormField(
                            // scrollPadding: EdgeInsets.only(
                            //     bottom: 200),
                            controller: usernameController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Email ID',
                              hintStyle: TextStyle(
                                  fontSize: 17, fontFamily: 'InterRegular'),
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                    value.isloginsuccess
                        ? Container()
                        : TextFormField(
                            obscureText: !value.isPasswordHidden,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.none,
                            controller: pwdController,
                            //   scrollPadding: const EdgeInsets.only(bottom: 200),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  fontSize: 17, fontFamily: 'InterRegular'),
                              isDense: true,
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 20,
                              ),
                              suffix: InkWell(
                                onTap: () {
                                  value.setPasswordVisibility();
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: Icon(
                                  value.isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: value.isPasswordHidden
                                      ? ThemeColor.themeGreenColor
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 5.0,
                    ),

                    value.isloginsuccess
                        ? value.arrcompanylist.length > 1
                            ? Container(
                                height: 80,
                                margin: EdgeInsets.only(
                                    //left: 5,
                                    bottom: 5,
                                    //right: 5,
                                    top: 10),
                                alignment: Alignment.topLeft,
                                child: DropdownSearch<String>(

                                    /*dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select Company",
                              hintText: "Driver Company",
                            ),
                          ),*/

                                    popupProps: PopupProps.menu(
                                      //modalBottomSheet
                                      fit: FlexFit.loose,
                                      showSearchBox:
                                          value.arrcompanylist.length > 3,
                                      showSelectedItems: true,
                                      searchDelay:
                                          const Duration(milliseconds: 1),
                                      searchFieldProps: const TextFieldProps(
                                        decoration: InputDecoration(
                                          labelText: "Search Company",
                                        ),
                                      ),
                                      // disabledItemFn: (String s) =>
                                      //     s.startsWith('I'),
                                    ),
                                    items: value.arrcompanylist,

                                    // onChanged: print,
                                    onChanged: (selectedvalue) {
                                      if (value.isloginsuccess) {
                                        print(selectedvalue);
                                        value.selectedcompanystr =
                                            selectedvalue.toString();
                                        final selectedvalueindex = value
                                            .arrcompanylist
                                            .indexWhere((element) =>
                                                element ==
                                                value.selectedcompanystr);

                                        value.onchangecompanyselection(
                                            selectedvalueindex, context);
                                      }
                                    },
                                    selectedItem: //value
                                        //.selectedcompanystr,
                                        "Please Select a Company"),
                              )
                            : Container()
                        : Container(),

                    /*Container(
                                    height: 50,
                                    width: 380,
                                    padding: EdgeInsets.all(10.0),
                                    margin: EdgeInsets.only(
                                        //left: 5,
                                        bottom: 5,
                                        //right: 5,
                                        top: 10),
                                    //alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xffd3d3d3),
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      'Select Company',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'InterBold',
                                          fontSize: 16,
                                          color: Color(0xffd3d3d3)),
                                    ),
                                  ),*/

                    value.arrcompanylist.length > 1
                        ? Container()
                        : Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Color(0xff0AAC19)),
                                              child: Checkbox(
                                                  activeColor:
                                                      Color(0xff0AAC19),
                                                  value: isCheckedRememberMe,
                                                  onChanged: (bool? val) async {
                                                    isCheckedRememberMe =
                                                        !isCheckedRememberMe;
                                                    if (isCheckedRememberMe!) {
                                                      print("value:" +
                                                          isCheckedRememberMe
                                                              .toString());
                                                      await SharedPreferenceHelper
                                                          .saveusername(
                                                              usernameController
                                                                  .text);
                                                      await SharedPreferenceHelper
                                                          .saveuserpwd(
                                                              pwdController
                                                                  .text);
                                                      await SharedPreferenceHelper
                                                          .saveIsremember(
                                                              isCheckedRememberMe);
                                                    } else {
                                                      print("not saved");
                                                      print("value:" +
                                                          isCheckedRememberMe
                                                              .toString());
                                                      await SharedPreferenceHelper
                                                          .saveIsremember(
                                                              isCheckedRememberMe);
                                                    }
                                                    value.notifyListeners();
                                                  }))),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Remember Me",
                                        style: TextStyle(
                                            fontFamily: 'InterRegular',
                                            fontSize: 14,
                                            color: Color(0xff0AAC19)),
                                      )
                                    ]),
                                Spacer(), //
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, top: 15),
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<Lttechprovider>(context,
                                              listen: false)
                                          .navigatetoforgetpassword(context);
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Forgot Password?',
                                        style: TextStyle(
                                            fontFamily: 'InterRegular',
                                            fontSize: 14,
                                            color: Color(0xff0AAC19)),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                    value.arrcompanylist.length > 1
                        ? Container()
                        : RoundedLoadingButton(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            //
                            borderRadius: 5,
                            color: Color(0xff0AAC19),
                            successColor: Color(0xff0AAC19),
                            successIcon: Icons.check_circle,
                            failedIcon: Icons.error_outlined,
                            resetAfterDuration: true,
                            resetDuration: Duration(seconds: 3),
                            controller: _btnController,
                            onPressed: () {
                              print("login button click");
                              print("username:${usernameController.text}");
                              print("pwd:${pwdController.text}");
                              /*  Provider.of<Lttechprovider>(context, listen: false)
                                .authenticateApiRequest('', '', context);
                           */
                              if (usernameController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Username",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (!RegExp(r'\S+@\S+\.\S+')
                                  .hasMatch(usernameController.text)) {
                                //return "Please Enter a Valid Email";
                                Fluttertoast.showToast(
                                    msg: "Please Enter a Valid Email",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (pwdController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Password",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                //  getinitialchar();
                                Provider.of<Lttechprovider>(context,
                                        listen: false)
                                    .createtimesheet = 0;

                                var authresponse = Provider.of<Lttechprovider>(
                                        context,
                                        listen: false)
                                    .authenticateApiRequest(
                                        usernameController.text,
                                        pwdController.text,
                                        context);

                                authresponse
                                    .then((value) => proceedtodashboard());
                              }
                            },
                            child: Text('Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: FontName.interBold))),
                    value.arrcompanylist.length > 1
                        ? Container()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width, //
                            child: Center(
                              child: value.isLoading
                                  ? Text("Processing...",
                                      style: TextStyle(
                                          fontFamily: 'InterRegular',
                                          fontSize: 14,
                                          color: Color(0xff0AAC19)))
                                  : value.isError || value.isInactive
                                      ? setmessage(value)
                                      : Text(""),
                            ),
                          ),
                    /*
              ElevatedButton(

                  onPressed: () {


              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0AAC19)
                  ),

                  child: Text(
                'Login',
                style: TextStyle(
                    fontFamily: 'InterBold',
                    fontSize: 16,
                    color: Color(0xffffffff)),
              ))*/
                    // Container(height: 300)
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // void proceedtodashboard(AuthenticationResponse data) {
  void proceedtodashboard() {
    // print("authtoken ${data.accessToken}");
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  Widget setmessage(Lttechprovider lp) {
    // usernameController.clear();
    // pwdController.clear();

    if (lp.isInactive) {
      return Text("Driver Login is Disabled!",
          style: TextStyle(
              fontFamily: 'InterRegular', fontSize: 14, color: Colors.red));
    } else if (Environement.ACCESS_TOKEN.isEmpty) {
      return Text("Invalid user credentials!",
          style: TextStyle(
              fontFamily: 'InterRegular', fontSize: 14, color: Colors.red));
    } else {
      return Text("Something went wrong, Please try again!",
          style: TextStyle(
              fontFamily: 'InterRegular', fontSize: 14, color: Colors.red));
    }
  }

/*void getinitialchar() {
    Environement.initialloginname = usernameController.text[0];
    print("Initial:${Environement.initialloginname}");
  }*/
}
