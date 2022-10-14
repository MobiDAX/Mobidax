import 'package:flutter/material.dart';
import '../helpers/sizes_helpers.dart';

const String _fontFamily = 'SourceSansPro';
const Color primaryColor = Color(0xff003A4C);
const Color onPrimary = Colors.white;
const Color backgroundColor = Color(0xff002F41);
const Color primaryVariant = Color(0xff12A8A7);
const Color systemGreen = Colors.green;
const Color systemRed = Colors.red;
const Color accentColor = Color(0xff12A8A7);

ThemeData appTheme() {
  return ThemeData(
    iconTheme: const IconThemeData(
      color: onPrimary,
    ),
    unselectedWidgetColor: Colors.grey,
    canvasColor: const Color(0xff12A8A7),
    accentColor: const Color(0xff12A8A7),
    primaryColor: primaryColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: onPrimary,
      selectionColor: accentColor.withOpacity(0.5),
      selectionHandleColor: onPrimary.withOpacity(0.7),
    ),
    dialogBackgroundColor: primaryColor,
    inputDecorationTheme: InputDecorationTheme(
        fillColor: primaryVariant,
        labelStyle: const TextStyle(
          color: primaryVariant,
        ),
        contentPadding: const EdgeInsets.only(
          left: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        hintStyle: const TextStyle(
          color: primaryVariant,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: primaryVariant,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
        )),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontFamily: _fontFamily,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        letterSpacing: 0.44,
        height: 1.0,
      ),
      bodyText2: TextStyle(
          fontFamily: _fontFamily,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12.0,
          letterSpacing: 0.25,
          height: 1.4),
      overline: TextStyle(
        fontFamily: _fontFamily,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: 10.0,
        letterSpacing: 0.5,
        height: 2.0,
      ),
      subtitle1: TextStyle(
        color: Colors.white, //TextFormField input color !
      ),
      subtitle2: TextStyle(
        fontFamily: _fontFamily,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.8,
        letterSpacing: 0.1,
      ),
      button: TextStyle(
        color: onPrimary, //TextFormField input color !
      ),
      headline6: TextStyle(
        color: onPrimary,
      ),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        error: Colors.red,
        onError: Colors.black,
        background: Colors.black, // Scrollable content background color
        surface: Colors.black, // Cards surface color
        primary: onPrimary, // App top bar color
        primaryVariant: Color.fromRGBO(
          87,
          87,
          87,
          0.38,
        ), // App clock background color
        secondary: Colors.white, // Enabled input color.
        secondaryVariant: Color(0xff121212), // Disabled input color
        onPrimary: Colors.white, // Color of content on primary color
        onSecondary: Colors.black, // Color of content on secondary color
        onBackground: Colors.white, // Color of content on background color
        onSurface: Colors.white, // Color of content on surface color
      ),
      minWidth: 272.0,
      height: 42.0,
      buttonColor: Colors.white,
      disabledColor: Colors.grey.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        primary: onPrimary,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      elevation: 0,
    )),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      error: Colors.red,
      onError: Colors.white,
      background: backgroundColor, // Scrollable content background color
      surface: primaryColor, // Cards surface color
      primary: Color(0xff003A4C), // App top bar color
      primaryVariant: primaryVariant, // App clock background color
      secondary: Colors.white, // Enabled input color.
      secondaryVariant: Color(0xff121212), // Disabled input color
      onPrimary: Colors.white, // Color of content on primary color
      onSecondary: Colors.black, // Color of content on secondary color
      onBackground: Colors.white, // Color of content on background color
      onSurface: Colors.white, // Color of content on surface color
    ),
  );
}

ButtonTheme exchangeTopButtonTheme(BuildContext context, Widget child) {
  return ButtonTheme(
    minWidth: displayWidth(context) * 0.01,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        8.0,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: child,
    ),
  );
}
