import 'package:flutter/material.dart';

import '../services/link_preview_service.dart';



class LinkPreviewProvider extends ChangeNotifier {


  final LinkPreviewService service;



  LinkPreviewProvider({

    required this.service,

  });





  bool _loading = false;


  bool get loading => _loading;





  Map<String,dynamic>? _preview;



  Map<String,dynamic>? get preview => _preview;







  Future<void> loadPreview(

      String url

  ) async {



    _loading = true;


    notifyListeners();





    _preview = await service.getPreview(

      url,

    );





    _loading = false;


    notifyListeners();


  }






  void clear(){



    _preview = null;


    notifyListeners();


  }





}