import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tt/providers/lang_mode.dart';
import 'package:tt/widegets/sideMenu.dart';
import 'package:tt/widegets/widgets.dart'; //  AppLocalizations.of(context)!.light,
import '../myThemeData.dart';

class personInfo extends StatefulWidget {
  const personInfo({Key? key}) : super(key: key);

  @override
  State<personInfo> createState() => _personInfoState();
}

class _personInfoState extends State<personInfo> {
  late List<String> infoList;
//عبدالباسط
  List<String> abdelbaset_imgList = [
    'images/abdelbaset/4.jfif',
    'images/abdelbaset/1.jpg',
    'images/abdelbaset/3.jfif',
    'images/abdelbaset/2.jfif',
  ];
  void makeAbdElBasetInfoList(BuildContext context) {
    infoList = [
      AppLocalizations.of(context)!.abdElBasetbirth1,
      AppLocalizations.of(context)!.abdElBasetbirth2,
      AppLocalizations.of(context)!.abdElBasetDeath1,
      AppLocalizations.of(context)!.abdElBasetPrice1,
      AppLocalizations.of(context)!.abdElBasetPrice2,
      AppLocalizations.of(context)!.abdElBasetPrice3,
      AppLocalizations.of(context)!.abdElBasetPrice4,
      AppLocalizations.of(context)!.abdElBasetPrice5,
      AppLocalizations.of(context)!.abdElBasetPrice6,
      AppLocalizations.of(context)!.abdElBasetPrice7,
      AppLocalizations.of(context)!.abdElBasetPrice8,
      AppLocalizations.of(context)!.abdElBasetPrice9,
    ];
  }

//ماهر
  List<String> maher_imgList = [
    'images/maher/1.png',
    'images/maher/2.jfif',
    'images/maher/3.jfif',
    'images/maher/4.jfif',
  ];
  void makeMaherInfoList(BuildContext context) {
    infoList = [
      AppLocalizations.of(context)!.maherbirth1,
      AppLocalizations.of(context)!.maherbirth2,
      AppLocalizations.of(context)!.maherWork1,
      AppLocalizations.of(context)!.maherWork2,
      AppLocalizations.of(context)!.maherWork3,
      AppLocalizations.of(context)!.maherWork4,
    ];
  }

//الحصري
  List<String> hosary_imgList = [
    'images/hosary/4.jfif',
    'images/hosary/1.jfif',
    'images/hosary/3.jfif',
    'images/hosary/2.jfif',
    'images/hosary/5.jfif',
  ];
  void makeHosaryInfoList(BuildContext context) {
    infoList = [
      AppLocalizations.of(context)!.hosarybirth1,
      AppLocalizations.of(context)!.hosarybirth2,
      AppLocalizations.of(context)!.hosaryDeath1,
      AppLocalizations.of(context)!.hosaryWork1,
      AppLocalizations.of(context)!.hosaryWork2,
      AppLocalizations.of(context)!.hosaryWork3,
      AppLocalizations.of(context)!.hosaryWork4,
      AppLocalizations.of(context)!.hosaryWork5,
      AppLocalizations.of(context)!.hosaryWork6,
      AppLocalizations.of(context)!.hosaryWork7,
      AppLocalizations.of(context)!.hosaryWork8,
      AppLocalizations.of(context)!.hosaryWork9,
      AppLocalizations.of(context)!.hosaryWork10,
      AppLocalizations.of(context)!.hosaryWork11,
      AppLocalizations.of(context)!.hosaryWork12,
      AppLocalizations.of(context)!.hosaryWork13,
      AppLocalizations.of(context)!.hosaryWork14,
      AppLocalizations.of(context)!.hosaryWork15,
      AppLocalizations.of(context)!.hosaryWork16,
      AppLocalizations.of(context)!.hosaryWork17,
      AppLocalizations.of(context)!.hosaryWork18,
      AppLocalizations.of(context)!.hosaryWork19,
      AppLocalizations.of(context)!.hosaryWork20,
    ];
  }

//ناصر
  List<String> naser_imgList = [
    'images/naser/4.jfif',
    'images/naser/1.jfif',
    'images/naser/3.jfif',
    'images/naser/2.jfif',
    'images/naser/5.jfif',
  ];
  void makeNaserInfoList(BuildContext context) {
    infoList = [
      AppLocalizations.of(context)!.naserbirth1,
      AppLocalizations.of(context)!.naserbirth2,
      AppLocalizations.of(context)!.naserWork1,
      AppLocalizations.of(context)!.naserWork2,
      AppLocalizations.of(context)!.naserWork3,
      AppLocalizations.of(context)!.naserWork4,
    ];
  }

