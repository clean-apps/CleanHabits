package com.babanomania.CleanHabits

import android.content.Intent
import android.widget.RemoteViewsService

class TodayWidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TodayWidgetRemoteViewsFactory(this.applicationContext, intent)
    }
}