import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';

import 'package:lttechapp/router/AppRoutes.dart';
import 'package:lttechapp/router/routes.dart';
import 'package:lttechapp/utility/env.dart';
import 'package:lttechapp/view/Splash/SplashScreen.dart';

import 'package:provider/provider.dart';

import 'data/shared_preferences/helper.dart';
import 'view/addjobdetail_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferenceHelper.isRemberme.then((value) => Environement.isremuser = value);
  if (Environement.isremuser) {
    await SharedPreferenceHelper.username
        .then((value) => Environement.remusername = value);
    await SharedPreferenceHelper.userpwd
        .then((value) => Environement.remuserpwd = value);
  } else {
    Environement.isremuser = false;
    Environement.remusername = '';
    Environement.remuserpwd  = '';
  }
  print("isrem_main:" + Environement.isremuser.toString());
  print("username_main:" + Environement.remusername.toString());
  print("password_main:" + Environement.remuserpwd.toString());

  HttpOverrides.global = DevHttpOverrides();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Lttechprovider())],
      child:  MyApp()));
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    print("isrem:"+Environement.isremuser.toString());
    print("username:"+Environement.remusername.toString());
    print("pwd:"+Environement.remuserpwd.toString());
    return MaterialApp(
      title: 'LtTech App',
      home: SplashScreen(),
      initialRoute: Routes.splash,
      routes: AppRoutes.routes,
      navigatorKey: navigatorKey,
    );
  }
}
