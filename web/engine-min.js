window.ff_trigger_firebase_core = async (e) => {
  e(await import("./firebase/firebase-app.js"));
};
window.ff_trigger_firebase_app_check = async (e) => {
  e(await import("./firebase/firebase-app-check.js"));
};
window.ff_trigger_firebase_remote_config = async (e) => {
  e(await import("./firebase/firebase-auth.js"));
};
window.ff_trigger_firebase_remote_config = async (e) => {
  e(await import("./firebase/firebase-database.js"));
};
window.ff_trigger_firebase_remote_config = async (e) => {
  e(await import("./firebase/firebase-firestore.js"));
};
window.ff_trigger_firebase_remote_config = async (e) => {
  e(await import("./firebase/firebase-remote-config.js"));
};
window.ff_trigger_firebase_remote_config = async (e) => {
  e(await import("./firebase/firebase-storage.js"));
};
