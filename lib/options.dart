class Options {
  static bool mcGrawEnabled = false;
  static bool mcGrawRunning = false;

  static setMcGrawEnabled(bool value) => mcGrawEnabled = value;
  static setMcGrawRunning(bool value) => mcGrawRunning = value;

  static bool getMcGrawEnabled() => mcGrawEnabled;
  static bool getMcGrawRunning() => mcGrawRunning;
}
