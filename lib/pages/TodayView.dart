import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BottomNavBar.dart';
import 'package:CleanHabits/widgets/today/HCalDayWidget.dart';
import 'package:CleanHabits/widgets/today/HabitsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayView extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  //
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  //
  final DateFormat dFormat = new DateFormat("dd MMM yyyy");
  var _selectedDate = DateTime.now();
  List<Habit> _habits = new List();
  var selectedArea = "All Day";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    widget.habitMaster.list(_selectedDate).then(
          (data) => setState(() {
            this._habits = data;
            loading = false;
          }),
        );
  }

  AppBar _getAppBar(selectedDate, context) {
    var index = DateTime.now().difference(selectedDate).inDays;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var title = index == 0 ? 'Today' : dFormat.format(thisDate);

    var areas = ['Morning', 'Afternoon', 'Evening', 'Night', 'All Day'];
    var areaOptions = DropdownButton<String>(
      value: selectedArea,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).accentColor),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {
          selectedArea = newValue;
        });
      },
      items: areas.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
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
      onPressed: () => Navigator.pushNamed(context, '/new'),
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

  List<Habit> _filter() {
    if (selectedArea == "All Day")
      return _habits;
    else {
      return _habits.where((i) => i.timeOfDay == selectedArea).toList();
    }
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
              onChange: (dt) => {
                    this.setState(() {
                      _selectedDate = dt;
                      loading = true;
                    }),
                    _loadData(),
                  }),
          loading
              ? showLoading()
              : new HabitsList(habits: _filter(), date: _selectedDate)
        ],
      ),
      bottomNavigationBar: BottomNavBar(index: _selectedNavIndex),
      floatingActionButton: _getFab(),
    );
  }
}
