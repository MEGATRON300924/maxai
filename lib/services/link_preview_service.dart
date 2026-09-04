import 'package:flutter_link_previewer/flutter_link_previewer.dart';



class LinkPreviewService {


  Map<String,dynamic>? _cache;





  Future<Map<String,dynamic>?> getPreview(

      String url

  ) async {



    try {



      final preview = await LinkPreview.getPreview(

        url,

      );



      _cache = preview;



      return preview;



    } catch(_){



      return null;


    }



  }






  Map<String,dynamic>? getCached(){

    return _cache;

  }



}