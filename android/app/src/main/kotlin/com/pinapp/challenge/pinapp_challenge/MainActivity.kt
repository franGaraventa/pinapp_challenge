package com.pinapp.challenge.pinapp_challenge

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import kotlin.concurrent.thread

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.dartExecutor?.let {
            MethodChannel(it, METHOD_CHANNEL).setMethodCallHandler { call, result ->
                when(call.method) {
                    "getComments" -> {
                        val url = call.argument<String>("url")
                        thread {
                            url?.run {
                                val data = getDataFromUrl(this)
                                runOnUiThread {
                                    if (data != null) {
                                        result.success(data)
                                    } else {
                                        result.error("DATA",
                                            "No se pudo obtener informacion sobre el post elegido",
                                            null
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private fun getDataFromUrl(url: String): String? {
        val client = OkHttpClient()
        val request = Request.Builder().url(url).build()
        try {
            val response: Response = client.newCall(request).execute()
            return if (response.isSuccessful) {
                response.body?.string()
            } else {
                null
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    companion object {
        private const val METHOD_CHANNEL = "com.pinapp.challenge.pinapp_challenge.service"
    }
}
