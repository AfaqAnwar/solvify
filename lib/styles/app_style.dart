import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle currentMainHeadingFont = GoogleFonts.karla();

  static bool isDarkMode = true;

  // Primary background color for OLED dark mode
  static Color primaryBackground =
      const Color.fromARGB(255, 0, 0, 0); // pure black for OLED

  // Secondary background color for components like cards or modals
  static Color secondaryBackground =
      const Color.fromARGB(255, 10, 10, 10); // slight grey

  // Borders or dividers color
  static Color dividerColor =
      const Color.fromARGB(255, 20, 20, 20); // dark grey

  // Primary accent color
  static Color primaryAccent =
      const Color.fromARGB(255, 98, 0, 238); // medium purple

  // Light version of primary accent for highlights or gradients
  static Color primaryLightAccent =
      const Color.fromARGB(255, 120, 81, 169); // lightest purple

  // Dark version of primary accent for active state, buttons, etc.
  static Color primaryDarkAccent =
      const Color.fromARGB(255, 49, 0, 115); // darkest purple

  // Secondary accent color
  static Color secondaryAccent =
      const Color.fromARGB(255, 24, 123, 148); // medium teal

  // Light version of secondary accent for highlights or gradients
  static Color secondaryLightAccent =
      const Color.fromARGB(255, 180, 210, 228); // light teal

  // Dark version of secondary accent for active state, buttons, etc.
  static Color secondaryDarkAccent =
      const Color.fromARGB(255, 2, 64, 85); // darkest teal

  // Tertiary color (could be used for warnings or to draw attention)
  static Color tertiaryColor =
      const Color.fromARGB(255, 255, 192, 0); // medium yellow

  // Light version of tertiary color
  static Color tertiaryLightColor =
      const Color.fromARGB(255, 255, 224, 130); // light yellow

  // Dark version of tertiary color
  static Color tertiaryDarkColor =
      const Color.fromARGB(255, 184, 134, 0); // darkest yellow

  // Primary Green Success Indicator
  static Color primarySuccess =
      const Color.fromARGB(255, 1, 182, 54); // pure green

  // Primary Red Error Indicator
  static Color primaryError = const Color.fromARGB(255, 255, 0, 0); // pure red

  static Color primaryTextForDarkMode =
      const Color.fromARGB(255, 255, 255, 255);
  static Color primaryTextForLightMode = const Color.fromARGB(255, 0, 0, 0);

  static Color primaryIconForDarkMode =
      const Color.fromARGB(255, 255, 255, 255);
  static Color primaryIconForLightMode = const Color.fromARGB(255, 0, 0, 0);

  static Color darkTextFieldHintColor = Colors.grey.shade400;
  static Color darkTextFieldTextColor = Colors.white;

  static Color lightTextFieldHintColor = Colors.grey.shade600;
  static Color lightTextFieldTextColor = Colors.black;

  static Color faqTextHeading = const Color.fromARGB(255, 250, 250, 250);

  static void setToLightMode() {
    primaryBackground = const Color.fromARGB(255, 255, 255, 255);
    secondaryBackground = const Color.fromARGB(255, 250, 250, 250);
    dividerColor = const Color.fromARGB(255, 240, 240, 240);
    primaryAccent = const Color.fromARGB(255, 98, 0, 238);
    primaryLightAccent = const Color.fromARGB(255, 120, 81, 169);
    primaryDarkAccent = const Color.fromARGB(255, 49, 0, 115);
    secondaryAccent = const Color.fromARGB(255, 24, 123, 148);
    secondaryLightAccent = const Color.fromARGB(255, 180, 210, 228);
    secondaryDarkAccent = const Color.fromARGB(255, 2, 64, 85);
    tertiaryColor = const Color.fromARGB(255, 255, 192, 0);
    tertiaryLightColor = const Color.fromARGB(255, 255, 224, 130);
    tertiaryDarkColor = const Color.fromARGB(255, 184, 134, 0);
    primarySuccess = const Color.fromARGB(255, 1, 182, 54);
    primaryError = const Color.fromARGB(255, 255, 0, 0);
    faqTextHeading = primaryAccent;
    isDarkMode = false;
  }

  static void setToDarkMode() {
    primaryBackground = const Color.fromARGB(255, 0, 0, 0);
    secondaryBackground = const Color.fromARGB(255, 10, 10, 10);
    dividerColor = const Color.fromARGB(255, 20, 20, 20);
    primaryAccent = const Color.fromARGB(255, 98, 0, 238);
    primaryLightAccent = const Color.fromARGB(255, 120, 81, 169);
    primaryDarkAccent = const Color.fromARGB(255, 49, 0, 115);
    secondaryAccent = const Color.fromARGB(255, 24, 123, 148);
    secondaryLightAccent = const Color.fromARGB(255, 180, 210, 228);
    secondaryDarkAccent = const Color.fromARGB(255, 2, 64, 85);
    tertiaryColor = const Color.fromARGB(255, 255, 192, 0);
    tertiaryLightColor = const Color.fromARGB(255, 255, 224, 130);
    tertiaryDarkColor = const Color.fromARGB(255, 184, 134, 0);
    primarySuccess = const Color.fromARGB(255, 1, 182, 54);
    primaryError = const Color.fromARGB(255, 255, 0, 0);
    faqTextHeading = const Color.fromARGB(255, 250, 250, 250);
    isDarkMode = true;
  }

  static Color getTextColor() {
    if (isDarkMode) {
      return primaryTextForDarkMode;
    } else {
      return primaryTextForLightMode;
    }
  }

  static Color getIconColor() {
    if (isDarkMode) {
      return primaryIconForDarkMode;
    } else {
      return primaryIconForLightMode;
    }
  }

  static Color getTextFieldHintColor() {
    if (isDarkMode) {
      return darkTextFieldHintColor;
    } else {
      return lightTextFieldHintColor;
    }
  }

  static Color getTextFieldTextColor() {
    if (isDarkMode) {
      return darkTextFieldTextColor;
    } else {
      return lightTextFieldTextColor;
    }
  }

  static Color getAccent() {
    return primaryAccent;
  }

  static String getIdleGif() {
    if (isDarkMode) {
      return "assets/gifs/idle_dark.gif";
    } else {
      return "assets/gifs/idle_light.gif";
    }
  }

  static String getLoadingGif() {
    if (isDarkMode) {
      return "assets/gifs/load_dark.gif";
    } else {
      return "assets/gifs/load_light.gif";
    }
  }

  static String getErrorGif() {
    if (isDarkMode) {
      return "assets/gifs/error_dark.gif";
    } else {
      return "assets/gifs/error_light.gif";
    }
  }
}
