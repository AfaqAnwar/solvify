import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  setPersistence,
  inMemoryPersistence,
  signOut,
  updateEmail,
  updatePassword,
  deleteUser,
  sendPasswordResetEmail,
} from "./firebase/firebase-auth.js";
import {
  getFirestore,
  doc,
  setDoc,
  getDoc,
  deleteDoc,
} from "./firebase/firebase-firestore.js";
window.userState = {
  loggedIn: !1,
  email: "",
  uid: "",
  error: "",
  sessionActive: !1,
  sessionError: "",
  apiKeyUpdated: !1,
  apiKey: "",
  onboarded: !1,
  websites: [],
  dataDeleted: !1,
  resetSent: !1,
};
window.auth = getAuth();
window.signUserIn = (e, t) => {
  window.clearState();
  return new Promise(async (s, w) => {
    window.auth = await getAuth();
    signInWithEmailAndPassword(window.auth, e, t)
      .then((e) => {
        const t = e.user;
        window.userState.loggedIn = !0;
        window.userState.email = t.email;
        window.userState.uid = t.uid;
        s(!0);
      })
      .catch((e) => {
        window.userState.loggedIn = !1;
        window.userState.error = e.code;
        s(!1);
      });
  });
};
window.registerUser = (e, t) => {
  window.clearState();
  return new Promise(async (s, w) => {
    window.auth = getAuth();
    createUserWithEmailAndPassword(window.auth, e, t)
      .then((e) => {
        const t = e.user;
        window.userState.loggedIn = !0;
        window.userState.email = t.email;
        window.userState.uid = t.uid;
        s(!0);
      })
      .catch((e) => {
        window.userState.loggedIn = !1;
        window.userState.error = e.code;
        s(!1);
      });
  });
};
window.saveAuth = () =>
  new Promise((e, t) => {
    setPersistence(window.auth, inMemoryPersistence)
      .then(() => {
        window.userState.sessionActive = !0;
        e(!0);
      })
      .catch((t) => {
        window.userState.sessionError = t.code;
        e(!1);
      });
  });
window.clearState = () => {
  window.userState.loggedIn = !1;
  window.userState.email = "";
  window.userState.uid = "";
  window.userState.error = "";
  window.userState.sessionActive = !1;
  window.userState.sessionError = "";
  window.userState.apiKeyUpdated = !1;
  window.userState.apiKey = "";
  window.userState.onboarded = !1;
  window.userState.websites = [];
  window.userState.dataDeleted = !1;
  window.userState.resetSent = !1;
};
window.checkSession = () =>
  new Promise((e, t) => {
    window.auth.onAuthStateChanged(function (t) {
      if (t) {
        window.userState.sessionActive = !0;
        window.userState.email = t.email;
        window.userState.uid = t.uid;
        e(!0);
      } else {
        window.userState.sessionActive = !1;
        window.userState.email = "";
        window.userState.uid = "";
        e(!1);
      }
    });
  });
window.signUserOut = () =>
  new Promise(async (e, t) => {
    signOut(window.auth)
      .then(() => {
        window.clearState();
        e(!0);
      })
      .catch((t) => {
        window.userState.error = t.code;
        e(!1);
      });
  });
window.updateUserEmail = (e) =>
  new Promise(async (t, s) => {
    updateEmail(window.auth.currentUser, e)
      .then(() => {
        window.userState.email = e;
        t(!0);
      })
      .catch((e) => {
        window.userState.error = e.code;
        t(!1);
      });
  });
window.updateUserPassword = (e) =>
  new Promise(async (t, s) => {
    updatePassword(window.auth.currentUser, e)
      .then(() => {
        t(!0);
      })
      .catch((e) => {
        window.userState.error = e.code;
        t(!1);
      });
  });
window.updateAPIKeyToFirestore = async (e) =>
  new Promise(async (t, s) => {
    const w = getFirestore(window.appInstance),
      a = doc(w, "users", window.userState.uid);
    await setDoc(a, { apiKey: e }, { merge: !0 })
      .then(() => {
        window.userState.apiKeyUpdated = !0;
        window.userState.apiKey = e;
        t(!0);
      })
      .catch((e) => {
        window.userState.apiKey = "";
        window.userState.apiKeyUpdated = !1;
        window.userState.error = e.code;
        t(!1);
      });
  });
window.getAPIKeyFromFirestore = async () =>
  new Promise(async (e, t) => {
    const s = getFirestore(window.appInstance),
      w = doc(s, "users", window.userState.uid);
    await getDoc(w).then((t) => {
      if (t.exists()) {
        window.userState.apiKey = t.data().apiKey;
        print("API Key: " + window.userState.apiKey);
        e(!0);
      } else {
        window.userState.apiKey = "";
        e(!1);
      }
    });
  });
window.updateOnboardedStatus = async () =>
  new Promise(async (e, t) => {
    const s = getFirestore(window.appInstance),
      w = doc(s, "users", window.userState.uid);
    await setDoc(w, { onboarded: !0 }, { merge: !0 })
      .then(() => {
        window.userState.onboarded = !0;
        e(!0);
      })
      .catch((t) => {
        window.userState.onboarded = !1;
        window.userState.error = t.code;
        e(!1);
      });
  });
window.getOnboardedStatus = async () =>
  new Promise(async (e, t) => {
    const s = getFirestore(window.appInstance),
      w = doc(s, "users", window.userState.uid);
    await getDoc(w).then((t) => {
      if (t.exists()) {
        window.userState.onboarded = t.data().onboarded;
        e(!0);
      } else {
        window.userState.getOnboardedStatus = !1;
        e(!1);
      }
    });
  });
window.getWebsitesFromFirestore = async () =>
  new Promise(async (e, t) => {
    const s = getFirestore(window.appInstance),
      w = doc(s, "users", window.userState.uid);
    await getDoc(w).then((t) => {
      if (t.exists()) {
        window.userState.websites = t.data().websites;
        e(!0);
      } else {
        window.userState.websites = [];
        e(!1);
      }
    });
  });
window.updateWebsites = async (e) =>
  new Promise(async (t, s) => {
    const w = getFirestore(window.appInstance),
      a = doc(w, "users", window.userState.uid);
    await setDoc(a, { websites: e }, { merge: !0 })
      .then(() => {
        window.userState.websites = e;
        t(!0);
      })
      .catch((e) => {
        window.userState.websites = [];
        window.userState.error = e.code;
        t(!1);
      });
  });
window.deleteUserFromCloud = async () =>
  new Promise(async (e, t) => {
    window.auth = getAuth();
    await deleteUser(window.auth.currentUser)
      .then(() => {
        window.clearState();
        e(!0);
      })
      .catch((t) => {
        window.userState.error = t.code;
        e(!1);
      });
  });
window.deleteDocFromCloud = async (e) =>
  new Promise(async (e, t) => {
    const s = getFirestore(window.appInstance),
      w = doc(s, "users", window.userState.uid);
    await deleteDoc(w)
      .then(() => {
        window.userState.dataDeleted = !0;
        e(!0);
      })
      .catch((t) => {
        window.userState.error = t.code;
        window.userState.dataDeleted = !1;
        e(!1);
      });
  });
window.sendPasswordResetEmail = async (e) =>
  new Promise(async (t, s) => {
    await sendPasswordResetEmail(window.auth, e)
      .then(() => {
        window.userState.resetSent = !0;
        t(!0);
      })
      .catch((e) => {
        window.userState.error = e.code;
        window.userState.resetSent = !1;
        t(!1);
      });
  });
