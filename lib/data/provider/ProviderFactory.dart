import 'package:CleanHabits/data/provider/HabitLastRunDataProvider.dart';
import 'package:CleanHabits/data/provider/HabitMasterProvider.dart';
import 'package:CleanHabits/data/provider/HabitRunDataProvider.dart';
import 'package:CleanHabits/data/provider/ServiceLastRunProvider.dart';
import 'package:CleanHabits/data/MockDataFactory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProviderFactory {
  //
  static var habitMasterProvider = HabitMasterProvider();
  static var habitRunDataProvider = HabitRunDataProvider();
  static var habitLastRunDataProvider = HabitLastRunDataProvider();
  static var serviceLastRunProvider = ServiceLastRunProvider();

  static Future<bool> init() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();

    String path1 = join(documentsDirectory.path, 'clean_habits-1.db');
    await habitMasterProvider.open(path1);

    String path2 = join(documentsDirectory.path, 'clean_habits-2.db');
    await habitRunDataProvider.open(path2);

    String path3 = join(documentsDirectory.path, 'clean_habits-3.db');
    await habitLastRunDataProvider.open(path3);

    String path4 = join(documentsDirectory.path, 'clean_habits-4.db');
    await serviceLastRunProvider.open(path4);

    await MockDataFactory.create(daysToMock: 0);
    return Future<bool>(() => true);
  }

  static Future<bool> close() async {
    await habitMasterProvider.close();
    await habitRunDataProvider.close();
    await habitLastRunDataProvider.close();
    await serviceLastRunProvider.close();

    return Future<bool>(() => true);
  }
}
