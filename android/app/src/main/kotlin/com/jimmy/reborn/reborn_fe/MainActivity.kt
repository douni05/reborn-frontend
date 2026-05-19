package com.jimmy.reborn.reborn_fe

import android.app.Activity
import android.content.Intent
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.jimmy.reborn.reborn_fe/mlkit"
    private var pendingResult: MethodChannel.Result? = null

    private val mlkitLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result: ActivityResult ->
        val pr = pendingResult ?: return@registerForActivityResult
        pendingResult = null
        if (result.resultCode == Activity.RESULT_OK && result.data != null) {
            val data = result.data!!
            val label = data.getStringExtra("label") ?: ""
            val confidence = data.getFloatExtra("confidence", 0f)
            val imagePath = data.getStringExtra("imagePath") ?: ""
            pr.success(mapOf("label" to label, "confidence" to confidence, "imagePath" to imagePath))
        } else {
            pr.success(null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "launchMLKit") {
                    if (pendingResult != null) {
                        result.error("ALREADY_RUNNING", "MLKit is already running", null)
                        return@setMethodCallHandler
                    }
                    pendingResult = result
                    val intent = Intent(
                        this,
                        com.google.mlkit.vision.demo.kotlin.StillImageActivity::class.java
                    )
                    mlkitLauncher.launch(intent)
                } else {
                    result.notImplemented()
                }
            }
    }
}
