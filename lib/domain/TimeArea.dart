import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeArea {
  String area;
  TimeOfDay startTime;
  final _format = DateFormat("HH:mm");
  TimeArea({this.area, this.startTime});

  IconData get icon {
    switch (area) {
      case "Morning":
        return Icons.landscape;
        break;
      case "Afternoon":
        return Icons.brightness_5;
        break;
      case "Evening":
        return Icons.brightness_4;
        break;
      case "Night":
        return Icons.brightness_2;
        break;
      case "All Day":
        return Icons.view_day;
        break;
      default:
        return Icons.lightbulb_outline;
    }
  }

  Map<String, String> toJson() {
    Map<String, String> jsonData = Map<String, String>();
    jsonData['area'] = area;

    final _now = new DateTime.now();
    jsonData['startTime'] = _format.format(
      DateTime(
        _now.year,
        _now.month,
        _now.day,
        startTime.hour,
        startTime.minute,
      ),
    );

    return jsonData;
  }

  static TimeArea fromJson(Map<String, dynamic> data) {
    String sArea = data['area'];
    TimeOfDay sStartTime = TimeOfDay(
      hour: int.parse(data['startTime'].split(":")[0]),
      minute: int.parse(data['startTime'].split(":")[1]),
    );

    return TimeArea(
      area: sArea,
      startTime: sStartTime,
    );
  }

  String toString() {
    return toJson().toString();
  }
}
