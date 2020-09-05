import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var sp = ProviderFactory.settingsProvider;
  var loading = true;

  @override
  void initState() {
    super.initState();

    sp.loadInitData().whenComplete(
          () => setState(() {
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final _themeColor = const Color(0xFF056676);

    final pages = [
      // SkOnboardingModel(
      //     title: 'Welcome To Clean Habits',
      //     description:
      //         'Let today be the day you give up who you\'ve been, for who you can become',
      //     titleColor: _themeColor,
      //     descripColor: Colors.black,
      //     imagePath: 'assets/app-logo.png'),
      SkOnboardingModel(
          title: 'Build Great Habits',
          description:
              'Create new habits, track them daily and become a better you',
          titleColor: _themeColor,
          descripColor: Colors.black,
          imagePath: 'assets/welcome-1.png'),
      SkOnboardingModel(
          title: 'Learn Your Progress',
          description:
              'With intuitive graphs and data, you can easily track your improvements',
          titleColor: _themeColor,
          descripColor: Colors.black,
          imagePath: 'assets/welcome-2.png'),
      SkOnboardingModel(
          title: 'Reminders',
          description:
              'Will help you to keep the streak and never miss a habit',
          titleColor: _themeColor,
          descripColor: Colors.black,
          imagePath: 'assets/welcome-3.png'),
    ];

    return Scaffold(
      body: SKOnboardingScreen(
        bgColor: const Color(0xFFFAFAFA),
        themeColor: _themeColor,
        pages: pages,
        skipClicked: (value) {
          Navigator.popAndPushNamed(context, "/");
        },
        getStartedClicked: (value) {
          Navigator.popAndPushNamed(context, "/");
        },
      ),
    );
  }
}
