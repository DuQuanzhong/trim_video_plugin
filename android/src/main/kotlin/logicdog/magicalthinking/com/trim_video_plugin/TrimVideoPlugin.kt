package logicdog.magicalthinking.com.trim_video_plugin

import android.app.Activity
import android.content.Context
import android.net.Uri
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.daasuu.mp4compose.composer.Mp4Composer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File

/** TrimVideoPlugin */
class TrimVideoPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel

    private lateinit var con: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.nwdn.plugins/trim/video/method/channel")
        channel.setMethodCallHandler(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            var plugin = TrimVideoPlugin()
            plugin.channel = MethodChannel(registrar.messenger(), "com.nwdn.plugins/trim/video/method/channel")
            plugin.con = registrar.activity()
            plugin.channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "videoThumbnails") {

            var path = call?.argument<String>("videoPath")
            Log.e("视频信息：", "$path")

            if (path != null) {
                var path = call?.argument<String>("videoPath") ?: ""
                var dur = getVideoDuration(con, path)
                Log.e("视频时长", "$dur")

                Thread {

                    var handler = Handler(Looper.getMainLooper())
                    var thumbs = ArrayList<String>()

                    var thumbsUtil = VideoFrameExtractor(con, Uri.fromFile(File(path)))
                    thumbsUtil.getThumbnail(1000, dur) { bitmap, index ->

                        bitmap?.run {
                            var fileName = con.externalCacheDir?.absolutePath + "thumbnail_" + index + ".jpg"
                            writeToFile(bitmap, fileName)
                            Log.e("帧$index", "$fileName")
                            thumbs.add(fileName)
                            var count = Math.ceil(((dur/1000).toDouble())).toInt()
                            if (index == count-1){
                                handler.post{
                                    var back = hashMapOf("duration" to dur.toDouble(), "thumbnails" to thumbs)
                                    result.success(back)
                                }
                            }

                        }

                    }

                }.start()
            }

        } else if (call.method == "trimVideo") {

            var path = call?.argument<String>("videoPath") ?: ""
            Log.e("视频信息：", "$path")

            var fileName = con.externalCacheDir?.absolutePath + "thumbnail_" + ".mp4"

            if (path != null) {
                Mp4Composer(path, fileName)
                        .trim(2000L, 4000L)
                        .size(540, 960)
                        .listener(object : Mp4Composer.Listener {
                            override fun onProgress(progress: Double) {
                                Log.e("剪切中...", "onProgress = $progress")
                            }

                            override fun onCompleted() {
                                Log.e("剪切完成", "onCompleted()")

                            }

                            override fun onCanceled() {
                                Log.e("剪切被取消", "onCompleted()")
                            }

                            override fun onCurrentWrittenVideoTime(timeUs: Long) {

                            }

                            override fun onFailed(exception: Exception) {
                                Log.e("剪切失败", "clip onFailed:$exception")

                            }
                        })
                        .start()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        con = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }
}
