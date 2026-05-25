package com.google.mlkit.vision.demo.kotlin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.mlkit.vision.demo.R

class ManualInputActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manual_input)

        val editText = findViewById<EditText>(R.id.input_edit_text)

        findViewById<Button>(R.id.save_button).setOnClickListener {
            val input = editText.text.toString().trim()
            if (input.isEmpty()) {
                Toast.makeText(this, "재질을 입력해주세요", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val resultIntent = Intent().apply {
                putExtra("label", input)
                putExtra("confidence", 1.0f) // 직접 입력이므로 신뢰도 100%
            }
            setResult(Activity.RESULT_OK, resultIntent)
            finish()
        }
    }
}
