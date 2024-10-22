package com.biubiu.nothing

import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import androidx.annotation.NonNull
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.biubiu.nothing"
    private lateinit var channel: MethodChannel

    override fun provideFlutterEngine(@NonNull context: Context): FlutterEngine {
        return AudioServicePlugin.getFlutterEngine(context)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "backToDeskTop" -> {
                    val i = Intent(Intent.ACTION_MAIN)
                    i.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    i.addCategory(Intent.CATEGORY_HOME)
                    startActivity(i)
                    result.success(null)
                }

                "welcomeLoad" -> result.success(null)
                "getBatteryLevel" -> {
                    val manager = getSystemService(BATTERY_SERVICE) as BatteryManager
                    val battery =
                        manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) // 当前电量百分比
                    result.success(battery)
                }

                else -> result.notImplemented()
            }
        }
    }
}