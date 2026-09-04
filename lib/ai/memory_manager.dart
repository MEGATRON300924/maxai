import 'package:flutter/material.dart';



class MemoryManager extends ChangeNotifier {


  MemoryManager._();



  static final MemoryManager instance =
      MemoryManager._();



  final Map<String,dynamic> _memory =
      {};



  Map<String,dynamic> get memory =>
      _memory;



  void save(

    String key,

    dynamic value,

  ){


    _memory[key] =
        value;


    notifyListeners();

  }





  dynamic get(
    String key,
  ){

    return _memory[key];

  }





  String generateContext(){


    if(_memory.isEmpty){

      return "";

    }



    return _memory.entries
        .map(

          (e)=>
              "${e.key}: ${e.value}"

        )
        .join("\n");


  }

}