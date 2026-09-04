class TypingIndicatorService {



  bool _typing = false;



  bool get isTyping => _typing;







  void start(){



    _typing = true;


  }







  void stop(){



    _typing = false;


  }







  void toggle(){



    _typing = !_typing;


  }





}