import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectFromDate.dart';
import 'package:CleanHabits/widgets/new/SelectReminder.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:CleanHabits/widgets/new/SelectTimeOfDay.dart';
import 'package:flutter/material.dart';

class NewHabit extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  //
  @override
  _NewHabitState createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  String title;
  Repeats repeat;
  DateTime fromDate;
  ChecklistType type;
  TimeOfDay reminder;
  String timeOfDay;
  bool loading;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //
    title = null;
    repeat = Repeats();
    fromDate = DateTime.now();
    type = ChecklistType(
      isSimple: true,
      times: 1,
      timesType: null,
    );
    reminder = null;
    timeOfDay = "All Day";
    loading = false;
  }

  void _saveHabit() {
    setState(() {
      loading = true;
    });
    //
    widget.habitMaster
        .create(
          title: title,
          repeat: repeat,
          fromDate: fromDate,
          type: type,
          reminder: reminder,
          timeOfDay: timeOfDay,
        )
        .then((sts) => {
              setState(() {
                loading = false;
              }),
              Navigator.pushNamed(context, '/'),
            });
  }

  AppBar _getAppBar(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Create New Habit',
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => this.title == null
              ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("please enter a title for the Habbit"),
                ))
              : _saveHabit(),
          child: Text(
            'Save',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Container(color: Colors.grey.withOpacity(0.5), height: 1.0),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }

  Widget _nameTile(context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: TextField(
          autofocus: false,
          controller: TextEditingController(text: title),
          onChanged: (val) => title = val,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 0,
              bottom: 11,
              top: 11,
              right: 15,
            ),
            hintText: 'Name',
          ),
        ),
      ),
    );
  }

  Widget _chip(text) {
    return Padding(
      padding: EdgeInsets.only(left: 3.0, right: 3.0),
      child: InputChip(
        backgroundColor: Colors.grey.withOpacity(0.25),
        label: Text(text),
        onPressed: () => setState(() {
          title = text;
        }),
      ),
    );
  }

  Widget _suggestionsTile(context) {
    var suggestions = [
      '📖 Read Book',
      '🧘 Meditate',
      '💤 Sleep Early',
      '🏃 Go Running',
      '🏋️ Hit The Gym',
      '🚰 Drink Water',
      '🙇 Yoga',
      '📕 Learn a Langage',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      padding: EdgeInsets.all(5),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Wrap(
          children: suggestions.map((e) => _chip(e)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppBar(context),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: loading
            ? Center(
                child: Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(),
              ))
            : ListView(
                children: <Widget>[
                  _nameTile(context),
                  _suggestionsTile(context),
                  SelectRepeat(
                    value: repeat,
                    onChange: (val) => {
                      setState(() {
                        repeat = val;
                      })
                    },
                  ),
                  SelectFromDate(
                    value: fromDate,
                    onChange: (val) => setState(() {
                      fromDate = val;
                    }),
                  ),
                  SelectChecklistType(
                    value: type,
                    onChange: (val) => setState(() {
                      type = val;
                    }),
                  ),
                  SelectReminder(
                    value: reminder,
                    onChange: (val) => setState(() {
                      reminder = val;
                    }),
                  ),
                  SelectTimeOfDay(
                    value: timeOfDay,
                    onChange: (val) => setState(() {
                      timeOfDay = val;
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
