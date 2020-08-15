import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:CleanHabits/data/domain/HabitRunData.dart';

class HabitRunDataProvider {
  Database db;

  Future open(String path) async {
    //
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableHabitRunData ( 
          $columnId integer primary key autoincrement, 
          $columnHabitId integer not null, 

          $columnTargetDate integer not null,
          $columnTargetWeekInYear text not null,
          columnTargetDayInWeek text not null,
          
          $columnTarget integer not null,
          $columnProgress integer not null
        )
        ''');
      },
    );
  }

  Future<HabitRunData> insert(HabitRunData runData) async {
    runData.id = await db.insert(
      tableHabitRunData,
      runData.toMap(),
    );
    return runData;
  }

  Future<HabitRunData> getData(int id) async {
    List<Map> maps = await db.query(
      tableHabitRunData,
      columns: [
        columnId,
        columnHabitId,
        columnTargetDate,
        columnTarget,
        columnProgress
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return HabitRunData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableHabitRunData,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(HabitRunData runData) async {
    return await db.update(
      tableHabitRunData,
      runData.toMap(),
      where: '$columnId = ?',
      whereArgs: [runData.id],
    );
  }

  Future<int> count() async {
    return await db.query(
      tableHabitRunData,
      columns: [columnId],
    ).then((data) => data.length);
  }

  Future<List<HabitRunData>> list() async {
    return await db.query(
      tableHabitRunData,
      columns: [
        columnId,
        columnHabitId,
        columnTargetDate,
        columnTarget,
        columnProgress
      ],
    ).then(
      (data) => data
          .map(
            (m) => HabitRunData.fromMap(m),
          )
          .toList(),
    );
  }

  Future<List<HabitRunData>> listForDate(DateTime forDate) async {
    return await db
        .query(
          tableHabitRunData,
          columns: [
            columnId,
            columnHabitId,
            columnTargetDate,
            columnTarget,
            columnProgress
          ],
          where: '$columnTargetDate = ?',
          whereArgs: [forDate.millisecondsSinceEpoch],
        )
        .then(
          (data) => data
              .map(
                (m) => HabitRunData.fromMap(m),
              )
              .toList(),
        );
  }

  Future<List<HabitRunData>> listBetween(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return await db
        .query(
          tableHabitRunData,
          columns: [
            columnId,
            columnHabitId,
            columnTargetDate,
            columnTarget,
            columnProgress
          ],
          where: '$columnTargetDate between ? and ?',
          whereArgs: [
            fromDate.millisecondsSinceEpoch,
            toDate.millisecondsSinceEpoch
          ],
        )
        .then(
          (data) => data
              .map(
                (m) => HabitRunData.fromMap(m),
              )
              .toList(),
        );
  }

  Future close() async => db.close();
}
