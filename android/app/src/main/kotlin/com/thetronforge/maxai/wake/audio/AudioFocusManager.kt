package com.thetronforge.maxai.wake.audio


import android.content.Context


class AudioFocusManager(

    private val context: Context

){



    fun requestFocus(

        duckOthers:Boolean

    ):Boolean{


        return true


    }




    fun abandonFocus(){

    }


}