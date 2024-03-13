# Solvify <img src="https://github.com/AfaqAnwar/solvify/blob/main/assets/icons/Solvify.png?raw=true" width="3%" height="3%">

AI powered Chrome extension that automatically scans and solves your assignment problems.

## Guide To Run Project Locally

- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Clone a copy of this repository, or download a zipped version.
- Navigate to the root folder within a terminal.
- Run the following command. `dart pub get`
- Run the following command. `flutter build web --web-renderer html --csp`
- Open Chrome and type chrome://extensions in the URL address bar.
- Enable Developer mode.
- Click on "Load unpacked" and select the <solvify_project_dir>/build/web folder.

_You can also find zipped versions of the published builds on the side, however they will not function due to the Firebase project being deleted._

_Due to this project being directly corellated with a custom Firebase project, in case of the Firebase project being depricated, please connect to a local Firebase project with Firebase Authentication & Firebase Firestore via the JS file `fire-init-min.js`_

## Solvify Demo

Since the project and its respective Google domains will be deleted, there is a .mp4 of the demo used on the chrome webstore.

[Video Of Demo Here!](https://github.com/AfaqAnwar/solvify/blob/main/Solvify%20Demo.mp4)
