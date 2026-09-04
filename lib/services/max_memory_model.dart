class MaxMemory {


  final String id;

  final String userId;

  final String type;

  final String key;

  final String value;

  final int importance;

  final DateTime createdAt;




  MaxMemory({

    required this.id,

    required this.userId,

    required this.type,

    required this.key,

    required this.value,

    required this.importance,

    required this.createdAt,

  });





  factory MaxMemory.fromJson(

      Map<String,dynamic> json

  ){

    return MaxMemory(

      id: json['id'],

      userId: json['user_id'],

      type: json['memory_type'],

      key: json['memory_key'],

      value: json['memory_value'],

      importance: json['importance'] ?? 1,

      createdAt:

        DateTime.parse(

          json['created_at'],

        ),

    );

  }






  Map<String,dynamic> toJson(){


    return {


      "user_id":userId,


      "memory_type":type,


      "memory_key":key,


      "memory_value":value,


      "importance":importance,


    };


  }


}