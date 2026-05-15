package com.google.mlkit.vision.demo.kotlin

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.google.mlkit.vision.demo.R

class ManualInputActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manual_input)

        findViewById<Button>(R.id.save_button).setOnClickListener {
            // 저장 로직은 아직 구현하지 않음
            finish()
        }
    }
}
