package com.redpanda.pair

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.RemoteMessage

object PairNotificationHelper {
    private const val CHANNEL_ID = "pair_notifications"
    private const val CHANNEL_NAME = "Pair Notifications"

    fun show(context: Context, message: RemoteMessage) {
        val notification = message.notification
        val data = message.data

        val title: String = notification?.title
            ?: data["title"]
            ?: context.getString(R.string.app_name)
        val body: String = notification?.body
            ?: data["body"]
            ?: return

        if (body.isBlank()) return

        val manager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        ensureChannel(manager)

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            data.forEach { entry -> putExtra(entry.key, entry.value) }
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            stableNotificationId(message),
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)

        manager.notify(stableNotificationId(message), builder.build())
    }

    private fun ensureChannel(manager: NotificationManager) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Notifications for Pair app"
        }
        manager.createNotificationChannel(channel)
    }

    private fun stableNotificationId(message: RemoteMessage): Int {
        val data = message.data
        val stableKey = data["messageId"]
            ?: data["itemId"]
            ?: message.messageId
            ?: System.currentTimeMillis().toString()
        return stableKey.hashCode()
    }
}
