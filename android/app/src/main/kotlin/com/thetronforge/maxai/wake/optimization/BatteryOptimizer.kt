package com.thetronforge.maxai.wake.optimization

import android.content.Context
import android.os.BatteryManager

class BatteryOptimizer(private val context: Context) {
    fun shouldPauseDueToBattery(): Boolean {
        val manager = context.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
            ?: return false
        val level = manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return level in 1..10
    }
}
