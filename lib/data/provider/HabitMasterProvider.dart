import 'package:CleanHabits/data/provider/WidgetDataProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:CleanHabits/data/domain/HabitMaster.dart';

class HabitMasterProvider {
  Database db;

  Future open(String path) async {
    //
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableHabitMaster ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null, 
          $columnReminder integer null,

          $columnFromDate integer not null, 
          $columnTimeOfDay text null,
          
          $columnRepIsNone integer not null,
          $columnRepIsWeekly integer not null,
          $columnRepInSun integer not null,
          $columnRepInMon integer not null,
          $columnRepInTue integer not null,
          $columnRepInWed integer not null,
          $columnRepInThu integer not null,
          $columnRepInFri integer not null,
          $columnRepInSat integer not null,
          $columnRepDuration integer not null,

          $columnISYNType integer not null,
          $columnTimesTarget integer not null,
          $columnTimesTargetType text null
        )
        ''');
      },
    );
  }

  Future<HabitMaster> insert(HabitMaster todo) async {
    todo.id = await db.insert(
      tableHabitMaster,
      todo.toMap(),
    );

    doUpdateAppWidget();
    return todo;
  }

  Future<HabitMaster> getData(int id) async {
    List<Map> maps = await db.query(
      tableHabitMaster,
      columns: [
        columnId,
        columnTitle,
        columnReminder,
        columnFromDate,
        columnTimeOfDay,
        columnRepIsNone,
        columnRepIsWeekly,
        columnRepInSun,
        columnRepInMon,
        columnRepInTue,
        columnRepInWed,
        columnRepInThu,
        columnRepInFri,
        columnRepInSat,
        columnRepDuration,
        columnISYNType,
        columnTimesTarget,
        columnTimesTargetType
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return HabitMaster.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var updated = await db.delete(
      tableHabitMaster,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    doUpdateAppWidget();
    return updated;
  }

  Future<int> update(HabitMaster habit) async {
    var updated = await db.update(
      tableHabitMaster,
      habit.toMap(),
      where: '$columnId = ?',
      whereArgs: [habit.id],
    );

    doUpdateAppWidget();
    return updated;
  }

  Future<int> count() async {
    return await db.query(
      tableHabitMaster,
      columns: [columnId],
    ).then((data) => data.length);
  }

  Future<List<HabitMaster>> list() async {
    return await db.query(
      tableHabitMaster,
      columns: [
        columnId,
        columnTitle,
        columnReminder,
        columnFromDate,
        columnTimeOfDay,
        columnRepIsNone,
        columnRepIsWeekly,
        columnRepInSun,
        columnRepInMon,
        columnRepInTue,
        columnRepInWed,
        columnRepInThu,
        columnRepInFri,
        columnRepInSat,
        columnRepDuration,
        columnISYNType,
        columnTimesTarget,
        columnTimesTargetType
      ],
    ).then(
      (data) => data
          .map(
            (m) => HabitMaster.fromMap(m),
          )
          .toList(),
    );
  }

  Future close() async => db.close();
}
