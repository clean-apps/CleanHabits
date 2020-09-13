package com.babanomania.CleanHabits

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.widget.AdapterView
import android.widget.RemoteViews
import android.widget.RemoteViewsService

class TodayWidgetRemoteViewsFactory : RemoteViewsService.RemoteViewsFactory {

    private val TAG = this::class.java.simpleName

    private val mContext: Context
    private var appWidgetId = 0

    private var habits: List<Map<String, *>> = emptyList()
    private var progress: List<Map<String, *>> = emptyList()

    constructor(mContext: Context, intent: Intent?) {
        this.mContext = mContext
        appWidgetId = intent?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)!!;

        this.habits = intent?.getSerializableExtra("habits") as List<Map<String, *>>
        this.progress = intent?.getSerializableExtra("progress") as List<Map<String, *>>

    }

    override fun onCreate() {
    }
    override fun onDataSetChanged() {
    }
    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return habits.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        if (position == AdapterView.INVALID_POSITION) {
            val rv = RemoteViews(mContext.packageName, R.layout.widget_loading)
            rv.setTextViewText(R.id.widgetLoadingText, "#N/A")
            return rv
        }

        val hbData = habits.get(position)
        val progData = progress.get(position)

        //Log.d(TAG, "------------------------------------------------------------------------------")
        //Log.d(TAG, "data - habit #position $position - $hbData")
        //Log.d(TAG, "data - progress #position $position - $progData")

        val title = hbData["title"] as String
        val isYNType = ( hbData["is_yn_type"] as Int ) == 1
        val timeOfDay = hbData["time_of_day"] as String
        val target = hbData["times_target"] as String
        val targetType = if (isYNType) null else (hbData["times_target_type"] as String)
        val progress = progData["progress"] as String

        var complete = target == progress

        return RemoteViews(mContext.packageName, R.layout.today_widget_listitem).apply {
            setTextViewText(R.id.todayWidgetListItemHabitTitle, title)
            setTextViewText(R.id.todayWidgetListItemHabitSubtitle1, timeOfDay)

            var listSubtitle2 = if (isYNType) " " else "$progress/$target $targetType"
            setTextViewText(R.id.todayWidgetListItemHabitSubtitle2, listSubtitle2)

            var listIcon = if (complete) R.drawable.ic_baseline_check_24 else R.drawable.ic_baseline_check_24_white
            setImageViewResource(R.id.todayWidgetListItemHabitProgress, listIcon)

            setOnClickPendingIntent(
                    R.id.todayWidgetListItem,
                    PendingIntent.getActivity(
                            mContext,
                            0,
                            Intent(mContext, MainActivity::class.java),
                            0
                    )
            )
        }
    }

    override fun getLoadingView(): RemoteViews {
        val rv = RemoteViews(mContext.packageName, R.layout.widget_loading)
        rv.setTextViewText(R.id.widgetLoadingText, "... loading ...")
        return rv
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

}