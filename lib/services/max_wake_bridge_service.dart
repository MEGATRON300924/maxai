import 'package:flutter/services.dart';



class MaxWakeBridgeService {



  static const MethodChannel _channel = MethodChannel(

    "com.thetronforge.maxai/wake",

  );



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







  Stream<dynamic> get wakeEvents {



    return EventChannel(

      "com.thetronforge.maxai/wake_events",

    ).receiveBroadcastStream();

  }

}