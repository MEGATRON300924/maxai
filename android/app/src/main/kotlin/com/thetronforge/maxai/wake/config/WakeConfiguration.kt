package com.thetronforge.maxai.wake.config



class WakeConfiguration {



    private var vadThreshold = 0.5f


    private var wakeThreshold = 0.75f





    fun getVadThreshold():Float{


        return vadThreshold


    }





    fun getWakeThreshold():Float{


        return wakeThreshold


    }



}