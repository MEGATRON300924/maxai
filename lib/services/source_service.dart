class SourceService {



  List<String> extractSources(

      String text

  ){



    final regex = RegExp(

      r'https?:\/\/[^\s]+',

      caseSensitive:false,

    );





    return regex

        .allMatches(text)

        .map(

          (match)=>match.group(0)!,

        )

        .toList();


  }






  bool containsSource(

      String text

  ){



    return extractSources(

      text,

    ).isNotEmpty;


  }





}