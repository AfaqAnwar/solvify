// Import the functions you need from the SDKs you need
import { initializeApp } from "./firebase/firebase-app.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyApPgB8BVZ3E68AAMR2LvdQj61iqmxlt2Y",
  authDomain: "solvify-chrome-extension.firebaseapp.com",
  projectId: "solvify-chrome-extension",
  storageBucket: "solvify-chrome-extension.appspot.com",
  messagingSenderId: "3979832668",
  appId: "1:3979832668:web:d58c0084dddb5403e2e599",
};

// Initialize Firebase
await initializeApp(firebaseConfig);
