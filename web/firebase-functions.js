import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  setPersistence,
  inMemoryPersistence,
  signOut,
  updateEmail,
  updatePassword,
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
  window.clearState();
  var logged = false;
  window.auth = await getAuth();
  await signInWithEmailAndPassword(window.auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      window.userState.loggedIn = true;
      window.userState.email = user.email;
      window.userState.uid = user.uid;
      logged = true;
    })
    .catch((error) => {
      window.userState.loggedIn = false;
      const errorCode = error.code;
      window.userState.error = errorCode;
      window.userState.sessionActive = false;
    });
  return logged;
};

window.registerUser = async (email, password) => {
  window.clearState();
  var registered = false;
  window.auth = getAuth();
  await createUserWithEmailAndPassword(window.auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      window.userState.loggedIn = true;
      window.userState.email = user.email;
      window.userState.uid = user.uid;
      registered = true;
    })
    .catch((error) => {
      window.userState.loggedIn = false;
      const errorCode = error.code;
      window.userState.error = errorCode;
      window.userState.sessionActive = false;
    });
  return registered;
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
  });
};

window.signUserOut = async () => {
  var signedOut = false;
  await signOut(window.auth)
    .then(() => {
      // Sign-out successful.
      window.clearState();
      signedOut = true;
    })
    .catch((error) => {
      // An error happened.
      const errorCode = error.code;
      window.userState.error = errorCode;
    });
  return signedOut;
};

window.updateUserEmail = async (email) => {
  var emailUpdated = false;
  await updateEmail(window.auth.currentUser, email)
    .then(() => {
      window.userState.email = email;
      emailUpdated = true;
    })
    .catch((error) => {
      const errorCode = error.code;
      window.userState.error = errorCode;
    });

  return emailUpdated;
};

window.updateUserPassword = async (password) => {
  var passwordUpdated = false;
  await updatePassword(window.auth.currentUser, password)
    .then(() => {
      passwordUpdated = true;
    })
    .catch((error) => {
      const errorCode = error.code;
      window.userState.error = errorCode;
    });

  return passwordUpdated;
};
