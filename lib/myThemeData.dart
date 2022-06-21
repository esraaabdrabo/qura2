import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class lightTheme {
  static TextStyle lanAndModeSettings = TextStyle(
    fontSize: 15,
    letterSpacing: 2,
    color: LightThemeData.accentColor,
  );
  static ThemeData LightThemeData = ThemeData(
      iconTheme: IconThemeData(
        color: Color(0xff273c57),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 52, 81, 118),
        selectedItemColor: Color(0xffDDD099),
        selectedIconTheme: IconThemeData(
          size: 30,
        ),
        unselectedItemColor: Color.fromARGB(65, 233, 223, 223),
      ),
      accentColor: Color(0XFF1C4C74), //
      primaryColor: Color.fromARGB(255, 242, 238, 191),
      scaffoldBackgroundColor: Color.fromARGB(255, 242, 238, 191),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0XFF1C4C74),
          centerTitle: true,
          titleSpacing: 3,
          toolbarTextStyle: GoogleFonts.arefRuqaa(
              textStyle: TextStyle(
            letterSpacing: 3,
            fontWeight: FontWeight.w300,
            fontSize: 35,
            color: Color.fromARGB(255, 242, 238, 191),
          ))),
      textTheme: TextTheme(
        headline1: GoogleFonts.markaziText(
            textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
                color: Color(0xff757575))),
      ),
      buttonTheme: ButtonThemeData(buttonColor: Color(0XFF1C4C74)));

  static BoxDecoration btnDecoration = BoxDecoration(
    color: Color(0xff273c57),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
  static TextStyle stepTextStyle = TextStyle(
    color: Color(0XFF4F3834),
    letterSpacing: 1,
    fontWeight: FontWeight.w100,
  );
  static Color whiteColor = Color.fromARGB(255, 218, 205, 204);
  static TextStyle stepDiscriptionTextStyle = TextStyle(
      color: lightTheme.LightThemeData.accentColor,
      fontWeight: FontWeight.w400,
      shadows: [
        Shadow(blurRadius: 1, color: Color.fromARGB(136, 93, 10, 10)),
        Shadow(blurRadius: 2, color: Color.fromARGB(136, 240, 88, 88))
      ],
      fontSize: 18,
      letterSpacing: 1);
  static TextStyle instructionDetails = TextStyle(
      fontSize: 16,
      color: lightTheme.LightThemeData.accentColor,
      fontWeight: FontWeight.w300,
      letterSpacing: 1);

  static ButtonStyle btnStyle = ButtonStyle(
    textStyle: MaterialStateProperty.all(lightTheme.lanAndModeSettings),
    backgroundColor: MaterialStateProperty.all(Color.fromARGB(157, 133, 7, 7)),
  );
}

class DarkTheme {
  static TextStyle lanAndModeSettings = TextStyle(
      fontSize: 15,
      letterSpacing: 2,
      fontWeight: FontWeight.w300,
      color: Color.fromARGB(211, 250, 249, 249));

  static ThemeData DarkThemeData = ThemeData(
      iconTheme: IconThemeData(
        color: Color(0xffDDD099),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 52, 81, 118),
        selectedItemColor: Color(0xffDDD099),
        selectedIconTheme: IconThemeData(
          size: 30,
        ),
        unselectedItemColor: Color.fromARGB(65, 233, 223, 223),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 52, 81, 118),
        centerTitle: true,
        toolbarTextStyle: GoogleFonts.arefRuqaa(
            textStyle: TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.w300,
          fontSize: 35,
          color: Color.fromARGB(255, 242, 238, 191),
        )),
      ),
      primaryColor: Color.fromARGB(255, 52, 81, 118),
      accentColor: Color(0xffDDD099),
      scaffoldBackgroundColor: Color(0xff273c57),
      textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
              color: Color(0XFfF6F9EA))));
  static BoxDecoration btnDecoration = BoxDecoration(
    color: Color(0XFfF6F9EA),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
  static TextStyle stepTextStyle = TextStyle(
    color: Color(0XFF4F3834),
    letterSpacing: 1,
    fontWeight: FontWeight.w100,
  );
  static Color whiteColor = Color.fromARGB(211, 250, 249, 249);
  static TextStyle stepDiscriptionTextStyle = TextStyle(
      color: DarkTheme.whiteColor,
      fontWeight: FontWeight.w400,
      shadows: [
        Shadow(blurRadius: 1, color: Color.fromARGB(196, 226, 234, 125)),
        Shadow(blurRadius: 2, color: Color.fromARGB(136, 240, 88, 88))
      ],
      letterSpacing: 1);
  static TextStyle instructionDetails = TextStyle(
      fontSize: 16,
      color: Color.fromARGB(211, 250, 249, 249),
      fontWeight: FontWeight.w300,
      letterSpacing: 1);
  static ButtonStyle btnStyle = ButtonStyle(
    textStyle: MaterialStateProperty.all(TextStyle(
      fontSize: 15,
      letterSpacing: 2,
      fontWeight: FontWeight.w300,
      color: Color(0xff273c57),
    )),
    backgroundColor: MaterialStateProperty.all(DarkThemeData.accentColor),
  );
}
 
//dark
//text => E0C097
//background => 2D2424
// btn =>B85C38
///////////////////////////////
///light
//text => 8E806A
//background => FFE6BC
// btn =>C3B091