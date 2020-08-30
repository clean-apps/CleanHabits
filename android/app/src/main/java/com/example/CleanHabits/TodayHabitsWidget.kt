package com.example.CleanHabits

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

/**
 * Implementation of App Widget functionality.
 */
class TodayHabitsWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            // refresh all your widgets
            val mgr = AppWidgetManager.getInstance(context)
            val cn = ComponentName(context, TodayHabitsWidget::class.java)
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.todayWidgetListView)
        }
        super.onReceive(context, intent)
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager,
                            appWidgetId: Int) {

            // Construct the RemoteViews object
            val views = RemoteViews(context.packageName, R.layout.today_habits_widget)
            val widgetText: CharSequence = context.getString(R.string.todayWidgetHeaderText)
            views.setTextViewText(R.id.todayWidgetHeaderText, widgetText)
            val intent = Intent(context, TodayWidgetRemoteViewsService::class.java)
            views.setRemoteAdapter(R.id.todayWidgetListView, intent)

            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        /*
        Implement This in Flutter Code to update the Widget when stuff changes
        https://www.sitepoint.com/killer-way-to-show-a-list-of-items-in-android-collection-widget/

        public static void sendRefreshBroadcast(Context context) {
            Intent intent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
            intent.setComponent(new ComponentName(context, CollectionAppWidgetProvider.class));
            context.sendBroadcast(intent);
        }
     */
        fun sendRefreshBroadcast(context: Context) {
            val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
            intent.component = ComponentName(context, TodayHabitsWidget::class.java)
            context.sendBroadcast(intent)
        }
    }
}