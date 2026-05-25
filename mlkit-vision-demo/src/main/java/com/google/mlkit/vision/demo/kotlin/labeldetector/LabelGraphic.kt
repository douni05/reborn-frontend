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

package com.google.mlkit.vision.demo.kotlin.labeldetector

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import com.google.mlkit.vision.demo.GraphicOverlay
import com.google.mlkit.vision.demo.GraphicOverlay.Graphic
import com.google.mlkit.vision.label.ImageLabel
import java.util.Locale
import android.content.Context
import androidx.core.content.res.ResourcesCompat
import com.google.mlkit.vision.demo.R

/** Graphic instance for rendering a label within an associated graphic overlay view.  */
class LabelGraphic(
  private val overlay: GraphicOverlay,
  private val labels: List<ImageLabel>,
  private val labelsList: List<String> = emptyList(),
  private val context: Context
) : Graphic(overlay) {
  private val textPaint: Paint = Paint()
  private val labelPaint: Paint

  init {
    textPaint.color = Color.WHITE
    textPaint.textSize = TEXT_SIZE
    val typeface = ResourcesCompat.getFont(context, R.font.ownglyph) // ← 추가
    textPaint.typeface = typeface
    labelPaint = Paint()
    labelPaint.color = Color.parseColor("#DAF3D1")
    labelPaint.style = Paint.Style.FILL
    labelPaint.alpha = 200
  }

  @Synchronized
  override fun draw(canvas: Canvas) {
    // First try to find maxWidth and totalHeight in order to draw to the center of the screen.
    var maxWidth = 0f
    val totalHeight = labels.size * 2 * TEXT_SIZE
    for (label in labels) {
      val text = if (labelsList.isNotEmpty() && label.index < labelsList.size) {
        labelsList[label.index]
      } else {
        label.text
      }.split(" ").drop(1).joinToString(" ").ifEmpty {
        labelsList.getOrNull(label.index) ?: label.text
      }

      val line1Width = textPaint.measureText(text)
      val line2Width =
        textPaint.measureText(
          String.format(
            Locale.US,
            LABEL_FORMAT,
            label.confidence * 100
          )
        )

      maxWidth = Math.max(maxWidth, Math.max(line1Width, line2Width))
    }

    val padding = 20f
    val x = overlay.width - maxWidth - padding * 2
    var y = overlay.height - totalHeight - padding * 4

    if (!labels.isEmpty()) {
      val padding = 20f
      canvas.drawRect(
        x - padding,
        y - padding * 0.5f,
        x + maxWidth + padding,
        y + totalHeight + padding * 0.5f,
        labelPaint
      )
    }

    for (label in labels) {
      if (y + TEXT_SIZE * 2 > overlay.height) {
        break
      }
      val text = if (labelsList.isNotEmpty() && label.index < labelsList.size) {
        labelsList[label.index].split(" ").drop(1).joinToString(" ")
      } else {
        label.text
      }
      canvas.drawText(text, x, y + TEXT_SIZE * 0.8f, textPaint)
      y += TEXT_SIZE
      canvas.drawText(
        String.format(Locale.US, LABEL_FORMAT, label.confidence * 100),
        x, y + TEXT_SIZE * 0.8f, textPaint
      )
      y += TEXT_SIZE
    }
  }

  companion object {
    private const val TEXT_SIZE = 60.0f
    private const val LABEL_FORMAT = "%.2f%%"
  }
}
