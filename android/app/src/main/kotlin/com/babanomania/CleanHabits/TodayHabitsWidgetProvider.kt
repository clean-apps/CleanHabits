package com.babanomania.CleanHabits

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

class TodayHabitsWidgetProvider : AppWidgetProvider(), MethodChannel.Result {

    private val TAG = this::class.java.simpleName

    companion object {
        private var channel: MethodChannel? = null;
    }

    private lateinit var context: Context

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        this.context = context

        initializeFlutter()

        for (appWidgetId in appWidgetIds)
            channel?.invokeMethod("getTodayAppWidgetData", appWidgetId, this)

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
        val id = args["id"] as Int
        val habits = args["habits"] as List<Map<String, *>>
        val progress = args["progress"] as List<Map<String, *>>

        updateTodayWidget(id, habits, progress, context)
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

internal fun updateTodayWidget(id: Int, habits: List<Map<String, *>>, progress: List<Map<String, *>>, context: Context) {

    val views = RemoteViews(context.packageName, R.layout.today_habits_widget).apply {
        val widgetText: CharSequence = context.getString(R.string.todayWidgetHeaderText)
        setTextViewText(R.id.todayWidgetHeaderText, widgetText)

        val intent = Intent(context, TodayWidgetRemoteViewsService::class.java)
        intent.putExtra("habits", habits as Serializable)
        intent.putExtra("progress", progress as Serializable)
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, id)
        intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
        intent.setAction( System.currentTimeMillis().toString() )

        setOnClickPendingIntent(
                R.id.todayWidget,
                PendingIntent.getActivity(
                        context,
                        0,
                        Intent(context, MainActivity::class.java),
                        0
                )
        )

        setRemoteAdapter(R.id.todayWidgetListView, intent)
    }

    val manager = AppWidgetManager.getInstance(context)
    manager.updateAppWidget(id, views)
}