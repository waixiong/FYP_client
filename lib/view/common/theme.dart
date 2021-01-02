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


// headline1 = old display4,
// headline2 = old display3,
// headline3 = old display2,
// headline4 = old display1,
// headline5 = old headline,
// headline6 = old title,
// subtitle1 = old subhead,
// subtitle2 = old subtitle,
// bodyText1 = old body2,
// bodyText2 = old body1

const Color PRIMARY_COLOR = Color(0xFF4568DC);
const Color PRIMARY_COLOR_FOR_DARK = Color(0xFF4F72E6);
const Color RED_COLOR = Color(0xFFFF3165);
const Color GREEN_COLOR = Color(0xFF78CBBB);
const Color NIGHT_COLOR = Color(0xFF0F2027);
const Color LIGHT_COLOR = Color(0xFFF0DFD8);

List<Color> PIE_COLORS = [
  Color(0xFF024481), 
  Color(0xFF87A986), 
  Color(0xFFF7567C), 
  Color(0xFF018ABE), 
  Color(0xFF156064), 
  Color(0xFFD94174),
  Color(0xFFE98A15), 
  Color(0xFF293F14), 
  Color(0xFFAB81CD), 
  Color(0xFF4D9DE0),

  Color(0xFF5F1A37), Color(0xFF7871AA), Color(0xFF525C50), 
  Color(0xFF345559), Color(0xFFB89177), Color(0xFF485665),
  Color(0xFF56282D), Color(0xFF265D6E), Color(0xFF8E936D), Color(0xFF376156),
];

// List<Color> PIE_COLORS = [
//   Color(0xFF84AE8E), Color(0xFFDB6C79), Color(0xFF46A3A4), 
//   Color(0xFF4059AD), Color(0xFFA1457A), Color(0xFFDC991E),
//   Color(0xFFB47850)
// ];

const List<Color> PRIMARY_GRADIENT = [Color(0xFFB06AB3), Color(0xFF4568DC)]; 
const List<Color> PRIMARY_ALTERNATIVE_GRADIENT = [Color(0xFFDA7979), Color(0xFF4568DC)]; 
const List<Color> RED_GRADIENT = [Color(0xFFFC6767), Color(0xFFFF3165)]; 
const List<Color> GREEN_GRADIENT = [Color(0xFFA7E092), Color(0xFF78CBBB)]; 
const List<Color> NIGHT_GRADIENT = [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)];



final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: PRIMARY_COLOR,
  accentColor: PRIMARY_COLOR,
  backgroundColor: _bgLight,
  scaffoldBackgroundColor: _bgLight,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: _bgLight,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: _bgDark),
    textTheme: lightTextTheme
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
  tabBarTheme: TabBarTheme(
    labelColor: _bgDark,
    indicator: BoxDecoration(
      color: _bgLight,
      boxShadow: [BoxShadow(color: _bgLight),BoxShadow(color: _bgDark)]
    )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
    primary: PRIMARY_COLOR,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      // side: BorderSide()
    ),
  )),
  canvasColor: _lightSurface,
  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: _bgDark),
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
  textTheme: lightTextTheme,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[200],
    filled: true,
    labelStyle: TextStyle(
        color: Colors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  )
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: PRIMARY_COLOR_FOR_DARK,
  accentColor: PRIMARY_COLOR_FOR_DARK,
  backgroundColor: _bgDark,
  scaffoldBackgroundColor: _bgDark,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: _bgDark,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: _bgLight),
    textTheme: darkTextTheme,
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
  tabBarTheme: TabBarTheme(
    labelColor: _bgLight,
    indicator: BoxDecoration(
      color: _bgDark,
      boxShadow: [BoxShadow(color: _bgDark),BoxShadow(color: _bgLight)]
    )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
    primary: PRIMARY_COLOR_FOR_DARK,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      // side: BorderSide()
    ),
  )),
  canvasColor: _darkSurface,
  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: _bgLight),
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
  textTheme: darkTextTheme,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[800],
    filled: true,
    labelStyle: TextStyle(
        color: Colors.white),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white),
      borderRadius: BorderRadius.circular(20),
    ),
  )
);


final lightTextTheme = TextTheme(
    headline1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 72,
      color: _bgDark,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.4,
    ),
    headline2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 40,
      color: _bgDark,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.37
    ),
    headline3: TextStyle(
      fontFamily: "Poppins",
      fontSize: 32,
      color: _bgDark,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3
    ),
    headline4: TextStyle(
      fontFamily: "Poppins",
      fontSize: 26,
      color: _bgDark,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.26
    ),
    headline5: TextStyle(
      fontFamily: "Poppins",
      fontSize: 22,
      color: _bgDark,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.22
    ),
    headline6: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      color: _bgDark,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2
    ),
    subtitle1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _bgDark,
      fontWeight: FontWeight.w300,
      letterSpacing: 0
    ),
    subtitle2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _bgDark,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.1
    ),
    bodyText1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _bgDark,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1
    ),
    bodyText2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _bgDark,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      height: 1.3
    ),
    button: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _bgDark,
      fontWeight: FontWeight.w400,
      letterSpacing: 1
    ),
    caption: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _bgDark.withOpacity(0.8),
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.0
    ),
    overline: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _bgDark.withOpacity(0.9),
      fontWeight: FontWeight.w500,
      letterSpacing: -0.1
    )
  );

final darkTextTheme = TextTheme(
    headline1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 72,
      color: _lightSurface,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.7,
    ),
    headline2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 40,
      color: _lightSurface,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.9
    ),
    headline3: TextStyle(
      fontFamily: "Poppins",
      fontSize: 32,
      color: _lightSurface,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.75
    ),
    headline4: TextStyle(
      fontFamily: "Poppins",
      fontSize: 26,
      color: _lightSurface,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.55
    ),
    headline5: TextStyle(
      fontFamily: "Poppins",
      fontSize: 22,
      color: _lightSurface,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.45
    ),
    headline6: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      color: _lightSurface,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25
    ),
    subtitle1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _lightSurface,
      fontWeight: FontWeight.w300,
      letterSpacing: 0
    ),
    subtitle2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _lightSurface,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.1
    ),
    bodyText1: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _lightSurface,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1
    ),
    bodyText2: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _lightSurface,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      height: 1.3
    ),
    button: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _lightSurface,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.1
    ),
    caption: TextStyle(
      fontFamily: "Poppins",
      fontSize: 14,
      color: _lightSurface.withOpacity(0.8),
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.0
    ),
    overline: TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: _lightSurface.withOpacity(0.9),
      fontWeight: FontWeight.w500,
      letterSpacing: -0.1
    ),
  );