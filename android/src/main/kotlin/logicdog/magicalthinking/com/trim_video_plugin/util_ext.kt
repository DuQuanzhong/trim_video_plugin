package logicdog.magicalthinking.com.trim_video_plugin

import android.animation.ValueAnimator
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import android.view.View
import android.view.animation.LinearInterpolator
import android.widget.RelativeLayout
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream


/**
 * 读取媒体文件的时长
 *
 * @return
 */
fun getVideoDuration(context: Context, mediaPath: String): Long {
    val start = System.currentTimeMillis()
    val mmr = android.media.MediaMetadataRetriever()

    try {
        mmr.setDataSource(context, Uri.parse(mediaPath))
        var duration = mmr.extractMetadata(android.media.MediaMetadataRetriever.METADATA_KEY_DURATION)
        val end = System.currentTimeMillis()
        Log.e("video duration-", "duration " + duration + ", use:" + (end - start) + "ms")
        return java.lang.Long.parseLong(duration!!)
    } catch (ex: Exception) {
    } finally {
        mmr.release()
    }

    return 0
}

/**
 * 保存截图
 */
fun writeToFile(bitmap: Bitmap, outBitmap: String, quality: Int = 50): Boolean {
    var success = false
    var out: FileOutputStream? = null
    try {
        out = FileOutputStream(outBitmap)
        success = bitmap.compress(Bitmap.CompressFormat.JPEG, quality, out)
        out.close()
    } catch (e: IOException) {
        // success is already false
    } finally {
        try {
            if (out != null) {
                out.close()
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }

    }
    return success
}

fun decodeFile(file:  String): Bitmap? {
    var fileInputStream: FileInputStream? = null
    try {
        fileInputStream = FileInputStream(file)
        return decodeInputStream(fileInputStream)
    } finally {
        fileInputStream?.run {
            close()
        }
    }

}

fun decodeInputStream(inputStream:  InputStream): Bitmap? {
    val opt_decord = BitmapFactory.Options()
    opt_decord.inPurgeable = true
    opt_decord.inInputShareable = true
    var bitmap_ret: Bitmap? = null
    try {
        bitmap_ret = BitmapFactory.decodeStream(inputStream, null, opt_decord)
    } catch (e: Throwable) {
        // TODO: handle exception
        bitmap_ret = null
    }

    return bitmap_ret
}

fun View.scale(){
    var margin: Int = 120
    var bottomMargin: Int = 430
    val anim = ValueAnimator.ofFloat(0f, 1f)
    anim.duration = 500
    anim.interpolator = LinearInterpolator()
    var lp = this.layoutParams as RelativeLayout.LayoutParams
    anim.addUpdateListener {
        var newMargin = (margin * anim.animatedFraction).toInt()
//        Log.d(TAG, "update anim newMargin:$newMargin")


        lp.leftMargin = newMargin
        lp.topMargin = newMargin
        lp.rightMargin = newMargin
        lp.bottomMargin = (bottomMargin * anim.animatedFraction).toInt()
        this.layoutParams = lp
        this.invalidate()
    }
    anim.start()
}

fun Long.toTime():String{
    var sec = this/1000
    var leftMs = this%1000
    return "$sec.$leftMs s"
}