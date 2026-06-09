package com.redpanda.pair

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseTokenLiveData

class PairFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        FlutterFirebaseTokenLiveData.getInstance().postToken(token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        // The foreground service keeps the process alive, but Flutter may not
        // receive FCM when the UI is backgrounded or swiped from recents.
        // Fall back to native notifications whenever the app is not in front.
        if (PairActivityTracker.isAppInForeground) return

        PairNotificationHelper.show(this, message)
    }
}
