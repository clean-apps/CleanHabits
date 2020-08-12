import 'package:CleanHabits/widgets/basic/BaseSelectionRadioTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectChecklistType extends StatefulWidget {
  final ChecklistType value;
  final ValueChanged<ChecklistType> onChange;
  SelectChecklistType({
    this.value,
    this.onChange,
  });

  @override
  _SelectChecklistTypeState createState() => _SelectChecklistTypeState();
}

class _SelectChecklistTypeState extends State<SelectChecklistType> {
  bool isSimple;
  int times;
  String timesType;

  @override
  void initState() {
    super.initState();
    isSimple = widget.value.isSimple;
    times = widget.value.times;
    timesType = widget.value.timesType;
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctxt) => SimpleDialog(
        title: Text('Times Type Options'),
        children: [
          ListTile(
            title: new TextField(
              controller: TextEditingController(text: times.toString()),
              decoration: new InputDecoration(labelText: "Count"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (val) => setState(() {
                times = int.parse(val);
              }),
            ),
          ),
          ListTile(
            title: new TextField(
              controller: TextEditingController(text: timesType),
              decoration: new InputDecoration(labelText: "Type"),
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() {
                timesType = val;
              }),
            ),
          ),
          ListTile(
            leading: FlatButton(
              onPressed: () => {
                setState(() {
                  isSimple = true;
                  times = 1;
                  timesType = null;
                }),
                widget.onChange(new ChecklistType(
                  isSimple: true,
                  times: 1,
                  timesType: null,
                )),
                Navigator.of(context).pop()
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            trailing: FlatButton(
              onPressed: () => {
                widget.onChange(new ChecklistType(
                  isSimple: this.isSimple,
                  times: this.times,
                  timesType: this.timesType,
                )),
                Navigator.of(context).pop()
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelectionRadioTile(
      value: this.isSimple,
      icon: Icon(Icons.check),
      title: this.isSimple == null || this.isSimple
          ? 'Simple Habit'
          : 'Countable Habit',
      subtitle: this.isSimple == null ||
              this.isSimple ||
              times == null ||
              timesType == null
          ? null
          : 'Target $times $timesType',
      onTap: () => this.isSimple ? {} : _showDialog(context),
      onChange: (val) => {
        setState(() {
          this.isSimple = val;
        }),
        this.isSimple
            ? widget.onChange(new ChecklistType(
                isSimple: true,
                times: null,
                timesType: null,
              ))
            : _showDialog(context),
        widget.onChange(new ChecklistType(
          isSimple: this.isSimple,
          times: this.times,
          timesType: this.timesType,
        )),
      },
      onClear: () => {
        setState(() {
          isSimple = true;
        }),
        widget.onChange(new ChecklistType(
          isSimple: true,
          times: null,
          timesType: null,
        )),
      },
    );
  }
}

class ChecklistType {
  final bool isSimple;
  final int times;
  final String timesType;
  ChecklistType({this.isSimple, this.times, this.timesType});
}
