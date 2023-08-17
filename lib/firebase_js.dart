@JS()
library main;

import 'package:js/js.dart';

@JS('signUserIn')
external dynamic signUserIn(String email, String password);

@JS('clearState')
external dynamic clearState();

@JS('registerUser')
external dynamic registerUser(String email, String password);

@JS('checkSession')
external dynamic checkSession();

@JS('signUserOut')
external dynamic signUserOut();

@JS('updateUserEmail')
external dynamic updateUserEmail(String email);
