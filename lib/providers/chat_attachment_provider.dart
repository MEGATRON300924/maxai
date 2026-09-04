import 'dart:io';

import 'package:flutter/material.dart';

import '../services/chat_attachment_service.dart';



class ChatAttachmentProvider extends ChangeNotifier {



  final ChatAttachmentService service;



  ChatAttachmentProvider({

    required this.service,

  });







  File? _file;



  File? get file => _file;






  String? _type;



  String? get type => _type;







  Future<void> selectAttachment() async {



    final result = await service.selectAttachment();



    if(result == null){

      return;

    }





    _file = File(

      result["path"],

    );





    _type = result["type"];



    notifyListeners();


  }








  void removeAttachment(){



    _file = null;


    _type = null;



    notifyListeners();


  }





}