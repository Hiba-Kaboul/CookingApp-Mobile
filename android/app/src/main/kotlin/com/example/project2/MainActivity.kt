package com.example.project2

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        const val CHANNEL = "com.example.project2/notifications"
        @JvmField
        var isInForeground = false
        var pendingLaunchData: HashMap<String, String>? = null
    }

    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CookingNotificationHelper.ensureChannel(this)
        captureLaunchData(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getLaunchData" -> {
                    result.success(pendingLaunchData)
                    pendingLaunchData = null
                }
                "cancelGenericNotifications" -> {
                    CookingNotificationHelper.cancelGenericDuplicates(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val data = extractLaunchData(intent) ?: return
        pendingLaunchData = data
        methodChannel?.invokeMethod("onLaunchData", data)
    }

    override fun onResume() {
        super.onResume()
        isInForeground = true
    }

    override fun onPause() {
        isInForeground = false
        super.onPause()
    }

    private fun captureLaunchData(intent: Intent?) {
        val data = extractLaunchData(intent) ?: return
        pendingLaunchData = data
    }

    private fun extractLaunchData(intent: Intent?): HashMap<String, String>? {
        if (intent == null) return null
        val type = intent.getStringExtra("type").orEmpty()
        val postId = intent.getStringExtra("post_id").orEmpty()
        val recipeId = intent.getStringExtra("recipe_id").orEmpty()
        if (type.isEmpty() && postId.isEmpty() && recipeId.isEmpty()) return null
        return hashMapOf(
            "type" to type,
            "post_id" to postId,
            "recipe_id" to recipeId,
        )
    }
}
