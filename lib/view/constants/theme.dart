import 'package:flutter/material.dart';

// The app's main accent colour
// Color _primary = PRIMARY_COLOR;

// The app's main accent colour
// Color _accent = _primary;
// const Color dark_accent = Color(0xFF3BC2CC);
// The accent for light themes
// const Color lightAccent = Color(0xFFfec28f);

// The primary background color for dark mode;
// Inversely this is the foreground color for light mode
const Color _bgDark = Color(0xFF0A0A0A);

// The primary background color for light mode;
// Inversely this is the foreground color for dark mode
// const Color bgLight = Color(0xFFF3F3F1);
// const Color bgLight = Color(0xFFF0EFF5); // iOS
// const Color bgLight = Color(0xFFF5F6F9);
// const Color bgLight = Color(0xFFF9F6F5);
const Color _bgLight = Color(0xFFF7F9FC);

// Surface's are used for Cards and ListTile elements
const Color _darkSurface = Color(0xFF2A2A2A);
const Color _lightSurface = Color(0xFFFFFFFF);
// const Color _lightSurface = Color(0xFFf6f8fb);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.purple,
  accentColor: Colors.purple,

  backgroundColor: _bgLight,
  scaffoldBackgroundColor: _bgLight,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: _bgLight,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: _bgDark),
  ),
  disabledColor: _bgDark.withOpacity(0.3),
  bottomAppBarTheme: BottomAppBarTheme(
    color: _lightSurface,
    elevation: 2.0,
  ),
  cardColor: _lightSurface,
  cardTheme: CardTheme(
    elevation: 0.0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dialogTheme: DialogTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  canvasColor: _lightSurface,
  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: _bgDark),
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  accentColor: Colors.purple,

  backgroundColor: _bgDark,
  scaffoldBackgroundColor: _bgDark,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: _bgDark,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: _lightSurface),
  ),
  disabledColor: _bgDark.withOpacity(0.3),
  bottomAppBarTheme: BottomAppBarTheme(
    color: _darkSurface,
    elevation: 2.0,
  ),
  cardColor: _darkSurface,
  cardTheme: CardTheme(
    elevation: 0.0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dialogTheme: DialogTheme(
    elevation: 0.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  canvasColor: _darkSurface,
  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: _bgLight),
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
);
