import 'package:flutter/material.dart';

class AppStyle {
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
}
