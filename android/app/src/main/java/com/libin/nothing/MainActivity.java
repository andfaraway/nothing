package com.libin.nothing;

import android.content.Intent;
import android.os.BatteryManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.libin.nothing";
    private static MethodChannel channel;

    ///接受消息
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("backToDeskTop")) {
                        Intent i = new Intent(Intent.ACTION_MAIN);
                        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        i.addCategory(Intent.CATEGORY_HOME);
                        startActivity(i);
                    } else if (call.method.equals("welcomeLoad")) {
                        result.success(null);
                    } else if (call.method.equals("'getBatteryLevel'")) {
                        BatteryManager manager = (BatteryManager) getSystemService(BATTERY_SERVICE);
                        int battery =
                                manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);///当前电量百分比
                        result.success(battery+"");
                    }
                }
        );
    }


}
