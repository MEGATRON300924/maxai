class MemoryFilter {



  static bool shouldRemember(

      String message

  ){



    final text =

        message.toLowerCase();





    final keywords = [


      "remember",


      "my name is",


      "i am",


      "i like",


      "i love",


      "my favorite",


      "my company",


      "my project",


      "i work",


      "i use",


      "save this",


    ];





    return keywords.any(

      (word)=>

        text.contains(word),

    );


  }








  static int importance(

      String message

  ){



    final text =

      message.toLowerCase();





    if(text.contains("remember"))

      return 5;



    if(text.contains("name"))

      return 5;



    if(text.contains("company"))

      return 5;



    return 2;


  }



}