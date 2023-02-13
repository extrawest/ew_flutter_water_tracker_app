<h1>Water Tracker Flutter App</h1>

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)]()
[![Maintaner](https://img.shields.io/static/v1?label=Roman%20Ovsepian&message=Maintainer&color=red)](mailto:roman.ovsepian@extrawest.com)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)]()
![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)
![GitHub release](https://img.shields.io/badge/release-v1.0.0-blue)

<h2>Project Info</h2>

* Water Tracker works with Flutter latest version
* Water Tracker is integrated with firebase services(authentication, firestore, storage, analytics, crashlytics, dynamic links, remote config, cloud messaging)
* App is built with BloC state managment
* Codemagic is used to make production builds
<br><br>

#### PRODUCTION

In main_prod.dart set <b>AppConfig()</b> with
such parameters:

dart
final configuredApp = AppConfig(
    appName: <App name>,
    flavorName: 'prod',
    apiUrl: <Api Url>,
    child: Application(),
  );


#### DEVELOPMENT
Follow the same process, but fill the empty fields with the development values
dart
final configuredApp = AppConfig(
    appName: 'DEV <App name>',
    flavorName: 'dev',
    apiUrl: <Api Url>,
    child: Application(),
  );



## Releasing a production build

In order to create a new production release on Android, you have to push to master branch or merge development branch with master.

Push to master branch. 

shell
git push origin master
or make pull request to master branch on your remote repository. 
<br>
<br>
GitLab repository and Codemagic have triggers on this events, so the build will start.


### Installing:

**1. Clone this repo to your folder:**

```
git clone https://gitlab.extrawest.com/roman.ovsepian/water-tracker.git
```

**2. Change current directory to the cloned folder:**

```
cd triple_seven_slots_game
```

**3. Get packages**

```
flutter pub get
```

## Firebase Distribution

1. In order to get proper Firebase Access Token for Firebase Distribution uploading you need to
   perform the following command:

shell
firebase login:ci

2. Login with the needed account (which is added to the Firebase Console of the project)
3. Get back to the terminal where you performed the command above and copy the Firebase Access Token
4. Set the Access Token as a value of the FIREBASE_TOKEN env var in the Codemagic workflow

Additional info:
https://firebase.google.com/docs/cli#cli-ci-systems

## Firebase Services Integration

In order to ENCODE Firebase configs (GoogleService-Info.plist, google-services.json) in
Codemagic with environment variables follow this link:
https://blog.codemagic.io/how-to-load-firebase-config-in-codemagic-with-environment-variables/

shell
openssl base64 -in GoogleService-Info.plist

shell
openssl base64 -in google-services.json

Copy the output encoded text and put it as env var GOOGLE_SERVICE_IOS and GOOGLE_SERVICE_ANDROID
respectively

In order to DECODE Firebase configs (GoogleService-Info.plist, google-services.json) from
Codemagic environment variables perform these scripts under the Pre-build script section:

shell
echo $GOOGLE_SERVICE_IOS | base64 --decode \
> $FCI_BUILD_DIR/android/app/google-services.json

echo $GOOGLE_SERVICE_ANDROID | base64 --decode \
> $FCI_BUILD_DIR/ios/Runner/GoogleService-Info.plist

### <i>Firebase Authentication</i>

Water tracker supports this types of firebase authentication

* Email/password
* Google Authentication
* Facebook Authentication

To add another types of authentication check https://firebase.google.com/docs/auth

### <i>Firebase Firestore</i>

Firestore database is used to store all needed information for each user.

* User Data(email, name, daily limit)
* Tracked water (separate document for each day)
* Fcm token

All data is secured using security rules

1. Unauthorized access to firebase services are not permitted
2. Each user has access only to it's own data based on user UUID provided

### <i>Firebase Storage</i>

Firestore storage is used to store user profile photo

All data is secured using security rules such as in firestore

### <i>Firebase Analytics</i>

Firestore storage is used to track such events

1. drink_water - event is tracked when user add water
2. photo_updated - event is tracked when user update the profile photo
3. name_updated - event is tracked when user changes the name

### <i>Firebase Crashlytics</i>

Firestore storage is used to track all fatal and non-fatal crashes.

### <i>Firebase Cloud Messaging</i>

Water tracker supports receiving notifications in background and terminated states.

Each user is automatically subscribeb on the topic
"reminders" in cloud_messaging.

### <i>Firebase Remote Config</i>
Remote config is used for changing the progress indicator of drunk water during the day. There are two options: 'linear' and 'circular', so it can be changed in firebase console/remote config and users will see the update without new build

### <i>Firebase Dynamic Links</i>

Dynamic links gives each user ability to share his daily progress with others. User can just copy the link or share it to other social media with the share_plus package(https://pub.dev/packages/share_plus)

Created by Roman Ovsepian

[Extrawest.com](https://www.extrawest.com), 2022

---