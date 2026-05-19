package com.jimmy.reborn.reborn_fe

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.jimmy.reborn.reborn_fe/mlkit"
    private val REQUEST_MLKIT = 2001
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "launchMLKit") {
                    pendingResult = result
                    val intent = Intent(
                        this,
                        com.google.mlkit.vision.demo.kotlin.StillImageActivity::class.java
                    )
                    startActivityForResult(intent, REQUEST_MLKIT)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_MLKIT) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val label = data.getStringExtra("label") ?: ""
                val confidence = data.getFloatExtra("confidence", 0f)
                pendingResult?.success(mapOf("label" to label, "confidence" to confidence))
            } else {
                // 사용자가 그냥 뒤로 나간 경우
                pendingResult?.success(null)
            }
            pendingResult = null
        }
    }
}