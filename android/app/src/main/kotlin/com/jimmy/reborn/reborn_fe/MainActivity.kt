package com.jimmy.reborn.reborn_fe

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.jimmy.reborn.reborn_fe/mlkit"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "launchMLKit") {
                    val intent = Intent(
                        this,
                        com.google.mlkit.vision.demo.kotlin.StillImageActivity::class.java
                    )
                    startActivity(intent)
                    result.success("launched")
                } else {
                    result.notImplemented()
                }
            }
    }
}