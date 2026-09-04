import 'dart:io';

import 'file_upload_service.dart';



class ChatAttachmentService {



  final FileUploadService fileService;



  ChatAttachmentService({

    required this.fileService,

  });







  Future<Map<String,dynamic>?> selectAttachment() async {



    final File? file = await fileService.pickFile();



    if(file == null){

      return null;

    }





    return {

      "path":file.path,

      "type":

      fileService.getFileType(

        file,

      ),

    };


  }








  bool isSupported(

      String type

  ){



    return [

      "image",

      "audio",

      "document",

      "file"

    ].contains(type);


  }





}