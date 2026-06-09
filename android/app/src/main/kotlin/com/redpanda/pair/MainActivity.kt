package com.redpanda.pair

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onStart() {
        super.onStart()
        PairActivityTracker.onActivityCreated(this)
    }

    override fun onResume() {
        super.onResume()
        PairActivityTracker.onActivityResumed()
    }

    override fun onPause() {
        PairActivityTracker.onActivityPaused()
        super.onPause()
    }

    override fun onDestroy() {
        PairActivityTracker.onActivityDestroyed(this)
        super.onDestroy()
    }
}
