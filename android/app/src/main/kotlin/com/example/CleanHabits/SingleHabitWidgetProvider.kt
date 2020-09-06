package com.example.CleanHabits

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import java.io.Serializable
import java.time.LocalDate
import java.time.format.TextStyle
import java.util.*

class SingleHabitWidgetProvider : AppWidgetProvider(), MethodChannel.Result {

    private val TAG = this::class.java.simpleName

    companion object {
        var channel: MethodChannel? = null;
    }

    private lateinit var context: Context

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        this.context = context

        initializeFlutter()

        for (appWidgetId in appWidgetIds){
            val fetchType = loadTypePref(context, appWidgetId)
            channel?.invokeMethod("getSingleHabitAppWidgetData", "$appWidgetId#$fetchType", this)
        }
    }

    private fun initializeFlutter() {
        if (channel == null) {
            FlutterMain.startInitialization(context)
            FlutterMain.ensureInitializationComplete(context, arrayOf())

            val handle = WidgetHelper.getRawHandle(context)
            if (handle == WidgetHelper.NO_HANDLE) {
                Log.w(TAG, "Couldn't update widget because there is no handle stored!")
                return
            }

            val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(handle)
            // You could also use a hard coded value to save you from all
            // the hassle with SharedPreferences, but alas when running your
            // app in release mode this would fail.
            val entryPointFunctionName = callbackInfo.callbackName

            // Instantiate a FlutterEngine.
            val engine = FlutterEngine(context.applicationContext)
            val entryPoint = DartExecutor.DartEntrypoint(FlutterMain.findAppBundlePath(), entryPointFunctionName)
            engine.dartExecutor.executeDartEntrypoint(entryPoint)

            // Register Plugins when in background. When there
            // is already an engine running, this will be ignored (although there will be some
            // warnings in the log).
            GeneratedPluginRegistrant.registerWith(engine)

            channel = MethodChannel(engine.dartExecutor.binaryMessenger, WidgetHelper.CHANNEL)
        }
    }

    override fun success(result: Any?) {

        val args = result as HashMap<*, *>
        val id = args["id"] as String
        val type = args["type"] as String
        val habits = args["habits"] as List<Map<String, *>>
        val progress = args["progress"] as Map<String, Int>

        updateSingleHabitWidget(id.toInt(), type, habits, progress, context)
    }

    override fun notImplemented() {
        Log.d(TAG, "notImplemented")
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        Log.d(TAG, "onError $errorCode")
    }

    override fun onDisabled(context: Context?) {
        super.onDisabled(context)
        channel = null
    }
}

internal fun updateSingleHabitWidget(appWidgetId: Int, type: String, habits: List<Map<String, *>>, progress: Map<String, Int>, context: Context) {
    val views = RemoteViews(context.packageName, R.layout.single_habit_widget).apply{

        setTextViewText(R.id.singleHabitWidgetHeaderText, type)

        val now = LocalDate.now()
        var month = now.month.getDisplayName(TextStyle.SHORT, Locale.getDefault())
        var year = now.year

        val monthText = "$month, $year"
        setTextViewText(R.id.singleHabitWidgetMonthText, monthText)

        ///////////////////////////////////////////////////
//        val intentMain = Intent(context, MainActivity::class.java)
//        val pendingIntentMain = PendingIntent.getActivity(context, 0, intentMain, 0)
//        setOnClickPendingIntent( R.id.todayWidget, pendingIntentMain )

        ///////////////////////////////////////////////////
        val intentConfig = Intent(context, SingleHabitWidgetConfigureActivity::class.java)
        intentConfig.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId) //set widget id
        val pendingIntentConfig = PendingIntent.getActivity(context, 0, intentConfig, 0)
        setOnClickPendingIntent(R.id.singleHabitWidgetHeaderIcon, pendingIntentConfig)

        ///////////////////////////////////////////////////////////
        val intent = Intent(context, SingleHabitWidgetRemoteViewsService::class.java)
        intent.putExtra("progress", progress as Serializable)
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
        intent.setAction(System.currentTimeMillis().toString())
        setRemoteAdapter(R.id.singleHabitCalenderGridView, intent)
    }

    val manager = AppWidgetManager.getInstance(context)
    manager.updateAppWidget(appWidgetId, views)
}