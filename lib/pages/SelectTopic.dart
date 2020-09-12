import 'package:CleanHabits/domain/Topics.dart';
import 'package:CleanHabits/widgets/suggest/TopicTile.dart';
import 'package:flutter/material.dart';

class SelectTopic extends StatelessWidget {
  AppBar _getAppBar(context) {
    return AppBar(
      title: Text(
        "Create New Habit",
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _getFab(context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.popAndPushNamed(context, '/new'),
        label: Text(
          'Create Your Own',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    final topics = <Topics>[
      Topics(
        title: "Popular",
        assetPath: _darkMode
            ? 'assets/topics/dark/DoogieDoodle.png'
            : 'assets/topics/light/DoogieDoodle.png',
      ),
      Topics(
        title: "Get Fit",
        assetPath: _darkMode
            ? 'assets/topics/dark/MeditatingDoodle.png'
            : 'assets/topics/light/MeditatingDoodle.png',
      ),
      Topics(
        title: "Stay Healthy",
        assetPath: _darkMode
            ? 'assets/topics/dark/StrollingDoodle.png'
            : 'assets/topics/light/StrollingDoodle.png',
      ),
      Topics(
        title: "Watch Your Diet",
        assetPath: _darkMode
            ? 'assets/topics/dark/IceCreamDoodle.png'
            : 'assets/topics/light/IceCreamDoodle.png',
      ),
      Topics(
        title: "Have a Hobby",
        assetPath: _darkMode
            ? 'assets/topics/dark/ReadingDoodle.png'
            : 'assets/topics/light/ReadingDoodle.png',
      ),
      Topics(
        title: "Others",
        assetPath: _darkMode
            ? 'assets/topics/dark/SwingingDoodle.png'
            : 'assets/topics/light/SwingingDoodle.png',
      ),
    ];

    var widgets = topics
        .map(
          (t) => TopicTile(
            topic: t.title,
            assetPath: t.assetPath,
          ),
        )
        .toList();

    return new Scaffold(
      appBar: _getAppBar(context),
      body: GridView.count(
        crossAxisCount: 2,
        children: widgets,
        padding: EdgeInsets.all(12),
      ),
      bottomNavigationBar: _getFab(context),
    );
  }
}
