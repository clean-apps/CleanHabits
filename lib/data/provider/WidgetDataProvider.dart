import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:flutter/services.dart';

var _hms = HabitMasterService();

Future<dynamic> getAppWidgetData(MethodCall call) async {
//
  final id = call.arguments;

  var runData = await ProviderFactory.habitRunDataProvider.listForDate(
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ),
  );

  var runDataSer = runData
      .map(
        (rd) => rd.toMap(),
      )
      .toList();

  var habitData = await Future.wait(
    runData.map(
      (rd) async => await ProviderFactory.habitMasterProvider.getData(
        rd.habitId,
      ),
    ),
  );

  var habitDataSer = habitData
      .map(
        (hd) => hd.toMap(),
      )
      .toList();

  return {'id': id, 'habits': habitDataSer, 'progress': runDataSer};
}

doUpdateAppWidget() {
  const platform = const MethodChannel(
    'com.babanomania.CleanHabits/updateTodayWidget',
  );
  platform.invokeMethod('updateTodayWidget');
}
