package com.example.CleanHabits

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import java.util.*

class SingleHabitWidgetConfigureActivity : Activity(), MethodChannel.Result {

    private val TAG = this::class.java.simpleName

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID
    private lateinit var context: Context

    private var types = arrayOf( "All" )
    private lateinit var adapter: ArrayAdapter<String>

    private var onClickListener = View.OnClickListener {
        val context = this@SingleHabitWidgetConfigureActivity

        // It is the responsibility of the configuration activity to update the app widget
        initializeFlutter()

        var fetchType:String = loadTypePref(context, appWidgetId)
        SingleHabitWidgetProvider.channel?.invokeMethod("getSingleHabitAppWidgetData", "$appWidgetId#$fetchType", this)

        // Make sure we pass back the original appWidgetId
        val resultValue = Intent()
        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        setResult(RESULT_OK, resultValue)
        finish()
    }

    public override fun onCreate(icicle: Bundle?) {
        super.onCreate(icicle)

        context = applicationContext

        var fetchType = "All";
        SingleHabitWidgetProvider.channel?.invokeMethod("getSingleHabitAppWidgetData", "$appWidgetId#$fetchType#0", this)

        // Set the result to CANCELED.  This will cause the widget host to cancel
        // out of the widget placement if the user presses the back button.
        setResult(RESULT_CANCELED)

        setContentView(R.layout.single_habit_widget_configure)

        val spinner: Spinner = findViewById<View>(R.id.singleHabitSelection) as Spinner

        adapter = ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, types)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.setAdapter(adapter)
        spinner.setOnItemSelectedListener(object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(p0: AdapterView<*>?, view: View?, position: Int, id: Long) {
                saveTypePref(context, appWidgetId, types[position])
            }

            override fun onNothingSelected(p0: AdapterView<*>?) {
                //deleteTypePref(context, appWidgetId)
            }
        })

        findViewById<View>(R.id.add_button).setOnClickListener(onClickListener)

        // Find the widget id from the intent.
        val intent = intent
        val extras = intent.extras
        if (extras != null) {
            appWidgetId = extras.getInt(
                    AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
        }

        // If this activity was started with an intent without an app widget ID, finish with an error.
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

    }

    private fun initializeFlutter() {
        if (SingleHabitWidgetProvider.channel == null) {
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

            SingleHabitWidgetProvider.channel = MethodChannel(engine.dartExecutor.binaryMessenger, WidgetHelper.CHANNEL)
        }
    }

    override fun success(result: Any?) {

        val args = result as HashMap<*, *>
        val habits = args["habits"] as List<Map<String, *>>
        val type = args["type"] as String
        val isInit = args["init"] as Boolean

        if( type == "All" ) {

            for(habit in habits) {
                val title = habit["title"] as String
                types += title
            }

            adapter = ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, types)
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

            val spinner: Spinner = findViewById<View>(R.id.singleHabitSelection) as Spinner
            spinner.setAdapter(adapter)

            val selected = loadTypePref(context, appWidgetId)
            val selectionIndex = types.indexOf(selected)
            spinner.setSelection( if(selectionIndex < 0 ) 0 else selectionIndex )

            adapter.notifyDataSetChanged()
            if(!isInit){
                val id = args["id"] as String
                val progress = args["progress"] as Map<String, Int>

                updateSingleHabitWidget(id.toInt(), type, habits, progress, context)
            }
            //
        } else {
            val id = args["id"] as String
            val progress = args["progress"] as Map<String, Int>

            updateSingleHabitWidget(id.toInt(), type, habits, progress, context)

        }
    }

    override fun notImplemented() {
        Log.d(TAG, "notImplemented")
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        Log.d(TAG, "onError $errorCode")
    }
}

private const val PREFS_NAME = "com.example.cleanhabits.singleHabitWidget.type"
private const val PREF_PREFIX_KEY = "singleHabitWidget_"

// Write the prefix to the SharedPreferences object for this widget
internal fun saveTypePref(context: Context, appWidgetId: Int, text: String) {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0).edit()
    prefs.putString(PREF_PREFIX_KEY + appWidgetId, text)
    prefs.apply()
}

// Read the prefix from the SharedPreferences object for this widget.
// If there is no preference saved, get the default from a resource
internal fun loadTypePref(context: Context, appWidgetId: Int): String {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0)
    val type =  prefs.getString(PREF_PREFIX_KEY + appWidgetId, null)
    return type ?: "All"
}

internal fun deleteTypePref(context: Context, appWidgetId: Int) {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0).edit()
    prefs.remove(PREF_PREFIX_KEY + appWidgetId)
    prefs.apply()
}