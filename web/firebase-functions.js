import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  setPersistence,
  inMemoryPersistence,
} from "./firebase/firebase-auth.js";

window.userState = {
  loggedIn: false,
  email: "",
  uid: "",
  error: "",
  sessionActive: false,
  sessionError: "",
};

window.auth = getAuth();

window.signUserIn = async (email, password) => {
  window.auth = await getAuth();
  signInWithEmailAndPassword(window.auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      window.userState.loggedIn = true;
      window.userState.email = user.email;
      window.userState.uid = user.uid;
    })
    .catch((error) => {
      window.userState.loggedIn = false;
      const errorCode = error.code;
      window.userState.error = errorCode;
      window.userState.sessionActive = false;
    });
};

window.registerUser = async (email, password) => {
  window.auth = getAuth();
  createUserWithEmailAndPassword(window.auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      window.userState.loggedIn = true;
      window.userState.email = user.email;
      window.userState.uid = user.uid;
    })
    .catch((error) => {
      window.userState.loggedIn = false;
      const errorCode = error.code;
      window.userState.error = errorCode;
      window.userState.sessionActive = false;
    });
};

function saveAuth() {
  setPersistence(window.auth, inMemoryPersistence)
    .then(() => {
      window.userState.sessionActive = true;
    })
    .catch((sError) => {
      // Handle Errors here.
      const sessionErrorCode = sError.code;
      window.userState.sessionError = sessionErrorCode;
    });
}

window.clearState = () => {
  window.userState.loggedIn = false;
  window.userState.email = "";
  window.userState.uid = "";
  window.userState.error = "";
};

window.checkSession = () => {
  window.auth.onAuthStateChanged(function (user) {
    if (user) {
      window.userState.sessionActive = true;
    } else {
      window.userState.sessionActive = false;
    }
    console.log(window.userState.sessionActive);
  });
};
