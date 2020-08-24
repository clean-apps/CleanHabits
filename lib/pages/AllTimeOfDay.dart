import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/domain/TimeArea.dart';
import 'package:flutter/material.dart';

class AllTimeOfDay extends StatefulWidget {
  @override
  _AllTimeOfDayState createState() => _AllTimeOfDayState();
}

class _AllTimeOfDayState extends State<AllTimeOfDay> {
  final sp = ProviderFactory.settingsProvider;
  List<TimeArea> data = ProviderFactory.settingsProvider.timeArea;

  @override
  void initState() {
    super.initState();
  }

  showTextWTimePicker(int index, BuildContext context) {
    showTimePicker(
      initialTime: data[index].startTime,
      context: context,
    ).then(
      (value) => setState(() {
        data[index].startTime = value == null ? data[index].startTime : value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: accentColor),
        elevation: 0.0,
        title: Text('Time Of Day', style: TextStyle(color: Colors.black)),
        backgroundColor: _theme.scaffoldBackgroundColor,
        actions: [
          FlatButton(
              onPressed: () {
                sp.timeArea = data;
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: accentColor)))
        ],
      ),
      body: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) => ListTile(
          title: Text(data[index].area),
          subtitle: Text(data[index].startTime.format(context)),
          leading: Icon(data[index].icon, size: 40.0),
          onTap: () => showTextWTimePicker(index, context),
        ),
      ),
    );
  }
}
