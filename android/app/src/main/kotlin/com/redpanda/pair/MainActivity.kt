package com.redpanda.pair

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onStart() {
        super.onStart()
        PairActivityTracker.onActivityCreated(this)
    }

    override fun onDestroy() {
        PairActivityTracker.onActivityDestroyed(this)
        super.onDestroy()
    }
}
