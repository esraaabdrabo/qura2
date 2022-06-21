import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt/myThemeData.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tt/providers/lang_mode.dart';

class sideMenu extends StatefulWidget {
  @override
  State<sideMenu> createState() => _sideMenuState();
}

class _sideMenuState extends State<sideMenu> {
  var Applocal = AppLocalizations;
  bool showLang = false;
  bool checkBoxEnglish = false;
  bool checkBoxArabic = false;
  var lanAndMode = TextStyle(
    fontSize: 15,
    letterSpacing: 2,
    color: lightTheme.LightThemeData.accentColor,
  );
  //  color: Color.fromARGB(100, 235, 223, 223));
  bool showMode = false;
  bool checkBoxDark = false;
  bool checkBoxLight = false;
  //get instance from shared prefrence

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    return Container(
      width: MediaQuery.of(context).size.width * .6,
      color: currentMode == 'light'
          ? lightTheme.LightThemeData.primaryColor
          : DarkTheme.DarkThemeData.primaryColor,
      padding: EdgeInsets.all(30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 30),
        //settings text
        Text(AppLocalizations.of(context)!.settings,
            style: GoogleFonts.markaziText(
                textStyle: currentMode == 'light'
                    ? lightTheme.instructionDetails.copyWith(
                        fontSize: 30,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w700)
                    : DarkTheme.instructionDetails.copyWith(
                        fontSize: 25,
                        letterSpacing: 4,
                      )

                //  color: Color.fromARGB(168, 235, 223, 223)),
                )),
        SizedBox(height: 25),
        //language
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.language,
            style: GoogleFonts.markaziText(
                textStyle: currentMode == 'light'
                    ? lightTheme.lanAndModeSettings
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w600)
                    : DarkTheme.lanAndModeSettings
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          onPressed: () {
            showLang ? showLang = false : showLang = true;
            setState(() {});
          },
        ),
        showLang
            ? Container(
                padding: EdgeInsets.all(15),
                color: Color.fromARGB(68, 117, 113, 113),
                child: Column(
                  children: [
                    //english
                    Row(
                      children: [
                        Checkbox(
                            value: provider.appLanguage == 'en' ? true : false,
                            onChanged: (value) async {
                              //can not choose two lang at the same time
                              if (checkBoxArabic) checkBoxArabic = false;
                              this.checkBoxEnglish = value!;
                              provider.setNewLanguage('en');
                              setNewLangInShared('en');
                              setState(() {});
                            }),
                        Text(
                          'english',
                          style: GoogleFonts.markaziText(
                              textStyle: currentMode == 'light'
                                  ? lightTheme.lanAndModeSettings.copyWith(
                                      fontSize: 18,
                                    )
                                  : DarkTheme.lanAndModeSettings.copyWith(
                                      fontSize: 18,
                                    )),
                        )
                      ],
                    ),

                    //arabic
                    Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                            value: provider.appLanguage == 'ar' ? true : false,
                            onChanged: (value) async {
                              if (checkBoxEnglish) checkBoxEnglish = false;
                              this.checkBoxArabic = value!;
                              provider.setNewLanguage('ar');
                              setNewLangInShared('ar');
                              setState(() {});
                            }),
                        Text(
                          'العربية',
                          style: GoogleFonts.markaziText(
                                  textStyle: currentMode == 'light'
                                      ? lightTheme.lanAndModeSettings.copyWith(
                                          fontSize: 18,
                                        )
                                      : DarkTheme.lanAndModeSettings)
                              .copyWith(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.mode,
            style: GoogleFonts.markaziText(
                    textStyle: currentMode == 'light'
                        ? lightTheme.lanAndModeSettings
                            .copyWith(fontSize: 20, fontWeight: FontWeight.w600)
                        : DarkTheme.lanAndModeSettings)
                .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            showMode ? showMode = false : showMode = true;
            setState(() {});
          },
        ),
        showMode
            ? Container(
                padding: EdgeInsets.all(15),
                color: Color.fromARGB(68, 117, 113, 113),
                //dark and light
                child: Column(
                  children: [
                    //dark
                    Row(
                      children: [
                        Checkbox(
                            value: provider.appMode == 'dark' ? true : false,
                            onChanged: (value) {
                              if (checkBoxLight) checkBoxLight = false;
                              provider.setNewMode('dark');

                              setNewModeInShared('dark');

                              setState(() {
                                this.checkBoxDark = value!;
                              });
                            }),
                        //dark
                        Text(
                          AppLocalizations.of(context)!.dark,
                          style: GoogleFonts.markaziText(
                              textStyle: currentMode == 'light'
                                  ? lightTheme.lanAndModeSettings
                                  : DarkTheme.lanAndModeSettings),
                        )
                      ],
                    ),

                    //light
                    Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                            value: provider.appMode == 'light' ? true : false,
                            onChanged: (value) async {
                              setState(() {
                                if (checkBoxDark) checkBoxDark = false;
                                provider.setNewMode('light');
                              });
                              setNewModeInShared('light');
                              this.checkBoxLight = value!;
                            }),
                        //light
                        Text(
                          AppLocalizations.of(context)!.light,
                          style: GoogleFonts.markaziText(
                              textStyle: currentMode == 'light'
                                  ? lightTheme.lanAndModeSettings
                                  : DarkTheme.lanAndModeSettings),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ]),
    );
  }

  setNewModeInShared(String newMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('from set new mode the old mode is : ${prefs.get('mode')}');
    prefs.setString('mode', newMode);
    print('from set new mode the new mode is : ${prefs.get('mode')}');
  }

  setNewLangInShared(String newLang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  print('from set new lang the new lang is : ${prefs.get('lang')}');

    prefs.setString('lang', newLang);
    print('from set new lang the new lang is : ${prefs.get('lang')}');
  }

  getSharedMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('mode');
  }

  getSharedLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('lang');
  }
}
