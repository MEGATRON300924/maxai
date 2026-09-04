import 'package:flutter/foundation.dart';

import '../models/max_orb_state.dart';


class MaxOrbController extends ChangeNotifier {

  MaxOrbState _state = MaxOrbState.idle;

  double _intensity = 0.5;

  double _audioLevel = 0.0;

  double _transition = 1.0;


  MaxOrbState get state => _state;

  double get intensity => _intensity;

  double get audioLevel => _audioLevel;

  double get transition => _transition;



  void setState(
    MaxOrbState newState,
  ) {

    if (_state == newState) {
      return;
    }


    _state = newState;

    _transition = 0.0;


    notifyListeners();

    _animateTransition();

  }




  void setIntensity(
    double value,
  ) {

    _intensity = value.clamp(
      0.0,
      1.0,
    );


    notifyListeners();

  }




  void updateAudioLevel(
    double level,
  ) {

    _audioLevel = level.clamp(
      0.0,
      1.0,
    );


    notifyListeners();

  }




  Future<void> _animateTransition() async {

    const steps = 20;


    for (
      var i = 0;
      i <= steps;
      i++
    ) {

      _transition =
          i / steps;


      notifyListeners();


      await Future.delayed(
        const Duration(
          milliseconds: 16,
        ),
      );

    }

  }




  void reset() {

    _state = MaxOrbState.idle;

    _intensity = 0.5;

    _audioLevel = 0.0;

    _transition = 1.0;


    notifyListeners();

  }

}