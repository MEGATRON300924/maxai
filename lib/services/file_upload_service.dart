import 'dart:io';

import 'package:file_picker/file_picker.dart';



class FileUploadService {



  Future<File?> pickFile() async {



    final result = await FilePicker.platform.pickFiles();



    if(result == null){

      return null;

    }





    final path = result.files.single.path;



    if(path == null){

      return null;

    }





    return File(path);


  }








  Future<List<File>> pickMultipleFiles() async {



    final result = await FilePicker.platform.pickFiles(

      allowMultiple:true,

    );





    if(result == null){

      return [];

    }





    return result.paths

        .whereType<String>()

        .map(

          (path)=>File(path),

        )

        .toList();


  }







  String getFileType(

      File file

  ){



    final extension = file.path

        .split('.')

        .last

        .toLowerCase();





    if([

      "png",

      "jpg",

      "jpeg",

      "webp"

    ].contains(extension)){



      return "image";


    }





    if([

      "mp3",

      "wav",

      "m4a"

    ].contains(extension)){



      return "audio";


    }





    if([

      "pdf",

      "doc",

      "docx",

      "txt"

    ].contains(extension)){



      return "document";


    }





    return "file";


  }





}