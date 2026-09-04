import 'package:supabase_flutter/supabase_flutter.dart';



class PlanService {


  PlanService._();



  static final PlanService instance =
      PlanService._();



  final SupabaseClient _client =
      Supabase.instance.client;



  Future<String> getCurrentPlan(
    String userId,
  ) async {


    try {


      final response =
          await _client
              .from('subscriptions')
              .select('plan')
              .eq(
                'user_id',
                userId,
              )
              .single();



      return response['plan']
          ?? "MAX BASIC";


    }

    catch (_) {


      throw Exception(
        "Failed to load plan",
      );

    }

  }


}