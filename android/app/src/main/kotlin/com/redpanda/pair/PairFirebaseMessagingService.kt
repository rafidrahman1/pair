package com.redpanda.pair

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseTokenLiveData

class PairFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        FlutterFirebaseTokenLiveData.getInstance().postToken(token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        // A foreground service keeps the process at IMPORTANCE_FOREGROUND, so
        // Flutter routes FCM to onMessage in the main isolate. After swiping
        // the app from recents that isolate is gone while the FGS keeps running.
        // Show the notification natively whenever the UI is not alive.
        if (PairActivityTracker.isActivityAlive) return

        PairNotificationHelper.show(this, message)
    }
}
