[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](https://opensource.org/licenses/Apache-2.0)
[![GitHub release](https://img.shields.io/github/release/clean-apps/CleanHabits.svg?style=flat-square)](https://github.com/clean-apps/CleanHabits/releases/latest)
![Powered By](https://img.shields.io/badge/Powered%20By-Flutter-blue&logo=flutter)

<p align="center">
<img src="https://github.com/clean-apps/CleanHabits/raw/master/marketing/gh-feature-graphic.png?raw=true" />
</p>

<img src="https://github.com/clean-apps/CleanHabits/raw/master/marketing/gh-logo.png?raw=true" />

Did you know that around 40% of everything we do on a daily basis is habitual? This means that a big part of our lives is almost entirely on autopilot! Think this through for a second and evaluate those habits of yours. Do they empower you or dis-empower you? Do they limit you or free you? or Do they help you or hinder you from reaching your goals?

In reality, successful people are simply those with successful habits. They give small efforts everyday, and stick to it, day in and day out.

I've build an app around this idea to help you build great habits and sticking to it. Clean Habits is a Minimalist Habit Tracker that helps you to achieve good habits using data analytics

### <img src="https://use.fontawesome.com/releases/v5.1.0/svgs/solid/external-link-alt.svg" width="22" align="left" /> &nbsp; Build Great Habits

Clean Habits helps you to start with a habit, like "wake up early day" or "eat less sugar everyday" or "visit the gym 3 times per week". It gives you many customization over your habits like setting goals, repetitions, etc

### <img src="https://use.fontawesome.com/releases/v5.1.0/svgs/solid/chart-bar.svg" width="22" align="left" /> &nbsp; Learn Your Behavior

Once you have the habits set, Clean Habits provides you with detailed charts to track your behavior for every habit. Data Analytics can then help you showcase which habits you're easily sticking to and which ones you're avoiding. The idea is once you create a habit you should complete it every-time and maintain a completion streak.

### <img src="https://use.fontawesome.com/releases/v5.1.0/svgs/solid/chart-line.svg" width="22" align="left" /> &nbsp; Your Own Progress Journal

The reality is habits are not build in a day, it takes time and people do fail in the beginning, but they slowly learn and then start reaching their goals. Clean Habits lets you see the bigger picture and visualize you far you've achieved in terms of habit completion using charts and analytics.

### <img src="https://use.fontawesome.com/releases/v5.1.0/svgs/regular/bell.svg" width="22" align="left" /> &nbsp; Timely Reminders

There is nothing more bad than missing your streak and not completion your habit for the day. Clean Habits can send you timely reminders so that you remember to you don't miss your task and maintain your streak

<a href="https://play.google.com/store/apps/details?id=com.babanomania.CleanHabits" target="_blank">
<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" alt="Get it on Google Play" height="90"/></a>

# Getting Started

1. Follow the installation instructions on [www.flutter.io](www.flutter.io) to install Flutter.
2. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com
3. Once your Firebase instance is created, you'll need to enable anonymous authentication.

   - Create an app within your Firebase instance for Android, with package name com.yourcompany.CleanHabits
   - Follow instructions to download google-services.json, and place it into CleanHabits/android/app/
   - Run the following command to get your SHA-1 key:

     ```
     keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
     ```

   - In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".

4. Start the android emulator or connect your phone, check using the below command if devices has been dectected

```
flutter devices
```

5. Clean Habits can be run like any other Flutter app, either through the Android Studio/VSCode or through running the following command from within the CleanHabits directory:

```
flutter run
```

# License

Copyright 2020 Shouvik Basu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

_Comfortaa Font by Johan Aakerlund_

      Comfortaa is a rounded geometric sans-serif type design intended for large sizes.
      It is absolutely free, both for personal and commercial use.

      If you like it please visit my DeviantArt page and fav it (but obviously only if you like it.)
      You are also more than welcome to comment about anything you want (I'm open to critique).
      I obviously would love to see how my font is being used,
      so feel free to comment with a link to your work, or send me a message.

      I hope you will enjoy using my font!

      — Johan Aakerlund

_Open Doodles Illustrations by Pablo Stanley_

      Open Doodles is a set of free illustrations that embraces the idea of Open Design.
      You can copy, edit, remix, share, or redraw these images for any purpose
      without restriction under copyright or database law (CC0 license.)

      I hope that this kind of resource makes it easier for designers to show the value of illustration in their mockups.
      Maybe you use these images as placeholders, before you're ready to hire an illustrator.
      Or perhaps this will encourage others to create their own kit and share it with the world.


_Font Awesome by Dave Gandy - http://fontawesome.io_

      Font Awesome is fully open source and is GPL friendly.
      You can use it for commercial projects, open source projects, or really just about whatever you want.

# Credits

- Logo Font [Comfortaa](https://github.com/googlefonts/comfortaa) made by [Johan Aakerlund](https://www.deviantart.com/aajohan)
- Amazing [Open Doodles](https://www.opendoodles.com/) Illustrations by [Pablo Stanley](https://twitter.com/pablostanley)
- Absolultely Stunning [Font Awesome](https://fontawesome.com/) by [Dave Gandy](https://twitter.com/davegandy?lang=en)
- [Flutter Team](https://github.com/flutter/)
- Below Flutter Plugins
  - [sqflite](https://pub.dev/packages/sqflite)
  - [workmanager](https://pub.dev/packages/workmanager)
  - [settings_ui](https://pub.dev/packages/settings_ui)
  - [timeline_tile](https://pub.dev/packages/timeline_tile)
  - [charts_flutter](https://pub.dev/packages/charts_flutter)
  - [heatmap_calendar](https://pub.dev/packages/heatmap_calendar)
