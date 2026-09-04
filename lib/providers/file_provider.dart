import 'dart:io';

import 'package:flutter/material.dart';

import '../services/file_upload_service.dart';



class FileProvider extends ChangeNotifier {



  final FileUploadService service;



  FileProvider({

    required this.service,

  });







  File? _selectedFile;



  File? get selectedFile => _selectedFile;





  String? _fileType;



  String? get fileType => _fileType;









  Future<void> pickFile() async {



    final file = await service.pickFile();



    if(file == null){

      return;

    }





    _selectedFile = file;


    _fileType = service.getFileType(

      file,

    );



    notifyListeners();


  }









  Future<void> pickMultipleFiles() async {



    final files = await service.pickMultipleFiles();



    if(files.isEmpty){

      return;

    }





    _selectedFile = files.first;


    _fileType = service.getFileType(

      files.first,

    );



    notifyListeners();


  }









  void clearFile(){



    _selectedFile = null;


    _fileType = null;



    notifyListeners();


  }






}