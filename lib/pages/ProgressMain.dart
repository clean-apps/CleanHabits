import 'package:CleanHabits/widgets/basic/BottomNavBar.dart';
import 'package:CleanHabits/widgets/progress/CompletionRate.dart';
import 'package:CleanHabits/widgets/progress/DailyTracker.dart';
import 'package:CleanHabits/widgets/progress/DayWisePerfomance.dart';
import 'package:CleanHabits/widgets/progress/StatusSummary.dart';
import 'package:CleanHabits/widgets/progress/WeeklyProgress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProgressMain extends StatelessWidget {
  AppBar _appBar(context) {
    return new AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Progress',
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    var _selectedNavIndex = 1;

    var _widgetList = <Widget>[
      StatusSummary(),
      WeeklyProgress(),
      CompletionRate(),
      DayWisePerfomance(),
      DailyTracker(),
      new Text(' '),
    ];

    return new Scaffold(
      appBar: _appBar(context),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: _widgetList.length,
              itemBuilder: (context, index, anim) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(child: _widgetList[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(index: _selectedNavIndex),
    );
  }
}
