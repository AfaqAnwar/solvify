@JS()
library main;

import 'package:js/js.dart';

@JS('signUserIn')
external void signUserIn(String email, String password);

@JS('clearState')
external void clearState();

@JS('registerUser')
external void registerUser(String email, String password);

@JS('checkSession')
external void checkSession();