  Widget headLineContainer(String currentMode, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
        decoration: BoxDecoration(
          color: currentMode == 'light'
              ? lightTheme.LightThemeData.accentColor
              : DarkTheme.whiteColor,
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: currentMode == 'light'
              ? lightTheme.stepDiscriptionTextStyle
                  .copyWith(color: lightTheme.LightThemeData.primaryColor)
              : DarkTheme.stepDiscriptionTextStyle
                  .copyWith(color: DarkTheme.DarkThemeData.primaryColor),
        ),
      ),
    );
  }

  Widget imgListView(List imgList) {
    return Container(
      // color: Color.fromARGB(152, 187, 53, 53),
      height: MediaQuery.of(context).size.height * .2,
      child: ListView.builder(
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: imgList.length, // abdelbaset_imgList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Image.asset(
                imgList[index],
                fit: BoxFit.fitHeight,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    String currentLang = provider.appLanguage;

    // makeAbdElBasetInfoList(context);
    //  makeMaherInfoList(context);
    // makeHosaryInfoList(context);
    makeNaserInfoList(context);
    return Scaffold(
      /*appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .12,
          title: Text(AppLocalizations.of(context)!.abdElBasetName,
              style: lightTheme.LightThemeData.appBarTheme.toolbarTextStyle!)),
      drawer: sideMenu(),*/
      body: ListView(primary: false, children: [
        imgListView(maher_imgList),
        // maherInfo(currentMode)
        //imgListView(hosary_imgList),
        //  hosaryInfo(currentMode),
        // maherInfo(currentMode)
        // abdElbasetInfo(currentMode)
        naserInfo(currentMode)
      ]),
    );
  }

  abdElbasetInfo(String currentMode) {
    return Container(
      // color: Color.fromARGB(152, 187, 53, 53),
      height: MediaQuery.of(context).size.height * .8,

      child: ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: infoList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //    makeAbdElBasetInfoList(context);

            return Column(
              children: [
                //headlines
                infoList[index] ==
                        '${AppLocalizations.of(context)!.abdElBasetbirth1}'
                    //birth
                    ? headLineContainer(
                        currentMode, AppLocalizations.of(context)!.born)
                    : infoList[index] ==
                            '${AppLocalizations.of(context)!.abdElBasetDeath1}'
                        //born
                        ? headLineContainer(
                            currentMode, AppLocalizations.of(context)!.died)
                        : infoList[index] ==
                                '${AppLocalizations.of(context)!.abdElBasetPrice1}'
                            //prices
                            ? headLineContainer(currentMode,
                                AppLocalizations.of(context)!.prices)
                            : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //dot icon
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.circle,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                          ),
                          //space between icon and text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          //info text
                          Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                ' ${infoList[index]}',
                                style: currentMode == 'light'
                                    ? lightTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0)
                                    : DarkTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0),
                              )),
                        ],
                      )),
                ),
                //horizolntal line
              ],
            );
          }),
    );
  }

  maherInfo(String currentMode) {
    return Container(
      // color: Color.fromARGB(152, 187, 53, 53),
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: infoList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //    makeAbdElBasetInfoList(context);

            return Column(
              children: [
                //headlines
                infoList[index] ==
                        '${AppLocalizations.of(context)!.maherbirth1}'
                    //birth
                    ? headLineContainer(
                        currentMode, AppLocalizations.of(context)!.born)
                    : infoList[index] ==
                            '${AppLocalizations.of(context)!.maherWork1}'
                        //work
                        ? headLineContainer(
                            currentMode, AppLocalizations.of(context)!.work)
                        : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //dot icon
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.circle,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                          ),
                          //space between icon and text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          //info text
                          Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                ' ${infoList[index]}',
                                style: currentMode == 'light'
                                    ? lightTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0)
                                    : DarkTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0),
                              )),
                        ],
                      )),
                ),
                //horizolntal line
              ],
            );
          }),
    );
  }

  hosaryInfo(String currentMode) {
    return Container(
      // color: Color.fromARGB(152, 187, 53, 53),
      height: MediaQuery.of(context).size.height * 1.8,
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: infoList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //    makeAbdElBasetInfoList(context);

            return Column(
              children: [
                //headlines
                infoList[index] ==
                        '${AppLocalizations.of(context)!.hosarybirth1}'
                    //birth
                    ? headLineContainer(
                        currentMode, AppLocalizations.of(context)!.born)
                    : infoList[index] ==
                            '${AppLocalizations.of(context)!.hosaryDeath1}'
                        //born
                        ? headLineContainer(
                            currentMode, AppLocalizations.of(context)!.died)
                        : infoList[index] ==
                                '${AppLocalizations.of(context)!.hosaryWork1}'
                            //prices
                            ? headLineContainer(
                                currentMode, AppLocalizations.of(context)!.work)
                            : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //dot icon
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.circle,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                          ),
                          //space between icon and text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          //info text
                          Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                ' ${infoList[index]}',
                                style: currentMode == 'light'
                                    ? lightTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0)
                                    : DarkTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0),
                              )),
                        ],
                      )),
                ),
                //horizolntal line
              ],
            );
          }),
    );
  }

  naserInfo(String currentMode) {
    return Container(
      // color: Color.fromARGB(152, 187, 53, 53),
      height: MediaQuery.of(context).size.height * .4,
      child: ListView.builder(
          //primary: false,
          //scrollDirection: Axis.vertical,
          itemCount: infoList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //    makeAbdElBasetInfoList(context);

            return Column(
              children: [
                //headlines
                infoList[index] ==
                        '${AppLocalizations.of(context)!.naserbirth1}'
                    //birth
                    ? headLineContainer(
                        currentMode, AppLocalizations.of(context)!.born)
                    : infoList[index] ==
                            '${AppLocalizations.of(context)!.naserWork1}'
                        //prices
                        ? headLineContainer(
                            currentMode, AppLocalizations.of(context)!.work)
                        : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //dot icon
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.circle,
                              size: MediaQuery.of(context).size.width * .03,
                            ),
                          ),
                          //space between icon and text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          //info text
                          Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                ' ${infoList[index]}',
                                style: currentMode == 'light'
                                    ? lightTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0)
                                    : DarkTheme.lanAndModeSettings
                                        .copyWith(letterSpacing: 0),
                              )),
                        ],
                      )),
                ),
                //horizolntal line
              ],
            );
          }),
    );
  }
}
