package com.downloading.social_media

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel





class MainActivity: FlutterActivity() {
  private var sharedText: String? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    val intent = getIntent()
    val action = intent.action
    val type = intent.type

    if (Intent.ACTION_SEND == action && type != null) {
      if (type == "text/plain") {
        handleSendText(intent);
      }
    }

    MethodChannel(flutterView, "app.channel.shared.data").setMethodCallHandler { call, result ->
      if (call.method.contentEquals("getSharedText")) {
        result.success(sharedText)
        sharedText = null
      }
    }
  }

  fun handleSendText(intent: Intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
  }
}
