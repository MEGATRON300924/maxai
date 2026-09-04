import 'package:flutter/foundation.dart';

import '../models/suggested_prompt.dart';
import '../models/max_home_status.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeProvider extends ChangeNotifier {

  HomeStatus _status = HomeStatus.initial;

  HomeStatus get status => _status;


  String? _firstName;

  String? get firstName => _firstName;


  String _greeting = "";

  String get greeting => _greeting;


  String? _weather;

  String? get weather => _weather;


  List<SuggestedPrompt> _suggestedPrompts = [];

  List<SuggestedPrompt> get suggestedPrompts =>
      List.unmodifiable(_suggestedPrompts);


  bool _hasContinueConversation = false;

  bool get hasContinueConversation =>
      _hasContinueConversation;


  String? _continueConversationTitle;

  String? get continueConversationTitle =>
      _continueConversationTitle;


  MaxHomeStatus _maxHome =
      MaxHomeStatus.empty();

  MaxHomeStatus get maxHome =>
      _maxHome;


  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;


  bool get isLoading =>
      _status == HomeStatus.loading;


  bool get hasError =>
      _status == HomeStatus.error;



  Future<void> loadHome() async {

    try {

      _status = HomeStatus.loading;

      _errorMessage = null;

      notifyListeners();


      _firstName = null;

      _greeting = _getGreeting();

      _weather = null;

      _suggestedPrompts = [];

      _hasContinueConversation = false;

      _continueConversationTitle = null;

      _maxHome = MaxHomeStatus.empty();


      _status = HomeStatus.loaded;

      notifyListeners();


    } catch (e) {

      _status = HomeStatus.error;

      _errorMessage = e.toString();

      notifyListeners();

    }

  }



  Future<void> refresh() async {

    await loadHome();

  }



  String _getGreeting() {

    final hour =
        DateTime.now().hour;


    if (hour >= 5 && hour < 12) {

      return "Good Morning";

    }


    if (hour >= 12 && hour < 17) {

      return "Good Afternoon";

    }


    if (hour >= 17 && hour < 22) {

      return "Good Evening";

    }


    return "Good Night";

  }



  void updateUserName(String name) {

    _firstName = name;

    notifyListeners();

  }



  void updateSuggestions(
      List<SuggestedPrompt> prompts) {

    _suggestedPrompts = prompts;

    notifyListeners();

  }



  void updateMaxHomeStatus(
      MaxHomeStatus status) {

    _maxHome = status;

    notifyListeners();

  }



  void updateWeather(String value) {

    _weather = value;

    notifyListeners();

  }



  void updateConversation(
    String title,
  ) {

    _hasContinueConversation = true;

    _continueConversationTitle = title;

    notifyListeners();

  }



  void clearConversation() {

    _hasContinueConversation = false;

    _continueConversationTitle = null;

    notifyListeners();

  }

}