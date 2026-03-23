package com.example.animel_core

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "animel_core/maps_config",
        ).setMethodCallHandler { call, result ->
            if (call.method != "getMapsConfiguration") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            try {
                val appInfo = packageManager.getApplicationInfo(
                    packageName,
                    PackageManager.GET_META_DATA,
                )
                val apiKey = appInfo.metaData
                    ?.getString("com.google.android.geo.API_KEY")
                    ?.trim()
                    .orEmpty()
                val isConfigured = apiKey.isNotEmpty() &&
                    apiKey != "YOUR_ANDROID_API_KEY_HERE"

                result.success(
                    mapOf(
                        "isConfigured" to isConfigured,
                        "packageName" to packageName,
                    ),
                )
            } catch (exception: Exception) {
                result.error(
                    "MAPS_CONFIG_ERROR",
                    exception.message,
                    null,
                )
            }
        }
    }
}
