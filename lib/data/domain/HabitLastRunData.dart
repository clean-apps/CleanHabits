final String tableHabitLastRunData = 'habit_last_run_data';

final String columnId = '_id';
final String columnHabitId = '_habit_id';
final String columnLastUpdated = 'last_updated'; // unix epoch

class HabitLastRunData {
  int id;
  int habitId;
  DateTime lastUpdated;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnHabitId: habitId,
      columnLastUpdated:
          lastUpdated == null ? null : lastUpdated.millisecondsSinceEpoch,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  HabitLastRunData();

  HabitLastRunData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    habitId = map[columnHabitId];
    lastUpdated = map[columnLastUpdated] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnLastUpdated],
            isUtc: false,
          );
  }
}
