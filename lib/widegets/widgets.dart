import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import '../myThemeData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // AppLocalizations.of(context)!.light,

class widgets {
  static Widget predictionBackgroundContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.width * .35,
      //image
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/musicBG.png',
              ),
              fit: BoxFit.contain)),
    );
  }

  static Widget musicBackgroundContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * .6,
      height: MediaQuery.of(context).size.width * .35,
      //image
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/noNamedBG.png',
              ),
              fit: BoxFit.contain)),
    );
  }

  static Widget musicLine(BuildContext context, String currentMode,
      {int musicNum = 10}) {
    return SizedBox(
      width: musicNum != 10
          ? MediaQuery.of(context).size.width * .3
          : MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return MiniMusicVisualizer(
            color: currentMode == 'light'
                ? lightTheme.LightThemeData.accentColor
                : DarkTheme.DarkThemeData.accentColor, // DarkTheme.whiteColor,

            height: 15,
          );
        },
        itemCount: musicNum,
      ),
    );
  }

  static Widget silenceLine(BuildContext context, String currentMode,
      {double lineWidth = .5}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * lineWidth,
        height: MediaQuery.of(context).size.width * .005,
        color: currentMode == 'light'
            ? lightTheme.LightThemeData.accentColor
            : Color(
                0xffDDD099), //DarkTheme.DarkThemeData.accentColor, // DarkTheme.whiteColor,
      ),
    );
  }

  static Widget horizontalLine(String currentMode,
      {double lineWidth = 50, needOpacity = false}) {
    return Container(
      width: lineWidth,
      color: currentMode == 'dark'
          ? needOpacity
              ? Color.fromARGB(61, 214, 216, 211)
              : Color(0xffd6d8d3)
          : needOpacity
              ? Color.fromARGB(48, 39, 60, 87)
              : Color(0xff273c57),
      height: 3,
    );
  }

  static Widget stepContainer(
      BuildContext context, String number, String stepName,
      {bool needTransform = false, double containerWidth = 100}) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //step name
      //stack here is using for make step name on the background img
      Stack(children: [
        //back ground img
        Container(
          // width: needTransform ? 200 : 170,
          child: SvgPicture.asset(
            'images/islamiTextBG.svg',
            height: MediaQuery.of(context).size.width * .33,
          ),
        ),
        needTransform
            ? Container(
                //to center text
                // mainAxisAlignment: MainAxisAlignment.center,
                child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Container(
                    //  color: Color(0xff014173),
                    alignment: AlignmentGeometry.lerp(
                        Alignment.center, Alignment.center, 1),
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .42,
                    child: Text(
                      stepName,
                      style: GoogleFonts.markaziText(
                          textStyle: DarkTheme.stepTextStyle.copyWith(
                              color: Color(0xffd6d8d3),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1)),
                    )),
              ))
            //name
            : Container(
                alignment: AlignmentGeometry.lerp(
                    Alignment.center, Alignment.center, 1),
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width * .42,
                // color: Color.fromARGB(255, 125, 169, 203),
                child: Text(
                  stepName,
                  style: GoogleFonts.markaziText(
                      textStyle: DarkTheme.stepTextStyle.copyWith(
                          fontSize: 25,
                          color: Color(0xffd6d8d3),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3)),
                )),
      ]),
    ]));
  }

  static stepDiscriptionContainer(
      String currentMode, BuildContext context, String discription) {
    return Container(
        //leave space between text and mic
        padding: EdgeInsets.only(bottom: 35),
        //have width to control the extra text in a new row
        width: MediaQuery.of(context).size.width * .7,
        child: Text(
          discription,
          textAlign: TextAlign.center,
          style: GoogleFonts.markaziText(
              textStyle: currentMode == 'light'
                  ? lightTheme.stepDiscriptionTextStyle
                  : DarkTheme.stepDiscriptionTextStyle.copyWith(fontSize: 18)),
        ));
  }

  static stepInstructionsCoulmn(
      String currentMode, BuildContext context, List<String> instructionsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widgets.horizontalLine(currentMode,
            needOpacity: true, lineWidth: MediaQuery.of(context).size.width),
        //instructions
        Padding(
            padding: const EdgeInsets.only(top: 35, bottom: 10),
            child: Text(AppLocalizations.of(context)!.instructions,
                textAlign: TextAlign.start,
                style: GoogleFonts.markaziText(
                    textStyle: currentMode == 'light'
                        ? lightTheme.stepDiscriptionTextStyle
                        : DarkTheme.stepDiscriptionTextStyle))),
        //follow instruction
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
              AppLocalizations.of(context)!.pleaseFollowThisInstructions,
              textAlign: TextAlign.start,
              style: GoogleFonts.markaziText(
                  textStyle: currentMode == 'light'
                      ? lightTheme.instructionDetails
                      : DarkTheme.instructionDetails)),
        ),
        Container(
          //  color: Color.fromARGB(167, 126, 32, 32),
          height: MediaQuery.of(context).size.height * .2,
          child: ListView.builder(
              itemCount: instructionsList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15),
                    child: Text(
                      instructionsList[index],
                      textAlign: TextAlign.start,
                      style: GoogleFonts.markaziText(
                          textStyle: currentMode == 'light'
                              ? lightTheme.instructionDetails
                              : DarkTheme.instructionDetails),
                    ));
              }),
        ),
      ],
    );
  }

  static Widget verticalLine(BuildContext context, String currentMode,
      {int widgetNum = 0, double lineHight = 100}) {
    return //vertical line and content
        Container(
      height: lineHight,

      //vertical line and content
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //vetical line
          Container(
            height: lineHight,
            color: currentMode == 'light'
                ? lightTheme.LightThemeData.accentColor
                : DarkTheme.DarkThemeData
                    .accentColor, //Color(0XFf9d87a6), // DarkTheme.DarkThemeData.accentColor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .007,
            ),
          ),
        ],
      ),
    );
  }

  static Widget success(BuildContext context, String currentMode) {
    return Container(
        width: MediaQuery.of(context).size.width * .15,
        //  height: MediaQuery.of(context).size.height * .1,
        child: Image.asset('images/success.png',
            color: currentMode == 'light'
                ? Color.fromARGB(157, 133, 7, 7)
                : Color.fromARGB(193, 249, 249, 249)));
  }

  static Widget waitingPython(
      BuildContext context, String currentMode, String text) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .05,
        ),
        widgets.stepDiscriptionContainer(currentMode, context, text),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        CircularProgressIndicator()
      ],
    );
  }
}
