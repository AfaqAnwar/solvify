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

@JS('updateUserPassword')
external dynamic updateUserPassword(String password);

@JS('updateAPIKeyToFirestore')
external dynamic updateAPIKeyToFirestore(String apiKey);

@JS('getAPIKeyFromFirestore')
external dynamic getAPIKeyFromFirestore();

@JS('getOnboardedStatus')
external dynamic getOnboardedStatus();

@JS('updateOnboardedStatus')
external dynamic updateOnboardedStatus();
