import 'package:shared_preferences/shared_preferences.dart';

/// Local plan facade used until verified MAX Auth entitlements are available.
/// The backend entitlement adapter can replace this implementation later.
class PlanService {
  PlanService._();

  static final PlanService instance = PlanService._();

  static const _planKey = 'max_plan';

  Future<String> getCurrentPlan(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_planKey) ?? 'MAX BASIC';
  }

  Future<void> setDevelopmentPlan(String plan) async {
    final value = plan.trim();
    if (value.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, value);
  }
}
