package com.biubiu.nothing;

import android.content.Context;
import android.content.Intent;
import android.os.BatteryManager;

import androidx.annotation.NonNull;

import com.ryanheise.audioservice.AudioServicePlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.biubiu.nothing";
    private static MethodChannel channel;


    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        return AudioServicePlugin.getFlutterEngine(context);
    }

    ///接受消息
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("backToDeskTop")) {
                        Intent i = new Intent(Intent.ACTION_MAIN);
                        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        i.addCategory(Intent.CATEGORY_HOME);
                        startActivity(i);
                        result.success(null);
                    } else if (call.method.equals("welcomeLoad")) {
                        result.success(null);
                    } else if (call.method.equals("getBatteryLevel")) {
                        BatteryManager manager = (BatteryManager) getSystemService(BATTERY_SERVICE);
                        int battery =
                                manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);///当前电量百分比
                        result.success(battery);
                    } else{
                        result.notImplemented();
                    }
                }
        );
    }
}
