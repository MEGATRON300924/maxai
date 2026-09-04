import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';



class ProfileService {


  ProfileService._();



  static final ProfileService instance =
      ProfileService._();



  final SupabaseClient client =
      Supabase.instance.client;



  Future<void> saveProfile(

    UserProfile profile,

  ) async {



    await client

        .from(
          "profiles",
        )

        .upsert(

          profile.toJson(),

        );

  }





  Future<UserProfile?> getProfile(

    String id,

  ) async {



    final data =

        await client

            .from(
              "profiles",
            )

            .select()

            .eq(

              "id",

              id,

            )

            .maybeSingle();



    if(data == null){

      return null;

    }



    return UserProfile.fromJson(

      data,

    );


  }

}