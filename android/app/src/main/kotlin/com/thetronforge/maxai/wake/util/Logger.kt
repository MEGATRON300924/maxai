package com.thetronforge.maxai.wake.util

import android.util.Log

class Logger(private val tag: String) {
    fun debug(message: String) = Log.d(tag, message)
    fun info(message: String) = Log.i(tag, message)
    fun warn(message: String, error: Throwable? = null) = Log.w(tag, message, error)
    fun error(message: String, error: Throwable? = null) = Log.e(tag, message, error)
}
