import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color redLight = Color(0xFFE44125);
const Color blackShade = Color(0xFF222222);
const Color cherryRed = Color(0xffe8001d);
const Color greyShadeLight = Color(0xFFE5E5E5);
const Color greyLight = Color(0x0c000000);
const Color darkIndgigo = Color.fromRGBO(67, 91, 206, 0.9019607843137255);
const Color darkBlue = Color(0xff345475);

class TextStyles {
  static const notifierTextLabel = TextStyle(
    fontSize: 26,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );
}

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  backgroundColor: blackShade,
  colorScheme: ColorScheme.dark(primary: Colors.grey.shade200),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: Colors.black),
  dividerColor: Colors.black12,
  // or use string of the font in the assets 'SFUIDisplay'
  fontFamily: GoogleFonts.roboto().fontFamily,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0),
  ),
);

ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xffbfd3e2),//Color.fromRGBO(39, 75, 111, 1),
  scaffoldBackgroundColor: const Color(0xfff1f2f6),
  backgroundColor: greyShadeLight,
  colorScheme: const ColorScheme.light(primary: Colors.black54),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: Colors.white),
  dividerColor: Colors.white54,
  // or use string of the font in the assets 'SFUIDisplay'
  fontFamily: GoogleFonts.roboto().fontFamily,
  iconTheme: const IconThemeData(color: Color(0xff47a5ff)),
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Color(0xffbfd3e2)),
    headline3: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Color(0xffbfd3e2)),
    headline5: TextStyle(fontSize: 22.0, color: darkBlue, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 18.0, color: darkBlue, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 14.0, color: darkBlue, fontWeight: FontWeight.bold),
    bodyText2: TextStyle(fontSize: 16.0, color: darkBlue, fontWeight: FontWeight.w500),
    subtitle1: TextStyle(fontSize: 14.0, color: Color(0xffbfd3e2)),
    subtitle2: TextStyle(fontSize: 16.0, color: Colors.black38),
    button: TextStyle(fontSize: 18.0, color: Color(0xffbfd3e2)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(fontSize: 14.0, color: Color(0xffbfd3e2)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 1)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color(0xffbfd3e2), width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color(0xff47a5ff), width: 1)),
  ),
);
