import 'package:flutter/material.dart';

import '../services/plan_service.dart';



class PlanProvider extends ChangeNotifier {


  String _plan =
      "Failed to load";



  String get plan =>
      _plan;



  bool _loading =
      false;



  bool get loading =>
      _loading;



  Future<void> loadPlan(
    String userId,
  ) async {


    _loading =
        true;


    notifyListeners();



    try {


      _plan =
          await PlanService.instance
              .getCurrentPlan(
                userId,
              );


    }

    catch (_) {


      _plan =
          "Failed to load";


    }



    _loading =
        false;


    notifyListeners();

  }

}