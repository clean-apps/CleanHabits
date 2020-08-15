import 'package:CleanHabits/data/provider/HabitLastRunDataProvider.dart';
import 'package:CleanHabits/data/provider/HabitMasterProvider.dart';
import 'package:CleanHabits/data/provider/HabitRunDataProvider.dart';
import 'package:CleanHabits/data/provider/ServiceLastRunProvider.dart';
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
    String path = join(documentsDirectory.path, 'clean_habits.db');

    await habitMasterProvider.open(path);
    await habitRunDataProvider.open(path);
    await habitLastRunDataProvider.open(path);
    await serviceLastRunProvider.open(path);

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
