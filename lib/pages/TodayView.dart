import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/domain/TimeArea.dart';
import 'package:CleanHabits/widgets/basic/BottomNavBar.dart';
import 'package:CleanHabits/widgets/today/HCalDayWidget.dart';
import 'package:CleanHabits/widgets/today/HabitsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayView extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  final sp = ProviderFactory.settingsProvider;
  //
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  //
  final DateFormat dFormat = new DateFormat("dd MMM yyyy");
  var _selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  List<Habit> _habits = new List();
  List<TimeArea> areas = [TimeArea(area: 'All Day', startTime: null)];

  var selectedArea = "All Day";
  bool loading = true;

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    areas.addAll(widget.sp.timeArea);
    selectedArea = _currentTimeOfDay();
    _loadData();
  }

  void _loadData() {
    widget.habitMaster.list(_selectedDate).then(
          (data) => setState(() {
            this._habits.clear();
            this._habits.addAll(data);
            loading = false;
          }),
        );
  }

  int _toMinutes(TimeOfDay _time) {
    return (_time.hour * 60) + _time.minute;
  }

  String _currentTimeOfDay() {
    var timeNow = TimeOfDay.now();

    var _sortAreas = areas.where((ar) => ar.area != 'All Day').toList();

    _sortAreas.sort((prev, after) =>
        _toMinutes(prev.startTime) < _toMinutes(after.startTime) ? -1 : 1);

    var _nowArea = _sortAreas
        .where((ar) => _toMinutes(ar.startTime) < _toMinutes(timeNow));

    return _nowArea == null || _nowArea.length == 0
        ? 'All Day'
        : _nowArea.last.area;
  }

  AppBar _getAppBar(selectedDate, context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;

    var index = DateTime.now().difference(selectedDate).inDays;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var title = index == 0 ? 'Today' : dFormat.format(thisDate);

    var areaOptions = DropdownButton<String>(
      value: selectedArea,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Theme.of(context).accentColor,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).accentColor),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {
          selectedArea = newValue;
        });
      },
      items: areas.map<DropdownMenuItem<String>>((timeArea) {
        return DropdownMenuItem<String>(
          value: timeArea.area,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(
                  timeArea.icon,
                  color: _accent,
                  size: 20,
                ),
              ),
              Text(timeArea.area),
            ],
          ),
        );
      }).toList(),
    );

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      actions: [areaOptions],
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  FloatingActionButton _getFab() {
    return new FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/suggest/topic'),
      label: Text('NEW'),
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget showLoading() {
    return SliverList(
      delegate: new SliverChildListDelegate(
        [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  List<Habit> _filterHabits() {
    if (selectedArea == "All Day")
      return this._habits;
    else {
      return this
          ._habits
          .where((i) =>
              i.timeOfDay == selectedArea ||
              i.timeOfDay == null ||
              i.timeOfDay == "All Day")
          .toList();
    }
  }

  _onDateChange(DateTime newDate) {
    this.setState(() {
      _selectedDate = newDate;
      _habits.clear();
      loading = true;
    });
    _loadData();
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
        controller: _scrollController,
        slivers: <Widget>[
          HCalDayWidget(
            height: dateBarHeight,
            date: _selectedDate,
            onChange: _onDateChange,
          ),
          loading
              ? showLoading()
              : HabitsList(
                  habits: _filterHabits(),
                  date: _selectedDate,
                  onEdit: (habit) => Navigator.pushNamed(
                    context,
                    '/edit',
                    arguments: habit,
                  ),
                  onDelete: (habit) => {
                    setState(() {
                      loading = false;
                    }),
                    widget.habitMaster
                        .deleteHabit(habit.id)
                        .whenComplete(() => _loadData()),
                  },
                  onSkip: (habit) => {
                    setState(() {
                      habit.isSkipped = true;
                      if (habit.isYNType) {
                        habit.timesProgress = 1;
                        habit.ynCompleted = true;
                      } else {
                        habit.timesProgress = habit.timesProgress;
                      }
                      loading = false;
                    }),
                    widget.habitMaster
                        .updateStatus(habit: habit, dateTime: _selectedDate)
                        .then((value) => _loadData()),
                  },
                )
        ],
      ),
      bottomNavigationBar: BottomNavBar(index: _selectedNavIndex),
      floatingActionButton:
          _filterHabits().length == 0 ? Container() : _getFab(),
    );
  }
}
