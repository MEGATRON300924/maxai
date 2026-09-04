package com.thetronforge.maxai.wake.session


import android.content.Context


import com.thetronforge.maxai.wake.audio.AudioCaptureManager

import com.thetronforge.maxai.wake.audio.AudioFocusManager

import com.thetronforge.maxai.wake.config.WakeConfiguration

import com.thetronforge.maxai.wake.events.EventDispatcher

import com.thetronforge.maxai.wake.optimization.BatteryOptimizer

import com.thetronforge.maxai.wake.ml.HybridWakeDetector

import com.thetronforge.maxai.wake.util.Logger

import com.thetronforge.maxai.wake.util.WakeEngineConstants


import kotlinx.coroutines.*




/**
 * MAX Wake Session Manager v2
 *
 * Controls:
 *
 * Audio Capture
 *      ↓
 * Hybrid Wake Detector
 *      ↓
 * TensorFlow Lite
 *      ↓
 * Wake Event
 *
 */
class WakeSessionManagerV2(


    private val context: Context,


    private val configuration: WakeConfiguration,


    private val eventDispatcher: EventDispatcher,


    private val audioFocusManager: AudioFocusManager,


    private val batteryOptimizer: BatteryOptimizer,


    private val logger: Logger



) {



    private var listening = false



    private var currentMode =

        WakeEngineConstants.ListeningMode.FOREGROUND





    private val scope =

        CoroutineScope(

            Dispatchers.Main +

            SupervisorJob()

        )





    private var audioCaptureManager:

            AudioCaptureManager? = null





    private val hybridDetector =

        HybridWakeDetector(

            context = context,


            vadThreshold =

                configuration.getVadThreshold(),


            wakeThreshold =

                configuration.getWakeThreshold(),


            modelPath =

                "wake_model.tflite"

        )





    private var lastWakeTime = 0L



    private val wakeCooldown = 1000L







    fun startListening(

        mode:

        WakeEngineConstants.ListeningMode

    ){



        if(listening){

            logger.info(

                "Already listening"

            )

            return

        }





        try {



            currentMode = mode





            if(

                batteryOptimizer

                    .shouldPauseDueToBattery()

            ){



                eventDispatcher.publishError(

                    "Battery too low",

                    "BATTERY_LOW"

                )



                return

            }







            if(

                !hybridDetector.initialize()

            ){



                eventDispatcher.publishError(

                    "Wake detector failed",

                    "TFLITE_FAILED"

                )



                return

            }







            if(

                !audioFocusManager.requestFocus(

                    duckOthers = true

                )

            ){



                eventDispatcher.publishError(

                    "Audio focus failed",

                    "AUDIO_FOCUS_FAILED"

                )



                return

            }







            audioCaptureManager =

                AudioCaptureManager(


                    context = context,


                    onFrameCallback = {


                        frame ->

                        processFrame(frame)


                    },


                    onErrorCallback = {


                        message,error ->


                        handleAudioError(

                            message,

                            error

                        )


                    }

                )







            audioCaptureManager?.initialize()



            audioCaptureManager?.startCapture(

                scope

            )







            listening = true





            eventDispatcher.publishListeningStarted(

                mode.name

            )





            logger.info(

                "MAX Wake Engine started"

            )





        }catch(e:Exception){



            logger.error(

                "Failed starting wake engine",

                e

            )

        }



    }









    fun stopListening(){



        try {



            listening = false





            audioCaptureManager?.stopCapture()



            audioCaptureManager?.release()



            audioCaptureManager = null





            hybridDetector.release()



            hybridDetector.reset()



            audioFocusManager.abandonFocus()





            eventDispatcher.publishListeningStopped(

                "user"

            )



        }catch(e:Exception){



            logger.error(

                "Stop failed",

                e

            )


        }



    }









    private fun processFrame(

        frame:ByteArray

    ){



        if(!listening)

            return





        try {



            val result =

                hybridDetector.detectWakeWord(

                    frame

                )







            val level =

                estimateLevel(frame)







            eventDispatcher.publishAudioLevel(

                db = level.db,


                normalized = level.normalized,


                isVoice =

                    result.message !=

                    "No speech detected"

            )







            if(result.isWake){



                handleWake(

                    result

                )

            }





        }catch(e:Exception){



            logger.error(

                "Frame processing failed",

                e

            )


        }


    }









    private fun handleWake(

        result:

        com.thetronforge.maxai.wake.ml.HybridDetectionResult

    ){



        val now =

            System.currentTimeMillis()





        if(

            now-lastWakeTime < wakeCooldown

        )

            return





        lastWakeTime = now





        logger.info(

            "HEY MAX DETECTED ${result.nnConfidence}"

        )





        eventDispatcher.publishWakeDetected(

            phrase = "Hey MAX",


            confidence = result.nnConfidence

        )



    }









    private fun estimateLevel(

        frame:ByteArray

    ):AudioLevel {



        var sum = 0.0



        for(i in 0 until frame.size-1 step 2){



            val sample =

                (frame[i].toInt()

                or

                (frame[i+1].toInt() shl 8))

                .toShort()



            sum += sample * sample

        }







        val rms =

            kotlin.math.sqrt(

                sum /

                (frame.size/2)

            )





        val db =

            (

                20 *

                kotlin.math.log10(

                    rms / 32768.0

                )

            )

            .toFloat()

            .coerceIn(

                -60f,

                0f

            )





        return AudioLevel(

            db,

            ((db+60)/60)

                .coerceIn(

                    0f,

                    1f

                )

        )


    }









    private fun handleAudioError(

        message:String,

        error:Exception

    ){



        logger.error(

            message,

            error

        )



        eventDispatcher.publishError(

            message,

            "AUDIO_ERROR",

            error

        )



    }









    fun isActive():Boolean = listening





    fun cleanup(){



        stopListening()



        scope.cancel()



    }


}







data class AudioLevel(

    val db:Float,

    val normalized:Float

)