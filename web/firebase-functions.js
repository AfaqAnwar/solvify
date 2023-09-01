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

import {
  getFirestore,
  doc,
  setDoc,
  getDoc,
} from "./firebase/firebase-firestore.js";

window.userState = {
  loggedIn: false,
  email: "",
  uid: "",
  error: "",
  sessionActive: false,
  sessionError: "",
  apiKeyUpdated: false,
  apiKey: "",
  onboarded: false,
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
  window.userState.sessionActive = false;
  window.userState.sessionError = "";
  window.userState.apiKeyUpdated = false;
  window.userState.apiKey = "";
  window.userState.onboarded = false;
};

window.checkSession = () => {
  return new Promise((resolve, reject) => {
    window.auth.onAuthStateChanged(function (user) {
      if (user) {
        window.userState.sessionActive = true;
        window.userState.email = user.email;
        window.userState.uid = user.uid;
        console.log("User is signed in.");
        resolve(true);
      } else {
        window.userState.sessionActive = false;
        window.userState.email = "";
        window.userState.uid = "";
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

window.updateAPIKeyToFirestore = async (apiKey) => {
  return new Promise(async (resolve, reject) => {
    const db = getFirestore(window.appInstance);
    const docRef = doc(db, "users", window.userState.uid);
    await setDoc(docRef, { apiKey: apiKey }, { merge: true })
      .then(() => {
        window.userState.apiKeyUpdated = true;
        window.userState.apiKey = apiKey;
        resolve(true);
      })
      .catch((error) => {
        window.userState.apiKey = "";
        window.userState.apiKeyUpdated = false;
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.getAPIKeyFromFirestore = async () => {
  return new Promise(async (resolve, reject) => {
    const db = getFirestore(window.appInstance);
    const docRef = doc(db, "users", window.userState.uid);
    await getDoc(docRef).then((doc) => {
      if (doc.exists()) {
        window.userState.apiKey = doc.data().apiKey;
        print("API Key: " + window.userState.apiKey);
        resolve(true);
      } else {
        window.userState.apiKey = "";
        resolve(false);
      }
    });
  });
};

window.updateOnboardedStatus = async () => {
  return new Promise(async (resolve, reject) => {
    const db = getFirestore(window.appInstance);
    const docRef = doc(db, "users", window.userState.uid);
    await setDoc(docRef, { onboarded: true }, { merge: true })
      .then(() => {
        window.userState.onboarded = true;
        resolve(true);
      })
      .catch((error) => {
        window.userState.onboarded = false;
        window.userState.error = error.code;
        resolve(false);
      });
  });
};

window.getOnboardedStatus = async () => {
  return new Promise(async (resolve, reject) => {
    const db = getFirestore(window.appInstance);
    const docRef = doc(db, "users", window.userState.uid);
    await getDoc(docRef).then((doc) => {
      if (doc.exists()) {
        window.userState.onboarded = doc.data().onboarded;
        resolve(true);
      } else {
        window.userState.getOnboardedStatus = false;
        resolve(false);
      }
    });
  });
};
