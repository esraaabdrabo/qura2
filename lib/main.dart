import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt/myThemeData.dart';
import 'package:tt/providers/lang_mode.dart';
import 'package:tt/screens/home.dart';
import 'package:tt/screens/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tt/screens/splash.dart';
import 'package:tt/screens/upload.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (context) => lang_modeProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  static String homeRoute = 'home';
  static String baseServerUrl = 'https://c8d6-156-192-169-216.eu.ngrok.io/?';
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  String sharedMode = '', sharedLang = '';
  PageController _controller1 = PageController();

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);

    getSharedMode() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      sharedMode = prefs.getString('mode')!;
      print('from main shared mode = $sharedMode');
      if (sharedMode != '') provider.setNewMode(sharedMode);
    }

    getSharedMode();
    getSharedLang() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      sharedLang = prefs.getString('lang')!;
      print('from main shared lang = ${sharedLang}');
      if (sharedLang != '') provider.setNewLanguage(sharedLang);
    }

    getSharedLang();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('ar')],
        locale: Locale(provider.appLanguage),
        theme: provider.appMode == 'light'
            ? lightTheme.LightThemeData
            : DarkTheme.DarkThemeData,
        routes: {
          MyApp.homeRoute: (context) => MyApp(),
          upload.uploadRoute: (context) => upload(),
          record.recordRoute: (context) => record(),
          splash.splashRoute: (context) => splash()
        },
        initialRoute: splash.splashRoute,
        home: home());
  }
}
