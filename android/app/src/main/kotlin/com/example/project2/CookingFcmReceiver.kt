package com.example.project2

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class CookingFcmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (MainActivity.isInForeground) return
        val extras = intent.extras ?: return
        CookingNotificationHelper.showFromExtras(context, extras)
    }
}
