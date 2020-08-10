import 'package:CleanHabits/widgets/basic/BottomNavBar.dart';
import 'package:CleanHabits/widgets/today/HCalDayWidget.dart';
import 'package:CleanHabits/widgets/today/HabitsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayView extends StatefulWidget {
  //
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  //
  final DateFormat dFormat = new DateFormat("dd MMM yyyy");
  var _selectedDate = DateTime.now();

  AppBar _getAppBar(selectedDate, context) {
    var index = DateTime.now().difference(selectedDate).inDays;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var title = index == 0 ? 'Today' : dFormat.format(thisDate);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  FloatingActionButton _getFab() {
    return new FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/new'),
      label: Text('NEW'),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    var _selectedNavIndex = 0;

    var _appBar = _getAppBar(_selectedDate, context);
    var dateBarHeight = _appBar.preferredSize.height * 1.3;

    return Scaffold(
      appBar: _appBar,
      body: CustomScrollView(
        slivers: <Widget>[
          new HCalDayWidget(
            height: dateBarHeight,
            date: _selectedDate,
            onChange: (dt) => this.setState(() {
              _selectedDate = dt;
            }),
          ),
          new HabitsList(
            date: _selectedDate,
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(index: _selectedNavIndex),
      floatingActionButton: _getFab(),
    );
  }
}
