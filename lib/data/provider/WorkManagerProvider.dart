import 'package:CleanHabits/data/WorkManagerService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    //
    WidgetsFlutterBinding.ensureInitialized();
    await ProviderFactory.initDB();
    await ProviderFactory.settingsProvider.init();

    var wms = WorkManagerService();
    await wms.callback(taskName, inputData);

    return Future.value(true);
  });
}

class WorkManagerProvider {
  Future<void> init() async {
    return await Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> runSingleJob({
    String id,
    String taskName,
    Map<String, dynamic> inputData,
  }) async {
    //
    return await Workmanager.registerOneOffTask(
      id,
      taskName,
      inputData: inputData,
    );
  }

  Future<void> runSingleJobAt({
    String id,
    String taskName,
    Map<String, dynamic> inputData,
    DateTime then,
  }) async {
    return await Workmanager.registerOneOffTask(
      id,
      taskName,
      inputData: inputData,
      initialDelay: then.difference(DateTime.now()),
    );
  }

  Future<void> runPeriodicJob({
    String id,
    String taskName,
    Map<String, dynamic> inputData,
    DateTime then,
    Duration frequency,
  }) async {
    return await Workmanager.registerPeriodicTask(
      id,
      taskName,
      frequency: frequency,
      inputData: inputData,
      initialDelay: then.difference(DateTime.now()),
    );
  }

  Future<void> cancelJob({String taskName}) async {
    return await Workmanager.cancelByUniqueName(taskName);
  }

  Future<void> cancelAllJobs() async {
    return await Workmanager.cancelAll();
  }
}
