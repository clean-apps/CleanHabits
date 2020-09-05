import 'package:flutter/material.dart';

class BaseSelection2LineTile extends StatelessWidget {
  //
  final String value;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final Icon icon;
  final String title;
  final String subtitle;
  final String emptyText;

  BaseSelection2LineTile({
    this.value,
    this.onTap,
    this.onClear,
    this.icon,
    this.title,
    this.subtitle,
    this.emptyText,
  });

  Widget _tile(
    Icon _icon,
    String title,
    String subtitle,
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
        subtitle: Text(
          subtitle == null || subtitle == '' ? this.emptyText : subtitle,
        ),
        trailing: subtitle == null || subtitle == ''
            ? Text('')
            : IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.cancel),
                onPressed: () => this.onClear(),
              ),
        onTap: () => this.onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tile(
      this.icon,
      this.title,
      this.value,
      context,
    );
  }
}
