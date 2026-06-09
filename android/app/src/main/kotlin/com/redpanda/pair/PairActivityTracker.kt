package com.redpanda.pair

import java.lang.ref.WeakReference

object PairActivityTracker {
    private var activityRef: WeakReference<MainActivity>? = null

    fun onActivityCreated(activity: MainActivity) {
        activityRef = WeakReference(activity)
    }

    fun onActivityDestroyed(activity: MainActivity) {
        if (activityRef?.get() === activity) {
            activityRef = null
        }
    }

    val isActivityAlive: Boolean
        get() {
            val activity = activityRef?.get() ?: return false
            return !activity.isFinishing && !activity.isDestroyed
        }
}
