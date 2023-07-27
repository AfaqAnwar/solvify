import { initializeApp } from "./firebase/firebase-app.js";

const firebaseConfig = {
  apiKey: "AIzaSyApPgB8BVZ3E68AAMR2LvdQj61iqmxlt2Y",
  authDomain: "solvify-chrome-extension.firebaseapp.com",
  projectId: "solvify-chrome-extension",
  storageBucket: "solvify-chrome-extension.appspot.com",
  messagingSenderId: "3979832668",
  appId: "1:3979832668:web:d58c0084dddb5403e2e599",
};

await initializeApp(firebaseConfig);
