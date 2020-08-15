import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:CleanHabits/data/domain/ServiceLastRun.dart';

class ServiceLastRunProvider {
  Database db;

  Future open(String path) async {
    //
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableServiceLastRun ( 
          $columnId integer primary key autoincrement,
          $columnLastUpdated integer not null
        )
        ''');
      },
    );
  }

  Future<ServiceLastRun> insert(ServiceLastRun runData) async {
    runData.id = await db.insert(
      tableServiceLastRun,
      runData.toMap(),
    );
    return runData;
  }

  Future<ServiceLastRun> getData(int id) async {
    List<Map> maps = await db.query(
      tableServiceLastRun,
      columns: [columnId, columnLastUpdated],
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ServiceLastRun.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableServiceLastRun,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(ServiceLastRun lastRun) async {
    return await db.update(
      tableServiceLastRun,
      lastRun.toMap(),
      where: '$columnId = ?',
      whereArgs: [lastRun.id],
    );
  }

  Future<int> count() async {
    return await db.query(
      tableServiceLastRun,
      columns: [columnId],
    ).then((data) => data.length);
  }

  Future<List<ServiceLastRun>> list() async {
    return await db.query(
      tableServiceLastRun,
      columns: [columnId, columnLastUpdated],
    ).then(
      (data) => data
          .map(
            (m) => ServiceLastRun.fromMap(m),
          )
          .toList(),
    );
  }

  Future close() async => db.close();
}
