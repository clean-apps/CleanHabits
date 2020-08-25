import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HCalDayWidget extends StatelessWidget {
  //
  final double height;
  final DateTime date;
  final void Function(DateTime) onChange;

  HCalDayWidget({this.height, this.date, this.onChange});

  final int noOfDates = 30;

  final DateFormat dFormat = new DateFormat("MMM");

  Widget _eachCalDate(index, selected, context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var textStyle = index == selected
        ? TextStyle(color: Theme.of(context).accentColor)
        : TextStyle(color: Theme.of(context).textTheme.headline6.color);
    var backgroundColor = index == selected
        ? _darkMode
            ? Theme.of(context).accentColor.withAlpha(35)
            : Theme.of(context).scaffoldBackgroundColor
        : _darkMode
            ? Theme.of(context).textTheme.subtitle2.color.withAlpha(35)
            : Theme.of(context).primaryColor.withAlpha(10);
    var borderColor = index == selected
        ? Theme.of(context).accentColor.withAlpha(160)
        : _darkMode
            ? Theme.of(context).textTheme.subtitle2.color.withAlpha(50)
            : Theme.of(context).primaryColor.withAlpha(_darkMode ? 200 : 50);

    return GestureDetector(
      onTap: () => this.onChange(thisDate),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Column(
          children: <Widget>[
            Text(thisDate.day.toString(), style: textStyle),
            Text(dFormat.format(thisDate), style: textStyle),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedIndex = DateTime.now().difference(this.date).inDays;

    return new SliverPadding(
      padding: new EdgeInsets.all(5.0),
      sliver: new SliverList(
        delegate: new SliverChildListDelegate([
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: height,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              shrinkWrap: true,
              itemCount: noOfDates,
              itemBuilder: (context, index) =>
                  _eachCalDate(index, selectedIndex, context),
            ),
          ),
        ]),
      ),
    );
  }
}
