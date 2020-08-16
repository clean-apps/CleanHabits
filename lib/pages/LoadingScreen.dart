import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _textTheme = Theme.of(context).textTheme;

    return new MaterialApp(
      home: Center(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/app-logo.png',
                  //scale: 0.5,
                  width: 300,
                  height: 300,
                ),
                Text(
                  'Clean',
                  style: _textTheme.headline2.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Habits',
                  style: _textTheme.headline3.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
