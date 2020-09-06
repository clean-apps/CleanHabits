package com.example.CleanHabits

import android.R
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WidgetHelper.CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                if (call.arguments == null) return
                WidgetHelper.setHandle(this, call.arguments as Long)
            }
            "doUpdateTodayWidget" -> doUpdateTodayWidget(call, result)
            "doUpdateSingleHabitWidget" -> doUpdateSingleHabitWidget(call, result)
        }
    }

     private fun doUpdateTodayWidget(call: MethodCall, result: MethodChannel.Result) {

         val intent = Intent(context.applicationContext, TodayHabitsWidgetProvider::class.java)
         intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE

         val widgetManager = AppWidgetManager.getInstance(context)
         val ids = widgetManager.getAppWidgetIds(ComponentName(context, TodayHabitsWidgetProvider::class.java))

         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
             widgetManager.notifyAppWidgetViewDataChanged(ids, R.id.list)

         intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
         context.sendBroadcast(intent)
     }


    private fun doUpdateSingleHabitWidget(call: MethodCall, result: MethodChannel.Result) {

        val intent = Intent(context.applicationContext, SingleHabitWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE

        val widgetManager = AppWidgetManager.getInstance(context)
        val ids = widgetManager.getAppWidgetIds(ComponentName(context, SingleHabitWidgetProvider::class.java))

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
            widgetManager.notifyAppWidgetViewDataChanged(ids, R.id.list)

        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        context.sendBroadcast(intent)
    }

}
