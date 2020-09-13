import 'package:flutter/material.dart';

class BaseSelectionChipsTile extends StatelessWidget {
  //
  final List<TimeOfDay> values;
  final VoidCallback onAdd;
  final ValueChanged<TimeOfDay> onDelete;
  final Icon icon;
  final String title;
  final String emptyText;

  String toReminderString(TimeOfDay tod) {
    if (tod == null) {
      return '';
    } else {
      var _hour = tod.hour.toString().padLeft(2, '0');
      var _minute = tod.minute.toString().padLeft(2, '0');
      return "$_hour:$_minute";
    }
  }

  BaseSelectionChipsTile({
    this.values,
    this.onAdd,
    this.onDelete,
    this.icon,
    this.title,
    this.emptyText,
  });

  Widget _tile(
    Icon _icon,
    String title,
    List<TimeOfDay> subtitles,
    BuildContext context,
  ) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: _darkMode
            ? Colors.grey.withOpacity(0.25)
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: ListTile(
        leading: _icon,
        title: Text(title),
        subtitle: this.values == null || this.values.length == 0
            ? Text(this.emptyText)
            : Wrap(
                children: values
                    .map(
                      (e) => Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Chip(
                            backgroundColor: _theme.textTheme.subtitle2.color,
                            deleteIconColor: _theme.scaffoldBackgroundColor,
                            labelStyle: TextStyle(
                              color: _theme.scaffoldBackgroundColor,
                            ),
                            label: Text(toReminderString(e)),
                            deleteIcon: Icon(Icons.cancel),
                            onDeleted: () => this.onDelete(e),
                          )),
                    )
                    .toList(),
              ),
        trailing: IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.add_circle_outline),
          onPressed: () => this.onAdd(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tile(
      this.icon,
      this.title,
      this.values,
      context,
    );
  }
}
