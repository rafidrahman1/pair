package com.redpanda.pair

import java.lang.ref.WeakReference

object PairActivityTracker {
    private var activityRef: WeakReference<MainActivity>? = null
    private var isInForeground = false

    fun onActivityCreated(activity: MainActivity) {
        activityRef = WeakReference(activity)
    }

    fun onActivityResumed() {
        isInForeground = true
    }

    fun onActivityPaused() {
        isInForeground = false
    }

    fun onActivityDestroyed(activity: MainActivity) {
        if (activityRef?.get() === activity) {
            activityRef = null
            isInForeground = false
        }
    }

    val isActivityAlive: Boolean
        get() {
            val activity = activityRef?.get() ?: return false
            return !activity.isFinishing && !activity.isDestroyed
        }

    val isAppInForeground: Boolean
        get() = isActivityAlive && isInForeground
}
