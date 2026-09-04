package com.thetronforge.maxai


import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugin.common.EventChannel

import io.flutter.plugin.common.MethodChannel


import com.thetronforge.maxai.wake.session.WakeSessionManagerV2

import com.thetronforge.maxai.wake.config.WakeConfiguration

import com.thetronforge.maxai.wake.events.EventDispatcher

import com.thetronforge.maxai.wake.audio.AudioFocusManager

import com.thetronforge.maxai.wake.optimization.BatteryOptimizer

import com.thetronforge.maxai.wake.util.Logger




class MainActivity: FlutterActivity(){



    private val METHOD_CHANNEL =

        "com.maxai/wake"




    private val EVENT_CHANNEL =

        "com.maxai/wake_events"




    private lateinit var wakeManager:

            WakeSessionManagerV2






    override fun onCreate(

        savedInstanceState:Bundle?

    ){

        super.onCreate(savedInstanceState)



        initializeWakeEngine()


    }






    private fun initializeWakeEngine(){



        val logger =

            Logger("MAX")



        wakeManager = WakeSessionManagerV2(


            context = this,


            configuration = WakeConfiguration(),


            eventDispatcher = EventDispatcher(),


            audioFocusManager =

                AudioFocusManager(this),


            batteryOptimizer =

                BatteryOptimizer(this),


            logger = logger


        )


    }







    override fun configureFlutterEngine(

        flutterEngine:FlutterEngine

    ){


        super.configureFlutterEngine(

            flutterEngine

        )





        MethodChannel(

            flutterEngine.dartExecutor.binaryMessenger,

            METHOD_CHANNEL

        ).setMethodCallHandler{


                call,result ->



            when(call.method){



                "startWake" -> {


                    wakeManager.startListening(

                        com.thetronforge.maxai.wake.util.WakeEngineConstants.ListeningMode.BACKGROUND

                    )


                    result.success(true)

                }



                "stopWake" -> {


                    wakeManager.stopListening()


                    result.success(true)


                }



                else -> result.notImplemented()


            }



        }







        EventChannel(

            flutterEngine.dartExecutor.binaryMessenger,

            EVENT_CHANNEL


        ).setStreamHandler(

            object:

                EventChannel.StreamHandler{


                override fun onListen(

                    args:Any?,

                    events:EventChannel.EventSink?

                ){

                    // wake events stream later


                }



                override fun onCancel(

                    args:Any?

                ){

                }


            }

        )



    }







    override fun onDestroy(){


        if(::wakeManager.isInitialized){


            wakeManager.cleanup()


        }



        super.onDestroy()


    }



}