package com.thetronforge.maxai.wake.audio


class VoiceActivityDetector(

    private var threshold: Float = 0.5f

) {


    fun setThreshold(value: Float){

        threshold = value

    }



    fun processFrame(

        frame: ByteArray

    ): VoiceDetectionResult {


        var energy = 0.0


        var samples = 0



        for(i in 0 until frame.size - 1 step 2){


            val sample =

                (frame[i].toInt()
                    or
                (frame[i+1].toInt() shl 8))
                    .toShort()



            energy += sample * sample

            samples++


        }



        val rms =

            kotlin.math.sqrt(

                energy / samples

            )



        val confidence =

            (rms / 32768.0)

                .toFloat()

                .coerceIn(0f,1f)



        return VoiceDetectionResult(

            isVoiceDetected =

                confidence >= threshold,


            confidence = confidence

        )

    }




    fun reset(){

    }

}



data class VoiceDetectionResult(

    val isVoiceDetected:Boolean,

    val confidence:Float

)