class MaxPersonalityService {



  String applyPersonality(

      String response

  ){



    if(response.trim().isEmpty){

      return response;

    }





    return response.trim();


  }







  String greeting({

    required String name,

  }){



    if(name.trim().isEmpty){

      return "Hello, I am MAX. How can I help you today?";

    }





    return "Hello $name. I am MAX. How can I help you today?";


  }







  String errorMessage(){



    return "I am having trouble completing that request right now. Please try again.";


  }





}