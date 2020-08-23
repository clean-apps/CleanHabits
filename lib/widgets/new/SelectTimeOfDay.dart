import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/widgets/basic/BaseSelectionTile.dart';
import 'package:flutter/material.dart';

class SelectTimeOfDay extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChange;

  final sp = ProviderFactory.settingsProvider;

  SelectTimeOfDay({this.value, this.onChange});

  void _showDialog(context) {
    final List<String> options = sp.timeArea.map((ta) => ta.area).toList();
    options.add('All Day');

    showDialog(
      context: context,
      builder: (ctxt) => SimpleDialog(
        title: Text('Select Time Of Day'),
        children: options
            .map((e) => ListTile(
                  dense: true,
                  title: Text(e),
                  onTap: () => {
                    this.onChange(e),
                    Navigator.of(context).pop(),
                  },
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelectionTile(
      value: value,
      icon: Icon(Icons.brightness_low),
      title: 'Do at',
      emptyText: 'Do all day',
      onTap: () => _showDialog(context),
      onClear: () => this.onChange(null),
    );
  }
}
