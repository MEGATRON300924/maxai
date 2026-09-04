enum MaxPlan { free, plus, pro }

/// Product entitlement boundary. Payment verification belongs on the backend.
abstract interface class MaxSubscriptionContract {
  MaxPlan get currentPlan;
  bool hasFeature(String feature);
  Future<void> refresh();
}

class DevelopmentSubscriptionService implements MaxSubscriptionContract {
  final MaxPlan _plan = MaxPlan.free;

  @override
  MaxPlan get currentPlan => _plan;

  @override
  bool hasFeature(String feature) {
    // Development-safe defaults. Backend entitlements will replace this.
    return switch (feature) {
      'basic_chat' => true,
      'advanced_models' => _plan != MaxPlan.free,
      'cloud_memory' => _plan != MaxPlan.free,
      _ => false,
    };
  }

  @override
  Future<void> refresh() async {
    // TODO(max-auth): load verified entitlement from MAX backend.
  }
}
