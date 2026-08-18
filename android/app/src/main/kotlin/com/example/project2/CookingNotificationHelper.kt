package com.example.project2

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.Collections

object CookingNotificationHelper {
    const val CHANNEL_ID = "cooking_alerts_v2"
    private const val NOTIFICATION_TAG = "cooking_app"

    private val shownMessageIds = Collections.synchronizedSet(mutableSetOf<String>())

    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val channel = NotificationChannel(
            CHANNEL_ID,
            "إشعارات التطبيق",
            NotificationManager.IMPORTANCE_HIGH
        )
        channel.description = "إشعارات CookingApp"
        channel.enableVibration(true)
        channel.vibrationPattern = longArrayOf(0, 400, 200, 400)
        channel.enableLights(true)
        channel.setShowBadge(true)
        channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        channel.setSound(Settings.System.DEFAULT_NOTIFICATION_URI, audioAttributes)
        manager.createNotificationChannel(channel)
    }

    fun showFromExtras(context: Context, extras: Bundle) {
        val messageId = extra(extras, "google.message_id")
        if (messageId.isNotEmpty() && !shownMessageIds.add(messageId)) return

        ensureChannel(context)

        val type = extra(extras, "type")
        val rawTitle = extra(extras, "gcm.notification.title")
            .ifEmpty { extra(extras, "gcm.n.title") }
            .ifEmpty { extra(extras, "title") }
        val rawBody = extra(extras, "gcm.notification.body")
            .ifEmpty { extra(extras, "gcm.n.body") }
            .ifEmpty { extra(extras, "body") }
            .ifEmpty { extra(extras, "message") }

        val title = if (isGenericText(rawTitle)) titleFromType(type) else rawTitle
        val body = if (isGenericText(rawBody)) bodyFromType(type) else rawBody

        val notificationId = messageId.ifEmpty { "$title$body" }.hashCode()

        val clickIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
            action = "FCM_CLICK"
            putExtra("type", type)
            putExtra("post_id", extra(extras, "post_id").ifEmpty { extra(extras, "postId") })
            putExtra("recipe_id", extra(extras, "recipe_id").ifEmpty { extra(extras, "recipeId") })
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            notificationId,
            clickIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
            .setVibrate(longArrayOf(0, 400, 200, 400))
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(pendingIntent)
            .build()

        NotificationManagerCompat.from(context).notify(NOTIFICATION_TAG, notificationId, notification)
        cancelSystemDuplicates(context)
    }

    private fun cancelSystemDuplicates(context: Context) {
        val handler = Handler(Looper.getMainLooper())
        val cancel = {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            for (statusBarNotification in manager.activeNotifications) {
                if (statusBarNotification.tag != NOTIFICATION_TAG) {
                    manager.cancel(statusBarNotification.tag, statusBarNotification.id)
                }
            }
        }
        handler.postDelayed(cancel, 400)
        handler.postDelayed(cancel, 1200)
    }

    private fun extra(extras: Bundle, key: String): String {
        return extras.getString(key)
            ?: extras.get(key)?.toString()
            ?: ""
    }

    private fun isGenericText(text: String): Boolean {
        val normalized = text.trim()
            .replace("أ", "ا")
            .replace("إ", "ا")
            .replace("آ", "ا")
            .lowercase()
        if (normalized.isEmpty()) return true
        return normalized == "اشعار جديد" ||
            normalized == "لديك اشعار جديد" ||
            normalized == "وصلك اشعار جديد" ||
            normalized.contains("لديك اشعار") ||
            normalized.contains("new notification") ||
            normalized == "notification"
    }

    private fun titleFromType(type: String): String {
        val typeLower = type.lowercase()
        return when {
            typeLower.contains("like") -> "إعجاب جديد"
            typeLower.contains("comment") -> "تعليق جديد"
            typeLower.contains("reject") || typeLower.contains("declin") || typeLower.contains("رفض") -> "تم رفض منشورك"
            typeLower.contains("approv") || typeLower.contains("accept") || typeLower.contains("قبول") -> "تم قبول منشورك"
            typeLower.contains("recipe") || typeLower.contains("published") -> "وصفة جديدة"
            else -> "إشعار جديد"
        }
    }

    private fun bodyFromType(type: String): String {
        val typeLower = type.lowercase()
        return when {
            typeLower.contains("like") -> "شخص أعجب بمنشورك"
            typeLower.contains("comment") -> "شخص علّق على منشورك"
            typeLower.contains("reject") || typeLower.contains("declin") || typeLower.contains("رفض") -> "الأدمن رفض منشورك"
            typeLower.contains("approv") || typeLower.contains("accept") || typeLower.contains("قبول") -> "الأدمن قبل منشورك وصار ظاهر بالمجتمع"
            typeLower.contains("recipe") || typeLower.contains("published") -> "تم نشر وصفة جديدة"
            else -> "وصلك إشعار جديد"
        }
    }
}
