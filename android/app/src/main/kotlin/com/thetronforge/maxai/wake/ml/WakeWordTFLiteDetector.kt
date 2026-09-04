package com.thetronforge.maxai.wake.ml


import android.content.Context

import org.tensorflow.lite.Interpreter

import java.io.FileInputStream

import java.nio.ByteBuffer

import java.nio.ByteOrder

import java.nio.channels.FileChannel

import com.thetronforge.maxai.wake.util.Logger





/**
 * MAX Wake Word TensorFlow Lite Detector
 *
 * Fully local neural network inference.
 *
 * Audio Frame
 *      ↓
 * MFCC Feature Extraction
 *      ↓
 * Feature Normalization
 *      ↓
 * TensorFlow Lite Model
 *      ↓
 * Wake Confidence
 *
 */
class WakeWordTFLiteDetector(

    private val context: Context,

    private val modelPath: String = "wake_model.tflite",

    private var threshold: Float = 0.75f

) {



    private val logger =

        Logger("TFLiteWakeDetector")



    private var interpreter: Interpreter? = null



    private val featureExtractor =

        AudioFeatureExtractor()





    private var inputFeatureSize = 16



    private var outputSize = 2







    fun initialize(): Boolean {



        return try {



            logger.info(

                "Loading MAX wake model"

            )



            val modelBuffer =

                loadModelFile(

                    modelPath

                )





            val options =

                Interpreter.Options().apply {



                    setNumThreads(2)



                }





            interpreter =

                Interpreter(

                    modelBuffer,

                    options

                )





            logger.info(

                "TensorFlow Lite ready"

            )



            true



        } catch(e:Exception){



            logger.error(

                "TFLite init failed",

                e

            )



            false

        }


    }








    fun detectWakeWord(

        audioFrame:ByteArray

    ): DetectionResult {



        val engine = interpreter



        if(engine == null){



            return DetectionResult.notWake(

                0f

            )

        }





        return try {



            val features =

                featureExtractor.extractFeatures(

                    audioFrame

                )





            val vector =

                normalizeFeatures(

                    features.toFeatureVector()

                )







            val input =

                ByteBuffer.allocateDirect(

                    vector.size * 4

                ).apply {



                    order(

                        ByteOrder.nativeOrder()

                    )



                    vector.forEach {

                        putFloat(it)

                    }



                    rewind()

                }







            val output =

                Array(

                    1

                ){

                    FloatArray(

                        outputSize

                    )

                }







            engine.run(

                input,

                output

            )







            val scores =

                output[0]





            val notWake =

                scores.getOrElse(

                    0

                ){

                    0f

                }





            val wake =

                scores.getOrElse(

                    1

                ){

                    0f

                }





            logger.debug(

                "Wake confidence: $wake"

            )







            if(

                wake >= threshold

            ){



                DetectionResult.wake(

                    wake

                )



            }else{



                DetectionResult.notWake(

                    wake

                )



            }







        }catch(e:Exception){



            logger.error(

                "Inference failed",

                e

            )



            DetectionResult.error(

                e.message ?: "Unknown"

            )

        }



    }









    private fun normalizeFeatures(

        input:FloatArray

    ):FloatArray {



        return input.map {



            it / 100f



        }.toFloatArray()


    }









    private fun loadModelFile(

        filename:String

    ):ByteBuffer {



        val descriptor =

            context.assets.openFd(

                filename

            )



        val stream =

            FileInputStream(

                descriptor.fileDescriptor

            )



        val channel =

            stream.channel





        val buffer =

            channel.map(

                FileChannel.MapMode.READ_ONLY,

                descriptor.startOffset,

                descriptor.declaredLength

            )





        stream.close()



        return buffer


    }









    fun setThreshold(

        value:Float

    ){



        threshold = value


    }








    fun release(){



        interpreter?.close()



        interpreter = null


    }








    fun getModelInfo():Map<String,Any>{



        return mapOf(


            "model" to modelPath,


            "loaded" to

                (interpreter != null),


            "inputSize" to inputFeatureSize,


            "outputSize" to outputSize,


            "threshold" to threshold


        )

    }



}








data class DetectionResult(


    val isWake:Boolean,


    val confidence:Float,


    val message:String = ""


){



    companion object {



        fun wake(

            confidence:Float

        ) =

            DetectionResult(

                true,

                confidence,

                "Wake detected"

            )





        fun notWake(

            confidence:Float

        ) =

            DetectionResult(

                false,

                confidence,

                "Not wake"

            )





        fun error(

            message:String

        ) =

            DetectionResult(

                false,

                0f,

                message

            )

    }



}







interface IWakeWordDetector {



    fun initialize():Boolean



    fun detectWakeWord(

        audioFrame:ByteArray

    ):DetectionResult



    fun release()



    fun setThreshold(

        threshold:Float

    )



    fun getModelInfo():Map<String,Any>


}