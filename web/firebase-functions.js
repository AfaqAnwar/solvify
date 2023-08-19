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

window.signUserIn = (email, password) => {
  window.clearState();
  return new Promise(async (resolve, reject) => {
    window.auth = await getAuth();
    signInWithEmailAndPassword(window.auth, email, password)
      .then((userCredential) => {
        const user = userCredential.user;
        window.userState.loggedIn = true;
        window.userState.email = user.email;
        window.userState.uid = user.uid;
        resolve(true);
      })
      .catch((error) => {
        window.userState.loggedIn = false;
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.registerUser = (email, password) => {
  window.clearState();
  return new Promise(async (resolve, reject) => {
    window.auth = getAuth();
    createUserWithEmailAndPassword(window.auth, email, password)
      .then((userCredential) => {
        const user = userCredential.user;
        window.userState.loggedIn = true;
        window.userState.email = user.email;
        window.userState.uid = user.uid;
        resolve(true);
      })
      .catch((error) => {
        window.userState.loggedIn = false;
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.saveAuth = () => {
  return new Promise((resolve, reject) => {
    setPersistence(window.auth, inMemoryPersistence)
      .then(() => {
        window.userState.sessionActive = true;
        resolve(true);
      })
      .catch((sError) => {
        window.userState.sessionError = sError.code;
        resolve(false);
      });
  });
};

window.clearState = () => {
  window.userState.loggedIn = false;
  window.userState.email = "";
  window.userState.uid = "";
  window.userState.error = "";
};

window.checkSession = () => {
  return new Promise((resolve, reject) => {
    window.auth.onAuthStateChanged(function (user) {
      if (user) {
        window.userState.sessionActive = true;
        console.log("User is signed in.");
        resolve(true);
      } else {
        window.userState.sessionActive = false;
        console.log("No user is signed in.");
        resolve(false);
      }
    });
  });
};

window.signUserOut = () => {
  return new Promise(async (resolve, reject) => {
    signOut(window.auth)
      .then(() => {
        window.clearState();
        resolve(true);
      })
      .catch((error) => {
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.updateUserEmail = (email) => {
  return new Promise(async (resolve, reject) => {
    updateEmail(window.auth.currentUser, email)
      .then(() => {
        window.userState.email = email;
        resolve(true);
      })
      .catch((error) => {
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.updateUserPassword = (password) => {
  return new Promise(async (resolve, reject) => {
    updatePassword(window.auth.currentUser, password)
      .then(() => {
        resolve(true);
      })
      .catch((error) => {
        window.userState.error = error.code;
        resolve(false);
      });
  });
};
