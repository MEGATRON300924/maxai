import 'dart:async';

import 'package:flutter/services.dart';


class MaxWakeController {


  static const MethodChannel _channel =

      MethodChannel(

        "com.maxai/wake",

      );



  static const EventChannel _events =

      EventChannel(

        "com.maxai/wake_events",

      );






  Stream<dynamic> get wakeEvents =>

      _events.receiveBroadcastStream();







  Future<void> startWakeEngine() async {


    await _channel.invokeMethod(

      "startWake",

    );


  }







  Future<void> stopWakeEngine() async {


    await _channel.invokeMethod(

      "stopWake",

    );


  }



}