import 'package:flutter/material.dart';
import 'package:e_szivacs/globals.dart' as globals;

class ColorManager {

  Color getColorSample(int id){
    Color sample = Colors.blue;
    switch(id) {
      case 0: sample = Colors.blue; break;
      case 1: sample = Colors.red; break;
      case 2: sample = Colors.green; break;
      case 3: sample = Colors.lightGreen; break;
      case 4: sample = Colors.yellow; break;
      case 5: sample = Colors.orangeAccent; break;
      case 6: sample = Colors.grey; break;
      case 7: sample = Colors.pink; break;
      case 8: sample = Colors.purple; break;
      case 9: sample = Colors.teal; break;
    }
    return sample;
  }

  ThemeData getTheme(brightness) {
    Color accent;
    Color primary;
    Color primaryLight;
    Color primaryDark = Color.fromARGB(255, 25, 25, 25);
    Color background;

    switch (globals.themeID) {
      case 0:
        accent = Colors.blue;
        primaryLight = Colors.blue[700];
        break;
      case 1:
        accent = Colors.redAccent;
        primaryLight = Colors.red[700];
        break;
      case 2:
        accent = Colors.green;
        primaryLight = Colors.green[700];
        break;
      case 3:
        accent = Colors.lightGreen;
        primaryLight = Colors.lightGreen[700];
        break;
      case 4:
        accent = Colors.yellow;
        primaryLight = Colors.yellow[700];
        break;
      case 5:
        accent = Colors.orangeAccent;
        primaryLight = Colors.orangeAccent[400];
        break;
      case 6:
        accent = Colors.blueGrey;
        primaryLight = Colors.grey[700];
        break;
      case 7:
        accent = Colors.pink;
        primaryLight = Colors.pink[700];
        break;
      case 8:
        accent = Colors.purple;
        primaryLight = Colors.purple[700];
        break;
      case 9:
        accent = Colors.teal;
        primaryLight = Colors.teal[700];
        break;

    }

    if (brightness.index == 0) {
      primary = primaryDark;
      background = Color.fromARGB(255, 40, 40, 40);
    } else {
      primary = primaryLight;
      background = null;
    }

    if (globals.isAmoled && globals.isDark) {
      primary = Colors.black;
      background = Colors.black;
    }

    //globals.isDark = brightness.index == 0;
    return new ThemeData(
      primarySwatch: Colors.blue,
      accentColor: accent,
      brightness: brightness,
      primaryColor: primary,
      primaryColorLight: primaryLight,
      primaryColorDark: primaryDark,
      appBarTheme: AppBarTheme(
        color: primary,
      ),
      scaffoldBackgroundColor: background,
      dialogBackgroundColor: background,
      cardColor: brightness.index == 0 ? Color.fromARGB(255, 25, 25, 25) : null,
      fontFamily: 'Quicksand',
    );
  }
}