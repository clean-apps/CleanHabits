import 'package:intl/intl.dart';

final String tableServiceLastRun = 'service_last_run';

final String columnId = '_id';
final String columnLastUpdated = 'last_updated'; // unix epoch

var fmt = DateFormat("yyyy-MM-dd");

class ServiceLastRun {
  int id;
  DateTime lastUpdated;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnLastUpdated:
          lastUpdated == null ? null : lastUpdated.millisecondsSinceEpoch,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  ServiceLastRun();

  ServiceLastRun.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    lastUpdated = map[columnLastUpdated] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnLastUpdated],
            isUtc: false,
          );
  }
}
