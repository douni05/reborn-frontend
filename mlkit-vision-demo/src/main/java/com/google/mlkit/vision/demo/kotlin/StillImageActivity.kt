/*
 * Copyright 2020 Google LLC. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.mlkit.vision.demo.kotlin

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.util.Log
import android.util.Pair
import android.view.MenuItem
import android.view.View
import android.view.ViewTreeObserver
import android.widget.AdapterView
import android.widget.AdapterView.OnItemSelectedListener
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.PopupMenu
import android.widget.Spinner
import android.widget.Toast
import com.google.android.gms.common.annotation.KeepName
import com.google.mlkit.common.model.LocalModel
import com.google.mlkit.vision.demo.BitmapUtils
import com.google.mlkit.vision.demo.GraphicOverlay
import com.google.mlkit.vision.demo.R
import com.google.mlkit.vision.demo.VisionImageProcessor
import com.google.mlkit.vision.demo.kotlin.labeldetector.LabelDetectorProcessor
import com.google.mlkit.vision.label.custom.CustomImageLabelerOptions
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions
import java.io.IOException
import java.util.ArrayList

/** Activity demonstrating different image detector features with a still image from camera. */
@KeepName
class StillImageActivity : AppCompatActivity() {
  private var preview: ImageView? = null
  private var graphicOverlay: GraphicOverlay? = null
  private var selectedMode = IMAGE_LABELING_CUSTOM
  private var selectedSize: String? = SIZE_SCREEN
  private var isLandScape = false
  private var imageUri: Uri? = null
  // Max width (portrait mode)
  private var imageMaxWidth = 0
  // Max height (portrait mode)
  private var imageMaxHeight = 0
  private var imageProcessor: VisionImageProcessor? = null
  private var lastDetectedLabel: String? = null
  private var lastDetectedConfidence: Float = 0f

  private val takePictureLauncher = registerForActivityResult(
      ActivityResultContracts.StartActivityForResult()
  ) { result ->
      if (result.resultCode == android.app.Activity.RESULT_OK) {
          tryReloadAndDetectInImage()
      }
  }

  private val pickImageLauncher = registerForActivityResult(
      ActivityResultContracts.StartActivityForResult()
  ) { result ->
      if (result.resultCode == android.app.Activity.RESULT_OK) {
          imageUri = result.data?.data
          tryReloadAndDetectInImage()
      }
  }

