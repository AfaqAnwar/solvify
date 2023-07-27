console.log("common.js loaded");

import {
  getAuth,
  signInWithEmailAndPassword,
} from "./firebase/firebase-auth.js";

window.userState = {
  loggedIn: false,
  email: "",
  uid: "",
  error: "",
};

window.alertMessage = (text) => {
  alert(text);
};

window.logger = (flutter_value) => {
  console.log({ js_context: this, flutter_value });
};

window.signUserIn = async (email, password) => {
  const auth = await getAuth();
  signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      window.userState.loggedIn = true;
      window.userState.email = user.email;
      window.userState.uid = user.uid;
      // ...
    })
    .catch((error) => {
      window.userState.loggedIn = false;
      const errorCode = error.code;
      const errorMessage = error.message;
      window.userState.error = errorCode;
    });
};

window.clearState = () => {
  window.userState.loggedIn = false;
  window.userState.email = "";
  window.userState.uid = "";
  window.userState.error = "";
};
