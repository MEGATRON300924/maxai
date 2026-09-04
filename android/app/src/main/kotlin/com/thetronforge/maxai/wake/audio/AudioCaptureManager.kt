package com.thetronforge.maxai.wake.audio


import android.content.Context
import kotlinx.coroutines.CoroutineScope



class AudioCaptureManager(

    private val context: Context,

    private val onFrameCallback:(ByteArray)->Unit,

    private val onErrorCallback:(String,Exception)->Unit

){


    private var running = false




    fun initialize(){

        // microphone initialization later

    }





    fun startCapture(

        scope: CoroutineScope

    ){

        running = true


    }





    fun stopCapture(){

        running = false

    }





    fun release(){

        running = false

    }



}