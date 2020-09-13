package com.babanomania.CleanHabits

import android.content.Context

class WidgetHelper {
    companion object  {
        private const val WIDGET_PREFERENCES_KEY = "widget_preferences"
        private const val WIDGET_HANDLE_KEY = "handle"

        const val CHANNEL = "com.babanomania.cleanhabits/updateWidget"
        const val NO_HANDLE = -1L

        fun setHandle(context: Context, handle: Long) {
            context.getSharedPreferences(
                    WIDGET_PREFERENCES_KEY,
                    Context.MODE_PRIVATE
            ).edit().apply {
                putLong(WIDGET_HANDLE_KEY, handle)
                apply()
            }
        }

        fun getRawHandle(context: Context): Long {
            return context.getSharedPreferences(
                    WIDGET_PREFERENCES_KEY,
                    Context.MODE_PRIVATE
            ).getLong(WIDGET_HANDLE_KEY, NO_HANDLE)
        }
    }
}