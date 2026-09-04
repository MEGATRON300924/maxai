import '../contracts/max_auth_contract.dart';
import '../contracts/max_memory_contract.dart';
import '../contracts/max_subscription_contract.dart';
import '../contracts/max_sync_contract.dart';

/// Coordinates the shared runtime services used by MAX ecosystem surfaces.
///
/// UI code should depend on this coordinator rather than constructing its own
/// auth, memory, sync, or subscription services. Concrete providers remain
/// replaceable, which lets the app move from development adapters to MAX Cloud
/// and MAX Auth without rewriting feature screens.
class MaxRuntime {
  MaxRuntime({
    required this.auth,
    required this.memory,
    required this.sync,
    required this.subscriptions,
  });

  final MaxAuthContract auth;
  final MaxMemoryContract memory;
  final MaxSyncContract sync;
  final MaxSubscriptionContract subscriptions;

  bool get isReady => true;

  Future<void> initialize() async {
    await memory.initialize();
    await subscriptions.refresh();
    await auth.refreshSession();
  }

  Future<MaxRuntimeSnapshot> snapshot() async {
    final user = await auth.currentUser();

    return MaxRuntimeSnapshot(
      authenticated: auth.isAuthenticated,
      userId: user?.id,
      plan: subscriptions.currentPlan,
      memoryCount: memory.memories.length,
    );
  }
}

class MaxRuntimeSnapshot {
  const MaxRuntimeSnapshot({
    required this.authenticated,
    required this.userId,
    required this.plan,
    required this.memoryCount,
  });

  final bool authenticated;
  final String? userId;
  final MaxPlan plan;
  final int memoryCount;
}
