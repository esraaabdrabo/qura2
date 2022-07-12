import 'dart:async';
import 'package:tt/screens/personInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tt/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:tt/providers/lang_mode.dart';

//to make animation screen write stainm
class splash extends StatefulWidget {
  static String splashRoute = 'splash';
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  delayNavigator() async {
    await new Future.delayed(const Duration(milliseconds: 2500));
    goToHome();
  }

  goToHome() {
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (__) => home()
            //home()
            ));
  }

  @override
  void initState() {
    super.initState();

    delayNavigator();
  }

  @override
  Widget build(BuildContext context) {
    hideNavSys() async {
      await SystemChrome.setEnabledSystemUIOverlays([]);
      //setEnabledSystemUIMode(SystemUiMode.manual,
      //  overlays: [SystemUiOverlay.top]);
    }

    hideNavSys();
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    String currentLang = provider.appLanguage;

    return Scaffold(
        body: Container(
      child: Image.asset(
        currentMode == 'light' && currentLang == 'ar'
            ? 'images/splash-LA.gif'
            : currentMode == 'light' && currentLang == 'en'
                ? 'images/splash-LE.gif'
                : currentMode == 'dark' && currentLang == 'ar'
                    ? 'images/splash-DA.gif'
                    : 'images/splash-DE.gif',
        fit: BoxFit.fitHeight,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    ));
  }
}
