import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const channelAppWidget = "com.babanomania.cleanhabits/updateWidget";

Future<dynamic> getAppWidgetData(MethodCall call) async {
  switch (call.method) {
    case "getTodayAppWidgetData":
      return getTodayAppWidgetData(call);

    case "getSingleHabitAppWidgetData":
      return getSingleHabitAppWidgetData(call);
  }
}

Future<dynamic> getTodayAppWidgetData(MethodCall call) async {
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

  var habitDataSer = habitData.map((hd) => hd.toMap()).toList();

  return {'id': id, 'habits': habitDataSer, 'progress': runDataSer};
}

Future<dynamic> getSingleHabitAppWidgetData(MethodCall call) async {
//

  final args = call.arguments;
  final id = args.toString().split("#")[0];
  final type = args.toString().split("#")[1];
  final init = args.toString().split("#").length == 3 &&
      (args.toString().split("#")[2].toString() == "0");

  var _dateFormat = DateFormat('dd-MM-yyyy');

  var now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  var monthstart = DateTime(now.year, now.month, 1);

  var hmp = ProviderFactory.habitMasterProvider;
  var hm = await hmp.list();

  if ("All" == type) {
    var rdp = ProviderFactory.habitRunDataProvider;
    var allRunData = await rdp.listBetween(monthstart, now);
    var data = Map<String, int>();
    allRunData.forEach((rd) {
      var strDate = _dateFormat.format(rd.targetDate);
      var prevData = data[strDate];
      if (prevData == null) {
        data[strDate] = rd.progress;
        //
      } else {
        data[strDate] = prevData + rd.progress;
      }
    });

    var habitDataSer = hm.map((hd) => hd.toMap()).toList();
    return {
      'id': id,
      'type': type,
      'habits': habitDataSer,
      'progress': data,
      'init': init
    };
  } else {
    var habit = hm.firstWhere((ihm) => ihm.title == type);

    var rdp = ProviderFactory.habitRunDataProvider;
    var allRunData = await rdp.listBetweenFor(monthstart, now, habit.id);
    var data = Map<String, int>();
    allRunData.forEach((rd) {
      var strDate = _dateFormat.format(rd.targetDate);
      var prevData = data[strDate];
      if (prevData == null) {
        data[strDate] = rd.progress;
        //
      } else {
        data[strDate] = prevData + rd.progress;
      }
    });

    var habitDataSer = hm.map((hd) => hd.toMap()).toList();

    return {
      'id': id,
      'type': type,
      'habits': habitDataSer,
      'progress': data,
      'init': init
    };
  }
}

doUpdateTodayAppWidget() {
  const platform = const MethodChannel(channelAppWidget);
  platform.invokeMethod('doUpdateTodayWidget');
}

doUpdateSingleHabitWidget() {
  const platform = const MethodChannel(channelAppWidget);
  platform.invokeMethod('doUpdateSingleHabitWidget');
}
