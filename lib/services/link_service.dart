import '../models/link_preview.dart';



class LinkService {


  LinkService._();



  static final LinkService instance =
      LinkService._();



  Future<LinkPreview?> getPreview(
    String text,
  ) async {


    final regex =
        RegExp(
          r'https?:\/\/[^\s]+',
        );



    final match =
        regex.firstMatch(
          text,
        );



    if(match == null) {


      return null;


    }



    final url =
        match.group(0)!;



    return LinkPreview(

      url:
          url,

      title:
          "Link Preview",

      description:
          "Open this link to view the source.",

    );

  }

}