  private val manualInputLauncher = registerForActivityResult(
      ActivityResultContracts.StartActivityForResult()
  ) { result ->
      if (result.resultCode == android.app.Activity.RESULT_OK && result.data != null) {
          val label = result.data!!.getStringExtra("label") ?: return@registerForActivityResult
          val confidence = result.data!!.getFloatExtra("confidence", 1.0f)
          sendResultToFlutter(label, confidence)
      }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_still_image)
    findViewById<View>(R.id.select_image_button).setOnClickListener { view ->
      val popup = PopupMenu(this@StillImageActivity, view)
      popup.setOnMenuItemClickListener { menuItem: MenuItem ->
        when (menuItem.itemId) {
          R.id.select_images_from_local -> {
            startChooseImageIntentForResult()
            true
          }
          R.id.take_photo_using_camera -> {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                == PackageManager.PERMISSION_GRANTED) {
              startCameraIntentForResult()
            } else {
              ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), REQUEST_CAMERA_PERMISSION)
            }
            true
          }
          else -> false
        }
      }
      popup.menuInflater.inflate(R.menu.camera_button_menu, popup.menu)
      popup.show()
    }
    preview = findViewById(R.id.preview)
    graphicOverlay = findViewById(R.id.graphic_overlay)

    // 재선택 버튼 클릭 시 기존 선택 버튼의 기능을 수행하도록 연결
    findViewById<View>(R.id.reselect_image_button).setOnClickListener {
      findViewById<View>(R.id.select_image_button).performClick()
    }

    // AI 분석하기 버튼 — MLKit 결과를 Flutter로 전달하고 화면 종료
    findViewById<View>(R.id.manual_input_button).setOnClickListener {
      val label = lastDetectedLabel
      if (label == null) {
        Toast.makeText(this, "먼저 이미지를 선택해주세요", Toast.LENGTH_SHORT).show()
        return@setOnClickListener
      }
      sendResultToFlutter(label, lastDetectedConfidence)
    }

    // 직접 입력하기 버튼 — ManualInputActivity로 이동
    findViewById<View>(R.id.direct_input_button).setOnClickListener {
      manualInputLauncher.launch(Intent(this, ManualInputActivity::class.java))
    }

    populateFeatureSelector()
    populateSizeSelector()
    isLandScape = resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE
    if (savedInstanceState != null) {
      imageUri = savedInstanceState.getParcelable(KEY_IMAGE_URI)
      imageMaxWidth = savedInstanceState.getInt(KEY_IMAGE_MAX_WIDTH)
      imageMaxHeight = savedInstanceState.getInt(KEY_IMAGE_MAX_HEIGHT)
      selectedSize = savedInstanceState.getString(KEY_SELECTED_SIZE)
    }

    val rootView = findViewById<View>(R.id.root)
    rootView.viewTreeObserver.addOnGlobalLayoutListener(
      object : ViewTreeObserver.OnGlobalLayoutListener {
        override fun onGlobalLayout() {
          rootView.viewTreeObserver.removeOnGlobalLayoutListener(this)
          imageMaxWidth = rootView.width
          imageMaxHeight = rootView.height - findViewById<View>(R.id.control).height
          if (SIZE_SCREEN == selectedSize) {
            tryReloadAndDetectInImage()
          }
        }
      }
    )

    // Settings button removed
  }

  public override fun onResume() {
    super.onResume()
    Log.d(TAG, "onResume")
    createImageProcessor()
    tryReloadAndDetectInImage()
  }

  public override fun onPause() {
    super.onPause()
    imageProcessor?.run { this.stop() }
  }

  public override fun onDestroy() {
    super.onDestroy()
    imageProcessor?.run { this.stop() }
  }

  private fun populateFeatureSelector() {
    val featureSpinner = findViewById<Spinner>(R.id.feature_selector)
    val options: MutableList<String> = ArrayList()
    options.add(IMAGE_LABELING)
    options.add(IMAGE_LABELING_CUSTOM)

    // Creating adapter for featureSpinner
    val dataAdapter = ArrayAdapter(this, R.layout.spinner_style, options)
    // Drop down layout style - list view with radio button
    dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    // attaching data adapter to spinner
    featureSpinner.adapter = dataAdapter
    featureSpinner.onItemSelectedListener =
      object : OnItemSelectedListener {
        override fun onItemSelected(
          parentView: AdapterView<*>,
          selectedItemView: View?,
          pos: Int,
          id: Long
        ) {
          if (pos >= 0) {
            selectedMode = parentView.getItemAtPosition(pos).toString()
            createImageProcessor()
            tryReloadAndDetectInImage()
          }
        }

        override fun onNothingSelected(arg0: AdapterView<*>?) {}
      }

    // 스피너의 기본 선택 값을 Birds 모드 위치로 강제 설정합니다.
    val defaultPosition = options.indexOf(IMAGE_LABELING_CUSTOM)
    if (defaultPosition >= 0) {
      featureSpinner.setSelection(defaultPosition)
    }
  }

  private fun populateSizeSelector() {
    val sizeSpinner = findViewById<Spinner>(R.id.size_selector)
    val options: MutableList<String> = ArrayList()
    options.add(SIZE_SCREEN)
    options.add(SIZE_1024_768)
    options.add(SIZE_640_480)
    options.add(SIZE_ORIGINAL)
    // Creating adapter for featureSpinner
    val dataAdapter = ArrayAdapter(this, R.layout.spinner_style, options)
    // Drop down layout style - list view with radio button
    dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    // attaching data adapter to spinner
    sizeSpinner.adapter = dataAdapter
    sizeSpinner.onItemSelectedListener =
      object : OnItemSelectedListener {
        override fun onItemSelected(
          parentView: AdapterView<*>,
          selectedItemView: View?,
          pos: Int,
          id: Long
        ) {
          if (pos >= 0) {
            selectedSize = parentView.getItemAtPosition(pos).toString()
            tryReloadAndDetectInImage()
          }
        }

        override fun onNothingSelected(arg0: AdapterView<*>?) {}
      }
  }

  public override fun onSaveInstanceState(outState: Bundle) {
    super.onSaveInstanceState(outState)
    outState.putParcelable(KEY_IMAGE_URI, imageUri)
    outState.putInt(KEY_IMAGE_MAX_WIDTH, imageMaxWidth)
    outState.putInt(KEY_IMAGE_MAX_HEIGHT, imageMaxHeight)
    outState.putString(KEY_SELECTED_SIZE, selectedSize)
  }

  private fun startCameraIntentForResult() { // Clean up last time's image
    imageUri = null
    preview!!.setImageBitmap(null)
    val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
    if (takePictureIntent.resolveActivity(packageManager) != null) {
      val values = ContentValues()
      values.put(MediaStore.Images.Media.TITLE, "New Picture")
      values.put(MediaStore.Images.Media.DESCRIPTION, "From Camera")
      imageUri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
      takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri)
      takePictureLauncher.launch(takePictureIntent)
    }
  }

  private fun startChooseImageIntentForResult() {
    val intent = Intent()
    intent.type = "image/*"
    intent.action = Intent.ACTION_GET_CONTENT
    pickImageLauncher.launch(Intent.createChooser(intent, "Select Picture"))
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == REQUEST_CAMERA_PERMISSION) {
      if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        startCameraIntentForResult()
      } else {
        Toast.makeText(this, "카메라 권한이 필요합니다", Toast.LENGTH_SHORT).show()
      }
    }
  }

  private fun sendResultToFlutter(label: String, confidence: Float) {
    // imageUri를 임시 파일로 복사해서 실제 경로 전달
    val imagePath: String = try {
      val uri = imageUri
      if (uri != null) {
        val inputStream = contentResolver.openInputStream(uri)
        val tempFile = java.io.File(cacheDir, "mlkit_result.jpg")
        if (tempFile.exists()) tempFile.delete()
        inputStream?.use { input ->
          tempFile.outputStream().use { output -> input.copyTo(output) }
        }
        tempFile.absolutePath
      } else ""
    } catch (e: Exception) {
      ""
    }
    val resultIntent = Intent().apply {
      putExtra("label", label)
      putExtra("confidence", confidence)
      putExtra("imagePath", imagePath)
    }
    setResult(Activity.RESULT_OK, resultIntent)
    finish()
  }

  private fun tryReloadAndDetectInImage() {
    Log.d(TAG, "Try reload and detect image")
    try {
      if (imageUri == null) {
        // 이미지가 없으면 '이미지 선택' 버튼만 보여줌
        findViewById<View>(R.id.select_image_button).visibility = View.VISIBLE
        findViewById<View>(R.id.result_buttons_layout).visibility = View.GONE
        return
      }

      // 이미지가 있으면 '재선택/직접입력' 버튼으로 교체
      findViewById<View>(R.id.select_image_button).visibility = View.GONE
      findViewById<View>(R.id.result_buttons_layout).visibility = View.VISIBLE

      if (SIZE_SCREEN == selectedSize && imageMaxWidth == 0) {
        // UI layout has not finished yet, will reload once it's ready.
        return
      }

      val imageBitmap = BitmapUtils.getBitmapFromContentUri(contentResolver, imageUri) ?: return
      // Clear the overlay first
      graphicOverlay!!.clear()

      val resizedBitmap: Bitmap
      resizedBitmap =
        if (selectedSize == SIZE_ORIGINAL) {
          imageBitmap
        } else {
          // Get the dimensions of the image view
          val targetedSize: Pair<Int, Int> = targetedWidthHeight

          // Determine how much to scale down the image
          val scaleFactor =
            Math.max(
              imageBitmap.width.toFloat() / targetedSize.first.toFloat(),
              imageBitmap.height.toFloat() / targetedSize.second.toFloat()
            )
          Bitmap.createScaledBitmap(
            imageBitmap,
            (imageBitmap.width / scaleFactor).toInt(),
            (imageBitmap.height / scaleFactor).toInt(),
            true
          )
        }

      preview!!.setImageBitmap(resizedBitmap)
      if (imageProcessor != null) {
        graphicOverlay!!.setImageSourceInfo(
          resizedBitmap.width,
          resizedBitmap.height,
          /* isFlipped= */ false
        )
        imageProcessor!!.processBitmap(resizedBitmap, graphicOverlay)
      } else {
        Log.e(TAG, "Null imageProcessor, please check adb logs for imageProcessor creation error")
      }
    } catch (e: IOException) {
      Log.e(TAG, "Error retrieving saved image")
      imageUri = null
    }
  }

  private val targetedWidthHeight: Pair<Int, Int>
    get() {
      val targetWidth: Int
      val targetHeight: Int
      when (selectedSize) {
        SIZE_SCREEN -> {
          targetWidth = imageMaxWidth
          targetHeight = imageMaxHeight
        }
        SIZE_640_480 -> {
          targetWidth = if (isLandScape) 640 else 480
          targetHeight = if (isLandScape) 480 else 640
        }
        SIZE_1024_768 -> {
          targetWidth = if (isLandScape) 1024 else 768
          targetHeight = if (isLandScape) 768 else 1024
        }
        else -> throw IllegalStateException("Unknown size")
      }
      return Pair(targetWidth, targetHeight)
    }

  private fun createImageProcessor() {
    try {
      when (selectedMode) {
        IMAGE_LABELING ->
          imageProcessor = LabelDetectorProcessor(this, ImageLabelerOptions.DEFAULT_OPTIONS)
        IMAGE_LABELING_CUSTOM -> {
          Log.i(TAG, "Using Custom Image Label Detector Processor")
          val localClassifier = LocalModel.Builder().setAssetFilePath("model.tflite").build()
          val customImageLabelerOptions = CustomImageLabelerOptions.Builder(localClassifier)
            .setConfidenceThreshold(0.3f)
            .setMaxResultCount(5)
            .build()
          imageProcessor = LabelDetectorProcessor(this, customImageLabelerOptions) { label, confidence ->
            lastDetectedLabel = label
            lastDetectedConfidence = confidence
          }
        }
        else -> Log.e(TAG, "Unknown selectedMode: $selectedMode")
      }
    } catch (e: Exception) {
      Log.e(TAG, "Can not create image processor: $selectedMode", e)
      Toast.makeText(applicationContext, "Can not create image processor: " + e.message, Toast.LENGTH_LONG).show()
    }
  }

  companion object {
    private const val TAG = "StillImageActivity"
    private const val IMAGE_LABELING = "Image Labeling"
    private const val IMAGE_LABELING_CUSTOM = "Custom Image Labeling (Birds)"

    private const val SIZE_SCREEN = "w:screen"
    private const val SIZE_1024_768 = "w:1024"
    private const val SIZE_640_480 = "w:640"
    private const val SIZE_ORIGINAL = "w:original"
    private const val KEY_IMAGE_URI = "com.google.mlkit.vision.demo.KEY_IMAGE_URI"
    private const val KEY_IMAGE_MAX_WIDTH = "com.google.mlkit.vision.demo.KEY_IMAGE_MAX_WIDTH"
    private const val KEY_IMAGE_MAX_HEIGHT = "com.google.mlkit.vision.demo.KEY_IMAGE_MAX_HEIGHT"
    private const val KEY_SELECTED_SIZE = "com.google.mlkit.vision.demo.KEY_SELECTED_SIZE"
    private const val REQUEST_CAMERA_PERMISSION = 1003
  }
}
