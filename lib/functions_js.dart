@JS()
library main;

import 'package:js/js.dart';

@JS('scrapeHTML')
external dynamic scrapeHTML();

@JS('checkCurrentTabURL')
external dynamic checkCurrentTabURL(List<String> list);

@JS('checkForMcGraw')
external dynamic checkForMcGraw();
