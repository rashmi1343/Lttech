import 'package:flutter/material.dart';
import 'package:lttechapp/presenter/Lttechprovider.dart';
import 'package:lttechapp/utility/SizeConfig.dart';
import 'package:lttechapp/view/login_page.dart';
import 'package:provider/provider.dart';

import '../../utility/StatefulWrapper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    /**/
    return StatefulWrapper(
        onInit: () {
          Future.delayed(const Duration(seconds: 5)).then((value) {
            Provider.of<Lttechprovider>(context, listen: false)
                .navigatetologin(context);
          });
        },
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  child: Image.asset(
                      "assets/images/SplashIcon/splash_bckimage.png")),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 216,
                    width: 271,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/SplashIcon/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 97,
                    width: 271,
                    child: Text(
                      "LtTech",
                      style: TextStyle(
                          fontSize: 70,
                          color: Color(0xff000000),
                          fontFamily: 'MontHeavyDEMO'),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 31,
                      width: 313,
                      child: Text(
                        "LtTech Transport is the biggest refrigerated transport company in Geelong, Victoria.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff111111),
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
