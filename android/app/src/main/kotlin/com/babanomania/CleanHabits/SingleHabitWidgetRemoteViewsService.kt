package com.babanomania.CleanHabits

import android.content.Intent
import android.widget.RemoteViewsService

class SingleHabitWidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return SingleHabitWidgetRemoteViewsFactory(this.applicationContext, intent)
    }
}