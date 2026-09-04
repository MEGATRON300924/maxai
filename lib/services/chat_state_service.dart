class ChatStateService {



  bool _isGenerating = false;



  bool get isGenerating => _isGenerating;







  void startGenerating(){



    _isGenerating = true;


  }







  void stopGenerating(){



    _isGenerating = false;


  }







  void reset(){



    _isGenerating = false;


  }





}