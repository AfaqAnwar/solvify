@JS()
library main;

import 'package:js/js.dart';

@JS('setStateOfExtension')
external void setStateOfExtension(String key, String value);

@JS('getStateOfExtension')
external String getStateOfExtension(String key);
