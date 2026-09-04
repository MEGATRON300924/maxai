class UserProfile {


  final String id;


  final String name;


  final String email;


  final String? age;


  final String? country;


  final String? interests;


  final String? religion;


  final String? preferences;



  UserProfile({

    required this.id,

    required this.name,

    required this.email,

    this.age,

    this.country,

    this.interests,

    this.religion,

    this.preferences,

  });



  Map<String,dynamic> toJson(){

    return {

      "id":
          id,

      "name":
          name,

      "email":
          email,

      "age":
          age,

      "country":
          country,

      "interests":
          interests,

      "religion":
          religion,

      "preferences":
          preferences,

    };

  }



  factory UserProfile.fromJson(
      Map<String,dynamic> json
  ){

    return UserProfile(

      id:
          json["id"] ?? "",

      name:
          json["name"] ?? "",

      email:
          json["email"] ?? "",

      age:
          json["age"],

      country:
          json["country"],

      interests:
          json["interests"],

      religion:
          json["religion"],

      preferences:
          json["preferences"],

    );

  }

}