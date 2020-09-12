import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:CleanHabits/widgets/suggest/HabitOptionTile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CleanHabits/domain/TopicHabits.dart';
import 'package:CleanHabits/domain/Topics.dart';
import 'package:flutter/material.dart';

class SelectHabit extends StatelessWidget {
  final _data = {
    "Popular": <TopicHabits>[
      TopicHabits(
        title: "Meditate",
        icon: FontAwesomeIcons.spa,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Running",
        icon: FontAwesomeIcons.running,
        isYNType: false,
        timesTarget: 3,
        timesTargetType: "Kilometers",
      ),
      TopicHabits(
        title: "Read Books",
        icon: FontAwesomeIcons.bookReader,
        isYNType: false,
        timesTarget: 30,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Review a To-Do list",
        icon: FontAwesomeIcons.clipboardList,
      )
    ],
    "Get Fit": <TopicHabits>[
      TopicHabits(
        title: "Hit the GYM",
        icon: FontAwesomeIcons.running,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
        repeat: Repeats(
            hasMon: true,
            hasWed: true,
            hasFri: true,
            isWeekly: true,
            none: false),
      ),
      TopicHabits(
        title: "Swimming",
        icon: FontAwesomeIcons.swimmer,
        isYNType: false,
        timesTarget: 1,
        timesTargetType: "Hour",
      ),
      TopicHabits(
        title: "Core Training",
        icon: FontAwesomeIcons.dumbbell,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Practice Yoga",
        icon: FontAwesomeIcons.spa,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Cardio",
        icon: FontAwesomeIcons.heartbeat,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Cycling",
        icon: FontAwesomeIcons.biking,
        isYNType: false,
        timesTarget: 5,
        timesTargetType: "Kilometers",
      )
    ],
    "Stay Healthy": <TopicHabits>[
      TopicHabits(
        title: "Go for a Walk",
        icon: FontAwesomeIcons.walking,
        isYNType: false,
        timesTarget: 3,
        timesTargetType: "Kilometers",
      ),
      TopicHabits(
        title: "Drink More Water",
        icon: FontAwesomeIcons.glassWhiskey,
        isYNType: false,
        timesTarget: 2000,
        timesTargetType: "ml",
      ),
      TopicHabits(
        title: "Get Good Sleep",
        icon: FontAwesomeIcons.bed,
        isYNType: false,
        timesTarget: 7,
        timesTargetType: "Hours",
      ),
      TopicHabits(
        title: "Take a Cold Shower",
        icon: FontAwesomeIcons.shower,
        isYNType: true,
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Take Power Nap",
        icon: FontAwesomeIcons.procedures,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
      )
    ],
    "Watch Your Diet": <TopicHabits>[
      TopicHabits(
        title: "Limit Suger",
        icon: FontAwesomeIcons.cube,
        isYNType: false,
        timesTarget: 32,
        timesTargetType: "Grams",
      ),
      TopicHabits(
        title: "Track Calories",
        icon: FontAwesomeIcons.cloudsmith,
        isYNType: false,
        timesTarget: 2200,
        timesTargetType: "Calories",
      ),
      TopicHabits(
        title: "Take Vitamins",
        icon: FontAwesomeIcons.pills,
        isYNType: true,
      ),
      TopicHabits(
        title: "Eat Fruits",
        icon: FontAwesomeIcons.appleAlt,
        isYNType: true,
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Limit Caffeine",
        icon: FontAwesomeIcons.mugHot,
        isYNType: false,
        timesTarget: 400,
        timesTargetType: "mg",
      )
    ],
    "Have a Hobby": <TopicHabits>[
      TopicHabits(
        title: "Learn a Language",
        icon: FontAwesomeIcons.atlas,
        isYNType: false,
        timesTarget: 30,
        timesTargetType: "Minutes",
      ),
      TopicHabits(
        title: "Practice Coding",
        icon: FontAwesomeIcons.laptopCode,
        isYNType: false,
        timesTarget: 3,
        timesTargetType: "Hour",
        repeat: Repeats(interval: 3, none: false),
      ),
      TopicHabits(
        title: "Try a new Recipe",
        icon: FontAwesomeIcons.blender,
        isYNType: true,
        repeat: Repeats(interval: 3, none: false),
      ),
      TopicHabits(
        title: "Play Guitar",
        icon: FontAwesomeIcons.guitar,
        isYNType: true,
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Take Photos",
        icon: FontAwesomeIcons.cameraRetro,
        isYNType: true,
      ),
      TopicHabits(
        title: "Paint Something",
        icon: FontAwesomeIcons.paintBrush,
        isYNType: true,
        repeat: Repeats(interval: 3, none: false),
      ),
      TopicHabits(
        title: "Dance",
        icon: FontAwesomeIcons.headphonesAlt,
        isYNType: false,
        timesTarget: 20,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 3, none: false),
      )
    ],
    "Others": <TopicHabits>[
      TopicHabits(
        title: "Play Badminton",
        icon: FontAwesomeIcons.circleNotch,
        isYNType: false,
        timesTarget: 40,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Play Cricket",
        icon: FontAwesomeIcons.circle,
        isYNType: false,
        timesTarget: 40,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Play Football",
        icon: FontAwesomeIcons.futbol,
        isYNType: false,
        timesTarget: 40,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 2, none: false),
      ),
      TopicHabits(
        title: "Go Bowling",
        icon: FontAwesomeIcons.bowlingBall,
        isYNType: false,
        timesTarget: 2,
        timesTargetType: "Hours",
        repeat: Repeats(interval: 7, none: false),
      ),
      TopicHabits(
        title: "Go Fishing",
        icon: FontAwesomeIcons.fish,
        isYNType: false,
        timesTarget: 40,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 7, none: false),
      ),
      TopicHabits(
        title: "Play Golf",
        icon: FontAwesomeIcons.golfBall,
        isYNType: false,
        timesTarget: 2,
        timesTargetType: "Hours",
        repeat: Repeats(interval: 7, none: false),
      ),
      TopicHabits(
        title: "Watch Your Steps",
        icon: FontAwesomeIcons.shoePrints,
        isYNType: false,
        timesTarget: 10000,
        timesTargetType: "Steps",
      ),
      TopicHabits(
        title: "Climb Stairs",
        icon: FontAwesomeIcons.walking,
        isYNType: false,
        timesTarget: 30,
        timesTargetType: "Minutes",
        repeat: Repeats(interval: 3, none: false),
      ),
      TopicHabits(
        title: "Fat Intake",
        icon: FontAwesomeIcons.utensils,
        isYNType: false,
        timesTarget: 70,
        timesTargetType: "mg",
      ),
      TopicHabits(
        title: "Protein Intake",
        icon: FontAwesomeIcons.drumstickBite,
        isYNType: false,
        timesTarget: 50,
        timesTargetType: "mg",
      ),
      TopicHabits(
        title: "Cholesterol Intake",
        icon: FontAwesomeIcons.conciergeBell,
        isYNType: false,
        timesTarget: 250,
        timesTargetType: "mg",
      )
    ],
  };

  SliverAppBar _getAppBar(context, flexibleSpace) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    var backgroundColor = _darkMode
        ? Theme.of(context).textTheme.subtitle2.color.withAlpha(35)
        : Theme.of(context).primaryColor.withAlpha(10);

    return SliverAppBar(
      backgroundColor: backgroundColor,
      title: Text(
        "Create New Habit",
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: flexibleSpace,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;

    Topics _topic = ModalRoute.of(context).settings.arguments;
    var _options = _data.entries
        .firstWhere(
          (en) => en.key == _topic.title,
        )
        .value;

    var flexibleSpace = Container(
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _accent.withOpacity(0.5),
          ),
        ),
      ),
      child: ListTile(
        title: Hero(
          tag: _topic.title,
          child: Text(
            _topic.title,
            style:
                Theme.of(context).textTheme.headline3.copyWith(color: _accent),
          ),
        ),
        trailing: Hero(
          tag: _topic.assetPath,
          child: Image.asset(_topic.assetPath),
        ),
      ),
    );

    return new Scaffold(
      body: CustomScrollView(
        slivers: [
          _getAppBar(context, flexibleSpace),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => HabitOptionTile(option: _options[index]),
              childCount: _options.length,
            ),
          ),
        ],
      ),
    );
  }
}
