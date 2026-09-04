class MaxMemoryAnalyzer {



  bool shouldRemember(

      String text,

  ){



    final content = text.toLowerCase();



    final keywords = [

      "my name",

      "i like",

      "i love",

      "i prefer",

      "remember",

      "my favorite",

      "my birthday",

      "my job",

      "my company",

      "my project",

      "i use",

    ];



    return keywords.any(

      (word) => content.contains(word),

    );

  }







  int calculateImportance(

      String text,

  ){



    final content = text.toLowerCase();



    if(content.contains("remember")){

      return 5;

    }



    if(content.contains("my name") ||

        content.contains("my company") ||

        content.contains("my project")){

      return 4;

    }



    if(content.contains("i like") ||

        content.contains("i prefer")){

      return 3;

    }



    return 1;

  }







  String generateKey(

      String text,

  ){



    final words = text

        .split(" ")

        .take(5)

        .join("_")

        .toLowerCase();



    return words;

  }

}