import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:CleanHabits/data/domain/HabitLastRunData.dart';

class HabitLastRunDataProvider {
  Database db;

  Future open(String path) async {
    //
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableHabitLastRunData ( 
          $columnId integer primary key autoincrement,
          $columnHabitId integer not null,
          $columnLastUpdated integer not null
        )
        ''');
      },
    );
  }

  Future<HabitLastRunData> insert(HabitLastRunData lastRunData) async {
    lastRunData.id = await db.insert(
      tableHabitLastRunData,
      lastRunData.toMap(),
    );
    return lastRunData;
  }

  Future<HabitLastRunData> getData(int id) async {
    List<Map> maps = await db.query(
      tableHabitLastRunData,
      columns: [columnId, columnHabitId, columnLastUpdated],
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return HabitLastRunData.fromMap(maps.first);
    }
    return null;
  }

  Future<HabitLastRunData> getHabitData(int habitId) async {
    List<Map> maps = await db.query(
      tableHabitLastRunData,
      columns: [columnId, columnHabitId, columnLastUpdated],
      where: '$columnHabitId = ?',
      whereArgs: [habitId],
    );

    if (maps.length > 0) {
      return HabitLastRunData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableHabitLastRunData,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteData(int habitId) async {
    return await db.delete(
      tableHabitLastRunData,
      where: '$columnHabitId = ?',
      whereArgs: [habitId],
    );
  }

  Future<int> update(HabitLastRunData lastRunData) async {
    return await db.update(
      tableHabitLastRunData,
      lastRunData.toMap(),
      where: '$columnId = ?',
      whereArgs: [lastRunData.id],
    );
  }

  Future<int> count() async {
    return await db.query(
      tableHabitLastRunData,
      columns: [columnId],
    ).then((data) => data.length);
  }

  Future<List<HabitLastRunData>> list() async {
    return await db.query(
      tableHabitLastRunData,
      columns: [columnId, columnLastUpdated],
    ).then(
      (data) => data
          .map(
            (m) => HabitLastRunData.fromMap(m),
          )
          .toList(),
    );
  }

  Future close() async => db.close();
}
